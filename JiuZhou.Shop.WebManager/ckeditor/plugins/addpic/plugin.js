
(function () {
	var a = {
		exec: function (editor) {
		    if (_fckAddPicCallback) _fckAddPicCallback(editor); //show();
		}
	},
	b = 'addpic';
	CKEDITOR.plugins.add(b, {
		init: function (editor) {
			editor.addCommand(b, a);
			editor.ui.addButton('addpic', {
			label: '\u4e0a\u4f20\u56fe\u7247',
			icon: this.path + 'album.gif',
			command: b
		});
		}
	});
})();