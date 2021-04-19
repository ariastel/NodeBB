'use strict';


define('forum/account/categories', ['forum/account/header'], function (header) {
	var Categories = {};

	Categories.init = function () {
		header.init();

		ajaxify.data.categories.forEach(function (category) {
			handleIgnoreWatch(category.cid);
		});

		$('[component="category/watch/all"]').find('[component="category/watching"], [component="category/ignoring"], [component="category/notwatching"]').on('click', function () {
			var cids = [];
			var state = $(this).attr('data-state');
			$('[data-parent-cid="0"]').each(function (index, el) {
				cids.push($(el).attr('data-cid'));
			});

			socket.emit('categories.setWatchState', { cid: cids, state: state, uid: ajaxify.data.uid }, function (err, modified_cids) {
				if (err) {
					return app.alertError(err.message);
				}
				updateDropdowns(modified_cids, state);
			});
		});
	};

	function handleIgnoreWatch(cid) {
		var category = $('[data-cid="' + cid + '"]');
		category.find('[component="category/watching"], [component="category/ignoring"], [component="category/notwatching"]').on('click', function () {
			var $this = $(this);
			var state = $this.attr('data-state');

			socket.emit('categories.setWatchState', { cid: cid, state: state, uid: ajaxify.data.uid }, function (err, modified_cids) {
				if (err) {
					return app.alertError(err.message);
				}
				updateDropdowns(modified_cids, state);

				app.alertSuccess('[[category:' + state + '.message]]');
			});
		});
	}

	function updateDropdowns(modified_cids, state) {
		modified_cids.forEach(function (cid) {
			var category = $('[data-cid="' + cid + '"]');
			var attr = {
				component: state === 'watching' ? 'category/watching' : 'category/notwatching',
				'data-state': state === 'watching' ? 'notwatching' : 'watching',
			};
			category.find('[component="category/watching"]').attr(attr);
			category.find('[component="category/notwatching"]').attr(attr);
		});
	}

	return Categories;
});
