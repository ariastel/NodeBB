'use strict';

const winston = require('winston');
const nconf = require('nconf');
const fs = require('fs');
const util = require('util');
const path = require('path');
const rimraf = require('rimraf');

const rimrafAsync = util.promisify(rimraf);

const plugins = require('../plugins');
const db = require('../database');
const file = require('../file');
const minifier = require('./minifier');

const CSS = module.exports;

CSS.supportedSkins = [
	'cerulean', 'cyborg', 'flatly', 'journal', 'lumen', 'paper', 'simplex',
	'spacelab', 'united', 'cosmo', 'darkly', 'readable', 'sandstone',
	'slate', 'superhero', 'yeti',
];

const buildImports = {
	client: function (source) {
		return `@import "mixins.scss";@import "generics.scss";@import "bootstrap/scss/bootstrap"; @import "theme.scss";\n${source}\n${[
			// TODO SASS
			/* '@import "../public/vendor/fontawesome/less/regular.less";',
			'@import "../public/vendor/fontawesome/less/solid.less";',
			'@import "../public/vendor/fontawesome/less/brands.less";',
			'@import "../public/vendor/fontawesome/less/fontawesome.less";',
			'@import "../public/vendor/fontawesome/less/v4-shims.less";',
			'@import "../public/vendor/fontawesome/less/nodebb-shims.less";', */
			'@import "jquery-ui.scss";',
			'@import "../../node_modules/@adactive/bootstrap-tagsinput/src/bootstrap-tagsinput.css";',
			'@import "../../node_modules/cropperjs/dist/cropper.css";',
			'@import "flags.scss";',
			'@import "global.scss";',
			'@import "modals.scss";',
		].map(str => str.replace(/\//g, path.sep)).join('\n')}`;
	},
	admin: function (source) {
		return `${source}\n${[
			/* '@import "../public/vendor/fontawesome/less/regular.less";',
			'@import "../public/vendor/fontawesome/less/solid.less";',
			'@import "../public/vendor/fontawesome/less/brands.less";',
			'@import "../public/vendor/fontawesome/less/fontawesome.less";',
			'@import "../public/vendor/fontawesome/less/v4-shims.less";',
			'@import "../public/vendor/fontawesome/less/nodebb-shims.less";', */
			'@import "mixins.scss";',
			'@import "generics.scss";',
			'@import "admin/admin.scss";',
			'@import "jquery-ui.scss";',
			'@import "../../node_modules/@adactive/bootstrap-tagsinput/src/bootstrap-tagsinput.css";',
			'@import "../../public/vendor/mdl/material.css";',
		].map(str => str.replace(/\//g, path.sep)).join('\n')}`;
	},
};

async function filterMissingFiles(filepaths) {
	const exists = await Promise.all(
		filepaths.map(async (filepath) => {
			const exists = await file.exists(path.join(__dirname, '../../node_modules', filepath));
			if (!exists) {
				winston.warn(`[meta/css] File not found! ${filepath}`);
			}
			return exists;
		})
	);
	return filepaths.filter((filePath, i) => exists[i]);
}

async function getImports(files, prefix, extension) {
	const pluginDirectories = [];
	let source = '';

	files.forEach((styleFile) => {
		if (styleFile.endsWith(extension)) {
			source += `${prefix + path.sep + styleFile}";`;
		} else {
			pluginDirectories.push(styleFile);
		}
	});
	await Promise.all(pluginDirectories.map(async (directory) => {
		const styleFiles = await file.walk(directory);
		styleFiles.forEach((styleFile) => {
			source += `${prefix + path.sep + styleFile}";`;
		});
	}));
	return source;
}

async function getBundleMetadata(target) {
	const paths = [
		path.join(__dirname, '../../node_modules'),
		path.join(__dirname, '../../public/scss'),
		path.join(__dirname, '../../public/vendor/fontawesome/less'),
	];

	// Skin support
	let skin;
	if (target.startsWith('client-')) {
		skin = target.split('-')[1];

		if (CSS.supportedSkins.includes(skin)) {
			target = 'client';
		}
	}
	let skinImport = [];
	if (target === 'client') {
		const themeData = await db.getObjectFields('config', ['theme:type', 'theme:id', 'bootswatchSkin']);
		const themeId = (themeData['theme:id'] || 'nodebb-theme-persona');
		const baseThemePath = path.join(nconf.get('themes_path'), (themeData['theme:type'] && themeData['theme:type'] === 'local' ? themeId : 'nodebb-theme-vanilla'));
		paths.unshift(baseThemePath);

		themeData.bootswatchSkin = skin || themeData.bootswatchSkin;
		if (themeData && themeData.bootswatchSkin) {
			skinImport.push(`\n@import "./@nodebb/bootswatch/${themeData.bootswatchSkin}/variables.scss";`);
			skinImport.push(`\n@import "./@nodebb/bootswatch/${themeData.bootswatchSkin}/bootswatch.scss";`);
		}
		skinImport = skinImport.join('');
	}

	console.log(plugins);

	const [sassImports, cssImports, acpSassImports] = await Promise.all([
		moo(plugins.sassFiles, '\n@import "../../node_modules/', '.scss'),
		moo(plugins.cssFiles, '\n@import "../../node_modules/', '.css'),
		target === 'client' ? '' : moo(plugins.acpSassFiles, '\n@import ".', '.scss'),
	]);

	async function moo(files, prefix, extension) {
		const filteredFiles = await filterMissingFiles(files);
		return await getImports(filteredFiles, prefix, extension);
	}

	let imports = `${skinImport}\n${cssImports}\n${sassImports}\n${acpSassImports}`;
	imports = buildImports[target](imports);

	return { paths: paths, imports: imports };
}

CSS.buildBundle = async function (target, fork) {
	if (target === 'client') {
		await rimrafAsync(path.join(__dirname, '../../build/public/client*'));
	}

	const data = await getBundleMetadata(target);
	const minify = process.env.NODE_ENV !== 'development';
	console.log(data);
	const bundle = await minifier.css.bundle(data.imports, data.paths, minify, fork);

	const filename = `${target}.css`;
	await fs.promises.writeFile(path.join(__dirname, '../../build/public', filename), bundle.code);
	return bundle.code;
};
