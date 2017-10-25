<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="orderRefund-boxControl" class="moveBox" style="height:220px;width:390px;">
	<div class="name">
		退款
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postOrderRefund(this)">
<input type="hidden" id="refund-orderNumber" name="orderNumber" value=""/>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">订单号：</td>
    <td><input type="text" id="orefund-orderNumber" class="input" value="" disabled="disabled"/></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">退款金额：</td>
    <td><input type="text" name="money" class="input" value="" style="width:60px"/> 元 (最多可退 <span id="maxManey">0</span> 元)</td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">登录密码：</td>
    <td><input type="password" name="password" class="input" value=""/></td>
  </tr>

  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value="  保 存  " /></td>
  </tr>
</table>
</form>
<script type="text/javascript">
function postOrderRefund(form){
	var postData=getPostDB(form);
	$.ajax({
			url: "/msell/Refund"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function(json){
				if(json.error){
					$(_orderRefundBoxDialog.dialog).find("span[class='tips-text']").html(json.message);return false;
				}else{
					window.location.href=window.location.href;
				}
			}
	});
	return false;
}
var _orderRefundBoxDialog = false;
var _orderRefundClickObject = false;
function resetRefund(obj, orderNumber){
	$("#refund-orderNumber").val(orderNumber);
	$("#orefund-orderNumber").val(orderNumber);
	var money=$(obj).attr("price");
	_orderRefundClickObject=obj;
	//var obj=$("#orderRefund-boxControl input[name='money']");
	//obj.val(money);
	$("#maxManey").html(money);

	var boxId="#orderRefund-boxControl";
	var box = Atai.$(boxId);
	var _dialog = false;
	if (!_dialog)
	    _dialog = new AtaiShadeDialog();
	_dialog.init({
	    obj: box
		, sure: function () { }
		, CWCOB: true
	});
	_orderRefundBoxDialog=_dialog;
	return false;
}
</script>
</div>