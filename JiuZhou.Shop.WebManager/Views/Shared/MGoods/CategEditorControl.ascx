<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="categ-boxControl" class="moveBox" style="height:550px;width:600px;">
	<div class="name">
		分类设置
		<div id="categ-box-close"  v="atai-shade-close" class="close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postProductCategBox(this)">
<input type="hidden" name="parentId" value="0"/>
<input type="hidden" name="itemId" value="0"/>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">父&nbsp;&nbsp;类 ：</td>
    <td><input type="text" id="categParentName" class="input" value="" disabled="disabled"/></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">名&nbsp;&nbsp;称<span style="color:red">*</span>：</td>
    <td><input type="text" name="name" class="input" value=""/>
    排序
    <input type="text" name="sort" class="input" style="width:60px;text-align:center" onclick="this.select()" value="0"/>
    </td>
  </tr>
  <tr>
    <td class="left">上传图片 ：</td>
    <td>
    <input type="file" id="upload-file-image" name="file" class="input" value="" style="display:none" onchange="_ajaxUploadFunction()"/>
    <input type="text" id="upload-url" name="imgsrc" v="upload-url" class="input" value="" readonly="readonly" onclick="$('#upload-file-image').click()"/>
    <input type="hidden" id="upload-full-url" class="input" value=""/>
    <input type="button" class="view-file" value="浏览..." onclick="$('#upload-file-image').click()"/></td>
  </tr>
  <tr>
    <td class="left" style="height:160px">&nbsp;</td>
    <td valign="top">
    <div id="upload-image-view" style="width:120px;height:120px;float:left;"></div>
    <div style="float:left;margin-top:30px;"><input type="button" class="view-file" value="从图片库中选择" onclick="_showImageList()" style="width:136px"/></div>
    </td>
  </tr>
  <tr>
    <td class="left" style="height:126px;" valign="top">说&nbsp;&nbsp;明 ：</td>
    <td><textarea id="categ-content" name="content" style="height:100px"></textarea></td>
  </tr>
  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value="  保 存  " /></td>
  </tr>
</table>
</form>
</div>
<script type="text/javascript">
var _categEditorBoxDialog = false;
function categEditorBox(event, parentId, itemId) {
    var boxId = "#categ-boxControl";
    var _dialog = new AtaiShadeDialog();
    _dialog.init({
        obj: boxId
		, sure: function () { }
		, CWCOB: true
    });
    _categEditorBoxDialog = _dialog;

    $.ajax({
        url: "/MTools/GetProductTypeInfo"
		, type: "post"
		, data: "parentId=" + parentId + "&itemId=" + itemId
		, dataType: "json"
		, success: function (json) {
		    $(_categEditorBoxDialog.dialog).find("[name='parentId']").val(parentId);
		    $(_categEditorBoxDialog.dialog).find("[name='itemId']").val(itemId);
		    $(_categEditorBoxDialog.dialog).find("#categParentName").val(json.parentName);
		    $(_categEditorBoxDialog.dialog).find("[name='name']").val(json.type.type_name);
		    $(_categEditorBoxDialog.dialog).find("[name='sort']").val(json.type.sort_no);
		    $(_categEditorBoxDialog.dialog).find("#categ-content").val(json.type.seo_text);
		    $(_categEditorBoxDialog.dialog).find("#upload-url").val(json.type.img_src);
		    $(_categEditorBoxDialog.dialog).find("#upload-image-view").html("");
		    Atai.$("#upload-image-view").style.background = "";
		    $(_categEditorBoxDialog.dialog).find("#upload-full-url").val(json.type.img_src);
		    var html = '<div style="width:120px"><a href="' + formatImageUrl(json.type.img_src, 120, 120) +'" target="_blank"><img src="' + formatImageUrl(json.type.img_src, 120, 120) +'" alt=""/></a></div>';
		    $(_categEditorBoxDialog.dialog).find("#upload-image-view").html(html);
		}
    });

	return false;
}

var _uploadBoxCallbackFunction = false;
function _ajaxShowImageListBoxCallback(path, fullpath) {
   // if (_uploadBoxCallbackFunction) {
       // _uploadBoxCallbackFunction.callback(_uploadBoxCallbackFunction.obj, path, fullpath)
    // }

    Atai.$("#upload-image-view").style.background = "";
    var path2 = formatImageUrl(fullpath, 120, 120);
    var html = '<div style="width:120px"><a href="' + path2 + '" target="_blank"><img src="' + path2 + '" alt=""/></a></div>';
    $(_categEditorBoxDialog.dialog).find("#upload-url").val(path);
    $(_categEditorBoxDialog.dialog).find("#upload-full-url").val(path2);
    $(_categEditorBoxDialog.dialog).find("#upload-image-view").html(html);

}
function _showImageList() {
    //$('#upload-box-close').click();
    //if (_uploadBoxCallbackFunction && showImageListBox) 
    showImageListBox(_ajaxShowImageListBoxCallback);
}
function _ajaxUploadFunction() {
    Atai.$("#upload-image-view").style.background = "url(/images/loading-2.gif) center center no-repeat";

    $.ajaxFileUpload({
        dataType: 'json',
        fileElementId: "upload-file-image",
        url: "/MTools/uploadimage2",
        success: function (json) {
            $(_categEditorBoxDialog.dialog).find("#upload-image-view").html("");
            if (!json.error) {
                Atai.$("#upload-image-view").style.background = "";
                var html = '<div style="width:120px"><a href="' + json.fullPath + '" target="_blank"><img src="' + json.fullPath + '" alt=""/></a></div>';
                $(_categEditorBoxDialog.dialog).find("#upload-url").val(json.save);
                $(_categEditorBoxDialog.dialog).find("#upload-full-url").val(json.fullPath);
                $(_categEditorBoxDialog.dialog).find("#upload-image-view").html(html);

            } else {
                $("*tips-text").html(json.message);
            }
        }
    });
    return false;
}

function postProductCategBox(form){
	var obj=$("#categ-boxControl span[class='tips-text']");
	obj.html("");
	//if(showLoadding) showLoadding();
	var postData=getPostDB(form);
	$.ajax({
		url: "/MGoods/PostCategData"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function(json){
			if(json.error){
				obj.html(json.message);
			}else{
                _categEditorBoxDialog.close();
				jsbox.success(json.message,window.location.href);
			}
			//if(closeLoadding) closeLoadding();
		}
	});
	return false;
}

</script>