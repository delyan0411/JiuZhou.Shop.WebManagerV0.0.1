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
<div id="QJ-boxControl" class="moveBox" style="height: 350px; width: 500px;">
    <div class="name">
        查看企健商品审核状态
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
    </div>
    <div class="clear">&nbsp;</div>

    
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tbody>
            <tr>
                <td class="left" style="height: 36px;" valign="top">商品ID：</td>
                <td>
                    <input type="text" name="product_id" value="" disabled="disabled" /></td>
            </tr>
            <tr>
                <td class="left" style="height: 36px;" valign="top">返回原文：</td>
                <td>
                    <textarea name="result"></textarea></td>
            </tr>
            <tr>
                <td class="left" style="height: 36px;" valign="top"></td>
                <td><span>-1未登记 1审核通过 0审核未通过</span><br />
                </td>
            </tr>
            <tr>
                <td class="left" style="height: 36px;" valign="top"></td>
                <td>
                    <select name="product_type_name">
                        <option>保健品
                        </option>
                        <option selected="selected">（散装）中药及中药饮片
                        </option>
                        <option>药品
                        </option>
                        <option>医疗器械
                        </option>
                        <option>药食同源
                        </option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="left" style="height: 36px;" valign="top"></td>
                <td>
                    <input type="button" style="width: 120px;" value="手动推送商品到企健审核" name="updatebtn" onclick="pushproQJ()" /></td>
            </tr>
        </tbody>
    </table>
    <script type="text/javascript">
        var _QJBoxDialog = false;
        function getQJstate(obj, product_id, product_code) {

            var boxId = "#QJ-boxControl";
            var box = Atai.$(boxId);
            var _dialog = false;
            if (!_dialog)
                _dialog = new AtaiShadeDialog();
            _dialog.init({
                obj: box
                , sure: function () { }
                , CWCOB: true
            });
            _QJBoxDialog = _dialog;
            $(_QJBoxDialog.dialog).find("input[name='product_id']").val(product_id);
            $.ajax({
                url: "/MGoods/CheckQJ"
                    , type: "post"
                    , data: { "product_id": product_id, "product_code": product_code }
                    , dataType: "json"
                    , success: function (json) {
                        //console.log(json);

                        if (json.error) {
                            alert(json.message);
                        } else {
                            $(_QJBoxDialog.dialog).find("textarea[name='result']").val(json.result);
                        }
                    }
            });
            return false;
        }
        function pushproQJ() {
            var product_id = $(_QJBoxDialog.dialog).find("input[name='product_id']").val();
            var product_type_name = $(_QJBoxDialog.dialog).find("select[name='product_type_name']").val();
            $.ajax({
                url: "/MGoods/PushQJ"
                   , type: "post"
                   , data: { "product_id": product_id, "product_type_name": product_type_name }
                   , dataType: "json"
                   , success: function (json) {
                       //console.log(json);
                       if (json.error) {
                           alert(json.message);
                       }
                       else
                           alert(json.result);
                       //window.location.href = window.location.href;

                   }
            });
        }
    </script>
</div>
