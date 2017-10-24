/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	 config.language = 'zh-cn';
	 //config.uiColor = '#9AB8F3';
	 config.autoUpdateElement=true;
	 config.font_names = '\u5b8b\u4f53\u002f\u5b8b\u4f53\u003b\u9ed1\u4f53\u002f\u9ed1\u4f53\u003b\u4eff\u5b8b\u002f\u4eff\u5b8b\u005f\u0047\u0042\u0032\u0033\u0031\u0032\u003b\u6977\u4f53\u002f\u6977\u4f53\u005f\u0047\u0042\u0032\u0033\u0031\u0032\u003b\u96b6\u4e66\u002f\u96b6\u4e66\u003b\u5e7c\u5706\u002f\u5e7c\u5706\u003b\u5fae\u8f6f\u96c5\u9ed1\u002f\u5fae\u8f6f\u96c5\u9ed1;' + config.font_names;
	 config.toolbar =[
		['Source', '-', 'Maximize', '-', 'Preview'],
		['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord'],
		['Undo', 'Redo', '-', 'Find', 'Replace', '-', 'SelectAll', 'RemoveFormat'],
		['Table', 'HorizontalRule', 'Smiley', 'PageBreak', 'SpecialChar'],
		'/',
		['Bold', 'Italic', 'Underline'],
		['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', 'Blockquote'],
		['JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'],
		['Link', 'Unlink', 'Anchor'],
		['tuku', 'addpic', 'addbackpic', 'batchpic', 'Image', 'Flash'],
		'/',
		['Styles', 'Format', 'Font', 'FontSize'],
		['TextColor', 'BGColor']//, ['Maximize', '-', 'About']
	];
	config.extraPlugins = 'tuku,addpic,addbackpic,batchpic';
	config.allowedContent = true;
	$.each(CKEDITOR.dtd.$removeEmpty, function (i, value) {
	    CKEDITOR.dtd.$removeEmpty[i] = false;
	});
};