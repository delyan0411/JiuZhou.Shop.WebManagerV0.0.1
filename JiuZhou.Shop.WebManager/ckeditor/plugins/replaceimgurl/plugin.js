(function () {
	var a = {
		exec: function (editor) {
		    if (test) test(); 
		}
	},
	b = 'replaceimgurl';
	CKEDITOR.plugins.add(b, {
		init: function (editor) {
			editor.addCommand(b, a);
			editor.ui.addButton('replaceimgurl', {
            label: '\u66ff\u6362\u56fe\u7247',
			icon: this.path + 'r.gif',
			command: b
		});
		}
	});
})();