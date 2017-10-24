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
		<a href="/redpacklist" title="红包管理">红包管理</a>
		&gt;&gt;
		<span>红包规则列表</span>
	</div>
<form id="post-form" method="post" action="">
<%=ViewData["pageIndexLink"]%>
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th >主题</th>
    <th style="width:6%">红包总额</th>
    <th style="width:10%">开始时间</th>
    <th style="width:10%">结束时间</th>
    <th style="width:10%">效期</th>
    <th style="width:10%">红包最大额度</th>
    <th style="width:10%">红包最小额度</th>
    <th style="width:6%">红包数</th>
    <th style="width:6%">添加时间</th>
    <th style="width:6%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<RedPackInfo> infoList = (List<RedPackInfo>)ViewData["infoList"];
    if (infoList == null)
        infoList = new List<RedPackInfo>();
    foreach (RedPackInfo item in infoList)
    {		
%>
  <tr>
    <td>
	<a href="/mpromotions/redpackeditor?redpack_rule_id=<%=item.redpack_rule_id%>" target="_blank">
    <%=item.title%></a>
   </td>
   <td>
    <span ><%=item.sum_money.ToString()%></span>
   </td>
    <td>
    <a><%=DateTime.Parse(item.start_time).ToString("yyyy-MM-dd HH:mm:ss")%></a>
    </td>
    <td>
    <a><%=DateTime.Parse(item.end_time).ToString("yyyy-MM-dd HH:mm:ss")%></a>
    </td>
     <td>
    <a><%=DateTime.Parse(item.valid_time).ToString("yyyy-MM-dd HH:mm:ss")%></a>
    </td>
    <td>
        <span ><%=item.pack_money_max.ToString()%></span>
    </td>
    <td>
        <span ><%=item.pack_money_min.ToString()%></span>
    </td>
    <td>
        <span ><%=item.pack_numsum.ToString()%></span>
    </td>
     <td>
        <span ><%=item.add_time.ToString()%></span>
    </td>
    <td>
    <a href="/mpromotions/redpackeditor?redpack_rule_id=<%=item.redpack_rule_id%>" target="_blank" style="color:#333">编辑</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
<%=ViewData["pageIndexLink2"]%>
    <div class="div-tab-bottom">
      <b class="icon-add">&nbsp;</b><a href="/mpromotions/redpackeditor?redpack_rule_id=0" style="color:#0000FF">新增红包规则</a>
    </div>
</form>
</div>
</div>
<%--//table--%>
<br/><br/><br/>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>
