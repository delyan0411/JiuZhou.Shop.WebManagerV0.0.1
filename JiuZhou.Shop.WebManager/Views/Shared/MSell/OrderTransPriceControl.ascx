<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="orderTransPrice-boxControl" class="moveBox" style="height:280px;width:390px;">
	<div class="name">
		修改价格
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postOrderTransPrice(this)">
<input type="hidden" id="otp-orderNumber" name="orderNumber" value=""/>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">订单号：</td>
    <td><input type="text" id="old-orderNumber" class="input" value="" disabled="disabled"/></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">订单金额：</td>
    <td><input type="text" name="orderPrice" class="input" value=""/> 元</td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">运费：</td>
    <td><input type="text" name="transPrice" class="input" value="" onclick="this.select()"/> 元</td>
  </tr>

  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value="  保 存  " /></td>
  </tr>
</table>
</form>
<script type="text/javascript">
function postOrderTransPrice(form){
	var postData=getPostDB(form);
	$.ajax({
	    url: "/msell/ResetOrderTransPrice"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        $(_orderTransPriceBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
			    } else {
			        if (_orderTransClickObject) {
			            //$(_orderTransClickObject).parent("th").find("b[v='price']").html("￥" + json.order_money);
			            //$(_orderTransClickObject).parent("th").find("span[v='farePrice']").html("(含运费 " + json.trans_money + " 元)");
			            //$(_orderTransClickObject).attr("price", json.data.order_money).attr("farePrice", json.trans_money);
			            //if(_orderTransPriceBoxDialog)_orderTransPriceBoxDialog.close();
			            _orderTransPriceBoxDialog.close();
			            jsbox.success(json.message, window.location.href);
			        } else {
			            window.location.href = window.location.href;
			        }
			    }
			}
	});
	return false;
}
var _orderTransPriceBoxDialog = false;
var _orderTransClickObject = false;
function orderTransPriceBox(obj, orderNumber, allowResetTotalPrice){

	var boxId="#orderTransPrice-boxControl";
	var box = Atai.$(boxId);
	var _dialog = false;
	if (!_dialog)
	    _dialog = new AtaiShadeDialog();
	_dialog.init({
	    obj: box
		, sure: function () { }
		, CWCOB: true
	});
	_orderTransPriceBoxDialog = _dialog;

	$(_orderTransPriceBoxDialog.dialog).find("#otp-orderNumber").val(orderNumber);
	$(_orderTransPriceBoxDialog.dialog).find("#old-orderNumber").val(orderNumber);
	var orderPrice = $(obj).attr("price");
	var transPrice = $(obj).attr("farePrice");
	_orderTransClickObject = obj;
	var obj1 = $(_orderTransPriceBoxDialog.dialog).find("input[name='orderPrice']");
	var obj2 = $(_orderTransPriceBoxDialog.dialog).find("input[name='transPrice']");
	obj1.val(orderPrice);
	if (!allowResetTotalPrice) obj1.attr("disabled", "disabled");
	else obj1.attr("disabled", false);
	obj2.val(transPrice);
	return false;
}
</script>
</div>