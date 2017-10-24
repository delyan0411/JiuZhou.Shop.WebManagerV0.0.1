<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    %>
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
	string nodeIndex= DoRequest.GetQueryString("node");
	int classid = DoRequest.GetQueryInt("classid");
	int sType = DoRequest.GetQueryInt("sType");
%>

<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>商品关联列表</span>
</div>
<form action="/mgoods/join" method="get" onsubmit="checksearch(this)">
<input type="hidden" name="size" value="<%=DoRequest.GetQueryInt("size", 30)%>"/>
			<div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px;height:48px;">
		<p><select id="stype" name="type" style="width:80px">
			<option value="" init="true">全部类别</option>
            <option value="颜色分类">颜色分类</option>
            <option value="商品规格">商品规格</option>
		</select>
</p>
<p>
		<input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input" autocomplete="off" onkeyup="suggest.init(event,this,'/MTools/SeachSuggest')" style="width:390px;height:24px;line-height:24px;"/></p>
<p>
<input type="submit" value=" 搜索 " class="submit"/>
</p>
<div class="console" style="text-align:left;width:auto;position:relative;border:0;float:right;">
<a href="/mgoods/joinEditor"><b class="add">&nbsp;</b>新增关联规则</a>
</div>
			</div>
</form>
<script type="text/javascript">
var qInitValue="请输入关键词";
Atai.addEvent(window,"load",function(){
	dropSType=new _DropListUI({
		input: Atai.$("#stype")
	});dropSType.maxHeight="260px";dropSType.width="80px";
	dropSType.init();dropSType.setDefault("<%=sType%>");

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
var _currUrl="<%=ViewData["currPageUrl"]%>";
function formatUrl(ocol, val, url){
	if(!url) url=_currUrl;
	var reg = ocol + "=[^-]*";
	var reg = new RegExp(ocol + "=[^&\.]*");
	url = url.replace(reg, ocol + "=" + val);
	return url;
}
var changeOrderBy=function(ocol,ot){
	_currUrl=formatUrl("ocol",ocol);
	url=formatUrl("ot",ot);
	window.location.href=url;
};
</script>
<form id="post-form" method="post" action="">
<%=ViewData["pageIndexLink"]%>
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:3%"><input type="checkbox" onclick="checkAll(this.form,this)" name="chkall" title="选中/取消选中"/></th>
    <th style="width:8%">规则类别</th>
    <th>名称</th>
    <th style="width:8%">刷新页面</th>
    <th style="width:8%">显示方式</th>
    <th style="width:16%">操作</th>
  </tr>
</thead>
<tbody>
<%
	List<ProductJoinInfo> infoList=(List<ProductJoinInfo>)ViewData["infoList"];
    if (infoList == null)
        infoList = new List<ProductJoinInfo>();
	foreach (ProductJoinInfo item in infoList){
%>
  <tr>
    <td><input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=item.product_join_id%>" /></td>
    <td>[<%=item.type_name%>]</td>
    <td><a href="/mgoods/joinEditor?joinid=<%=item.product_join_id%>" target="_blank"><%=item.join_name%></a></td>
    </td>
    <td><%=item.allow_refresh>0?"是":"否"%></td>
    <td><%=item.view_type>0?"图片":"文字"%></td>
    <td>
    <a href="/mgoods/joinEditor?joinid=<%=item.product_join_id%>">编辑</a>
    &nbsp;&nbsp;&nbsp;&nbsp;
    <a href="javascript:;" onclick="deleteList(<%=item.product_join_id%>)">删除</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
<%=ViewData["pageIndexLink2"]%>
			<div class="console" style="text-align:left;position:relative;">
            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <a href="javascript:;" onclick="deleteList(Atai.$('#post-form'))" class="black">批量删除规则</a>
                
                <a href="/mgoods/joinEditor" style="position:absolute;right:10px;top:0;"><b class="add">&nbsp;</b>新增关联规则</a>
			</div>
</form>
<br/><br/><br/><br/>
</div>

</div>
<script type="text/javascript">
function deleteList(form){
	var postData="";
	if(Atai.isNumber(form)){
		postData="visitid=" + form;
	}else{
		postData=getPostDB(form);
	}
	jsbox.confirm('您确定要删除这些关联信息吗？',function(){
		$.ajax({
		    url: "/mgoods/RemoveJoinList"
            , type: "post"
			, data: postData
			, dataType: "json"
			, success: function(json){
				if(json.error){
					jsbox.error(json.message);
				}else{
					window.location.href=window.location.href;
				}
			}
		});
	});
	return false;
}
</script>
<br/><br/>
<%Html.RenderPartial("Base/_PageFootControl"); %>
<br/><br/><br/>
</body>
</html>