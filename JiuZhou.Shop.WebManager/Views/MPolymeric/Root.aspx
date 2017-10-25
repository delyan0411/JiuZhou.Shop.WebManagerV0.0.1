<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.ControllerBase" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
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
	string Parent=DoRequest.GetQueryString("pid").Trim();
	//PolymericPositionInfo pos=PolymericPositionDB.GetInfo(0);
    bool _isallow = false;
    _isallow = ForeSysBaseController.HasPermission2(574);
%>
<div id="container-syscp">
<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
</div>
<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>页面设置(PC)</span>
</div>
<form method="post" action="" onsubmit="return submitTable(this)">
<table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:4%">ID</th>
    <th style="width:25%">页面名称</th>
    <th style="width:10%">&nbsp;</th>
    <th style="width:14.6%">添加时间</th>
    <th>操作</th>
    <th style="width:4%">&nbsp;</th>
  </tr>
</thead>
<tbody>
<%
    List<ShortRecommendPosition> infoList = null;
    var ress = GetRecommendPositionByCode.Do("0", 4);
    if (ress == null || ress.Body == null)
    {
        infoList = new List<ShortRecommendPosition>();
    }
    else {
        infoList = ress.Body.recommend_list;
    }
    foreach (ShortRecommendPosition item in infoList)
    {  
%>
  <tr>
    <td><%=item.rp_id%></td>
    <td><a id="rpname" href="/mpolymeric/index?pid=<%=item.rp_id%>&useplat=4"><%=item.rp_name.Trim()%>(<%=item.rp_id %>)</a></td>
    <td>&nbsp;<div id="pos-<%=item.rp_id%>" style="display:none"><%=item.rp_name.Trim()%></div></td>
    <td class="move-links">
    <%=DateTime.Parse(item.add_time).ToString("yyyy-MM-dd HH:mm:ss")%>
    </td>

    <td>
    <a href="javascript:;" onclick="showRecommendPageEditorBox(event,'<%=item.rp_id%>',$('#pos-<%=item.rp_id%>').html(),1,4)">修改名称</a>
    <%if (_isallow)
      { %>
    &nbsp;
    <a id="poschg" href="/mpolymeric/index?pid=<%=item.rp_id%>&useplat=4">查看/设置页面</a>
    <%} %>
    &nbsp;
    <a id="itemchg" href="/mpolymeric/list?posid=<%=item.rp_id%>&useplat=4">查看/设置主题</a>
    &nbsp;
    <a href="javascript:;" onclick="removePage('<%=item.rp_id%>')">删除</a>
    </td>
    <td>&nbsp;</td>
  </tr>
<%
	}
%>
  </tbody>
</table>
</form>
<%--//table--%>
 <%if (_isallow)
      { %>
	<div class="console">
		<a href="javascript:;" onclick="showRecommendPageEditorBox(event,0,'',0,4)"><b class="add">&nbsp;</b>新增页面</a>
	</div>
     <%} %>
</div>
</div>
<script type="text/javascript">

function removePage(posId){
    jsbox.confirm('您确定要永久删除这个页面吗？', function () {
        $.ajax({
            url: "/MPolymeric/RemoveRecommendPage"
			, data: "posId=" + posId
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        jsbox.error(json.message); 
			    } else {
			        //jsbox.success(json.message);
			        window.location.href = window.location.href;
			    }
			}
        });
    });
	return false;
}
</script>
<%Html.RenderPartial("MPolymeric/PolymericPositionBox"); %>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>