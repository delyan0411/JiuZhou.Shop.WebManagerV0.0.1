<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="resetOrderstyle-boxControl" class="moveBox" style="height:250px;width:450px;">
	<div class="name">
		退订方式
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
    <input type="radio" name="resetstyle" onclick="checkedthis(this,'resetstyle')" value="1" /> 整单退订
    &nbsp;|&nbsp;
    <input type="radio" name="resetstyle" onclick="checkedthis(this,'resetstyle')" value="2"/> 部分退订
    </td>
  </tr>

  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="button" class="submit" value=" 确定 " onclick="sureButton()"/>&nbsp;&nbsp;<input type="button" class="submit" value=" 取消 "onclick="cancleButton()" /></td>
  </tr>
</table>
</div>


<div id="resetOrderState-boxControl" class="moveBox" style="height:450px;width:520px;">
	<div class="name">
		整单退订
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return PostResetOrderStatus(this)">
<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">订 单 号：</td>
    <td>
    <input type="text" id="reset-orderNumber" class="input" value="" name="orderNumber2" disabled="disabled"/>
    <input type="hidden" name="orderNumber" />
    </td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">售后状态：</td>
    <td>
    <input type="radio" name="serviceState" onclick="checkedthis(this,'serviceState')" value="1"/> 正在处理
    &nbsp;|&nbsp;
    <input type="radio" name="serviceState" onclick="checkedthis(this,'serviceState')" value="2"/> 处理完毕
    </td> </tr>
    <tr name="isallow">
    <td class="left" style="height:36px;">积分\优惠券：</td>
    <td>
    <input type="checkbox" name="returnintergral" value="1" checked/> 是否退积分
    &nbsp;|&nbsp;
    <input type="checkbox" name="returncoupon" value="1" checked/> 是否退优惠券
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
    var _state = 0;
    function PostResetOrderStatus(form) {
        var postData = {
             "orderNumber": $(form).find("input[name='orderNumber']").val()
           , "innerremark": $(form).find("textarea[name='remark']").val()
         //  , "returnmoney": $(form).find("input[name='returnmoney']").val()
           , "servicestate": $(form).find("input[name=serviceState]:checked").val()
           , "returnintergral": _state==1 ? 0 : $(form).find("input[name=returnintergral]:checked").val()
           , "returncoupon": _state == 1 ? 0 : $(form).find("input[name=returncoupon]:checked").val()
        }
         jsbox.confirm('您确定要将订单 <span style="color:#ff6600">' + $(form).find("input[name='orderNumber']").val() + '</span> 退订吗？', function () {
            $.ajax({
                url: "/MSell/ResetOrderStatus"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        $(_resetOrderStatusBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
			    } else {
			        jsbox.success(json.message, window.location.href);
			    }
			}
            });
        });
        return false;
    }

var _resetOrderStatusBoxDialog = false;
function resetOrderStatusBox(orderNumber, state, remark) {

    var boxId = "#resetOrderState-boxControl";
    var box = Atai.$(boxId);
    var _dialog = new AtaiShadeDialog();
    _dialog.init({
        obj: box
		, sure: function () { }
		, CWCOB: false
    });
    _resetOrderStatusBoxDialog = _dialog;
    _state = state;
    $(_resetOrderStatusBoxDialog.dialog).find("input[name='orderNumber']").val(orderNumber);
    $(_resetOrderStatusBoxDialog.dialog).find("input[name='orderNumber2']").val(orderNumber);
    if (_state == 1)
        $(_resetOrderStatusBoxDialog.dialog).find("tr[name='isallow']").hide();
    $(_resetOrderStatusBoxDialog.dialog).find("input[name='serviceState']").each(function () {
        if ($(this).val() == (Number(state) + 1)) {
            $(this).attr("checked", true);
            //$(this).click();
        } else {
            $(this).attr("checked", false);
        }
    });
    /*
    $.ajax({
        url: "/MSell/GetOrderMoneys"
    , data: { "orderno": orderNumber }
    , type: "post"
    , dataType: "json"
    , success: function (json) {
        if (json.error) {
            //jsbox.error(json.message); return false;
            $(_resetOrderStatusBoxDialog.dialog).find("span[class='tips-text']").html("获取该订单金额信息失败！");
        } else {
            $(_resetOrderStatusBoxDialog.dialog).find("span[class='ordermoney']").html(json.orderinfo.order_money);
            $(_resetOrderStatusBoxDialog.dialog).find("span[class='transmoney']").html(json.orderinfo.trans_money);
            $(_returnOrderBoxDialog.dialog).find("span[class='couponmoney']").html(json.orderinfo.coupon_money + json.orderinfo.integral_money + json.orderinfo.fulloff_money);
            if (Number(state) == 0) {
                $(_resetOrderStatusBoxDialog.dialog).find("input[name='returnmoney']").val(json.orderinfo.order_money + json.orderinfo.trans_money);
            } else {
                $(_resetOrderStatusBoxDialog.dialog).find("input[name='returnmoney']").val(json.orderinfo.refund_money);
            }
            if (Number(state) == 1)
                $(_resetOrderStatusBoxDialog.dialog).find("input[name='returnmoney']").attr("Disabled", true); 
        }
    }
    });
    */
    $(_resetOrderStatusBoxDialog.dialog).find("textarea[name='remark']").val(remark);
	
	return false;
}

var _style = 1;
var _resetOrderStyleBoxDialog = false;
function resetOrderStyleBox(orderNumber, state) {
    var boxId = "#resetOrderstyle-boxControl";
    var box = Atai.$(boxId);
    var _dialog = new AtaiShadeDialog();
    _dialog.init({
        obj: box
		, sure: function () { }
		, CWCOB: false
    });
    _resetOrderStyleBoxDialog = _dialog;

    $(_resetOrderStyleBoxDialog.dialog).find("input[name='orderNumber']").val(orderNumber);
    $(_resetOrderStyleBoxDialog.dialog).find("input[name='orderNumber2']").val(orderNumber);

    $(_resetOrderStyleBoxDialog.dialog).find("input[name='servicestate']").val(state);

    $(_resetOrderStyleBoxDialog.dialog).find("input[name='resetstyle']").each(function () {
        if ($(this).val() == _style) {
            $(this).attr("checked",true);
        }
    });
    return false;
}

function sureButton() {
    $(_resetOrderStyleBoxDialog.dialog).find("input[name='resetstyle']").each(function () {
        if ($(this).attr("checked") == "checked")
            _style = $(this).val();
    });
    if (_style == 1)
        resetOrderStatusBox($(_resetOrderStyleBoxDialog.dialog).find("input[name='orderNumber']").val(), $(_resetOrderStyleBoxDialog.dialog).find("input[name='servicestate']").val());
    else
        resetPartOrderStatusBox($(_resetOrderStyleBoxDialog.dialog).find("input[name='orderNumber']").val(), $(_resetOrderStyleBoxDialog.dialog).find("input[name='servicestate']").val());
        _resetOrderStyleBoxDialog.close();
}

function cancleButton() {
    _resetOrderStyleBoxDialog.close();
}

function checkedthis(obj, name) {
    if (obj.checked) {
        $(obj).attr("checked", true);
        $("input[name='" + name + "']").each(function () {
            if (this != obj)
                $(this).attr("checked", false);
            if (name == "resetstyle")
                _style = $(this).val();
        });
   //     if (obj.val() == "1")
    //        $(_returnOrderBoxDialog.dialog).find("input[name='returnmoney']").attr("Disabled", false);
     //   if (obj.val() == "2")
      //      $(_returnOrderBoxDialog.dialog).find("input[name='returnmoney']").attr("Disabled", true);
    } else {
        $(obj).attr("checked", false);
        $("input[name='"+ name +"']").each(function () {
            if (this != obj)
                $(this).attr("checked", true);
        });
    }
}
</script>
