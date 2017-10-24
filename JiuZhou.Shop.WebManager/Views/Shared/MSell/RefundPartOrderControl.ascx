<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="resetPartOrderState-boxControl" class="moveBox" style="height:700px;width:700px;">
	<div class="name">
		部分退订
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return PostResetPartOrderStatus(this)">
<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" >订 单 号：</td>
    <td>
    <input type="text" id="reset-orderNumber" class="input" value="" name="orderNumber2"/>
    <input type="hidden" name="orderNumber" />
    </td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" >售后状态：</td>
    <td>
    <input type="radio" name="serviceState" onclick="checkedthis(this,'serviceState')" value="1"/> 正在处理
    &nbsp;|&nbsp;
    <input type="radio" name="serviceState" onclick="checkedthis(this,'serviceState')" value="2"/> 处理完毕
    </td>
  </tr>
  <tr>
  <td class="left" style="height:36px;" valign="top">商&nbsp;&nbsp;品：</td>
  <td><div v="data-list-options" style="width:100%;height:300px;overflow:scroll"><ul class="data-box-list"></ul></div></td>
  </tr>
  <tr>
    <td class="left" style="height:150px;" valign="top">备&nbsp;&nbsp;注：</td>
    <td>
      <textarea style="width:360px;height:120px;" name="remark"></textarea>
    </td>
  </tr>

  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value=" 退订 " /></td>
  </tr>
</table>
</form>
</div>
<script type="text/javascript">
    function PostResetPartOrderStatus(form) {
        var _data = getPostDB(form);
         jsbox.confirm('您确定要将订单 <span style="color:#ff6600">' + $(form).find("input[name='orderNumber']").val() + '</span> 退订吗？', function () {
            $.ajax({
                url: "/MSell/ResetPartOrderStatus"
			, data: _data
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        $(_resetPartOrderStatusBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
			    } else {
			        jsbox.success(json.message, window.location.href);
			    }
			}
            });
        });
        return false;
    }

var _resetPartOrderStatusBoxDialog = false;
function resetPartOrderStatusBox(orderNumber, state, remark) {

    var boxId = "#resetPartOrderState-boxControl";
    var box = Atai.$(boxId);
    var _dialog = new AtaiShadeDialog();
    _dialog.init({
        obj: box
		, sure: function () { }
		, CWCOB: false
    });
    _resetPartOrderStatusBoxDialog = _dialog;

    $(_resetPartOrderStatusBoxDialog.dialog).find("input[name='orderNumber']").val(orderNumber);
    $(_resetPartOrderStatusBoxDialog.dialog).find("input[name='orderNumber2']").val(orderNumber);

    $(_resetPartOrderStatusBoxDialog.dialog).find("input[name='serviceState']").each(function () {
        if ($(this).val() == (Number(state) + 1)) {
            $(this).attr("checked", true);
           // $(this).click();
        } else {
            $(this).attr("checked", false);
        }
    });

    $.ajax({
        url: "/MSell/GetOrderProducts"
			, data: { "orderno": orderNumber }
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        $(_resetPartOrderStatusBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
			    } else {
			        var html = '';
			        for (var i = 0; i < json.list.length; i++) {
			            var _dis = "";
			            var _sel = "";
			            if (json.list[i].item_state != 0) {
			                _dis = "disabled";
			                _sel = "checked=checked";
			            }
			            html += '<li style="height:65px;"><div style="float:left;"><input ' + _dis + ' type="checkbox" onclick="selectOne(this)" name="visitid" value="' + json.list[i].product_id + '" '+ _sel +'/>';
			            html += '<img src="' + (formatImageUrl(json.list[i].img_src, 60, 60)) + '" style="width:60px;height:60px;"/> </div>';
			            html += '<div style="float:left;">商品名：<a href="<%=config.UrlHome%>' + json.list[i].product_id + '.html" target="_blank" style="color:green">' + json.list[i].product_name + '</a><br/><span> 价&nbsp;格：' + json.list[i].deal_price + ' 元 × ' + json.list[i].sale_num + '</span></div>';
			            html += '<p class="clear"></p>';
			            html += '</li>';
			        }
			        var o = $(_resetPartOrderStatusBoxDialog.dialog).find("div[v='data-list-options'] ul");
			        o.append(html);
			    }
			}
    });

    $(_resetPartOrderStatusBoxDialog.dialog).find("textarea[name='remark']").val(remark);
	
	return false;
}

</script>
