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
            当前位置： <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>新品统计分析</span>
        </div>
        <form action="/manalysis/newprodata" method="get">
        <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px">
       <p>
<%
	DateTime date = DateTime.Now.AddDays(-8);
%><input type="text" name="sdate" value="<%=DoRequest.GetQueryDate("sDate", date).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
至
<input type="text" name="edate" value="<%=DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1)).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
      </p>
            <p>
                <input type="submit" value=" 搜索 " class="submit" />&nbsp;&nbsp;<a href="/Manalysis/DownLoadPage6" style="font-size:14px">导出</a> 
            </p>
        </div>
        </form>
        <form id="post-form" method="post" action="">
        <%=ViewData["pageIndexLink"]%>
     
        <table id="tab-category" class="table" cellpadding="0" cellspacing="0" >
            <thead>
                <tr>
                    <th style="width: 12%">
                        类目名称
                    </th>
                    <th style="width: 10%">
                        新品sku
                    </th>
                    <th style="width: 12%">
                        类目总sku
                    </th>
                    <th style="width:10%">
                        销售额
                    </th>
                    <th>
                        类目总销售额
                    </th>
                    <th>
                        销售额占比
                    </th>
                    <th>&nbsp;</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<NewProductInCategoryInfo> list = (List<NewProductInCategoryInfo>)ViewData["infoList"];
                    if (list == null)
                        list = new List<NewProductInCategoryInfo>();
                    int totalskunum = 0;
                    int totalallsku = 0;
                    decimal totalamount = 0;
                    decimal totalallamount = 0;

                    foreach (NewProductInCategoryInfo item in list)
                    {
                        totalskunum += Utils.IsNumber(item.sku_num) ? int.Parse(item.sku_num) : 0;

                        totalallsku += Utils.IsNumber(item.all_sku_num) ? int.Parse(item.all_sku_num) : 0;
                        totalamount += Utils.IsNumber(item.amount) ? decimal.Parse(item.amount) : 0;
                        totalallamount += Utils.IsNumber(item.all_amount) ? decimal.Parse(item.all_amount) : 0;
                %>
                <tr>
                  <td><%=item.type_name %></td>
                  <td><%=item.sku_num %></td>
                  <td><%=item.all_sku_num%></td>
                  <td><%=item.amount %></td>
                  <td><%=item.all_amount %></td>
                  <td><%=item.rate %></td>
                  <td>&nbsp;</td>
                </tr>
                <%
             }
                %>
                <tr>
                  <td>总计</td>
                  <td><%=totalskunum%></td>
                  <td><%=totalallsku%></td>
                  <td><%=totalamount%></td>
                  <td><%=totalallamount%></td>
                  <td><%=totalallamount==0?"0.00":(totalamount / totalallamount * 100).ToString("#0.00")%>%</td>
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
