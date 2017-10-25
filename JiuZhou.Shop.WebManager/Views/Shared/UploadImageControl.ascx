<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<div id="upload-box" class="moveBox" style="width:560px;height:320px;">
	<div id="upload-box-name" class="name">图片上传<div id="upload-box-close"  v="atai-shade-close" class="close">&nbsp;</div></div>
<form id="upload-form" action="" method="post" enctype="multipart/form-data">
<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="left" style="height:32px">&nbsp;</td>
    <td><span id="tips-text-forupload" style="color:#ff6600"></span></td>
  </tr>
  <tr>
    <td class="left">上传图片：</td>
    <td><input type="file" id="upload-file-image" name="file" class="input" value="" style="display:none" onchange="_ajaxUploadFunction()"/>
    <input type="text" id="upload-url" v="upload-url" class="input" value="" readonly="readonly" onclick="$('#upload-file-image').click()"/>
    <input type="hidden" id="upload-full-url" class="input" value=""/>
    <input type="button" class="view-file" value="浏览..." onclick="$('#upload-file-image').click()"/>
    <input type="button" id="upload-button" class="submit" value="确 定" style="width:80px"/></td>
  </tr>
  <tr>
    <td class="left" style="height:160px">&nbsp;</td>
    <td valign="top">
    <div id="upload-image-view" style="width:228px;height:160px;float:left;"></div>
    <div style="float:left;margin-top:30px;"><input type="button" class="view-file" value="从图片库中选择" onclick="_showImageList()" style="width:136px"/></div>
    </td>
  </tr>
  <tr>
    <td class="left">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</form>
</div>
<!--//对话框-->
<script type="text/javascript">
    var _uploadBoxCallbackFunction = false;
    var _editor;
    function _ajaxShowImageListBoxCallback(path, fullpath) {
        if (_uploadBoxCallbackFunction) {
            _uploadBoxCallbackFunction.callback(_uploadBoxCallbackFunction.obj, path, fullpath,_editor)
        }
    }
    function _showImageList() {
        $('#upload-box-close').click();
        if (_uploadBoxCallbackFunction && showImageListBox) showImageListBox(_ajaxShowImageListBoxCallback,0,_editor);
    }
    function _ajaxUploadFunction() {
        Atai.$("#upload-image-view").style.background = "url(/images/loading-2.gif) center center no-repeat";

        $.ajaxFileUpload({
            dataType: 'json',
            fileElementId: "upload-file-image",
            url: "/MTools/uploadimage2",
            success: function (json) {
                $("#upload-image-view").html("");
                if (!json.error) {
                    Atai.$("#upload-image-view").style.background = "";
                    var html = '<div style="width:220px"><a href="' + json.fullPath + '" target="_blank"><img src="' + json.fullPath + '" alt=""/></a></div>';
                    $(_dialogForUploadBox.dialog).find("#upload-url").val(json.image);
                    $(_dialogForUploadBox.dialog).find("#upload-full-url").val(json.fullPath);
                    $(_dialogForUploadBox.dialog).find("#upload-image-view").html(html);

                } else {
                    $(_dialogForUploadBox.dialog).find("#tips-text-forupload").html(json.message);
                }
            }
        });
        return false;
    }

    var _dialogForUploadBox = false;
    function upload(clickObj, callback, image, fullUrl,editor) {
        _uploadBoxCallbackFunction = { callback: callback, obj: clickObj };
        _editor = editor;
        var box = Atai.$("#upload-box");
        var _dialog = false;
        if (!_dialog)
            _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: box
		, sure: function () { }
		, CWCOB: true
        });

        Atai.$("#upload-url").value = "";
        if (image) {
            Atai.$("#upload-url").value = image;
        }
        $("#upload-image-view").html("");
        if (fullUrl) {
            var path = isIncludeHost(image) ? image : formatImageUrl(fullUrl, 120, 120);
            var html = '<div style="width:220px"><a href="' + fullUrl + '" target="_blank"><img src="' + path + '" alt=""/></a></div>';
            $("#upload-image-view").html(html);
        }
        _dialogForUploadBox = _dialog;

        $(_dialogForUploadBox.dialog).find("#upload-button").click(function () {
            if (callback) callback(clickObj, $(_dialogForUploadBox.dialog).find("#upload-url").val(), $(_dialogForUploadBox.dialog).find("#upload-full-url").val(),editor);
            _dialog.close();
        });
    }
</script>