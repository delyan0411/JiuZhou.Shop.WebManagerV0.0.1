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
            当前位置： <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>新用户统计分析</span>
        </div>
        <form action="/manalysis/newuserdata" method="get">
        <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px">
       <p>
<%
	DateTime date = DateTime.Now.AddDays(-8);
%><input type="text" name="sdate" value="<%=DoRequest.GetQueryDate("sDate", date).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
至
<input type="text" name="edate" value="<%=DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1)).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
      </p>
            <p>
                <input type="submit" value=" 搜索 " class="submit" />&nbsp;&nbsp;<a href="/Manalysis/DownLoadPage7" style="font-size:14px">导出</a> 
            </p>
        </div>
        </form>
        <form id="post-form" method="post" action="">
        <%=ViewData["pageIndexLink"]%>
     
        <table id="tab-category" class="table" cellpadding="0" cellspacing="0" >
            <thead>
                <tr>
                    <th style="width: 12%">
                        时&nbsp;&nbsp;间
                    </th>
                    <th style="width: 10%">
                        新注册数
                    </th>
                    <th style="width: 12%">
                        支 付 数
                    </th>
                    <th style="width:10%">
                        订 单 数
                    </th>
                    <th>&nbsp;</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<XyhtjInfo> list = (List<XyhtjInfo>)ViewData["infoList"];
                    if (list == null)
                        list = new List<XyhtjInfo>();
                    int totalregistercount = 0;
                    int totalpaymentcount = 0;
                    int totalordercount = 0;

                    foreach (XyhtjInfo item in list)
                    {
                        totalregistercount += Utils.IsNumber(item.register_count) ? int.Parse(item.register_count) : 0;

                        totalpaymentcount += Utils.IsNumber(item.payment_count) ? int.Parse(item.payment_count) : 0;
                        totalordercount += Utils.IsNumber(item.order_count) ? int.Parse(item.order_count) : 0;
                %>
                <tr>
                  <td><%=item.query_date %></td>
                  <td><%=item.register_count %></td>
                  <td><%=item.payment_count%></td>
                  <td><%=item.order_count %></td>
                  <td>&nbsp;</td>
                </tr>
                <%
             }
                %>
                <tr>
                  <td>总计</td>
                  <td><%=totalregistercount%></td>
                  <td><%=totalpaymentcount%></td>
                  <td><%=totalordercount%></td>
                  <td>&nbsp;</td>
                </tr>
            </tbody>
        </table>
        <%=ViewData["pageIndexLink2"]%>
        </form>
    </div>
    </div>
<script type="text/javascript">

</script>

<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
