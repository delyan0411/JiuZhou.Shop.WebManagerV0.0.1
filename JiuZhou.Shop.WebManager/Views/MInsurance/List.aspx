<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
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
	string nodeIndex= DoRequest.GetQueryString("node");
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
   PayTypeList ptlistinfo = new PayTypeList();
        var respPt = GetPayType.Do();
        if (respPt == null || respPt.Body == null)
        {
            ptlistinfo = new PayTypeList();
        }
        else
        {
            ptlistinfo = respPt.Body;
        }
%>

<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>商保列表</span>
</div>

<script type="text/javascript">
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
<%=ViewData["pageIndexLink"]%>
<form id="post-form" method="post" action="">
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="">商保名称</th>
    <th style="width:20%">商保类型</th>
      <th style="width:20%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<InsuranceInfo> infoList = (List<InsuranceInfo>)ViewData["infoList"];
    foreach (InsuranceInfo item in infoList)
    {
        //      DateTime addTime = DateTime.Parse(item.add_time);
        //      string classPath = "";
        //      HelpTypeInfo hCateg = new HelpTypeInfo();
        //      foreach (HelpTypeInfo c in tList)
        //      {
        //	if(c.help_type_id == item.help_id){
        //		classPath=c.type_path;
        //		hCateg=c;break;
        //	}
        //}
        //string[] _tem=classPath.Split(',');
        //tList
%>
  <tr>
    <td><%=item.insurance_name%></td>   
    <td><%=ptlistinfo.pay_type_list.FirstOrDefault(t=>t.pay_type_id==item.paytype).pay_type_name %></td>
    <td>
    <a href="/minsurance/editor?insurance_id=<%=item.insurance_id%>">编辑</a>
    &nbsp;
     <a href="/minsurance/TypeList?insurancetype=<%=item.insurance_id%>" >查看商保用户类别</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
</form>
<%=ViewData["pageIndexLink2"]%>
			<div class="console">
            	<%--<a href="javascript:;" onclick="deleteList(Atai.$('#post-form'), 0)">批量删除</a>--%>
                <a href="/minsurance/editor">新增</a>
			</div>
<br/><br/><br/><br/>
</div>
</div>
<br/><br/>
<br/><br/><br/>
<script type="text/javascript">
</script>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>