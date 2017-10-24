<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<div id="background-box" class="moveBox" style="width:620px;height:600px;">
	<div id="background-box-name" class="name">背景设置<div id="background-box-close"  v="atai-shade-close" class="close">&nbsp;</div></div>
<form id="background-form" action="" method="post" enctype="multipart/form-data">
<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="left" style="height:32px">&nbsp;</td>
    <td><span id="tips-text-forupload" style="color:#ff6600"></span></td>
  </tr>
  <tr>
    <td class="left">平&nbsp;&nbsp;铺：</td>
    <td>
    <select name="repeatposition" id="repeatposition" style="width:160px;">
        <option value="no-repeat" init="true">无平铺</option>
        <option value="repeat-x">水平平铺</option>
        <option value="repeat-y">垂直平铺</option>
        <option value="repeat">全屏平铺</option>
    </select>
    </td>
  </tr>
  <tr>
    <td class="left">水平对齐：</td>
    <td>
    <select name="xposition" id="xposition" style="width:160px;">
        <option value="center" init="true">居中</option>
        <option value="left">左对齐</option>
        <option value="right">右对齐</option>
    </select>
    </td>
  </tr>
  <tr>
    <td class="left">垂直对齐：</td>
    <td>
    <select name="yposition" id="yposition" style="width:160px;">
        <option value="center" init="true">居中</option>
        <option value="top">顶部对齐</option>
        <option value="bottom">底部对齐</option>
    </select>
    </td>
  </tr>
  <tr>
  <td class="left">尺&nbsp;&nbsp;寸：</td>
  <td>高度 <input type="text" name="picheight" style="width:35px;height:25px;" value="0px"/>  宽度 <input type="text" name="picwidth" value="100%" style="width:35px;height:25px;"/></td>
  </tr>
  <tr>
    <td class="left">上传图片：</td>
    <td><input type="file" id="upload-file-image2" name="file2" class="input" value="" style="display:none" onchange="_ajaxBackGroundFunction()"/>
    <input type="text" id="upload-url2" v="upload-url2" class="input" value="" readonly="readonly" onclick="$('#upload-file-image2').click()"/>
    <input type="hidden" id="upload-full-url2" class="input" value=""/>
    <input type="button" class="view-file" value="浏览..." onclick="$('#upload-file-image2').click()"/>
    </td>
  </tr>
  <tr>
    <td class="left" style="height:160px">&nbsp;</td>
    <td valign="top">
    <div id="upload-image-view2" style="width:228px;height:160px;float:left;"></div>
    <div style="float:left;margin-top:30px;"><input type="button" class="view-file" value="从图片库中选择" onclick="_showImageList()" style="width:136px"/></div>
    </td>
  </tr>
  <tr>
    <td class="left">&nbsp;</td>
    <td><input type="button" id="upload-button2" class="submit" value="确 定" style="width:70px"/></td>
  </tr>
</table>
</form>
</div>
<!--//对话框-->
<script type="text/javascript">
    var _backgroundBoxCallbackFunction = false;
    var repeat = "no-repeat";
    var xposition = "center";
    var yposition = "center";
    var _height = "";
    var _width = "";
    function _ajaxShowImageListBoxCallback2(path, fullpath) {
        if (_backgroundBoxCallbackFunction) {
            _backgroundBoxCallbackFunction.callback(_backgroundBoxCallbackFunction.obj, path, fullpath, repeat, xposition, yposition, _height, _width)
        }
    }
    function _showImageList() {
        repeat = $(_dialogBackGroundBox.dialog).find("#repeatposition option:selected").val();
        xposition = $(_dialogBackGroundBox.dialog).find("#xposition option:selected").val();
        yposition = $(_dialogBackGroundBox.dialog).find("#yposition option:selected").val();
        _height = "height:" + $(_dialogBackGroundBox.dialog).find("input[name='picheight']").val() + ";";
        _width = "width:" + $(_dialogBackGroundBox.dialog).find("input[name='picwidth']").val() + ";";
        $('#background-box-close').click();
        if (_backgroundBoxCallbackFunction && showImageListBox) showImageListBox(_ajaxShowImageListBoxCallback2);
    }
    function _ajaxBackGroundFunction() {
        Atai.$("#upload-image-view2").style.background = "url(/images/loading-2.gif) center center no-repeat";

        $.ajaxFileUpload({
            dataType: 'json',
            fileElementId: "upload-file-image2",
            url: "/MTools/uploadimage2",
            success: function (json) {
                $("#upload-image-view2").html("");
                if (!json.error) {
                    Atai.$("#upload-image-view2").style.background = "";
                    var html = '<div style="width:220px"><a href="' + json.fullPath + '" target="_blank"><img src="' + json.fullPath + '" alt=""/></a></div>';
                    $(_dialogBackGroundBox.dialog).find("#upload-ur2l").val(json.image);
                    $(_dialogBackGroundBox.dialog).find("#upload-full-url2").val(json.fullPath);
                    $(_dialogBackGroundBox.dialog).find("#upload-image-view2").html(html);

                } else {
                    $("#tips-text-forupload").html(json.message);
                }
            }
        });
        return false;
    }

    var _dialogBackGroundBox = false;
    function backGroundSet(clickObj, callback, image, fullUrl) {
        _backgroundBoxCallbackFunction = { callback: callback, obj: clickObj };
        var box = Atai.$("#background-box");
        var _dialog = false;
        if (!_dialog)
            _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: box
		, sure: function () { }
		, CWCOB: false
        });

        Atai.$("#upload-url2").value = "";
        if (image) {
            Atai.$("#upload-url2").value = image;
        }
        $("#upload-image-view2").html("");
        if (fullUrl) {
            var path = isIncludeHost(image) ? image : formatImageUrl(fullUrl, 120, 120);
            var html = '<div style="width:220px"><a href="' + fullUrl + '" target="_blank"><img src="' + path + '" alt=""/></a></div>';
            $("#upload-image-view2").html(html);
        }
        _dialogBackGroundBox = _dialog;

        $(_dialogBackGroundBox.dialog).find("#upload-button2").click(function () {
            repeat = $(_dialogBackGroundBox.dialog).find("#repeatposition option:selected").val();
            xposition = $(_dialogBackGroundBox.dialog).find("#xposition option:selected").val();
            yposition = $(_dialogBackGroundBox.dialog).find("#yposition option:selected").val();
            _height = "height:" + $(_dialogBackGroundBox.dialog).find("input[name='picheight']").val() + ";";
            _width = "width:" + $(_dialogBackGroundBox.dialog).find("input[name='picwidth']").val() + ";";
            if (callback) callback(clickObj, $(_dialogBackGroundBox.dialog).find("#upload-url2").val(), $(_dialogBackGroundBox.dialog).find("#upload-full-url2").val(),repeat, xposition, yposition, _height, _width);
            _dialog.close();
        });
    }
</script>