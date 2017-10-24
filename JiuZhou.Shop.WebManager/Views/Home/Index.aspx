<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.MySql" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    GlsyInfo item = (GlsyInfo)ViewData["glsy"]; 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<script type="text/javascript" src="../../echarts-2.2.6/build/dist/echarts.js"></script>
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
		<div class="syscp-head">
<%=ViewData["position"]%>
		</div>
        <div style="text-align:center;">
        <h4>欢迎进入九洲管理后台!</h4>
        </div>
        </div>
        </div>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>