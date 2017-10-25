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
%>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
		<div class="position">
			<a href="/" title="管理首页">管理首页</a>
			&gt;&gt;
			<a href="/mgoods" title="商品管理">商品管理</a>
			&gt;&gt;
			<span>运费模板</span>
		</div>
<%--//position--%>
		<div class="div-tab">
<table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:5%">序号</th>
    <th>标题</th>
    <th style="width:6%">优先级</th>
    <th style="width:6%">默认</th>
    <th style="width:6%">状态</th>
    <th style="width:12%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<FareTempInfo> tempList = new List<FareTempInfo>();
    var restemp = GetFareTempList.Do(-1);
    if (restemp != null && restemp.Body != null && restemp.Body.fare_temp_list != null)
        tempList = restemp.Body.fare_temp_list;
    
    int _count=0;
	foreach(FareTempInfo temp in tempList){
		_count++;
		string num=_count.ToString();
		if(_count<10) num = "0" + num;
%>
  <tr>
    <td style="text-align:center"><%=num%></td>
    <td><%=temp.template_name%></td>
    <td><%=temp.template_priority%></td>
    <td><%=temp.is_system==1?"是":"否"%></td>
    <td><%=temp.template_state==1?"正常":"禁用"%></td>
    <td>
    <a href="/mgoods/fareTemplateEditor?tempid=<%=temp.template_id%>" target="_blank">修改</a>
    &nbsp;
    <a href="javascript:;" onclick="deleteList(<%=temp.template_id %>)">删除</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
<%--//table--%>
		<div class="console">
			<a href="/mgoods/fareTemplateEditor?tempid=-1"><b class="add">&nbsp;</b>新增运费模板</a>
		</div>
    </div>
</div>
</div>
<br/><br/>
<script type="text/javascript">
    function deleteList(tempid) {

        var postData = "tempid=" + tempid;
       
        jsbox.confirm('您确定要删除这些数据吗？', function () {
            $.ajax({
                url: "/mgoods/RemoveFareTemplate"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        jsbox.error(json.message); return false;
			    } else {
			        window.location.href = window.location.href;
			    }
			}
            });
        });
        return false;
    }
</script>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>