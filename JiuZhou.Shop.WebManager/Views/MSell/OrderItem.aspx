<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<style>
.tab-items{border-left:#eee 1px solid;}
.tab-items th,.tab-items td{border-right:#eee 1px solid;}
</style>
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

    OrderDetail order = (OrderDetail)(ViewData["orderInfo"]);
    OrderPayList payorder = null;
    if (order == null)
    {
        payorder = new OrderPayList();
    }
    else {
        if (order.order_pay_list == null)
        {
            payorder = new OrderPayList();
        }
        else
        {
            payorder = order.order_pay_list;
        }
    }
    JiuZhou.ControllerBase.ForeBaseController su = new JiuZhou.ControllerBase.ForeBaseController();
%>

<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <a href="/msell" title="管理首页">订单列表</a> &gt;&gt; <span>订单明细</span>
</div>
<%
    /*     
     DateTime expiredTime=DateTime.Parse(payorder.add_time).AddMinutes(payorder.expired_minute);
     if(payorder.expired_minute>240)
         expiredTime=DateTime.Now.AddDays(1);
    */
    string _statusString = "未知状态";
    string _statusImage = "jindu0.gif";
    string _gotoPay = "";
    if ((order.order_state == 1 || order.order_state == 2)
        && (payorder.pay_state == 0 || payorder.pay_state == 1)
    ) {
        _statusString = "<span>等待买家付款</span>";
    }
    if (order.order_state == 2 && payorder.pay_state == 2 && order.delivery_state == 0) {
        //_statusImage="jindu2.gif";
        _statusString = "<span style='color:blue'>等待卖家发货</span>";
    }
    if (order.order_state == 2 && payorder.pay_state == 2 && order.delivery_state == 1) {
        //_statusImage="jindu3.gif";
        _statusString = "<span>等待买家确认收货</span>";
    }
    if (order.order_state == 3 && payorder.pay_state == 2) {
        //_statusImage="jindu5.gif";
        _statusString = "<span style='color:green'>交易成功</span>";
    }
    if (order.order_state == 0 || order.order_state == 4 || order.order_state == 5) {
        _statusString = "<span style='color:#999'>交易关闭</span>";
    } else if (payorder.pay_type == 18) {
    }
    if (order.order_state == 9 && payorder.pay_state == 0) {
        _statusString = "<span style='color:#999'>交易过期</span>";
    }
%>
		<div class="div-tab">
<table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th colspan="6">支付订单信息</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="lable" style="width:66px">订单编号</td>
    <td class="inputText" style="font-family:Arial;font-weight:bold;"><%=payorder.order_no%><%if (payorder.order_type == 2) {
                                                                                                    Response.Write("<img src=\"/images/icon/phone-1.png\" alt\"手机订单\"/>");
                                                                                                }%></td>
    <td class="lable">创建时间</td>
    <%string addtime = "";
        if (payorder.add_time != null && !payorder.add_time.Equals(""))
            addtime = DateTime.Parse(payorder.add_time).ToString("yyyy-MM-dd HH:mm:ss");
           %>
    <td class="inputText"><%=addtime%></td>
    <td class="lable" style="width:70px">发票抬头</td>
    <td class="inputText"><%=payorder.invoice_title%></td>
  </tr>
  <tr>
    <td class="lable">应付金额</td>
    <td class="inputText" style="font-family:Arial;color:#ff6600;font-weight:bold;font-size:18px">￥<%=payorder.order_money + payorder.trans_money%></td>
    <td class="lable">订单总额</td>
    <td class="inputText" style="font-family:Arial;">￥<%=payorder.total_money%>
    </td>
    <td class="lable">优惠金额</td>
    <td class="inputText"><%=payorder.total_money - payorder.order_money + payorder.taxes_money%></td>
  </tr>
  <tr>
    <td class="lable">积分金额</td>
    <td class="inputText" style="font-family:Arial;"><%=payorder.integral_money%></td>
    <td class="lable" style="width:80px">优惠券金额</td>
    <td class="inputText"><%
                              Response.Write(payorder.coupon_money);

	%></td>
    <td class="lable">满减金额</td>
    <td class="inputText"><%=payorder.fulloff_money %></td>
    </tr>
    <tr>
    <td class="lable">贵&nbsp;宾&nbsp;卡</td>
    <td class="inputText"><%=string.IsNullOrEmpty(payorder.vip_no) ? "&nbsp;" : payorder.vip_no%></td>
        <%if (payorder.ywlx != 2)
            { %>
    <td class="lable">运&nbsp;&nbsp;费</td>
    <td class="inputText" style="font-family:Arial;" colspan="3" >￥<%=payorder.trans_money%> </td>
        <%} else {%>
          <td class="lable">运&nbsp;&nbsp;费</td>
    <td class="inputText" style="font-family:Arial;"  >￥<%=payorder.trans_money%> </td>
         <td class="lable">税费</td>
    <td class="inputText"><%=payorder.taxes_money %></td>
        <%} %>
  </tr>
   <tr>
    <td class="lable">支付方式</td>
    <td class="inputText"><%=(payorder.pay_type==0 && payorder.pay_state > 0)?"医卡通支付":payorder.pay_type_name%><span style='color:#ff6600'>(医卡通支付： <%=payorder.eb_pay_money%> 元)</span></td>
    <td class="lable">支付时间</td>
    <td class="inputText" colspan="5"><%=payorder.pay_type<0?"未支付":payorder.pay_time%></td>
 
  </tr>
  </tbody>
</table>
<a>&nbsp </a>
<table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th colspan="6">订单信息</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="lable" style="width:66px">订单编号</td>
    <td class="inputText" style="font-family:Arial;font-weight:bold;"><%=order.order_no%><%if(payorder.order_type==2){
			Response.Write("<img src=\"/images/icon/phone-1.png\" alt\"手机订单\"/>");
		}%></td>
    <td class="lable" style="width:66px">订单状态</td>
    <td class="inputText"><%=_statusString%></td>
    <td class="lable" style="width:66px">创建时间</td>
    <%string addtime2 = "";
          if(payorder.add_time != null && !payorder.add_time.Equals(""))
              addtime2 = DateTime.Parse(payorder.add_time).ToString("yyyy-MM-dd HH:mm:ss");
           %>
    <td class="inputText"><%=addtime2%></td>
  </tr>

  <tr>
    <td class="lable">联系电话</td>
    <td class="inputText"> <%=order.receive_name%>，<%
        Response.Write(order.receive_mobile_no);
        if (!string.IsNullOrEmpty(order.receive_user_tel) && !string.IsNullOrEmpty(order.receive_mobile_no))
        {
            Response.Write(",");
            Response.Write(order.receive_user_tel);
        }
		%>
    </td>
     <td class="lable">收货地址</td>
    <td class="inputText" colspan="3"><%=order.receive_addr%>
    <%if (!string.IsNullOrEmpty(order.express_number)) { Response.Write("<br /><span style='color:#ff6600'>" + order.express_company + (order.delivery_state > 0 ? "(" + order.delivery_type + ")" : "") + "：" + order.express_number + " </span>"); }%>
    </td>
 
  </tr>
  <tr>
    <td class="lable">用户备注</td>
    <td colspan="5"><%=string.IsNullOrEmpty(order.guest_remark)?"&nbsp;":order.guest_remark%></td>
  </tr>

  </tbody>
</table>
<table class="table tab-items" cellpadding="0" cellspacing="0" style="margin-top:10px;">
<thead>
  <tr>
	<th style="width:90px">发货仓库</th>
    <th style="width:100px">商家编码</th>
    <th>商品名称</th>
    <th style="width:60px">单价</th>
    <th style="width:60px">结算价</th>
    <th style="width:30px">数量</th>
    <th style="width:70px">小计</th>
    <th style="width:80px">总计</th>
  </tr>
</thead>
<tbody>
<%
	decimal _productPriceTotal=0;
	decimal _realProductPriceTotal=0;//未打折的商品总价
    List<OrderItemsInfo> items = order.order_item_list;
/*	List<int> shopIdList=new List<int>();
	string shopIdString="0";
    foreach (OrderItemsInfo item in items)
    {
        int shopid = item.shop_id;
		if (!shopIdList.Contains(shopid)){
            shopIdList.Add(shopid);
			shopIdString += "," + shopid;
		}
	}
	List<ShopInfo> shopList = GetShopInfo(shopIdString);
	List<int> writeList=new List<int>();
 */
    if (items == null)
        items = new List<OrderItemsInfo>();
	for(int i=0;i<items.Count;i++){
		OrderItemsInfo item = items[i];
		_productPriceTotal += (item.deal_price)*(item.sale_num);

        ShopInfo shop = null;
        var resshop = GetShopDetail.Do(order.shop_id);
        if (resshop == null || resshop.Body == null)
        {
            shop = new ShopInfo();
        }
        else {
            shop = resshop.Body;
        }
%>  
  <tr <%=i%2==0?"":" class='bg'"%>>
 <%  if (i == 0)
     {%>
    <td rowspan="<%=items.Count%>" title="<%=shop.shop_name%>"><%=shop.shop_addr%><br/> #<%=shop.shop_id < 10 ? ("0" + shop.shop_id) : shop.shop_id.ToString()%>号仓</td><%} %>
    <td style="text-align:left;"><%=item.product_code%></td>
    <td style="text-align:left;padding:0 5px;"><a href="<%=config.UrlHome %><%=item.product_id %>.html" target="_blank"><%=item.product_name%><%if(!item.sku_name.Equals(""))Response.Write(" / " + item.sku_name);%></a><span style="color:Blue"><%=item.item_state!=0?"(已退订)":"" %></span>
    <%--&nbsp;
    <a href="javascript:;" onclick="addToCart(event,<%=SqlLib.GetString(dr["product_id"]) %>,1,false)" title="放入购物车" style="color:#ff6600">放入购物车</a>--%>
    </td>
    <td style="font-family:Arial">￥<%=item.sale_price%></td>
    <td style="font-family:Arial">￥<%=item.deal_price%></td>
    <td style="text-align:center"><%=item.sale_num%></td>
    <td style="font-family:Arial;font-weight:bold">￥<%=item.deal_price * item.sale_num%></td>
    <%if(i==0){%><td style="font-family:Arial;color:#ff6600;font-weight:bold;font-size:16px;background:#f9f9f9;" rowspan="<%=items.Count%>" id="ppriceCounts">&nbsp;</td><%}%>
  </tr>
<%
	}
%>
</tbody>
</table>

<table id="table-logistics" class="table" cellpadding="0" cellspacing="0" style="margin-top:10px;">
<thead>
  <tr>
    <th>订单跟踪</th>
  </tr>
</thead>
<tbody>
<%//if(order.express_company.IndexOf("圆通")>=0 && Utils.IsLong(order.express_number.Trim())){Response.Write("&nbsp;&nbsp;<a href='javascript:;' onclick='parseLogistics(\""+ order.express_number.Trim() +"\")' style='color:blue'>查询物流信息</a>");}%>
<%
    List<OrderTrackLogListInfo> logs = null;
    var reslog = GetOrderTrackLogInfo.Do(order.order_id);
    if (reslog == null || reslog.Body == null || reslog.Body.track_log_list == null)
    {
        logs = new List<OrderTrackLogListInfo>();
    }
    else {
        logs = reslog.Body.track_log_list;
    }
    
	for(int i=0;i<logs.Count;i++){
        OrderTrackLogListInfo log = logs[i];
		string _oprLog=log.op_log;//opType
        if(string.IsNullOrEmpty(_oprLog)) _oprLog="";
		_oprLog = _oprLog.Replace("WEB-","").Replace("LMS-","").Replace("SYS-","");
        Response.Write("<tr><td>[" + log.add_time + "]&nbsp;" + _oprLog + "/" + log.op_text + "</td></tr>");
	}
%>
</tbody>
</table>

<table id="table-express" class="table" cellpadding="0" cellspacing="0" style="margin-top:10px;">
<thead>
  <tr>
    <th>订单物流</th>
  </tr>
</thead>
<tbody>
<%
    List<ExpressInfo> infos = null;
    var resexp = GetExpressInfo.Do(order.order_no);
    if (resexp == null || resexp.Body == null || resexp.Body.list == null)
    {
        infos = new List<ExpressInfo>();
    }
    else {
        infos = resexp.Body.list;
    }

    for (int i = 0; i < infos.Count; i++)
    {
        ExpressInfo log = infos[i];
        Response.Write("<tr><td>[" + log.time + "]&nbsp;" + log.context + "</td></tr>");
	}
%>
</tbody>
</table>
		</div>
<script type="text/javascript">
$(function(){
	if($("#ppriceCounts")) $("#ppriceCounts").html("￥<%=_productPriceTotal%>");
    <%
    if(order.express_number == null)
      order.express_number = "";
    if(Utils.IsLong(order.express_number.Trim())){
	string traceUrl="";
	if (order.express_company.IndexOf("圆通") >= 0){
		traceUrl="YtoWaybillTrace";
	}else if (order.express_company.IndexOf("天天") >= 0){
		traceUrl="TTKDWaybillTrace";
	}
	if(traceUrl!=""){
%>
	$.ajax({
		url: "/Tools/<%=traceUrl%>"
		, type: "post"
		, data: {"orderNumber": "<%=order.order_no%>", "ot": "desc"}
		, dataType: "json"
		, success: function(json, textStatus){
			var tab=$("#table-logistics tbody");
			if(json.error){
				tab.prepend("<tr><td>[<%=DateTime.Now.ToString("yyyy-MM-dd HH:mm")%>]&nbsp;&nbsp;[物流查询] " + json.message + "</td></tr>");
			}else{
				var html='';
				for(var i=0;i<json.data.length;i++){
					html +="<tr><td>" + json.data[i].oprText + "</td></tr>";
				}
				tab.prepend(html);
			}
			$(".table tbody tr:odd").addClass("bg");
			$(".table tbody tr:even").removeClass("bg");
			$(".table tbody tr").hover(function(){
    			$(this).addClass("bg-on");
			},function(){
    			$(this).removeClass("bg-on");
			});
		}, error: function(http, textStatus, errorThrown){
			//errorBox(errorThrown);
		}
	});
<%}}%>});
</script>
<br/><br/><br/><br/>
	</div>
</div>
<br/><br/>
<br/><br/><br/>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>