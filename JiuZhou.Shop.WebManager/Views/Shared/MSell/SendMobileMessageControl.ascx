<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="mobile-boxControl" class="moveBox" style="height:360px;width:500px;">
	<div class="name">
		发送手机短信
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postMobileMessageData(this)">
<input type="hidden" name="orderNumber" value=""/>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">订单号：</td>
    <td><input type="text" id="mobile-orderNumber" class="input" value="" name="orderNumber" disabled="disabled"/></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">手机号：</td>
    <td><input type="text" id="mobile-mobile" class="input" name="mobile" value="" disabled="disabled"/>
        <input type="hidden" name="mobile2" value="" />
    </td>
  </tr>
  <tr>
    <td class="left" style="height:150px;" valign="top">短信内容：</td>
    <td>
<textarea style="width:360px;height:120px;" name="message"></textarea>
    </td>
  </tr>

  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value="  发送短信  " /></td>
  </tr>
</table>
</form>
<script type="text/javascript">
function postMobileMessageData(form){
	var postData=getPostDB(form);
	$.ajax({
	    url: "/msell/PostMobileMessageData"
            , type: "post"
			, data: postData
			, dataType: "json"
			, success: function(json){
				if(json.error){
				    $(_MobileMessageBoxDialog.dialog).find("span[class='tips-text']").html(json.message); return false;
				}else{
					if(_mobileMessageClickObj){
						var count=$(_mobileMessageClickObj).attr("count");
						count++;
						$(_mobileMessageClickObj).find("span").html("(" + count + ")");
						$(_mobileMessageClickObj).attr("count", count);
						if(_MobileMessageBoxDialog)_MobileMessageBoxDialog.close();
					}else{
						window.location.href=window.location.href;
					}
				}
			}
	});
	return false;
}
var _MobileMessageBoxDialog = false;
var _mobileMessageClickObj=false;
function sendMobileMessageBox(obj, orderNumber) {

    var boxId = "#mobile-boxControl";
    var box = Atai.$(boxId);
    var boxName = Atai.$(boxId + " div[class='name']")[0];
    var _dialog = false;
    if (!_dialog)
        _dialog = new AtaiShadeDialog();
    _dialog.init({
        obj: box
		, sure: function () { }
		, CWCOB: true
    });
    _MobileMessageBoxDialog = _dialog;

    $.ajax({
        url: "/msell/GetRecmobile"
            , type: "post"
			, data: { "orderno": orderNumber }
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        $("#mobile-boxControl span[class='tips-text']").html(json.message); return false;
			    } else {
			        _mobileMessageClickObj = obj;
			        $(_MobileMessageBoxDialog.dialog).find("input[name='orderNumber']").val(orderNumber);
			        $(_MobileMessageBoxDialog.dialog).find("#mobile-orderNumber").val(orderNumber);
			        $(_MobileMessageBoxDialog.dialog).find("#mobile-mobile").val(json.mobile);
			        $(_MobileMessageBoxDialog.dialog).find("input[name='mobile2']").val(json.mobile);
			        var message = "您的订单已经生成，因商品数量有限，请您完成最后的支付流程，以便物品及时发出，如需帮助可联系客服，电话：4008866360！谢谢！";
			        $(_MobileMessageBoxDialog.dialog).find("textarea[name='message']").val(message);
			    }
			}
    });
	
	return false;
}
</script>
</div>