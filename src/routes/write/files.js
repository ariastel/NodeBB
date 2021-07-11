'use strict';

const router = require('express').Router();
const middleware = require('../../middleware');
const controllers = require('../../controllers');
const uploadsController = require('../../controllers/uploads');
const routeHelpers = require('../helpers');

const { setupApiRoute } = routeHelpers;

module.exports = function () {
	const middlewares = [middleware.ensureLoggedIn];

	// setupApiRoute(router, 'put', '/', [
	// 	...middlewares,
	// 	middleware.checkRequired.bind(null, ['path']),
	// 	middleware.assert.folder
	// ], controllers.write.files.upload);

	const multipart = require('connect-multiparty');
	const multipartMiddleware = multipart();
	setupApiRoute(router, 'post', '/', [
		middleware.ensureLoggedIn,
		multipartMiddleware,
		middleware.validateFiles,
		middleware.uploads.ratelimit,
	], uploadsController.uploadPost);

	setupApiRoute(router, 'delete', '/', [
		...middlewares,
		middleware.checkRequired.bind(null, ['path']),
		middleware.assert.path,
	], controllers.write.files.delete);

	return router;
};
