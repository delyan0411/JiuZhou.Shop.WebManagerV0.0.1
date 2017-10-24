<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Cache" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
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
<%
	int sType = DoRequest.GetQueryInt("type");
    List<TypeList> tList = new List<TypeList>();
    DoCache chche = new DoCache();
    if (chche.GetCache("typelist") == null)
    {
        var res = GetTypeListAll.Do(-1);
        if (res != null && res.Body != null && res.Body.type_list != null)
        {
            tList = res.Body.type_list;
            chche.SetCache("typelist", tList);
            if (tList.Count == 0)
            {
                chche.RemoveCache("typelist");
            }
        }
    }
    else
    {
        tList = (List<TypeList>)chche.GetCache("typelist");
    }
%>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/">管理首页</a> &gt;&gt; <a href="/mgoods">商品管理</a> &gt;&gt; <span>组合套装</span>
</div>
<form action="/mgoods/assemble" method="get" onsubmit="checksearch(this)">
<input type="hidden" name="size" value="<%=DoRequest.GetQueryInt("size", 30)%>"/>
			<div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px;height:48px;">
		<p><select id="stype" name="type" style="width:80px">
			<option value="-1" init="true">查询条件</option>
            <option value="1">套装名称</option>
            <option value="2">主商品名称</option>
            <option value="3">主商品ID</option>
            <option value="4">套装商品名称</option>
            <option value="5">套装商品ID</option>
		</select>
</p>
<p>
		<input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input" autocomplete="off" style="width:390px;height:24px;line-height:24px;"/></p>
<p>
<input type="submit" value=" 搜索 " class="submit"/>
</p>
<div class="console" style="text-align:left;width:auto;position:relative;border:0;float:right;">
<a href="/mgoods/assembleEditor"><b class="add">&nbsp;</b>新增套装</a>
</div>
			</div>
</form>
<script type="text/javascript">
Atai.addEvent(window,"load",function(){
	dropSType=new _DropListUI({
		input: Atai.$("#stype")
	});dropSType.maxHeight="260px";dropSType.width="80px";
	dropSType.init();dropSType.setDefault("<%=sType%>");
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
    <th style="width:8%">类别</th>
    <th style="width:32%">名称</th>
    <th>说明</th>
    <th style="width:16%">操作</th>
  </tr>
</thead>
<tbody>
<%
	List<ProductAssembleInfo> infoList=(List<ProductAssembleInfo>)ViewData["infoList"];
    if (infoList == null)
        infoList = new List<ProductAssembleInfo>();
	foreach (ProductAssembleInfo item in infoList){
%>
  <tr>
    <td><input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=item.ass_id%>" /></td>
    <td>[<%=item.ass_type==0?"自由搭配":"固定套装"%>]</td>
    <td><a href="/mgoods/assembleEditor?assid=<%=item.ass_id%>" target="_blank"><%=item.ass_subject%></a></td>
    <td><%=item.ass_summary%></td>
    <td>
    <a href="/mgoods/assembleEditor?assid=<%=item.ass_id%>">编辑</a>
    &nbsp;&nbsp;&nbsp;&nbsp;
    <a href="javascript:;" onclick="deleteList(<%=item.ass_id%>)">删除</a>
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
                <a href="javascript:;" onclick="deleteList(Atai.$('#post-form'))" class="black">批量删除套装</a>
                
                <a href="/mgoods/assembleEditor"><b class="add">&nbsp;</b>新增套装</a>
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
	jsbox.confirm('您确定要删除这些数据吗？',function(){
		$.ajax({
			url: "/mgoods/RemoveAssembleList"
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
<br/><br/>
<br/><br/><br/>
</body>
</html>