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
	int posId = DoRequest.GetQueryInt("posid");
    int useplat = DoRequest.GetQueryInt("useplat");
%>

<div id="container-syscp">
<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
</div>
<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>已推荐列表<%=useplat==4?"(PC)":"(手机)" %></span>
</div>

<form action="/mpolymeric/list" method="get" onsubmit="checksearch(this)">
			<div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px">
            <input type="hidden" name="posid" value="<%=posId %>" />
            <input type="hidden" name="useplat" value="<%=useplat %>" />
<p>
		<input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input"/></p>
<p>
<input type="submit" value=" 搜索 " class="submit"/>
</p>
			</div>
</form>
<script type="text/javascript">

var qInitValue="请输入关键词";

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
    <th>位置</th>
    <th style="width:20%">&nbsp;</th>
    <th style="width:20%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<RecommendPositionList> infoList = (List<RecommendPositionList>)ViewData["infoList"];
    if (infoList == null)
        infoList = new List<RecommendPositionList>();
    foreach (RecommendPositionList item in infoList)
    {
        item.name_path = item.name_path.Trim();
  
%>
  <tr>
    <td><input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=item.rp_id%>" /></td>
    <td>
	<a href="/mpolymeric/items?posid=<%=item.rp_id%>&useplat=<%=useplat %>">
	<%=item.name_path.Replace("\n", " / ")%> (<%=item.rp_id %>)
    </a></td>
    <td id="plat" value="<%=item.rp_id %>">
&nbsp;
    </td>
    <td>
    <a href="/mpolymeric/items?posid=<%=item.rp_id%>&useplat=<%=useplat %>">查看详细</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
<%=ViewData["pageIndexLink2"]%>
			<div class="div-tab-bottom">
				<span onclick="deleteList(Atai.$('#post-form'))"><b class="icon-remove">&nbsp;</b>永久删除选定项</span>
			</div>
</form>
</div>
</div>
<script type="text/javascript">

function deleteList(form){
	var postData=getPostDB(form);
	jsbox.confirm('您确定要永久删除这些数据吗？',function(){
		$.ajax({
			url: "/MPolymeric/RemoveList"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function(json){
				if(json.error){
					jsbox.error(json.message);return false;
				}else{
					window.location.href=window.location.href;
				}
			}
		});
	});
	return false;
}
</script>
<br/><br/><br/><br/><br/><br/>
<br/><br/><br/>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>