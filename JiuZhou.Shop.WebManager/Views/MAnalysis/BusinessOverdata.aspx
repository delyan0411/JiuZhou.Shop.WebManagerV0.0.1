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
            当前位置： <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>经营概览</span>
        </div>
        <form action="/manalysis/businessoverdata" method="get">
        <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px">
       <p>
<%
	DateTime date = DateTime.Now.AddDays(-8);
%><input type="text" name="sdate" value="<%=DoRequest.GetQueryDate("sDate", date).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
至
<input type="text" name="edate" value="<%=DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1)).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
      </p>
            <p>
                <input type="submit" value=" 搜索 " class="submit" />&nbsp;&nbsp;<a href="/Manalysis/DownLoadPage2" style="font-size:14px">导出</a> 
            </p>
        </div>
        </form>
        <form id="post-form" method="post" action="">
        <%=ViewData["pageIndexLink"]%>
     
        <table id="tab-category" class="table" cellpadding="0" cellspacing="0" >
            <thead>
                <tr>
                    <th style="width: 10%">
                        时间
                    </th>
                    <th>
                        总销售额<br /> <span style="color:#aaa">销售总计</span>
                    </th>
                    <th style="width: 10%">
                        总毛利额
                    </th>
                    <th style="width:7%">
                        总毛利率
                    </th>
                    <th style="width: 8%">
                        支付订单<br /><span style="color:#aaa">总订单</span>
                    </th>
                    <th style="width: 9%">
                        动销品规数<br /><span style="color:#aaa">总商品数</span>
                    </th>
                    <th style="width: 9%">
                        发货率<br /><span style="color:#aaa">九洲发货率</span>
                    </th>
                    <th style="width: 6%">
                        PV<br /><span style="color:#aaa">UV</span>
                    </th>
                    <th style="width: 6%">
                        转化率
                    </th>
                    <th style="width: 7%">
                        订单人数
                    </th>
                    <th style="width: 8%">
                        客单价
                    </th>
                    <th style="width: 9%">
                        下单支付率
                    </th>
                </tr>
            </thead>
            <tbody>
                <%
                    ResponseJyglBody info = (ResponseJyglBody)ViewData["infoList"];
                    List<JyglInfo> infoList = info.list;
                    if (infoList == null)
                        infoList = new List<JyglInfo>();
                    decimal totalamount1 = 0;
                    //decimal totalamount2 = 0;
                    decimal totalsellprofit = 0;
                    int totalpayordercount = string.IsNullOrEmpty(info.pay_order_in_all)?0:int.Parse(info.pay_order_in_all);
                    int totalordercount = 0;
                    int totalsalecount = 0;
                    int totalpv = 0;
                    int totaluv = 0;
                    int totalpeoplenum = string.IsNullOrEmpty(info.people_num_in_all)?0: int.Parse(info.people_num_in_all);
                    
                    foreach (JyglInfo item in infoList)
                    {
                        totalamount1 += Utils.IsNumber(item.amount_by_chargetime) ? decimal.Parse(item.amount_by_chargetime) : 0;
                        //totalamount2 += Utils.IsNumber(item.amount_by_delivery_time) ? decimal.Parse(item.amount_by_delivery_time) : 0;
                        totalsellprofit += Utils.IsNumber(item.sell_profit) ? decimal.Parse(item.sell_profit) : 0;
                        
                        totalordercount += Utils.IsNumber(item.total_order_count) ? int.Parse(item.total_order_count) : 0;
                        totalsalecount += Utils.IsNumber(item.sale_product_count) ? int.Parse(item.sale_product_count) : 0;
                        totalpv += Utils.IsNumber(item.page_view) ? int.Parse(item.page_view) : 0;
                        totaluv += Utils.IsNumber(item.user_view) ? int.Parse(item.user_view) : 0;
                        
                %>
                <tr>
                  <td><%=item.query_date %></td>
                  <td><%=item.amount_by_chargetime %> 元<br /><span style="color:#aaa"><%=item.amount %> 元</span></td>
                  <td><%=(Utils.IsNumber(item.sell_profit)?decimal.Parse(item.sell_profit):0)==0?"--":(item.sell_profit + " 元") %></td>
                  <td><%=item.profit_percent=="0.00%"?"--":item.profit_percent %></td>
                  <td><%=item.payment_order_count %><br /><span style="color:#aaa"><%=item.total_order_count%></span></td>
                  <td><%=item.sale_product_count%><br /><span style="color:#aaa"><%=item.all_on_sale_product_num%></span></td>
                  <td><%=item.delivery_rate%><br /><span style="color:#aaa"><%=item.specific_delivery_rate%></span></td>
                  <td><%=(Utils.IsNumber(item.page_view)?int.Parse(item.page_view):0)==0?"--":item.page_view %><br /><span style="color:#aaa"><%=(Utils.IsNumber(item.user_view)?int.Parse(item.user_view):0)==0?"--":item.user_view %></span></td>
                  <td><%=item.transform_rate=="0.00%"?"--":item.transform_rate %></td>
                  <td><%=item.people_num == "0" ? "--" : item.people_num%></td>
                  <td><%=item.payment_per_client%> 元</td>
                  <td><%=item.payment_rate%></td>
                </tr>
                <%
             }
                %>
                <tr>
                  <td>总计</td>
                  <td><%=totalamount1%> 元<br /><span style="color:#aaa">--</span></td>
                  <td><%=totalsellprofit%> 元</td>
                  <td><%=totalamount1==0?"0.00":((totalsellprofit / totalamount1) * 100).ToString("#0.00")%>%</td>
                  <td><%=totalpayordercount%><br /><span style="color:#aaa"><%=totalordercount%></span></td>
                  <td><%=info.sale_product_count_in_all%><br /><span style="color:#aaa">--</span></td>
                  <td><%=info.delivery_rate_in_all%><br /><span style="color:#aaa"><%=info.specific_delivery_rate_in_all %></span></td>
                  <td><%=totalpv%><br /><span style="color:#aaa"><%=totaluv%></span></td>
                  <td><%=totaluv==0?"0.00":((totalpayordercount / (decimal)totaluv)*100).ToString("#0.00")%>%</td>
                  <td><%=totalpeoplenum%></td>
                  <td><%=totalpayordercount==0?0:decimal.Parse((totalamount1 / totalpayordercount).ToString("#0.00"))%> 元</td>
                  <td><%=totalordercount==0?"0.00":(((decimal)totalpayordercount / (decimal)totalordercount) * 100).ToString("#0.00")%>%</td>
                </tr>
            </tbody>
        </table>
        <%=ViewData["pageIndexLink2"]%>
        </form>
        <div>
        <span style="color:red">* 销售总计=每月1号到当前日期的总销售额&nbsp;&nbsp;&nbsp;客单价=总销售额(支付时间)/支付订单数</span>
        </div>
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
