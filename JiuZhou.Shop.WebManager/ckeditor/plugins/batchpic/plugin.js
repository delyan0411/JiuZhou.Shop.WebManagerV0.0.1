(function () {
	var a = {
		exec: function (editor) {
		    if (_batchCallback) _batchCallback(editor); //show();
		}
	},
	b = 'batchpic';
	CKEDITOR.plugins.add(b, {
		init: function (editor) {
			editor.addCommand(b, a);
			editor.ui.addButton('batchpic', {
			label: '\u6279\u91CF\u4E0A\u4F20',
			icon: this.path + 'space.gif',
			command: b
		});
		}
	});
})();