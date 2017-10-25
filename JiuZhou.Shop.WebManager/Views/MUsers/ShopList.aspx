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
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>商家列表</span>
</div>
<form action="/musers/shoplist" method="get">
<div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px;height:36px">
<p style="position:relative">
		<input type="text" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input" autocomplete="off" style="width:220px;height:24px;line-height:24px;"/></p>
<p>
<input type="submit" value=" 搜索 " class="submit"/>
</p>
			</div>
</form>
<%
    List<ShortShopInfo> infoList = (List<ShortShopInfo>)(ViewData["infoList"]);
%>
<%=ViewData["pageIndexLink"]%>
		<div class="div-tab">
<table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:16%">店铺名称</th>
    <th style="width:20%">公司名称</th>
    <th style="width:10%">发货地址</th>
    <th style="width:25%">联系方式</th>
    <th>备注</th>
    <th style="width:14%">操作</th>
  </tr>
</thead>
<tbody>
<%
    foreach (ShortShopInfo item in infoList)
    {
%>
  <tr>
    <td><%=item.shop_name%></td>
    <td><%=item.company_name%></td>
    <td><%=item.shop_addr%></td>
    <td><%=item.link_way%></td>
    <td><%=item.shop_remark.Replace("\n","<br/>")%></td>
    <td>
    <a href="/musers/shopeditor?shopid=<%=item.shop_id%>" target="_blank">编&nbsp;&nbsp;辑</a>
    <a href="javascript:;" onclick="resetShopState(<%=item.shop_id%>,<%=item.shop_state==0?1:0 %>)"><%=item.shop_state==0?"已 显 示":"<span style='color:red'>已 隐 藏</span>"%></a><br />
    <a href="javascript:;" onclick="resetShoppsw(<%=item.shop_id%>)">重置密码</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
		</div>
<%=ViewData["pageIndexLink2"]%>
	</div>
</div>
<br/><br/>
<script type="text/javascript">
    function resetShopState(id, status) {
        $.ajax({
            url: "/musers/ResetShopState"
			, data: {"id":id,"state":status}
            , type: "post"
			, dataType: "json"
			, success: function (json, textStatus) {
			    if (json.error) {
			        jsbox.error(json.message); 
                    return false;
			    } else {
			        jsbox.success(json.message, window.location.href);
			    }
			}
        });
        return false;
    }

    function resetShoppsw(id) {
        $.ajax({
            url: "/musers/ResetShopPsw"
			, data: { "id": id}
            , type: "post"
			, dataType: "json"
			, success: function (json, textStatus) {
			    if (json.error) {
			        jsbox.error(json.message);
			        return false;
			    } else {
			        jsbox.success(json.message, window.location.href);
			    }
			}
        });
        return false;
    }
</script>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>