<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="categ-boxControl" class="moveBox" style="height:260px;width:430px;">
	<div class="name">
		分类设置
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postHelpCategBox(this)">
<input type="hidden" name="parentId" value="0"/>
<input type="hidden" name="itemId" value="0"/>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">父类：</td>
    <td><input type="text" id="categParentName" class="input" value="" style="width:220px" disabled="disabled"/></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">名称：</td>
    <td><input type="text" name="name" class="input" value="" style="width:120px"/>
    排序
    <input type="text" name="sort" class="input" style="width:50px;text-align:center" onclick="this.select()" value="0"/>
    </td>
  </tr>
  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td>&nbsp;</td>
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
    var box = Atai.$(boxId);
    var _dialog = new AtaiShadeDialog();
    _dialog.init({
        obj: boxId
		, sure: function () { }
		, CWCOB: false
    });
    _categEditorBoxDialog = _dialog;

	$.ajax({
		url: "/MArticle/GetArticleTypeInfo"
		, type: "post"
		, data: "parentId=" + parentId + "&itemId=" + itemId
		, dataType: "json"
		, success: function(json){
			$(_categEditorBoxDialog.dialog).find("input[name='parentId']").val(parentId);

			$(_categEditorBoxDialog.dialog).find("input[name='itemId']").val(itemId);
			$(_categEditorBoxDialog.dialog).find("#categParentName").val(json.parentName);
			$(_categEditorBoxDialog.dialog).find("input[name='name']").val(json.type.article_type_name);
			$(_categEditorBoxDialog.dialog).find("input[name='sort']").val(json.type.sort_no); //s_text
		}
	});
	return false;
}
function postHelpCategBox(form){
    var obj = $(_categEditorBoxDialog.dialog).find("span[class='tips-text']");
	obj.html("");
	if(showLoadding) showLoadding();
	var postData=getPostDB(form);
	$.ajax({
		url: "/MArticle/PostCategData"
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
			if(closeLoadding) closeLoadding();
		}
	});
	return false;
}
</script>