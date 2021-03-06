﻿<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
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
		<a href="/mpromotions/CouponGetRule" title="优惠券列表">优惠券列表</a>
<%--//position--%>
</div>
<form action="/mpromotions/CouponGetRule" method="get" onsubmit="checksearch(this)">
			<div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px">
		<p>
		<input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input"/></p>
<p>
<input type="submit" value=" 搜索 " class="submit"/>
</p>
			</div>
</form>
<script type="text/javascript">
    var qInitValue = "请输入关键词";
    Atai.addEvent(window, "load", function () {
        var sQuery = Atai.$("#sQuery");
        if (sQuery.value == qInitValue || sQuery.value == "") {
            sQuery.value = qInitValue;
            sQuery.style.color = "#999";
        } else {
            sQuery.style.color = "#111";
        }
        sQuery.onfocus = function () {
            if (this.value == qInitValue) {
                this.value = "";
                sQuery.style.color = "#111";
            }
        };
        sQuery.onblur = function () {
            if (this.value == "") {
                this.value = qInitValue;
                sQuery.style.color = "#999";
            }
        };
    });
    function checksearch(form) {
        var sQuery = Atai.$("#sQuery");
        if (sQuery.value == qInitValue) {
            sQuery.value = "";
        }
    }
</script>

<form id="post-form" method="post" action="">
<%=ViewData["pageIndexLink"]%>
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:3%"><input type="checkbox" onclick="checkAll(this.form,this)" name="chkall" title="选中/取消选中"/></th>
    <th style="width:10%">活动名称</th>
    <th>备注</th>
    <th style="width:6%">有效期</th>
    <th style="width:6%">总数量</th>
    <th style="width:10%">每天发放数量</th>
    <th style="width:14%">开始时间</th>
    <th style="width:14%">结束时间</th>
    <th style="width:14%">添加时间</th>
    <th style="width:8%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<CouponGetRuleInfo> infoList = new List<CouponGetRuleInfo>();
    infoList = (List<CouponGetRuleInfo>)ViewData["infolist"];
    if (infoList == null)
        infoList = new List<CouponGetRuleInfo>();
    foreach (CouponGetRuleInfo item in infoList)
    {
		
%>
  <tr>
    <td><input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=item.cget_rule_id%>" /></td>
    <td>
    <a><%=item.cget_name%></a>
   </td>
   <td>
    <a><%=item.cget_remark%></a>
   </td>
   <td>
    <a><%=item.validity_days%>天</a>
   </td>
   <td>
    <a><%=item.max_give_num%></a>
   </td>
   <td>
    <a><%=item.max_day_give_num%></a>
   </td>
    <td>
    <a><%=DateTime.Parse(item.start_time).ToString("yyyy-MM-dd HH:mm:ss")%></a>
    </td>
    <td>
    <a><%=DateTime.Parse(item.end_time).ToString("yyyy-MM-dd HH:mm:ss")%></a>
    </td>
    <td>
    <a><%=DateTime.Parse(item.add_time).ToString("yyyy-MM-dd HH:mm:ss")%></a>
    </td>
    <td>
    <a href="/mpromotions/coupongetruleeditor?getid=<%=item.cget_rule_id%>" target="_blank" style="color:#333">编辑</a>
    <a href="javascript:;" onclick="deleteList(<%=item.cget_rule_id%>)" style="color:#333">删除</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
<%=ViewData["pageIndexLink2"]%>
    <div class="div-tab-bottom">
      <b class="icon-add">&nbsp;</b><a href="/mpromotions/coupongetruleeditor?getid=0" style="color:#0000FF">新增规则</a>
	  <span onclick="deleteList(Atai.$('#post-form'))"><b class="icon-remove">&nbsp;</b>删除选定项</span>
    </div>
</form>
</div>
</div>
<%--//table--%>
<script type="text/javascript">
function deleteList(form){
    var postData = "";
    if (Atai.isNumber(form)) {
        postData = "visitid=" + form;
    } else {
        postData = getPostDB(form);
    }
	jsbox.confirm('您确定要删除这些数据吗？',function(){
		$.ajax({
		    url: "/MPromotions/RemoveCouponGetRules"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function(json){
				if(json.error){
					jsbox.error(json.message);return false;
				}else{
					jsbox.success(json.message,window.location.href);
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
