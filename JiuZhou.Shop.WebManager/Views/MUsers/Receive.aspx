<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
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
%>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>收货信息</span>
</div>
<form action="/musers/receive" method="get" onsubmit="checksearch(this)">
<div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px;height:36px">
<p style="position:relative">
		<input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input" autocomplete="off" style="width:220px;height:24px;line-height:24px;"/></p>
<p>
<input type="submit" value=" 搜索 " class="submit"/>
</p>
			</div>
</form>
<script type="text/javascript">
    var qInitValue = "请输入收货人手机号码";
    $(function () {
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
        return false;
    }
</script>
<%
    List<AdressInfo> infoList = (List<AdressInfo>)(ViewData["adressinfo"]);
%>
		<div class="div-tab">
<table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:8%">用户ID</th>
    <th style="width:8%">收货ID</th>
    <th style="width:12%">收货人</th>
    <th>地址</th>
    <th style="width:10%">手机号</th>
    <th style="width:10%">电话</th>
    <th style="width:10%">添加时间</th>
  </tr>
</thead>
<tbody>
<%
    foreach (AdressInfo item in infoList)
    {
%>
  <tr>
    <td><a href="/musers/editor?uid=<%=item.user_id %>"><%=item.user_id%></a></td>
    <td><%=item.receive_addr_id%></td>
    <td><%=item.receive_name%></td>
    <td><%=item.province_name+","+item.city_name+","+item.county_name+","+item.receive_addr%></td>
    <td><%=item.mobile_no%></td>
    <td><%=item.user_tel%></td>
    <td><%=item.add_time %></td>
  </tr>
<%
	}
%>
  </tbody>
</table>
		</div>
	</div>
</div>
<br/><br/>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>