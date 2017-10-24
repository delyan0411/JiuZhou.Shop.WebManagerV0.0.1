<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<script type="text/javascript" src="/Tools/AreaDataToJson" charset="utf-8"></script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    int ruleid = DoRequest.GetQueryInt("ruleid");
    ConvertIntergralRuleDetail rule = new ConvertIntergralRuleDetail();
    var resrule = QueryConvertIntergralRuleDetail.Do(ruleid);
    if (resrule != null && resrule.Body != null)
        rule = resrule.Body;
%>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <a href="/mpromotions/ConvertIntergralRule">积分兑换优惠券列表</a> &gt;&gt; <span>编辑积分兑换优惠券</span>
</div>
<form method="post" action="" onsubmit="return submitData(this)">
<input type="hidden" name="ruleid" value="<%=ruleid%>"/>
		<div class="div-tab">
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr style="display:none">
    <td style="width:3%">&nbsp;</td>
    <td style="width:10%">&nbsp;</td>
    <td >&nbsp;</td>
    <td style="width:6%">&nbsp;</td>
  </tr>
</thead>
<tbody>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" style="width:80px">优惠券类型<b>*</b></td>
    <td class="inputText">
      <p>
        <select id="ctype" name="ctype" style="width:80px;height:26px;">
            <option value="1" init="true">现金券</option>
            <option value="2">优惠券</option>
        </select>
      </p>
    </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">兑&nbsp;换&nbsp;率<b>*</b></td>
    <td class="inputText" style="width:120px">每 <input type="text" name="integral" value="<%=rule.integral_count%>" class="input" style="width:35px"/> 积分兑换1张 <input type="text" name="couponprice" value="<%=rule.coupon_price%>" class="input" style="width:40px"/> 元优惠券</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">状&nbsp;&nbsp;&nbsp;态<b>*</b></td>
    <td>
    <input type="radio" name="ruleType" onclick="checkedthis(this)" value="1"<%if(rule.rule_state!=2){Response.Write(" checked=\"checked\"");}%> /> 启用
    &nbsp;|&nbsp;
    <input type="radio" name="ruleType" onclick="checkedthis(this)" value="2"<%if(rule.rule_state==2){Response.Write(" checked=\"checked\"");}%>/> 禁用
    </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">有&nbsp;效&nbsp;期<b>*</b></td>
    <td class="inputText"><input type="text" name="validday" value="<%=rule.valid_days%>" class="input" style="width:30px"/> 天</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">开始时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-sdate" name="sdate" value="<%=rule.begin_time==null?DateTime.Now.ToString("yyyy-MM-dd"):DateTime.Parse(rule.begin_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-shours" name="shours" value="<%=rule.begin_time==null?DateTime.Now.Hour:DateTime.Parse(rule.begin_time).Hour%>" class="input" style="width:40px" title="数字0至23"/> 时
    <input type="text" id="box-sminutes" name="sminutes" value="<%=rule.begin_time==null?DateTime.Now.Minute:DateTime.Parse(rule.begin_time).Minute%>" class="input" style="width:40px" title="数字0至59"/> 分
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
    <td><div class="tips-text" id="tips-starttime">&nbsp;</div></td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">结束时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-edate" name="edate" value="<%=rule.end_time==null?DateTime.Now.AddDays(7).ToString("yyyy-MM-dd"):DateTime.Parse(rule.end_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-ehours" name="ehours" value="<%=rule.end_time==null?DateTime.Now.Hour:DateTime.Parse(rule.end_time).Hour%>" class="input" style="width:40px" title="数字0至23"/> 时
    <input type="text" id="box-eminutes" name="eminutes" value="<%=rule.end_time==null?DateTime.Now.Minute:DateTime.Parse(rule.end_time).Minute%>" class="input" style="width:40px" title="数字0至59"/> 分
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
    <td><div class="tips-text" id="tips-endtime">&nbsp;</div></td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">&nbsp;</td>
    <td class="inputText"><input type="submit" value="确定提交" class="submit"/></td>
    <td><div class="tips-text" id="tips-message"></div></td>
  </tr>
  </tbody>
</table>
		</div>
</form>
	</div>
</div>
<script type="text/javascript">
function checkedthis(obj) {
     if (obj.checked) {
        $(obj).attr("checked", true);
        $("input[name='ruleType']").each(function () {
            if (this != obj)
                $(this).attr("checked", false);
        });
     } else {
        $(obj).attr("checked", false);    
        $("input[name='ruleType']").each(function () {
            if (this != obj)
                $(this).attr("checked", true);
        });
     }
}
function submitData(form) {
    if (showLoadding) showLoadding();
	var postData=getPostDB(form);
	$.ajax({
		url: "/MPromotions/PostConvertIntertralRuleData"
		, data: postData
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
<br/><br/>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>