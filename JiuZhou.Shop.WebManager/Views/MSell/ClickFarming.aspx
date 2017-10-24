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
<div id="loadding"></div>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    int productid = DoRequest.GetQueryInt("productid");
%>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>刷单</span>
</div>
<form method="post" action="" onsubmit="return submitData(this)">
<input type="hidden" name="productid" value="<%=productid%>"/>
		<div class="div-tab">
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr style="display:none">
    <td style="width:3%">&nbsp;</td>
    <td style="width:10%">&nbsp;</td>
    <td >&nbsp;</td>
    <td style="width:6%">&nbsp;</td>
  </tr>
</thead>
<tbody>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">评&nbsp;&nbsp;论</td>
    <td><textarea name="comments" style="height:60px;width:300px;"></textarea></td>
    <td>&nbsp;</td>
  </tr>


  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">&nbsp;</td>
    <td class="inputText"><input type="submit" id="loadding3" value="确定提交" class="submit"/> </td>
    <td><div class="tips-text" id="tips-message"></div></td>
  </tr>
  </tbody>
</table>
		</div>
</form>
	</div>
</div>
<script type="text/javascript">

function submitData(form) {
    if (showLoadding)  showLoadding();
       
	var postData=getPostDB(form);
	$.ajax({
	    url: "/Msell/PostClickFarming"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function (json) {
		    if (json.error) {
		        jsbox.error(json.message);
		    } else {
		        jsbox.success(json.message, window.location.href);
		    }
		    if (closeLoadding) closeLoadding();
		     
		}
	});
	return false;
}
</script>
<br/><br/>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>