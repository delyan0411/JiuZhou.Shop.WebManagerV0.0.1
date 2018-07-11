<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="JiuZhou.Model" %>
<%@ Import Namespace="JiuZhou.Common" %>
<%@ Import Namespace="JiuZhou.MySql" %>
<%@ Import Namespace="JiuZhou.Cache" %>
<%@ Import Namespace="JiuZhou.XmlSource" %>
<%@ Import Namespace="JiuZhou.HttpTools" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="HYstate-boxControl" class="moveBox" style="height: 460px; width: 500px;">
    <div class="name">
        查看翰医支付状态
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
    </div>
    <div class="clear">&nbsp;</div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tbody>
            <tr>
                <td class="left" style="height: 36px;" valign="top">订 单 号：</td>
                <td>
                    <input type="text" name="orderNumber" value="" disabled="disabled" /></td>
            </tr>
            <tr>
                <td class="left" style="height: 36px;" valign="top">返回原文：</td>
                <td>
                    <textarea name="result"></textarea></td>
            </tr>
            <tr>
                <td class="left" style="height: 36px;" valign="top">返回结果代码：</td>
                <td>
                    <input type="text" name="MsgRspCode" value="" disabled="disabled" /></td>
            </tr>
            <tr>
                <td class="left" style="height: 36px;" valign="top">返回结果：</td>
                <td>
                    <input type="text" name="MsgRspDesc" value="" disabled="disabled" /></td>
            </tr>
            <tr>
                <td class="left" style="height: 36px;" valign="top">订单状态：</td>
                <td>
                    <input type="text" name="OrderState" value="" disabled="disabled" /></td>
            </tr>
            <tr>
                <td class="left" style="height: 36px;" valign="top">订单状态描述：</td>
                <td>
                    <input type="text" name="OrderStateDesc" value="" disabled="disabled" /></td>
            </tr>
            <tr>
                <td class="left" style="height: 36px;" valign="top">传送时间：</td>
                <td>
                    <input type="text" name="TransDate" value="" disabled="disabled" /></td>
            </tr>
            <tr>
                <td class="left" style="height: 36px;" valign="top">金额(分)：</td>
                <td>
                    <input type="text" name="Amount" value="" disabled="disabled" /></td>
            </tr>
            <tr>
                <td class="left" style="height: 30px;">&nbsp;</td>
                <td>
                    <input type="button" style="width:120px;"  value="  更新订单状态  " name="updatebtn" onclick="updatestate()" disabled="disabled" /></td>
            </tr>
        </tbody>
    </table>
    <script type="text/javascript">
        var _HYstateBoxDialog = false;
        function getHYstate(obj, orderNumber, orderstate) {
            var boxId = "#HYstate-boxControl";
            var box = Atai.$(boxId);
            var _dialog = false;
            if (!_dialog)
                _dialog = new AtaiShadeDialog();
            _dialog.init({
                obj: box
                , sure: function () { }
                , CWCOB: true
            });
            _HYstateBoxDialog = _dialog;
            $.ajax({
                url: "/MSell/CheckHYOrder"
                    , type: "post"
                    , data: { "order_no": orderNumber }
                    , dataType: "json"
                    , success: function (json) {
                        //console.log(json);
                      
                        if (json.error) {
                            alert(json.message);
                        } else {
                            $(_HYstateBoxDialog.dialog).find("input[name='orderNumber']").val(orderNumber);
                            $(_HYstateBoxDialog.dialog).find("textarea[name='result']").val(json.result);
                            var resobj = JSON.parse(json.result);
                            $(_HYstateBoxDialog.dialog).find("input[name='MsgRspCode']").val(resobj.MsgRspCode);
                            $(_HYstateBoxDialog.dialog).find("input[name='MsgRspDesc']").val(resobj.MsgRspDesc);
                            $(_HYstateBoxDialog.dialog).find("input[name='OrderState']").val(resobj.OrderState);
                            $(_HYstateBoxDialog.dialog).find("input[name='OrderStateDesc']").val(resobj.OrderStateDesc);
                            $(_HYstateBoxDialog.dialog).find("input[name='TransDate']").val(resobj.TransDate);
                            $(_HYstateBoxDialog.dialog).find("input[name='Amount']").val(resobj.Amount);
                            //jsbox.success(json.message, window.location.href);
                            //console.log(json);
                            if (resobj.MsgRspCode == "0000" && resobj.OrderState == 2 && (orderstate == 0 || orderstate == 1 || orderstate == 9)) {
                                $(_HYstateBoxDialog.dialog).find("input[name='updatebtn']").css({"background-color":"#F00"}).removeAttr('disabled');                              
                            }
                        }
                    }
            });
            return false;
        }
        function updatestate()
        {
            var orderNumber = $(_HYstateBoxDialog.dialog).find("input[name='orderNumber']").val();
            $.ajax({
                url: "/MSell/UpdateHYOrderState"
                   , type: "post"
                   , data: { "order_no": orderNumber }
                   , dataType: "json"
                   , success: function (json) {
                       //console.log(json);
                       if (json.error) {
                           alert(json.message);
                       }
                       else
                           alert(json.message);
                       //window.location.href = window.location.href;

                   }
            });
        }
    </script>
</div>
