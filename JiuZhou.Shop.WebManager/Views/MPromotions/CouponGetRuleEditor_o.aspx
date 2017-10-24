<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<%
    int ruleid = DoRequest.GetQueryInt("getid", 0);
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    CouponGetRuleInfo info = new CouponGetRuleInfo();
    var resinfo = GetCouponGetRuleDetail.Do(ruleid);
    if (resinfo != null && resinfo.Body != null)
        info = resinfo.Body;
    List<CouponGetItem> items = new List<CouponGetItem>();
    if (info.item_list != null)
        items = info.item_list;
%>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
		<div class="editor-box-head" style="position:relative">
编辑优惠券领取规则
		</div>
		<div class="div-tab">
<form id="fareTempForm" method="post" action="" onsubmit="return submitForm(this)">
<input type="hidden" name="ruleid" value="<%=ruleid%>"/>
<table class="table" cellpadding="0" cellspacing="0">
<tbody>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">活动名称<b>*</b></td>
    <td class="inputText"><input type="text" name="name" must="1" value="<%=info.cget_name%>" class="input" style="width:320px" /></td>
    <td class="lable">有 效 期<b>*</b></td>
    <td class="inputText">
    <input type="text" name="validitydays" must="1" value="<%=info.validity_days>0?info.validity_days:30%>" class="input" style="width:40px"/> 天
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">发放数量<b>*</b></td>
    <td class="inputText">
    总数量： <input type="text" name="maxgivenum" must="1" value="<%=info.max_give_num%>" class="input" style="width:50px" /> 张&nbsp; 
    每天发放数量： <input type="text" name="maxdaygivenum" must="1" value="<%=info.max_day_give_num%>" class="input" style="width:50px" /> 张
    </td>
    <td class="lable">领取数量<b>*</b></td>
    <td class="inputText">
    总领取量： <input type="text" name="limitperusertotal" must="1" value="<%=info.limit_per_user_total%>" class="input" style="width:50px" /> 张&nbsp; 
    每天领取数量： <input type="text" name="limitperuserday" must="1" value="<%=info.limit_per_user_day%>" class="input" style="width:50px" /> 张
    </td>
  </tr>
 <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">开始时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-sdate" name="sdate" value="<%=info.start_time==null?DateTime.Now.ToString("yyyy-MM-dd"):DateTime.Parse(info.start_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-shours" name="shours" value="<%=info.start_time==null?"00":DateTime.Parse(info.start_time).Hour.ToString()%>" class="input" style="width:40px" title="数字0至23"/> 时
    <input type="text" id="box-sminutes" name="sminutes" value="<%=info.start_time==null?"00":DateTime.Parse(info.start_time).Minute.ToString()%>" class="input" style="width:40px" title="数字0至59"/> 分
<script type="text/javascript">
    Atai.addEvent(window, "load", function () {
        var hBox = Atai.$("#box-shours");
        var mBox = Atai.$("#box-sminutes");
        var tips = Atai.$("#tips-starttime");
        Atai.addEvent(hBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 23) {
                tips.className = "tips-icon";
                tips.innerHTML = " [时] 请填写0至23之间的数字";
            }
        });
        Atai.addEvent(mBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 59) {
                tips.className = "tips-icon";
                tips.innerHTML = " [分] 请填写0至59之间的数字";
            }
        });
        Atai.addEvent(hBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 24) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
        Atai.addEvent(mBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 60) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
    });
</script></td>
    <td colspan="2"><div class="tips-text" id="tips-starttime">&nbsp;</div></td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">结束时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-edate" name="edate" value="<%=info.end_time==null?DateTime.Now.AddDays(7).ToString("yyyy-MM-dd"):DateTime.Parse(info.end_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-ehours" name="ehours" value="<%=info.end_time==null?"23":DateTime.Parse(info.end_time).Hour.ToString()%>" class="input" style="width:40px" title="数字0至23"/> 时
    <input type="text" id="box-eminutes" name="eminutes" value="<%=info.end_time==null?"59":DateTime.Parse(info.end_time).Minute.ToString()%>" class="input" style="width:40px" title="数字0至59"/> 分
<script type="text/javascript">
    Atai.addEvent(window, "load", function () {
        var hBox = Atai.$("#box-ehours");
        var mBox = Atai.$("#box-eminutes");
        var tips = Atai.$("#tips-endtime");
        Atai.addEvent(hBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 23) {
                tips.className = "tips-icon";
                tips.innerHTML = " [时] 请填写0至23之间的数字";
            }
        });
        Atai.addEvent(mBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 59) {
                tips.className = "tips-icon";
                tips.innerHTML = " [分] 请填写0至59之间的数字";
            }
        });
        Atai.addEvent(hBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 24) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
        Atai.addEvent(mBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 60) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
    });
</script>
    </td>
    <td colspan="2"><div class="tips-text" id="tips-endtime">&nbsp;</div></td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">备&nbsp;&nbsp;注</td>
    <td colspan="3">
    <input type="text" name="remarks" value="<%=info.cget_remark%>" class="input" style="width:620px" />
    </td>
  </tr>
</tbody>
</table>
</form>
    <%
       List<UseCouponRuleInfo> infoList = new List<UseCouponRuleInfo>();
       var resrule = GetUseCouponRule.Do();
       if (resrule != null && resrule.Body != null && resrule.Body.coupon_rule_list != null)
           infoList = resrule.Body.coupon_rule_list;
       string couponmoney = "";
       int _count = 0;
       foreach (UseCouponRuleInfo item2 in infoList) {
           if (_count == 0)
           {
               couponmoney = item2.coupon_price.ToString();
           }
           else { 
               couponmoney = couponmoney + "," + item2.coupon_price.ToString();
           }
           _count++;
       }
     %>
<script type="text/javascript">
    function addRuleTable() {
    var _couponmoney = "<%=couponmoney %>".split(',');
   
    var html = '<table v="table-rules" class="table-rules" cellpadding="0" cellspacing="0" style="margin-top:20px">';
    html += '<input type="hidden" name="itemid" value="0"/>';
	html += '<thead><tr><th colspan="5">规则明细 <b style="color:#F00">*</b></th><th style="text-align:right">';
	html += '<a href="javascript:;" onclick="removeRules(this)" style="color:#999">删除明细</a></th></tr></thead>';

	html += '<tbody>';
	html += '<tr><td style="width:3%"></td>';
	html += '<td class="lable">优惠券面值</td>';
	html += '<td class="inputText" colspan="4">\n';
	html += '<select id="couponprice" name="couponprice" style="height:28px;width:160px;">';
	html += '<option value="0" init="true">请选择优惠券面值</option>';
    for(var i=0;i<_couponmoney.length;i++){
    	html += '<option value="'+ _couponmoney[i] +'">'+_couponmoney[i] +'元</option>';
    }
	html += '</select></td></tr>\n';

    html += '<tr><td style="width:3%"></td>\n';
	html += '<td class="lable">发放数量<b>*</b></td>\n';
	html += '<td class="inputText">\n';
	html += '总数量： <input type="text" name="itemmaxgivenum" must="1" value="" class="input" style="width:40px" /> 张&nbsp; \n';
	html += '每天发放数量： <input type="text" name="itemmaxdaygivenum" must="1" value="" class="input" style="width:40px" /> 张</td>\n';
	html += '<td class="lable">领取数量<b>*</b></td>\n';
	html += '<td class="inputText">\n';
	html += '总领取量： <input type="text" name="itemlimitperusertotal" must="1" value="" class="input" style="width:40px" /> 张&nbsp; \n';
	html += '每天领取数量： <input type="text" name="itemlimitperuserday" must="1" value="" class="input" style="width:40px" /> 张</td><td style="width:40px;">&nbsp;</td><tr>\n';

	html += '<tr><td style="width:3%"></td>\n';
	html += '<td class="lable">开始时间<b>*</b></td>\n';
	html += '<td class="inputText">\n';
	html += '<input type="text" id="itemsdate" name="itemsdate" value="<%=info.start_time==null?DateTime.Now.ToString("yyyy-MM-dd"):DateTime.Parse(info.start_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>';
	html += '<input type="text" id="itemshours" name="itemshours" value="00" class="input" style="width:40px" title="数字0至23"/> 时';
    html += '<input type="text" id="itemsminutes" name="itemsminutes" value="00" class="input" style="width:40px" title="数字0至59"/> 分';
    html += '</td><td colspan="3"><div class="tips-text" id="tips-istarttime">&nbsp;</div></td></tr>\n';

    html += '<tr><td style="width:3%"></td>\n';
	html += '<td class="lable">结束时间<b>*</b></td>\n';
	html += '<td class="inputText">\n';
	html += '<input type="text" id="itemedate" name="itemedate" value="<%=info.end_time==null?DateTime.Now.AddDays(7).ToString("yyyy-MM-dd"):DateTime.Parse(info.end_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>';
	html += '<input type="text" id="itemehours" name="itemehours" value="23" class="input" style="width:40px" title="数字0至23"/> 时';
    html += '<input type="text" id="itememinutes" name="itememinutes" value="59" class="input" style="width:40px" title="数字0至59"/> 分';
    html += '</td><td colspan="3"><div class="tips-text" id="tips-iendtime">&nbsp;</div></td></tr>\n';

	html += '</tbody>';
	html += '</table>';
	$("#fare-rules").append(html); 
}

var delids = "";
var _no = 0;
function removeRules(obj){
    jsbox.confirm('您确定要删除此明细吗？', function () {
        var tabObj = $(obj).parent("th").parent("tr").parent("thead").parent("table");
        var _itemid = tabObj.find("input[name='itemid']").val();
        if (_itemid > 0) {
            if (_no == 0) {
                delids = _itemid;
            } else {
                delids = delids + "," + _itemid;
            }
            _no++;
        }

        tabObj.remove();
    });
}

</script>
<div id="fare-rules">
<%
    int _count2 = 0;
    foreach(CouponGetItem item in items){
        _count2++;
%>
<table v="table-rules" class="table-rules" style="margin-top:20px" cellpadding="0" cellspacing="0">
<input type="hidden" name="itemid" value="<%=item.cget_item_id %>" />
<thead>
  <tr>
    <th colspan="5">规则明细 <b style="color:#F00">*</b></th>
    <th style="text-align:right"><a href="javascript:;" onclick="removeRules(this)" style="color:#999">删除明细</a></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td style="width:3%"></td>
    <td class="lable">优惠券面值</td>
    <td class="inputText">
    <select id="couponprice" name="couponprice" class="couponprice<%=item.cget_item_id %>" style="height:28px;width:160px;">
    <option value="0">请选择优惠券面值</option>
    <%
        decimal _price = 0;
        foreach (UseCouponRuleInfo item2 in infoList) {
            if (item2.coupon_price == item.coupon_price)
            {
                _price = item2.coupon_price;
                Response.Write("<option value=\"" + item2.coupon_price + "\" selected=\"selected\">" + item2.coupon_price + "元</option>");
            }
            else
            {
                Response.Write("<option value=\"" + item2.coupon_price + "\">" + item2.coupon_price + "元</option>");
            }
        }
     %>
    </select>
    </td>
    <td colspan="3">
    领取链接为：JS: &lt;a href="javascript:;" onclick="GetCoupon(<%=item.cget_item_id %>)"&gt;领取<%=_price %>元优惠券&lt;/a&gt;<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;URL: <%=config.UrlHome %>tools/GetCoupon?itemId=<%=item.cget_item_id %>
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">发放数量<b>*</b></td>
    <td class="inputText">
    总数量： <input type="text" name="itemmaxgivenum" must="1" value="<%=item.max_give_num%>" class="input" style="width:40px" /> 张&nbsp; 
    每天发放数量： <input type="text" name="itemmaxdaygivenum" must="1" value="<%=item.max_day_give_num%>" class="input" style="width:40px" /> 张
    </td>
    <td class="lable">领取数量<b>*</b></td>
    <td class="inputText">
    总领取量： <input type="text" name="itemlimitperusertotal" must="1" value="<%=item.limit_per_user_total%>" class="input" style="width:40px" /> 张&nbsp; 
    每天领取数量： <input type="text" name="itemlimitperuserday" must="1" value="<%=item.limit_per_user_day%>" class="input" style="width:40px" /> 张
    </td>
    <td style="width:40px;">&nbsp;</td>
  </tr>
 <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">开始时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="itemsdate" name="itemsdate" value="<%=item.start_time==null?DateTime.Now.ToString("yyyy-MM-dd"):DateTime.Parse(item.start_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="itemshours" name="itemshours" value="<%=item.start_time==null?"00":DateTime.Parse(item.start_time).Hour.ToString()%>" class="input" style="width:40px" title="数字0至23"/> 时
    <input type="text" id="itemsminutes" name="itemsminutes" value="<%=item.start_time==null?"00":DateTime.Parse(item.start_time).Minute.ToString()%>" class="input" style="width:40px" title="数字0至59"/> 分
<script type="text/javascript">

    Atai.addEvent(window, "load", function () {
        var hBox = Atai.$("#itemshours");
        var mBox = Atai.$("#itemsminutes");
        var tips = Atai.$("#tips-istarttime");
        Atai.addEvent(hBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 23) {
                tips.className = "tips-icon";
                tips.innerHTML = " [时] 请填写0至23之间的数字";
            }
        });
        Atai.addEvent(mBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 59) {
                tips.className = "tips-icon";
                tips.innerHTML = " [分] 请填写0至59之间的数字";
            }
        });
        Atai.addEvent(hBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 24) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
        Atai.addEvent(mBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 60) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
    });
</script></td>
    <td colspan="3"><div class="tips-text" id="tips-istarttime">&nbsp;</div></td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">结束时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="itemedate" name="itemedate" value="<%=item.end_time==null?DateTime.Now.AddDays(7).ToString("yyyy-MM-dd"):DateTime.Parse(item.end_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="itemehours" name="itemehours" value="<%=item.end_time==null?"23":DateTime.Parse(item.end_time).Hour.ToString()%>" class="input" style="width:40px" title="数字0至23"/> 时
    <input type="text" id="itememinutes" name="itememinutes" value="<%=item.end_time==null?"59":DateTime.Parse(item.end_time).Minute.ToString()%>" class="input" style="width:40px" title="数字0至59"/> 分
<script type="text/javascript">
    Atai.addEvent(window, "load", function () {
        var hBox = Atai.$("#itemehours");
        var mBox = Atai.$("#itememinutes");
        var tips = Atai.$("#tips-iendtime");
        Atai.addEvent(hBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 23) {
                tips.className = "tips-icon";
                tips.innerHTML = " [时] 请填写0至23之间的数字";
            }
        });
        Atai.addEvent(mBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 59) {
                tips.className = "tips-icon";
                tips.innerHTML = " [分] 请填写0至59之间的数字";
            }
        });
        Atai.addEvent(hBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 24) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
        Atai.addEvent(mBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 60) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
    });
</script>
    </td>
    <td colspan="3"><div class="tips-text" id="tips-iendtime">&nbsp;</div></td>
  </tr>
</tbody>
</table>
<%
	}
%>
</div>
<table class="table" cellpadding="0" cellspacing="0">
<tbody>
  <tr>
    <td><strong onclick="addRuleTable()" style="color:#00F;cursor:pointer"><b class="icon-add">&nbsp;</b>增加明细</strong></td>
  </tr>
</tbody>
</table>
<br/>
<table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:42%">&nbsp;</th>
    <th class="lable"><input type="button" id="loadding3" value="  确定提交  " onclick="$('#fareTempForm').submit()" class="submit" style="width:120px"/></th>
    <th><div class="tips-text" id="tips-message"></div></th>
  </tr>
</thead>
</table>
		</div>
<br/><br/><br/><br/>
	</div>
</div>
<br/><br/>
<script type="text/javascript">
function createXmlDocument(nodes){
	var xml='<?xml version="1.0" encoding="utf-8"?>';
	xml += '<items>';
	for(var i=0;i<nodes.length;i++){
		xml += nodes[i];
	}
	xml += '</items>';
	return xml;
}
function submitForm(form){
	var isError=false;
	$("input[must='1']").each(function(){
		if($(this).val()==""){
			isError=true;
		}
	});
	if(isError){
	    jsbox.error("请完成所有必填项的填写");
        return false;
	}

    var maxgivenum = Number($("input[name='maxgivenum']").val());
    var maxdaygivenum = Number($("input[name='maxdaygivenum']").val());
    var limitperusertotal = Number($("input[name='limitperusertotal']").val());
    var limitperuserday = Number($("input[name='limitperuserday']").val());

    if (!Atai.isNumber(maxgivenum)) {
        jsbox.error("总规则的发放【总数量】必须为数字");
        return false;
    }

    if (!Atai.isNumber(maxdaygivenum)) {
        jsbox.error("总规则的发放【每天发放数量】必须为数字");
        return false;
    }

    if (!Atai.isNumber(limitperusertotal)) {
        jsbox.error("总规则的领取【总数量】必须为数字");
        return false;
    }

    if (!Atai.isNumber(limitperuserday)) {
        jsbox.error("总规则的领取【每天领取数量】必须为数字");
        return false;
    }

    if (maxgivenum < maxdaygivenum) {
        jsbox.error("总规则的发放【每天发放数量】大于【总数量】");
        return false;
    }

    if (maxgivenum < limitperusertotal) {
        jsbox.error("总规则的领取【总领取量】大于发放【总数量】");
        return false;
    }

    if (maxdaygivenum < limitperuserday) {
        jsbox.error("总规则的领取【每天领取数量】大于发放【每天发放数量】");
        return false;
    }

    if (limitperusertotal < limitperuserday) {
        jsbox.error("总规则的领取【每天领取数量】大于【总领取量】");
        return false;
    }

	if(showLoadding) showLoadding();

	var postData=getPostDB(form);

	var nodes = [];
	var _error = false;
	var _ermsg = "";
	var _itemmaxgivenum = 0;
	var _itemmaxdaygivenum = 0;
	var _itemlimitperusertotal = 0;
	var _itemlimitperuserday = 0;
	$("#fare-rules table[v='table-rules']").each(function () {
	    var itemid = $(this).find("input[name='itemid']").val();
	    var couponprice = $(this).find("#couponprice option:selected").val();
	    if (!Atai.isNumber(couponprice) || couponprice <= 0) {
	        _error = true;
	        _ermsg = "请选择优惠券面值";
	        if (closeLoadding) closeLoadding();
	    }
	    var node = '<item itemid="' + itemid + '" couponprice="' + couponprice + '" ';

	    var itemmaxgivenum = Number($(this).find("input[name='itemmaxgivenum']").val());
	    var itemmaxdaygivenum = Number($(this).find("input[name='itemmaxdaygivenum']").val());
	    var itemlimitperusertotal = Number($(this).find("input[name='itemlimitperusertotal']").val());
	    var itemlimitperuserday = Number($(this).find("input[name='itemlimitperuserday']").val());
	    if (!Atai.isNumber(itemmaxgivenum)) {
	        _error = true;
	        _ermsg = "【总数量】必须为数字";
	    }
	    if (!Atai.isNumber(itemmaxdaygivenum)) {
	        _error = true;
	        _ermsg = "【 每天发放数量】必须为数字";
	    }
	    if (!Atai.isNumber(itemlimitperusertotal)) {
	        _error = true;
	        _ermsg = "【总领取量】必须为数字";
	    }
	    if (!Atai.isNumber(itemlimitperuserday)) {
	        _error = true;
	        _ermsg = "【每天领取数量】必须为数字";
	    }


        if(itemmaxgivenum < itemmaxdaygivenum){
            _error = true;
	        _ermsg = "明细的发放【每天发放数量】大于【总数量】";
        }

         if(itemmaxgivenum < itemlimitperusertotal){
            _error = true;
	        _ermsg = "明细的领取【总领取量】大于发放【总数量】";
        }

         if(itemmaxdaygivenum < itemlimitperuserday){
            _error = true;
	        _ermsg = "明细的领取【每天领取数量】大于发放【每天发放数量】";
        }

         if(itemlimitperusertotal < itemlimitperuserday){
            _error = true;
	        _ermsg = "明细的领取【每天领取数量】大于【总领取量】";
        }


	    _itemmaxdaygivenum += itemmaxdaygivenum;
	    _itemmaxgivenum += itemmaxgivenum;
	    _itemlimitperuserday += itemlimitperuserday;
	    _itemlimitperusertotal += itemlimitperusertotal;

	    node += ' itemmaxgivenum="' + itemmaxgivenum + '" itemmaxdaygivenum="' + itemmaxdaygivenum + '" itemlimitperusertotal="' + itemlimitperusertotal + '" itemlimitperuserday="' + itemlimitperuserday + '"';

	    var itemsdate = $(this).find("input[name='itemsdate']").val();
	    var itemshours = $(this).find("input[name='itemshours']").val();
	    var itemsminutes = $(this).find("input[name='itemsminutes']").val();
	    if (itemshours < 0 || itemshours > 24) {
	        _error = true;
	        _ermsg = "【开始时间】时输入不规范";
	    }
	    if (itemsminutes < 0 || itemsminutes > 60) {
	        _error = true;
	        _ermsg = "【开始时间】分输入不规范";
	    }
	    node += ' itemsdate="' + itemsdate + '" itemshours="' + itemshours + '" itemsminutes="' + itemsminutes + '"';

	    var itemedate = $(this).find("input[name='itemedate']").val();
	    var itemehours = $(this).find("input[name='itemehours']").val();
	    var itememinutes = $(this).find("input[name='itememinutes']").val();
	    if (itemehours < 0 || itemehours > 24) {
	        _error = true;
	        _ermsg = "【结束时间】时输入不规范";
	    }
	    if (itememinutes < 0 || itememinutes > 60) {
	        _error = true;
	        _ermsg = "【结束时间】分输入不规范";
	    }

	    node += ' itemedate="' + itemedate + '" itemehours="' + itemehours + '" itememinutes="' + itememinutes + '">';

	    node += '</item>';

	    nodes.push(node);

	});
	if(nodes.length<1){
		if(closeLoadding) closeLoadding();
		jsbox.error("请填写至少一个明细");
		if (closeLoadding) closeLoadding();
		return false;
}
if (_error) {
    jsbox.error(_ermsg);
    if (closeLoadding) closeLoadding();
    return false;
}

if (_itemmaxgivenum > maxgivenum) {
    jsbox.error("明细的【总数量】之和不能大于总规则的【总数量】");
    if (closeLoadding) closeLoadding();
    return false;
}
if (_itemmaxdaygivenum > maxdaygivenum) {
    jsbox.error("明细的【每天发放数量】之和不能大于总规则的【每天发放数量】");
    if (closeLoadding) closeLoadding();
    return false;
}
if (_itemlimitperusertotal > limitperusertotal) {
    jsbox.error("明细的【总领取量】之和不能大于总规则的【总领取量】");
    if (closeLoadding) closeLoadding();
    return false;
}
if (_itemlimitperuserday > limitperuserday) {
    jsbox.error("明细的【每天领取数量】之和不能大于总规则的【每天领取数量】");
    if (closeLoadding) closeLoadding();
    return false;
}
	var xml=createXmlDocument(nodes);
	$.ajax({
	    url: "/MPromotions/PostCouponGetRule"
		, data: postData + "&xml=" + encodeURIComponent(xml) + "&delids=" + delids
        , type: "post"
		, dataType: "json"
		, success: function(json){
			if(json.error){
				jsbox.error(json.message);
			}else{
				jsbox.success(json.message, window.location.href);
			}
			if(closeLoadding) closeLoadding();
		}
	});
	return false;
}
</script>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>