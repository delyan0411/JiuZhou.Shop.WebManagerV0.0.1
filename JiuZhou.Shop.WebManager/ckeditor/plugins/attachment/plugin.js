(function () {
	var a = {
		exec: function (editor) {
			if(_fckAttCallback) _fckAttCallback();//show();
		}
	},
	b = 'attachment';
	CKEDITOR.plugins.add(b, {
		init: function (editor) {
			editor.addCommand(b, a);
			editor.ui.addButton('attachment', {
			label: '\u4e0a\u4f20\u9644\u4ef6',
			icon: this.path + 'attachment.gif',
			command: b
		});
		}
	});
})();