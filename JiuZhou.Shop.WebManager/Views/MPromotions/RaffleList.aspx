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
		<a href="/rafflelist" title="抽奖管理">抽奖管理</a>
		&gt;&gt;
		<span>专题列表</span>
	</div>
<%--//position--%>
<form action="/mpromotions/rafflelist" method="get" onsubmit="checksearch(this)">
  <div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px">
	<p>
	  <input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input"/>
    </p>
    <p>
      <input type="submit" value=" 搜索 " class="submit"/>
    </p>
  </div>
</form>
<script type="text/javascript">
var qInitValue="请输入关键词";
Atai.addEvent(window,"load",function(){
	var sQuery=Atai.$("#sQuery");
	if(sQuery.value==qInitValue || sQuery.value==""){
		sQuery.value=qInitValue;
		sQuery.style.color="#999";
	}else{
		sQuery.style.color="#111";
	}
	sQuery.onfocus=function(){
		if(this.value==qInitValue){
			this.value="";
			sQuery.style.color="#111";
		}
	};
	sQuery.onblur=function(){
		if(this.value==""){
			this.value=qInitValue;
			sQuery.style.color="#999";
		}
	};
});
function checksearch(form){
	var sQuery=Atai.$("#sQuery");
	if(sQuery.value==qInitValue){
		sQuery.value="";
	}
}
</script>
<form id="post-form" method="post" action="">
<%=ViewData["pageIndexLink"]%>
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:14%">名称</th>
    <th>描述</th>
    <th style="width:14%">开始时间</th>
    <th style="width:14%">结束时间</th>
    <th style="width:10%">状态</th>
    <th style="width:14%">修改时间</th>
    <th style="width:6%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<AwardActivityInfo> infoList = (List<AwardActivityInfo>)ViewData["infoList"];
    if (infoList == null)
        infoList = new List<AwardActivityInfo>();
    foreach (AwardActivityInfo item in infoList)
    {
		
%>
  <tr>
    <td>
	<a href="/mpromotions/raffleeditor?activityid=<%=item.award_activity_id%>" target="_blank">
    <%=item.activity_name%></a>
   </td>
   <td>
    <span style="overflow:hidden;"><%=item.activity_desc%></span>
   </td>
    <td>
    <a><%=DateTime.Parse(item.begin_time).ToString("yyyy-MM-dd HH:mm:ss")%></a>
    </td>
    <td>
    <a><%=DateTime.Parse(item.end_time).ToString("yyyy-MM-dd HH:mm:ss")%></a>
    </td>
    <td>
      <%
          string statestring = "<span style=\"color:#999\">活动过期</span>";

          if (DateTime.Now >= DateTime.Parse(item.begin_time) && DateTime.Now <= DateTime.Parse(item.end_time)) {
              statestring = "<span style=\"color:green\">进行中</span>";
          }
          Response.Write(statestring);
      %>
    </td>
    <td>
      <a><%=DateTime.Parse(item.modify_time).ToString("yyyy-MM-dd HH:mm:ss")%></a>
    </td>
    <td>
    <a href="/mpromotions/raffleeditor?activityid=<%=item.award_activity_id%>" target="_blank" style="color:#333">编辑</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
<%=ViewData["pageIndexLink2"]%>
    <div class="div-tab-bottom">
      <b class="icon-add">&nbsp;</b><a href="/mpromotions/raffleeditor?activityid=0" style="color:#0000FF">新增抽奖</a>
    </div>
</form>
</div>
</div>
<%--//table--%>
<br/><br/><br/>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>
