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
            当前位置： <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>品牌统计</span>
        </div>
        <form action="/manalysis/branddata" method="get">
          <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px">
          <p>
            <%
	          DateTime date = DateTime.Now.AddMonths(-1).AddDays(-1);
            %>
            <input type="text" name="sdate" value="<%=DoRequest.GetQueryDate("sDate", date).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
            至
            <input type="text" name="edate" value="<%=DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1)).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
          </p>
          <p>
            <input type="submit" value=" 搜索 " class="submit" />&nbsp;&nbsp;<a href="/Manalysis/DownLoadPage3" style="font-size:14px">导出</a> 
          </p>
        </div>
        </form>
        <form id="post-form" method="post" action="">
        <%=ViewData["pageIndexLink"]%>
        <table id="tab-category" class="table" cellpadding="0" cellspacing="0" >
            <thead>
                <tr>
                    <th style="width:3%">&nbsp;</th>
                    <th style="width:16%">
                        品牌名称
                    </th>
                    <th style="width: 12%">
                        销 售 额
                    </th>
                    <th style="width:12%">
                        销售数量
                    </th>
                    <th >
                        周 动 销
                    </th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<PpphInfo> infoList = (List<PpphInfo>)ViewData["infoList"];
                    if (infoList == null)
                        infoList = new List<PpphInfo>();
                    int _count = 1; 
                    foreach (PpphInfo item in infoList)
                    {
                        int _index = (_count++) + (DoRequest.GetQueryInt("page", 1) - 1) * 30;
                %>
                <tr>
                  <td><%=_index %></td>
                  <td><%=item.brand_name %></td>
                  <td><%=item.sale_amount %> 元</td>
                  <td><%=item.product_num %></td>
                  <td><%=item.week_sku_rate%></td>
                  
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
