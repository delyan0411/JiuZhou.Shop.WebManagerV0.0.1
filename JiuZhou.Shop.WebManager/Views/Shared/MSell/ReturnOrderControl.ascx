<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="returnOrderstyle-boxControl" class="moveBox" style="height:250px;width:450px;">
	<div class="name">
		退货方式
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left" style="height:36px;">订 单 号：</td>
    <td>
    <input type="text" class="input" value="" name="orderNumber2" disabled="disabled"/>
    <input type="hidden" value="" name="orderNumber"/>
    <input type="hidden" value="" name="servicestate"/>
    </td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">退订方式：</td>
    <td>
    <input type="radio" name="resetstyle" onclick="checkedthis(this,'resetstyle')" value="1" /> 整单退货
    &nbsp;|&nbsp;
    <input type="radio" name="resetstyle" onclick="checkedthis(this,'resetstyle')" value="2"/> 部分退货
    </td>
  </tr>

  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="button" class="submit" value=" 确定 " onclick="sureButton2()"/>&nbsp;&nbsp;<input type="button" class="submit" value=" 取消 "onclick="cancleButton2()" /></td>
  </tr>
</table>
</div>

<div id="ReturnOrder-boxControl" class="moveBox" style="height:450px;width:520px;">
	<div class="name">
		退货
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return PostReturnOrder(this)">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">订 单 号：</td>
    <td><input type="text" id="reset-orderNumber" class="input" value="" name="orderNumber"/></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">售后状态：</td>
    <td>
    <input type="radio" name="serviceState" onclick="checkedthis(this,'serviceState')" value="1"/> 正在处理
    &nbsp;|&nbsp;
    <input type="radio" name="serviceState" onclick="checkedthis(this,'serviceState')" value="2"/> 处理完毕
    </td>
  </tr>
  <!--
  <tr>
   <td class="left" style="height:36px;" valign="top">金&nbsp;&nbsp;额：</td>
    <td>应付金额：<span class="ordermoney" style="color:#ff6600">&nbsp;</span> 元 | 运&nbsp;&nbsp;费：<span class="transmoney" style="color:#ff6600">&nbsp;</span> 元 | 优惠金额：<span class="couponmoney" style="color:#ff6600">&nbsp;</span> 元</td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">退款金额：</td>
    <td><input type="text" id="returnmoney" class="input" value="" name="returnmoney"/></td>
  </tr>
 -->
      <tr name="isallow">
    <td class="left" style="height:36px;">积分\优惠券：</td>
    <td>
    <input type="checkbox" name="isintegral" value="1" checked/> 是否退积分
    &nbsp;|&nbsp;
    <input type="checkbox" name="iscoupon" value="1" checked/> 是否退优惠券
    </td>
    </tr>

  <tr>
    <td class="left" style="height:150px;" valign="top">备&nbsp;&nbsp;注：</td>
    <td>
<textarea style="width:360px;height:120px;" name="remark"></textarea>
    </td>
  </tr>

  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value=" 退 货 " /></td>
  </tr>
</table>
</form>
<script type="text/javascript">
    var _style2 = 1;
    var _returnOrderStyleBoxDialog = false;
    function returnOrderStyleBox(orderNumber, state) {
        var boxId = "#returnOrderstyle-boxControl";
        var box = Atai.$(boxId);
        var _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: box
		, sure: function () { }
		, CWCOB: false
        });
        _returnOrderStyleBoxDialog = _dialog;

        $(_returnOrderStyleBoxDialog.dialog).find("input[name='orderNumber']").val(orderNumber);
        $(_returnOrderStyleBoxDialog.dialog).find("input[name='orderNumber2']").val(orderNumber);

        $(_returnOrderStyleBoxDialog.dialog).find("input[name='servicestate']").val(state);

        $(_returnOrderStyleBoxDialog.dialog).find("input[name='resetstyle']").each(function () {
            if ($(this).val() == _style2) {
                $(this).attr("checked", true);
            }
        });
        return false;
    }

    function sureButton2() {
        $(_returnOrderStyleBoxDialog.dialog).find("input[name='resetstyle']").each(function () {
            if ($(this).attr("checked") == "checked")
                _style2 = $(this).val();
        });
        if (_style2 == 1)
            returnOrderBox($(_returnOrderStyleBoxDialog.dialog).find("input[name='orderNumber']").val(), $(_returnOrderStyleBoxDialog.dialog).find("input[name='servicestate']").val());
        else
            returnPartOrderStatusBox($(_returnOrderStyleBoxDialog.dialog).find("input[name='orderNumber']").val(), $(_returnOrderStyleBoxDialog.dialog).find("input[name='servicestate']").val());
        _returnOrderStyleBoxDialog.close();
    }

    function cancleButton2() {
        _returnOrderStyleBoxDialog.close();
    }

    var _state = 0;
    function PostReturnOrder(form) {
        var postData = {
             "orderNumber": $(form).find("input[name='orderNumber']").val()
           , "innerremark": $(form).find("textarea[name='remark']").val()
          // , "returnmoney": $(form).find("input[name='returnmoney']").val()
           , "servicestate": $(form).find("input[name=serviceState]:checked").val()
           , "isintegral": _state == 1 ? 0 : $(form).find("input[name=isintegral]:checked").val()
           , "iscoupon": _state == 1 ? 0 : $(form).find("input[name=iscoupon]:checked").val()
        }
         jsbox.confirm('您确定要将订单 <span style="color:#ff6600">' + $(form).find("input[name='orderNumber']").val() + '</span> 退货吗？', function () {
            $.ajax({
                url: "/MSell/ReturnOrderPro"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    $(_returnOrderBoxDialog.dialog).find("span[class='tips-text']").html("");
			    if (json.error) {
			        $(_returnOrderBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
			    } else {
			        jsbox.success(json.message, window.location.href);
			    }
			}
            });
        });
        return false;
    }

    var _returnOrderBoxDialog = false;
function returnOrderBox(orderNumber, state, money, remark) {

    var boxId = "#ReturnOrder-boxControl";
    var box = Atai.$(boxId);
    var _dialog = new AtaiShadeDialog();
    _dialog.init({
        obj: box
		, sure: function () { }
		, CWCOB: false
    });
    _returnOrderBoxDialog = _dialog;
    _state = state;
    if (_state == 1)
        $(_returnOrderBoxDialog.dialog).find("tr[name='isallow']").hide();
    $(_returnOrderBoxDialog.dialog).find("input[name='orderNumber']").val(orderNumber);

    $(_returnOrderBoxDialog.dialog).find("input[name='serviceState']").each(function () {
        if ($(this).val() == (Number(state) + 1)) {
            $(this).attr("checked", true);
        } else {
            $(this).attr("checked", false);
        }
    });
    /*
    $.ajax({
        url: "/MSell/GetOrderMoneys"
			, data: {"orderno":orderNumber}
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        //jsbox.error(json.message); return false;
                    $(_returnOrderBoxDialog.dialog).find("span[class='tips-text']").html("获取该订单金额信息失败！");
			    } else {
			        $(_returnOrderBoxDialog.dialog).find("span[class='ordermoney']").html(json.orderinfo.order_money);
			        $(_returnOrderBoxDialog.dialog).find("span[class='transmoney']").html(json.orderinfo.trans_money);
			        $(_returnOrderBoxDialog.dialog).find("span[class='couponmoney']").html(json.orderinfo.coupon_money + json.orderinfo.integral_money + json.orderinfo.fulloff_money);
			        $(_returnOrderBoxDialog.dialog).find("input[name='returnmoney']").val(json.orderinfo.order_money + json.orderinfo.trans_money);
			        if (Number(state) == 0) {
			            $(_resetOrderStatusBoxDialog.dialog).find("input[name='returnmoney']").val(json.orderinfo.order_money + json.orderinfo.trans_money);
			        } else {
			            $(_resetOrderStatusBoxDialog.dialog).find("input[name='returnmoney']").val(json.orderinfo.refund_money);
			        }
                    if (Number(state) == 1)
                        $(_returnOrderBoxDialog.dialog).find("input[name='returnmoney']").attr("Disabled",true); 
			    }
			}
    });
      */
    $(_returnOrderBoxDialog.dialog).find("textarea[name='remark']").val(remark);
	
	return false;
}
</script>
</div>