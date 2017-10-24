<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="recommendPage-boxControl" class="moveBox" style="height:200px;width:520px;">
	<div class="name">
		推荐页面设置
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postRecommendPageBox(this)">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td colspan="2"><span id="recommendPageEditorBox-tips-message" class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">页面ID：</td>
    <td colspan="2">
    <input type="hidden" name="flag" class="input" value="" />
    <input type="hidden" name="plat" class="input" value="" />
    <input type="text" name="posid" class="input" value=""/>
    <input type="hidden" name="posid2" class="input" value="" />
    </td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">页面名称：</td>
    <td><input type="text" name="name" class="input" value=""/></td>
    <td><input type="submit" class="submit" value="  保 存  " /></td>
  </tr>
</table>
</form>
</div>
<script type="text/javascript">
    var _recommendPageEditorBoxDialog = false;

function showRecommendPageEditorBox(event, posid, name, isnew, plat){
	var boxId="#recommendPage-boxControl";
	var box = Atai.$(boxId);
	
    var _dialog = new AtaiShadeDialog();
    _dialog.init({
          obj: boxId
		, sure: function () { }
		, CWCOB: true
    });
      _recommendPageEditorBoxDialog = _dialog;
  
      $(_recommendPageEditorBoxDialog.dialog).find("input[name='posid']").attr("disabled", "true");
      $(_recommendPageEditorBoxDialog.dialog).find("input[name='posid']").val(posid);
      $(_recommendPageEditorBoxDialog.dialog).find("input[name='posid2']").val(posid);
      $(_recommendPageEditorBoxDialog.dialog).find("input[name='flag']").val(isnew);
      $(_recommendPageEditorBoxDialog.dialog).find("input[name='name']").val(name);
      $(_recommendPageEditorBoxDialog.dialog).find("input[name='plat']").val(plat);
      
	return false;
}
function postRecommendPageBox(form){
	//_recommendPageEditorBoxDialog.close();
    var obj = $(_recommendPageEditorBoxDialog.dialog).find("span[class='tips-text']");
    obj.html("");
	if(showLoadding) showLoadding();
	var postData=getPostDB(form);
	$.ajax({
		url: "/MPolymeric/PostRecommendPage"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function(json){
			//obj.className = "tips-text tips-icon";
			if(json.error){
			    obj.html(json.message);
            } else {
                _recommendPageEditorBoxDialog.close();
				window.location.href=window.location.href;
				//if(json.url) returnUrl = json.url;
				//succeedBox(json.message, returnUrl);
			}
			if(closeLoadding) closeLoadding();
		}
	});
	return false;
}
</script>