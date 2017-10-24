<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="updateRecAddr" class="moveBox" style="height:460px;width:450px;">
	<div class="name">
		修改收货信息
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postReceiveAddr(this)">
<input type="hidden" id="updateRecAddr-orderno" name="orderNumber" value=""/>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr> 
    <td class="left" style="height:36px;" valign="top">订 单 号：</td>
    <td><input type="text" id="updateRecAddr-orderno2" class="input" value="" disabled="disabled"/></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">收货姓名：</td>
    <td><input type="text" class="input" name="receivename" value="" /></td>
  </tr>
   <tr>
    <td class="left" style="height:36px;" valign="top">省&nbsp;&nbsp;名：</td>
    <td><input type="text" class="input" name="provincename" value="" /></td>
  </tr>
   <tr>
    <td class="left" style="height:36px;" valign="top">城 市 名：</td>
    <td><input type="text" class="input" name="cityname" value="" /></td>
  </tr>
   <tr>
    <td class="left" style="height:36px;" valign="top">区&nbsp;&nbsp;名：</td>
    <td><input type="text" class="input" name="countyname" value="" /></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">收货地址：</td>
    <td><input type="text" class="input" name="receiveaddr" value="" /></td>
  </tr>
   <tr>
    <td class="left" style="height:36px;" valign="top">收货电话：</td>
    <td><input type="text" class="input" name="receivemobile" value="" /></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">用户电话：</td>
    <td><input type="text" class="input" name="usertel" value="" /></td>
  </tr>
   <tr>
    <td class="left" style="height:36px;" valign="top">邮&nbsp;&nbsp;编：</td>
    <td><input type="text" class="input" name="zipcode" value="" /></td>
  </tr>
  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value="  保 存  " /></td>
  </tr>
</table>
</form>
</div>
<script type="text/javascript">
    function postReceiveAddr(form) {
	var postData=getPostDB(form);
	$.ajax({
	    url: "/msell/PostReceiveAddrData"
            , type: "post"
			, data: postData
			, dataType: "json"
			, success: function(json){
				if(json.error){
				    $(_oupdateAddrBoxDialog.dialog).find("span[class='tips-text']").html(json.message); return false;
				}else{
					jsbox.success(json.message,window.location.href);
				}
			}
	});
	return false;
}
var _oupdateAddrBoxDialog = false;
function updateReceiveAddr(orderNumber, receivename, pname, ciname, coname, receiveaddr, mobile, usertel, zipcode) {

    var boxId = "#updateRecAddr";
    var box = Atai.$(boxId);
    var _dialog = false;
    if (!_dialog)
        _dialog = new AtaiShadeDialog();
    _dialog.init({
        obj: boxId
		    , sure: function () { }
		    , CWCOB: false
    });
    _oupdateAddrBoxDialog = _dialog;
    $(_oupdateAddrBoxDialog.dialog).find("#updateRecAddr-orderno").val(orderNumber);
    $(_oupdateAddrBoxDialog.dialog).find("#updateRecAddr-orderno2").val(orderNumber);
    $(_oupdateAddrBoxDialog.dialog).find("input[name='receivename']").val(receivename);
    $(_oupdateAddrBoxDialog.dialog).find("input[name='provincename']").val(pname);
    $(_oupdateAddrBoxDialog.dialog).find("input[name='cityname']").val(ciname);
    $(_oupdateAddrBoxDialog.dialog).find("input[name='countyname']").val(coname);
    $(_oupdateAddrBoxDialog.dialog).find("input[name='receiveaddr']").val(receiveaddr);
    $(_oupdateAddrBoxDialog.dialog).find("input[name='receivemobile']").val(mobile);
    $(_oupdateAddrBoxDialog.dialog).find("input[name='usertel']").val(usertel);
    $(_oupdateAddrBoxDialog.dialog).find("input[name='zipcode']").val(zipcode);
    return false;
}
</script>
