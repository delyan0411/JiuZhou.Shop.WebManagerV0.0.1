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
		<a href="/fulloff" title="满减管理">满减管理</a>
		&gt;&gt;
		<span>专题列表</span>
	</div>
<%--//position--%>
<form action="/mpromotions/fulloff" method="get" onsubmit="checksearch(this)">
			<div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px">
		<p>
		<input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input"/></p>
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
    <th style="width:24%">名称</th>
    <th>描述</th>
    <th style="width:14%">开始时间</th>
    <th style="width:14%">结束时间</th>
    <th style="width:8%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<FullOffInfo> infoList = (List<FullOffInfo>)ViewData["infoList"];
    if (infoList == null)
        infoList = new List<FullOffInfo>();
    foreach (FullOffInfo item in infoList)
    {
		
%>
  <tr>
    <td><input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=item.fulloff_id%>" /></td>
    <td>
	<a href="/mpromotions/fulloffeditor?fid=<%=item.fulloff_id%>">
    <%=item.fulloff_name%></a>
   </td>
   <td>
    <a><%=item.fulloff_desc%></a>
   </td>
    <td>
    <a><%=DateTime.Parse(item.begin_time).ToString("yyyy-MM-dd HH:mm:ss")%></a>
    </td>
    <td>
    <a><%=DateTime.Parse(item.end_time).ToString("yyyy-MM-dd HH:mm:ss")%></a>
    </td>
    <td>
    <a href="/mpromotions/fulloffeditor?fid=<%=item.fulloff_id%>" target="_blank" style="color:#333">编辑</a>
    <a href="javascript:;" onclick="deleteList(<%=item.fulloff_id%>)" style="color:#333">删除</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
<%=ViewData["pageIndexLink2"]%>
    <div class="div-tab-bottom">
      <b class="icon-add">&nbsp;</b><a href="/mpromotions/fulloffeditor?fid=0" style="color:#0000FF">新增满减</a>
	  <span onclick="deleteList(Atai.$('#post-form'))"><b class="icon-remove">&nbsp;</b>删除选定项</span>
    </div>
</form>
</div>
</div>
<%--//table--%>
<script type="text/javascript">

    function deleteList(form) {
        var postData = "";
        if (Atai.isNumber(form)) {
            postData = "visitid=" + form;
        } else {
            postData = getPostDB(form);
        }
	jsbox.confirm('您确定要删除这些数据吗？',function(){
		$.ajax({
			url: "/MPromotions/RemoveFullOffs"
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
