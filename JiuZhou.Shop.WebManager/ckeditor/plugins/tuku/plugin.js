(function () {
	var a = {
		exec: function (editor) {
		    if (_fckCallback) _fckCallback(editor); //show();
		}
	},
	b = 'tuku';
	CKEDITOR.plugins.add(b, {
		init: function (editor) {
			editor.addCommand(b, a);
			editor.ui.addButton('tuku', {
			label: '\u4ece\u56fe\u7247\u5e93\u4e2d\u9009\u62e9',
			icon: this.path + 'space.gif',
			command: b
		});
		}
	});
})();