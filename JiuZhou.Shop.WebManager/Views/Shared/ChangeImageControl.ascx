<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<div id="changeimg-box" class="moveBox" style="width:450px;height:260px;">
	<div id="changeimg-box-name" class="name">图片更换<div id="upload-box-close"  v="atai-shade-close" class="close">&nbsp;</div></div>
<form id="upload-form" action="" method="post" enctype="multipart/form-data" onsubmit="return submitForm(this)">
<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr style="height:52px;">
    <td style="height:52px;" colspan="2" ><span id="tips-text-forupload" style="color:#ff6600"></span></td>
  </tr>
  <tr>
    <td class="left">图&nbsp;&nbsp;片：</td>
    <td>
        <input type="file" id="upload-file-image" name="file" value=""/>
    </td>
  </tr>
  <tr>
    <td class="left">替换名称：</td>
     <td>
        <input type="text" id="path" name="path" class="input" style="width:228px;"/>
    </td>
  </tr>
  <tr>
     <td colspan="2" style="text-decoration: none;text-align:center">
        <input type="submit" id="upload-button" class="submit" value="确 定" style="width:80px"/>
    </td>
  </tr>
</table>
</form>
</div>
<!--//对话框-->
<script type="text/javascript">

    function submitForm(form) {
        var postData = getPostDB(form);
        $(_dialogForUploadBox.dialog).find("#upload-file-image").attr("id", "upload-file-image1");
        $.ajaxFileUpload({
            dataType: 'json',
            fileElementId: $(_dialogForUploadBox.dialog).find("#upload-file-image1").attr("id"),
            url: "/MTools/ChangeImage?path=" + $(_dialogForUploadBox.dialog).find("input[name='path']").val(),
            success: function (json) {
                if (!json.error) {
                    $(_dialogForUploadBox.dialog).find("#tips-text-forupload").html("更换图片成功，更换后路径为：<br />" + json.fullpath);
                } else {
                    $(_dialogForUploadBox.dialog).find("#tips-text-forupload").html(json.message);
                }
            }
        });
        return false;
    }

    var _dialogForUploadBox = false;
    function changeImg() {
        var box = Atai.$("#changeimg-box");
        var _dialog = false;
        if (!_dialog)
            _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: box
		, sure: function () { }
		, CWCOB: true
        });

        _dialogForUploadBox = _dialog;
    }
</script>