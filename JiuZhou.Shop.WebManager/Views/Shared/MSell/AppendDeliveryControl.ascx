<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="DeliveryData-boxControl" class="moveBox" style="height:250px;width:390px;">
	<div class="name">
		订单发货
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postDeliveryData(this)">
<input type="hidden" id="otp-orderNumber" name="orderNumber" value=""/>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">订单号：</td>
    <td><input type="text" id="DeliveryData-orderNumber" class="input" value="" disabled="disabled"/></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">快递公司：</td>
    <td><input type="text" name="expressCompany" class="input" value="" /></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">快递单号：</td>
    <td><input type="text" name="expressNumber" class="input" value="" /></td>
  </tr>

  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value="  保 存  " /></td>
  </tr>
</table>
</form>
<script type="text/javascript">
function postDeliveryData(form){
	var postData=getPostDB(form);
	$.ajax({
			url: "/msell/postDeliveryData"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function(json){
				if(json.error){
				    $(_DeliveryDataBoxDialog.dialog).find("span[class='tips-text']").html(json.message); return false;
				}else{
					window.location.href=window.location.href;
				}
			}
	});
	return false;
}
var _DeliveryDataBoxDialog = false;
function appendDeliveryBox(event, orderNumber){
	var boxId="#DeliveryData-boxControl";
	var box = Atai.$(boxId);
	var _dialog = false;
	if (!_dialog)
	    _dialog = new AtaiShadeDialog();
	_dialog.init({
	    obj: boxId
		, sure: function () { }
		, CWCOB: true
	});
	_DeliveryDataBoxDialog = _dialog;
	$(_DeliveryDataBoxDialog.dialog).find("input[name='orderNumber']").val(orderNumber);
	$(_DeliveryDataBoxDialog.dialog).find("#DeliveryData-orderNumber").val(orderNumber);
	return false;
}
</script>
</div>