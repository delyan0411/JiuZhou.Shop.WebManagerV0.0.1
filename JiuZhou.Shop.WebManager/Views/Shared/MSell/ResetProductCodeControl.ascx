<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="resetProdectCode-boxControl" class="moveBox" style="height:260px;width:400px;">
	<div class="name">
		修改商品编码
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postProductCodeData(this)">
<input type="hidden" name="orderid" value=""/>
<input type="hidden" name="productid" value=""/>
<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">商 品 名：</td>
    <td><input type="text" class="input" value="" name="productname" disabled="disabled"/></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">商品编码：</td>
    <td><input type="text" class="input" value="" name="productcode"/></td>
  </tr>
  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value="  提 交  " /></td>
  </tr>
</table>
</form>
<script type="text/javascript">
    function postProductCodeData(form) {
	var postData=getPostDB(form);
	$.ajax({
	    url: "/msell/PostProductCodeData"
            , type: "post"
			, data: postData
			, dataType: "json"
			, success: function(json){
				if(json.error){
				    $(_resetProductCodeBoxDialog.dialog).find("span[class='tips-text']").html(json.message); return false;
				}else{
				    jsbox.success(json.message,window.location.href);
				}
			}
	});
	return false;
}
var _resetProductCodeBoxDialog = false;
function resetCode(orderid, productid, productcode, productname) {

    var boxId = "#resetProdectCode-boxControl";
    var box = Atai.$(boxId);
    var _dialog = false;
    if (!_dialog)
        _dialog = new AtaiShadeDialog();
    _dialog.init({
        obj: box
		, sure: function () { }
		, CWCOB: false
    });
    _resetProductCodeBoxDialog = _dialog;

    $(_resetProductCodeBoxDialog.dialog).find("input[name='orderid']").val(orderid);
    $(_resetProductCodeBoxDialog.dialog).find("input[name='productid']").val(productid);
    $(_resetProductCodeBoxDialog.dialog).find("input[name='productcode']").val(productcode);
    $(_resetProductCodeBoxDialog.dialog).find("input[name='productname']").val(productname);
	
	return false;
}
</script>
</div>