(function () {
	var a = {
		exec: function (editor) {
		    if (_fckAddBackCallback) _fckAddBackCallback(); //show();
		}
	},
	b = 'addbackpic';
	CKEDITOR.plugins.add(b, {
		init: function (editor) {
			editor.addCommand(b, a);
			editor.ui.addButton('addbackpic', {
			label: '\u4e0a\u4f20\u56fe\u7247',
			icon: this.path + 'album.gif',
			command: b
		});
		}
	});
})();