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
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="container-syscp">
<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
</div>
<div class="container-right">
	<div class="position">
		<a href="/" title="管理首页">管理首页</a>
		&gt;&gt;
		<a href="/mpromotions/ConvertIntergralRule" title="积分兑换优惠券">积分兑换优惠券列表</a>
<%--//position--%>
</div>

<form id="post-form" method="post" action="">
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:3%"><input type="checkbox" onclick="checkAll(this.form,this)" name="chkall" title="选中/取消选中"/></th>
    <th style="width:10%">类型</th>
    <th style="width:10%">积分数</th>
    <th style="width:10%">优惠券金额</th>
    <th style="width:8%">状态</th>
    <th style="width:8%">有效期</th>
    <th style="width:14%">开始时间</th>
    <th style="width:14%">结束时间</th>
    <th style="width:14%">添加时间</th>
    <th style="width:8%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<ConvertIntergralRuleInfo> infoList = new List<ConvertIntergralRuleInfo>();
    var resrule = GetConvertIntergralRule.Do();
    if (resrule != null && resrule.Body != null && resrule.Body.intergral_rule_list != null)
        infoList = resrule.Body.intergral_rule_list;
    foreach (ConvertIntergralRuleInfo item in infoList)
    {
		
%>
  <tr>
    <td><input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=item.ci_rule_id%>" /></td>
    <td>
    <%  string _type = "未知";
        if(item.coupon_type==1)
            _type = "现金券";
        if(item.coupon_type==2)
            _type = "优惠券"; 
         %>
    <a><%=_type%></a>
   </td>
   <td>
    <a><%=item.integral_count%></a>
   </td>
   <td>
    <a><%=item.coupon_price%></a>
   </td>
   <td>
   <%  string _state = "未知";
       string _color = "color:#060";
       if (item.rule_state == 1)
       {
           _state = "启用";
           _color = "color:#060";
       }
       if (item.rule_state == 2)
       {
           _state = "禁用";
           _color = "color:#999";
       }
         %>
    <a style=<%=_color %> href="javascript:;" onclick="ResetIntergralRuleStatus(this,'<%=item.ci_rule_id%>')" val="<%=item.rule_state %>"><%=_state%></a>
   </td>
   <td>
    <a><%=item.valid_days %>天</a>
   </td>
    <td>
    <a><%=DateTime.Parse(item.begin_time).ToString("yyyy-MM-dd HH:mm:ss")%></a>
    </td>
    <td>
    <a><%=DateTime.Parse(item.end_time).ToString("yyyy-MM-dd HH:mm:ss")%></a>
    </td>
    <td>
    <a><%=DateTime.Parse(item.add_time).ToString("yyyy-MM-dd HH:mm:ss")%></a>
    </td>
    <td>
    <a href="/mpromotions/ConvertIntergralRuleeditor?ruleid=<%=item.ci_rule_id%>" target="_blank" style="color:#333">编辑</a>
    <a href="javascript:;" onclick="deleteList(<%=item.ci_rule_id%>)" style="color:#333">删除</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
    <div class="div-tab-bottom">
      <b class="icon-add">&nbsp;</b><a href="/mpromotions/ConvertIntergralRuleEditor?ruleid=0" style="color:#0000FF">新增兑换</a>
	  <span onclick="deleteList(Atai.$('#post-form'))"><b class="icon-remove">&nbsp;</b>删除选定项</span>
    </div>
</form>
</div>
</div>
<%--//table--%>
<script type="text/javascript">
    function ResetIntergralRuleStatus(obj, ruleid) {
        var _state = 0;
        //jsbox.error(obj.val());
        if ($(obj).attr("val") == "1") {
            _state = "2";
        } else {
            _state = "1";
        }
        var postData = "ruleid=" + ruleid;
        postData += "&state=" + _state;
        var msg = (_state != "1" ? "您确定要禁用此规则吗？" : "您确定要启用此规则吗？");
        jsbox.confirm(msg, function () {
            $.ajax({
                url: "/MPromotions/ResetIntergralRuleStatus"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        jsbox.error(json.message); return false;
			    } else {
			        if (_state == "1") {
			            $(obj).css({ "color": "#060" }).html("启用");
			            $(obj).attr("val", "1");
			        } else {
			            $(obj).css({ "color": "#999" }).html("禁用");
			            $(obj).attr("val", "2");
			        }
			    }
			}
            });
        });
        return false;
    }

function deleteList(form){
    var postData = "";
    if (Atai.isNumber(form)) {
        postData = "visitid=" + form;
    } else {
        postData = getPostDB(form);
    }
	jsbox.confirm('您确定要删除这些数据吗？',function(){
		$.ajax({
		    url: "/MPromotions/RemoveConvertIntergralRules"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function(json){
				if(json.error){
					jsbox.success(json.message);return false;
				}else{
					window.location.href=window.location.href;
				}
			}
		});
	});
	return false;
}
</script>

<br/><br/><br/>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>
