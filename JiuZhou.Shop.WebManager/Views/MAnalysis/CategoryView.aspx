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
        ConfigInfo config = (ConfigInfo)(ViewData["config"]);     
    %>
    <div id="container-syscp">
   <div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
        <div class="position">
            当前位置： <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>用户列表</span>
        </div>
        <form action="/manalysis/CategoryView" method="get">
        <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px">
       <p>
<%
	DateTime date = DateTime.Now;
%><input type="text" name="sdate" value="<%=DoRequest.GetQueryDate("sDate", date).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
至
<input type="text" name="edate" value="<%=DoRequest.GetQueryDate("eDate", DateTime.Now).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
      </p>
            <p>
                <input type="submit" value=" 搜索 " class="submit" />&nbsp;&nbsp;<a href="/Manalysis/DownLoadPage" style="font-size:14px">导出</a> 
            </p>
        </div>
        </form>
        <form id="post-form" method="post" action="">
        <%=ViewData["pageIndexLink"]%>
     
        <table id="tab-category" class="table" cellpadding="0" cellspacing="0" >
            <thead>
                <tr>
                    <th style="width: 16%">
                        类目名称
                    </th>
                    <th style="width: 14%">
                        商品编码
                    </th>
                    <th >
                        商品名称
                    </th>
                    <th style="width: 9%">
                        销售数量
                    </th>
                    <th style="width: 9%">
                        销售额
                    </th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<SzlmxlphInfo> infoList = (List<SzlmxlphInfo>)ViewData["infoList"];
                    if (infoList == null)
                        infoList = new List<SzlmxlphInfo>();
                    foreach (SzlmxlphInfo item in infoList)
                    {
                %>
                <tr>
                  <td><%=item.type_name %></td>
                  <td><%=item.product_code %></td>
                  <td><%=item.product_name %></td>
                  <td><%=item.product_num %></td>
                  <td><%=item.sale_money%></td>
                </tr>
                <%
             }
                %>
            </tbody>
        </table>
        <%=ViewData["pageIndexLink2"]%>
        </form>
    </div>
    </div>
<script type="text/javascript">

    function changePage(val){
	var url=formatUrl("page", val);
	window.location.href=url;
    }

</script>

<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
