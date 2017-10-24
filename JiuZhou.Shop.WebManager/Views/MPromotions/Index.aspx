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
		<a href="/mpromotions" title="专题管理">专题管理</a>
		&gt;&gt;
		<span>专题列表</span>
	</div>
<%--//position--%>
<form action="/mpromotions" method="get" onsubmit="checksearch(this)">
			<div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px">
		<p>
		<input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input" style="height:26px;"/></p>
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
    <th style="width:3%"><input type="checkbox" onclick="checkAll(this.form,this)" name="chkall" title="选中/取消选中"/></th>
    <th>专题名称</th>
      <th style="width:8%">专题类型</th>
    <th style="width:14%">起止时间</th>
    <th style="width:8%">状态</th>
    <th style="width:8%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<TopicInfo> infoList = (List<TopicInfo>)ViewData["infoList"];
    if (infoList == null)
        infoList = new List<TopicInfo>();
    foreach (TopicInfo item in infoList)
    {
		
%><%//=namePath.Replace("\n","/")%>
  <tr>
    <td><input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=item.st_id%>" /></td>
    <td>
	<a href="/mpromotions/editor?tid=<%=item.st_id%>">
    <%=item.st_subject%></a><br/>
          <% if (item.type == 1)
            {%>
        <span style="color:#666"><%=config.UrlMobile%>festival/<%=item.st_dir%></span>
        <%}
    else
    { %>
    <span style="color:#666"><%=config.UrlHome%>hdzt/<%=DateTime.Parse(item.add_time).ToString("yyyy")%>/<%=item.st_dir%>/</span>
        <%} %>

    
    &nbsp;
        <% if (item.type == 1)
            {%>
        <a href="<%=config.UrlMobile%>festival/<%=item.st_dir%>.html" style="color:#060" target="_blank">查看手机专题</a>
        <%}
    else
    { %>
    <a href="<%=config.UrlHome%>hdzt/<%=DateTime.Parse(item.add_time).ToString("yyyy")%>/<%=item.st_dir%>/" style="color:#00F" target="_blank">查看PC专题</a>
        <%} %>
    </td>
      <td>
          <%=item.type==1?"手机端":"PC端" %>
      </td>
    <td><%=DateTime.Parse(item.start_time).ToString("yyyy-MM-dd HH:mm:ss")%><br/>
    <%=DateTime.Parse(item.end_time).ToString("yyyy-MM-dd HH:mm:ss")%></td>
    <td><%
	if(item.module_count>0){
		if(item.st_state== 0){
			if(DateTime.Now<DateTime.Parse(item.start_time)){
				Response.Write("<span style='color:red'>未开始</span>");
            }
            else if (DateTime.Now >= DateTime.Parse(item.start_time) && DateTime.Now <= DateTime.Parse(item.end_time))
            {
				Response.Write("<span style='color:green'>已开始</span>");
            } if (DateTime.Now > DateTime.Parse(item.end_time))
            {
				Response.Write("<span style='color:#999'>已结束</span>");
			}
		}else if(item.st_state== 1){
			Response.Write("<span style='color:#999'>已删除</span>");
		}else{
			Response.Write("<span style='color:red'>未发布</span>");
		}
	}else{
		if(item.st_state==1){
			Response.Write("<span style='color:#999'>已删除</span>");
		}else{
			Response.Write("<span style='color:red'>未装修</span>");	
		}
	}
	%></td>
    <td>
                <% if (item.type == 1)
            {%>
          <a href="/mpromotions/phonedecoration?tid=<%=item.st_id%>" target="_blank">专题装修</a><br/>
        <%}
    else
    { %>
      <a href="/mpromotions/decoration?tid=<%=item.st_id%>" target="_blank">专题装修</a><br/>
        <%} %>
  
    <a href="/mpromotions/editor?tid=<%=item.st_id%>" target="_blank" style="color:#333">编辑</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
<%=ViewData["pageIndexLink2"]%>
			<div class="div-tab-bottom">
            	<b class="icon-add">&nbsp;</b><a href="/mpromotions/editor" style="color:#0000FF">新增专题</a>
				<span onclick="deleteList(Atai.$('#post-form'))"><b class="icon-remove">&nbsp;</b>删除选定项</span>
			</div>
</form>
</div>
</div>
<%--//table--%>
<script type="text/javascript">
function deleteList(form){
	var postData=getPostDB(form);
	jsbox.confirm('您确定要删除这些数据吗？',function(){
		$.ajax({
			url: "/MPromotions/RemoveSTopics"
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
