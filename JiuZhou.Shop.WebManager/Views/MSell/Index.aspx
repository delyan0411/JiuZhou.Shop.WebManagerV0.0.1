<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="JiuZhou.Model" %>
<%@ Import Namespace="JiuZhou.Common" %>
<%@ Import Namespace="JiuZhou.MySql" %>
<%@ Import Namespace="JiuZhou.HttpTools" %>
<%@ Import Namespace="JiuZhou.Cache" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="/style/style.css" rel="stylesheet" type="text/css" />
    <%Html.RenderPartial("Base/_PageHeadControl"); %>
    <title>
        <%=ViewData["pageTitle"]%></title>
</head>
<body>
    <%Html.RenderPartial("Base/_SimplePageTopControl"); %>
    <%
        ConfigInfo config = (ConfigInfo)(ViewData["config"]);
        int status = DoRequest.GetQueryInt("status", -1);
        int pStatus = DoRequest.GetQueryInt("payStatus", -1);
        int dvStatus = DoRequest.GetQueryInt("dvStatus", -1);
        int sType = DoRequest.GetQueryInt("sType");
        int paytype = DoRequest.GetQueryInt("paytype", -1);
        string otype = DoRequest.GetQueryString("ot").ToLower().Trim();
        List<ShopList> shopList = new List<ShopList>();
        DoCache chche = new DoCache();
        if (chche.GetCache("shoplist") == null)
        {
            var resshop = GetShopInfo.Do(-1);
            if (resshop != null && resshop.Body != null && resshop.Body.shop_list != null)
            {
                shopList = resshop.Body.shop_list;
                chche.SetCache("shoplist", shopList);
                if (shopList.Count == 0)
                {
                    chche.RemoveCache("shoplist");
                }
            }
        }
        else
        {
            shopList = (List<ShopList>)chche.GetCache("shoplist");
        }
        JiuZhou.ControllerBase.ForeBaseController su = new JiuZhou.ControllerBase.ForeBaseController();
    %>
    <div id="container-syscp">
        <div class="container-left">
            <%Html.RenderPartial("Base/LeftControl"); %>
        </div>
        <div class="container-right">
            <div class="position">
                当前位置： <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>订单列表</span> &nbsp;&nbsp;&nbsp;
            </div>
            <form id="sForm" action="/msell" method="get" onsubmit="checksearch(this)">
                <input type="hidden" name="status" value="<%=status%>" />
                <input type="hidden" name="size" value="<%=DoRequest.GetQueryInt("size", 60)%>" />
                <input type="hidden" name="ocol" value="<%=DoRequest.GetQueryString("ocol")%>" />
                <input type="hidden" name="ot" value="<%=DoRequest.GetQueryString("ot")%>" />
                <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px; height: 36px">
                    <p>
                        <select id="stype" name="stype" style="width: 80px">
                            <option value="0" init="true">默认搜索</option>
                            <option value="1">订单号</option>
                            <option value="2">收货人</option>
                            <option value="3">联系电话</option>
                            <option value="4">用户ID</option>
                            <option value="5">快递单号</option>
                            <option value="6">商品名称</option>
                            <option value="7">用户名</option>
                        </select>
                    </p>
                    <p>
                        <select id="oStatus" style="width: 80px">
                            <option value="-1" init="true">全部状态</option>
                            <%--订单状态,支付状态,发货状态--%>
                            <option value="1">等待买家付款</option>
                            <option value="2">等待卖家发货</option>
                            <option value="3">等待确认收货</option>
                            <option value="4">待评价</option>
                            <option value="5">订单成功</option>
                            <option value="6">订单退订</option>
                            <option value="7">订单退货</option>
                            <option value="8">订单关闭</option>
                            <option value="9">货到付款</option>
                        </select>
                    </p>
                    <p>
                        <select id="paytypeStatus" name="payType" style="width: 80px">
                            <option value="-1" init="true">全部</option>
                            <%--支付状态--%>
                            <option value="1">医卡通</option>
                            <option value="2">弥康</option>
                            <option value="3">瀚医支付</option>
                            <option value="4">虚拟账户支付</option>
                            <option value="5">平安健康支付</option>
                            <option value="6">可乐否订单</option>
                            <option value="7">企健网</option>
                            <option value="8">微脉订单</option>
                            <option value="9">海外购订单</option>
                        </select>
                    </p>
                    <p>
                        <%
                            DateTime date = DateTime.Now.AddDays(-15);
                        %><input type="text" name="sdate" value="<%=DoRequest.GetQueryDate("sDate", date).ToString("yyyy-MM-dd")%>"
                            readonly="readonly" class="date" onclick="WdatePicker()" />
                        至
                    <input type="text" name="edate" value="<%=DoRequest.GetQueryDate("eDate", DateTime.Now).ToString("yyyy-MM-dd")%>"
                        readonly="readonly" class="date" onclick="WdatePicker()" />
                    </p>
                    <p style="position: relative">
                        <input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>"
                            class="input" autocomplete="off" style="height: 26px; width: 260px; line-height: 26px;" />
                    </p>
                    <p>
                        <input type="submit" value=" 搜索 " class="submit" />
                    </p>
                    <p>
                        <a href="javascript:;" onclick="changeOrderBy('TOTALMoney','<%=otype=="asc"?"desc":"asc"%>')">按价格排序</a>
                    </p>
                </div>
            </form>
            <script type="text/javascript">
                var _currUrl = "<%=ViewData["currPageUrl"]%>";
                function formatUrl(ocol, val, url) {
                    if (!url) url = _currUrl;
                    var reg = ocol + "=[^-]*";
                    var reg = new RegExp(ocol + "=[^&\.]*");
                    url = url.replace(reg, ocol + "=" + val);
                    return url;
                }
                var changeOrderBy = function (ocol, ot) {
                    _currUrl = formatUrl("ocol", ocol);
                    url = formatUrl("ot", ot);
                    window.location.href = url;
                };
                /*$(function(){
                    var obj=$("#sQuery");
                    obj.focus(function(){
                        $("#sLabel").css({"visibility":"hidden"});
                    }).blur(function(){
                        if(obj.val()=='') $("#sLabel").css({"visibility":"visible"});
                    });
                    if(obj.val()!=''){
                        $("#sLabel").css({"visibility":"hidden"});
                    }
                });*/
                var dropSType = dropOStatus = droppaytypeStatus = false;
                Atai.addEvent(window, "load", function () {
                    dropSType = new _DropListUI({
                        input: Atai.$("#stype")
                    }); dropSType.maxHeight = "260px"; dropSType.width = "80px";
                    dropSType.init(); dropSType.setDefault("<%=sType%>");

                    dropOStatus = new _DropListUI({
                        input: Atai.$("#oStatus")
                    }); dropOStatus.maxHeight = "260px"; dropOStatus.width = "100px";
                    dropOStatus.init(); dropOStatus.setDefault("<%=status%>");

                    droppaytypeStatus = new _DropListUI({
                        input: Atai.$("#paytypeStatus")
                    }); droppaytypeStatus.maxHeight = "260px"; droppaytypeStatus.width = "80px";
                    droppaytypeStatus.init(); droppaytypeStatus.setDefault("<%=paytype%>");
                });
                function checksearch(form) {
                    $("#sForm input[name='status']").val($("#oStatus option:selected").val());
                }
                var _currUrl = "<%=ViewData["currPageUrl"]%>";
                function formatUrl(ocol, val, url) {
                    if (!url) url = _currUrl;
                    var reg = ocol + "=[^-]*";
                    var reg = new RegExp(ocol + "=[^&\.]*");
                    url = url.replace(reg, ocol + "=" + val);
                    return url;
                }
                var changeOrderBy = function (ocol, ot) {
                    _currUrl = formatUrl("ocol", ocol);
                    url = formatUrl("ot", ot);
                    window.location.href = url;
                };
                $(function () {
                    $("table[v='order-list']").mouseenter(function () {
                        $(this).addClass("table-hover");
                    }).mouseleave(function () {
                        $(this).removeClass("table-hover");
                    });
                });
            </script>
            <%=ViewData["pageIndexLink"]%>
            <%
                List<OrderPayInfo> orderList = (List<OrderPayInfo>)ViewData["infoList"];//主订单列表
                if (orderList == null)
                    orderList = new List<OrderPayInfo>();
            %>
            <%
                foreach (OrderPayInfo order in orderList)
                {
                    /*		List<OrderInfo> _orderList = children.FindAll(
                                delegate(OrderInfo o){
                                    return o.GroupOrderNumber.Trim()==order.order_no.Trim();
                            });
                            DateTime addTime = order.add_date;
                            int expiredMinutes = order.ExpiredMinutes;
                            DateTime expiredTime=addTime.AddMinutes(expiredMinutes);
                            if(expiredMinutes>240) expiredTime=DateTime.Now.AddDays(1);*/

            %>
            <table class="order-list" v="order-list" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <th colspan="3">
                            <strong>合并单号：<%=order.pay_order_no%>
                                &nbsp;<%=DateTime.Parse(order.add_time).ToString("yyyy-MM-dd HH:mm:ss")%>
                                <%
                                    if (order.order_type == 2)
                                    {
                                        Response.Write("<img src=\"/images/icon/phone-1.png\" align=\"absmiddle\" alt=\"手机订单\"/>");
                                    }
                                    if (order.expired_minute <= 240)
                                        Response.Write("&nbsp;<img src=\"/images/icon/clock2.png\" align=\"absmiddle\" alt\"限时秒杀\"/>");
                                    
                                        // Response.Write("&nbsp;<img src=\"/images/icon/oversea.png\" align=\"absmiddle\" alt\"海外购\"/>");
                                %>
                            </strong><b v="price">￥<%=order.pay_order_money + order.pay_trans_money%></b> <span v="farePrice">(含运费
                                <%=order.pay_trans_money%>
                                元 
                                <%if (order.ywlx == 2)
                                    { %>
                                税费
                                <%=order.taxes_money%>
                                元)
                                <%}%>
                                    优惠
                              <%= order.pay_total_money - order.pay_order_money + order.taxes_money %><%--这两个都是不含运费pay_trans_money 但是pay_order_money减了优惠金额--%>
                                元)                                                                    </span><span>
                                    <%=(order.pay_type==0 && order.pay_state > 0)?"医卡通":order.pay_type_name%></span>
                            &nbsp; <a href="/msell?status=-1&stype=4&q=<%=order.user_id%>" target="_blank">查看用户订单</a>
                            <%
                                if ((order.pay_order_state == 1) && order.pay_state == 0 && order.is_delete != 1)
                                {
                                    Response.Write("&nbsp;<a href=\"javascript:;\"");
                                    Response.Write(" price=\"" + order.pay_order_money + "\"");
                                    Response.Write(" farePrice=\"" + order.pay_trans_money + "\"");

                                    //if (su._superUser.Contains(su._currUser.UserName)){
                                    Response.Write(" onclick=\"orderTransPriceBox(this,'" + order.pay_order_no + "',true)\"");
                                    Response.Write(" style=\"color:#00f\">改价/改运费</a>");
                                    //}else{
                                    //		Response.Write(" onclick=\"orderTransPriceBox(this,'"+order.pay_order_no+"',false)\"");
                                    //		Response.Write(" style=\"color:#00f\">改运费</a>");
                                    //	}
                                }
                            %>
                        </th>
                        <th style="width: 12%;">
                            <%

                                if ((order.pay_order_state == 1) && order.pay_state == 0 && order.is_delete != 1
                                )
                                {
                                    Response.Write("<a href=\"javascript:;\" count=\"" + order.send_msg_count + "\" onclick=\"sendMobileMessageBox(this,'" + order.pay_order_no + "')\" style=\"color:#00f\">提醒买家付款<span>(" + order.send_msg_count + ")</span></a>");
                                }

                                var servicestate = "";
                                if (order.pay_service_state == 2)
                                {
                                    servicestate = "处理完毕";
                                }
                                else
                                {
                                    if (order.pay_service_state == 1)
                                    {
                                        servicestate = "正在处理";
                                    }
                                    else
                                    {
                                        servicestate = "无售后";
                                    }
                                }
                                if ((((order.pay_order_state == 2 && (order.pay_state == 2 || order.pay_type == 18) && order.pay_delivery_state == 0) || (order.pay_order_state == 1 && order.pay_state == 1)) && order.is_delete == 0) || (order.pay_order_state == 4 && (order.pay_service_state == 1 || order.pay_service_state == 0)))
                                {
                                    if (order.pay_type != 53 && order.pay_type != 65 && order.pay_type != 66)
                                    {
                                        Response.Write("<a href=\"javascript:;\" onclick=\"resetOrderStyleBox('" + order.pay_order_no + "','" + order.pay_service_state + "')\" >退订(<span style=\"color:#555\">" + servicestate + "</span>)</a><br/>");
                                    }
                                }
                                if ((((order.pay_order_state == 2 && order.pay_delivery_state > 0) || order.pay_order_state == 3) && order.is_delete == 0 && order.pay_type == 0) || (order.pay_order_state == 5 && (order.pay_service_state == 1 || order.pay_service_state == 0)))
                                {
                                    Response.Write("<a href=\"javascript:;\" onclick=\"returnOrderStyleBox('" + order.pay_order_no + "','" + order.pay_service_state + "')\">退货(<span style=\"color:#555\">" + servicestate + "</span>)</a><br/>");
                                }
                            %>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<OrderInfo> oList = order.order_list;
                        int _orderCount = 0;
                        foreach (OrderInfo od in oList)
                        {
                            List<OrderItemsInfo> items = od.item_list; //订单明细
                            string className = " class=\"bg\"";
                            if (_orderCount % 2 == 0)
                            {
                                className = "";
                            }
                            _orderCount++;
                            ShopList shop = new ShopList();
                            foreach (ShopList sh in shopList)
                            {
                                if (sh.shop_id == od.shop_id)
                                {
                                    shop = sh; break;
                                }
                            }
                    %>
                    <tr <%=className%>>
                        <td class="data-list show">
                            <div class="order-hd">
                                <div class="order-number">
                                    订单编号：<%=od.order_no%>
                                    &nbsp;(<%=shop.shop_addr%>
                                    /
                                    <%=shop.shop_name%>)
                                </div>
                                <div class="order-items">
                                    <a href="javascript:;" onclick="showItems(this)"><span>展开</span><b>收缩</b></a>
                                </div>
                                <div class="clear">
                                </div>
                                <div>
                                    <%=od.province_name%>,<%=od.city_name%>,<%=od.county_name%>,<%=od.receive_addr%>,<%=od.receive_name%>,<%
                                                                                                                                              Response.Write(od.receive_mobile_no);
                                                                                                                                              if (!string.IsNullOrEmpty(od.receive_user_tel) && !string.IsNullOrEmpty(od.receive_mobile_no))
                                                                                                                                              {
                                                                                                                                                  Response.Write(",");
                                                                                                                                                  Response.Write(od.receive_user_tel);
                                                                                                                                              }
                                    %>,<%if (order.ywlx == 2)
                                           { %>
                                身份证号:
                                <%=od.id_card %>
                                )
                                <%}%>
                                </div>
                                <div id="remark-<%=od.order_id%>" style="background-color: #ccc">
                                    <%=od.inner_remark%>
                                </div>
                            </div>
                            <dl>
                                <%
                                    if (items == null)
                                        items = new List<OrderItemsInfo>();
                                    for (int i = 0; i < items.Count; i++)
                                    {
                                        OrderItemsInfo item = items[i];

                                        string p_spec = item.product_spec.Length > 20 ? (Utils.CutString(item.product_spec, 0, 16) + "...") : item.product_spec;
                                %>
                                <dd>
                                    <a href="<%=config.UrlHome%><%=item.product_id%>.html" target="_blank" class="img">
                                        <img src="<%=FormatImagesUrl.GetProductImageUrl(item.img_src, 60, 60)%>" />
                                    </a>
                                    <div class="text">
                                        <%
                                            string _itemstate = "";
                                            switch (item.item_state)
                                            {
                                                case 0:
                                                    _itemstate = "";
                                                    break;
                                                case 4:
                                                    _itemstate = "(已退订)";
                                                    break;
                                                case 5:
                                                    _itemstate = "(已退货)";
                                                    break;
                                                default:
                                                    _itemstate = "";
                                                    break;
                                            }
                                        %>
                                        <a href="<%=config.UrlHome%><%=item.product_id%>.html" target="_blank">
                                            <%=item.product_name%></a> <span style="color: Blue">
                                                <%=_itemstate%></span><br />
                                        规格：<%=p_spec%><%=string.IsNullOrEmpty(item.sku_name)?"":"&nbsp;/&nbsp;"%><%=item.sku_name%><br />
                                        编码：<%=item.product_code%>
                                        <a href="javascript:;" onclick="resetCode(<%=od.order_id %>,<%=item.product_id %>,'<%=item.product_code %>','<%=item.product_name %>')">修改</a>
                                    </div>
                                    <div class="unit-price">
                                        <%if (item.sale_price > item.deal_price)
                                            {%><del>￥<%=item.sale_price%></del><br />
                                        <%}%>
                                        ￥<%=item.deal_price%>
                                        ×
                                        <%=item.sale_num%>
                                    </div>
                                </dd>
                                <%
                                    }
                                %>
                            </dl>
                        </td>
                        <td class="price">￥<%=od.total_money%>
                        </td>
                        <td class="status">
                            <%
                                string _statusString = "未知状态";
                                if ((od.order_state == 1) && (order.pay_state == 0))
                                {
                                    _statusString = "<span style=\"color:#f00\">等待买家付款</span>";
                                }
                                if ((od.order_state == 1) && (order.pay_state == 1))
                                {
                                    _statusString = "<span style=\"color:#f00\">等待买家付款</br>(已部分付款)</span>";
                                }
                                if (od.order_state == 2 && order.pay_state == 2 && od.delivery_state == 0)
                                {
                                    _statusString = "<a href=\"javascript:;\" onclick=\"appendDeliveryBox(event,'" + od.order_no + "')\" style=\"color:#00f\">等待卖家发货</a>";
                                }
                                //货到付款
                                if (od.order_state == 2 && order.pay_state == 0 && od.delivery_state == 0)
                                {
                                    _statusString = "<span style=\"color:#f00\">货到付款</span>";
                                }
                                if (od.order_state == 2 && order.pay_state == 2 && od.delivery_state == 1)
                                {
                                    _statusString = "<span style=\"color:#00f\">等待确认收货</span>";
                                }
                                if (od.order_state == 2 && order.pay_state == 2 && od.delivery_state == 2)
                                {
                                    _statusString = "<span style=\"color:#00f\">待评价</span>";
                                }
                                if (od.order_state == 3 && order.pay_state == 2)
                                {
                                    _statusString = "<span style='color:#00f'>交易成功</span>";
                                }
                                if (od.order_state == 0)
                                {
                                    _statusString = "<span style='color:#999'>订单取消</span>";//AppendDeliveryControl
                                }
                                if (od.order_state == 4)
                                {
                                    _statusString = "<span style='color:#999'>订单退订</span>";//AppendDeliveryControl
                                }
                                if (od.order_state == 5)
                                {
                                    _statusString = "<span style='color:#999'>订单退货</span>";//AppendDeliveryControl
                                }
                                if (od.order_state == 9 && order.pay_state == 0)
                                {
                                    _statusString = "<span style='color:#999'>订单过期</span>";
                                }
                                Response.Write(_statusString);
                                if (order.pay_state == 53 || od.order_state == 1 || (od.order_state == 9 && order.pay_state == 0) || od.order_state == 0)
                                {
                                    Response.Write("<a href=\"javascript:;\" onclick=\"getHYstate(this,'" + od.order_no + "','" + od.order_state + "')\" >查看翰医支付状态</a><br/>");
                                }
                            %>
                        </td>
                        <td class="op">
                            <a href="/msell/orderItem?id=<%=od.order_id%>&orderNumber=<%=od.order_no %>" target="_blank">查看详情</a><br />
                            <a href="javascript:;" onclick="updateRemarkBox('#remark-<%=od.order_id%>', '<%=od.order_no%>')">订单备注</a><br />
                            <% 
                                if (od.order_state == 1 || (od.order_state == 2 && od.delivery_state == 0))
                                    Response.Write("<a href=\"javascript:;\" onclick=\"updateReceiveAddr('" + od.order_no + "', '" + od.receive_name + "', '" + od.province_name + "', '" + od.city_name + "', '" + od.county_name + "', '" + od.receive_addr + "', '" + od.receive_mobile_no + "', '" + od.receive_user_tel + "', '" + od.zip_code + "')\">修改收货地址</a><br/>");
                            %>
                            <% 
                                if (order.pay_type == 53 && order.pay_state == 2 && od.order_state != 0 && od.order_state != 4 && od.order_state != 5)//od.order_state == 0
                                {
                                    Response.Write("<a href=\"javascript:;\" onclick=\"BalanceRefund('" + od.order_no + "','" + order.user_id + "','" + order.pay_type + "')\" >退订翰医子订单</a><br/>");
                                }
                                if (order.pay_type == 65 && order.pay_state == 2 && od.order_state != 0 && od.order_state != 4 && od.order_state != 5)//od.order_state == 0
                                {
                                    Response.Write("<a href=\"javascript:;\" onclick=\"BalanceRefund('" + od.order_no + "','" + order.user_id + "','" + order.pay_type + "')\" >退订企健子订单</a><br/>");
                                }
                                if (order.pay_type == 66 && order.pay_state == 2 && od.order_state != 0 && od.order_state != 4 && od.order_state != 5)//od.order_state == 0
                                {
                                    Response.Write("<a href=\"javascript:;\" onclick=\"BalanceRefund('" + od.order_no + "','" + order.user_id + "','" + order.pay_type + "')\" >退订可乐否子订单</a><br/>");
                                }
                            %>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
                }
            %>
            <%=ViewData["pageIndexLink2"]%>
            <br />
            <br />
            <br />
            <br />
        </div>
    </div>
    <script type="text/javascript">

        function showItems(obj) {
            var td = $(obj).parent("div").parent("div").parent("td");
            if (td.hasClass("show")) {
                td.removeClass("show");
            } else {
                td.addClass("show");
            }
        }
        $(function () {
            var obj = $("#syscp-menu");
            var _offset = obj.offset();
            $(window).scroll(function () {
                var _stop = $(window).scrollTop() + 1;
                if (parseInt(_stop) > parseInt(_offset.top)) {
                    obj.css({ margin: "0", width: 220, zIndex: "1" });
                    if (Atai.ST.isMinIE6) {
                        obj.css({ position: "absolute", "opacity": 0.9, top: (_stop) + "px" });
                    } else {
                        obj.css({ position: "fixed", "opacity": 0.9, top: "1px" });
                    }
                } else {
                    obj.css({ position: "relative", "opacity": 1, top: "auto", marginTop: "0", borderBottom: "0" });
                }
            });
        });
    </script>
    <%Html.RenderPartial("MSell/SendMobileMessageControl"); %>
    <%Html.RenderPartial("MSell/OrderTransPriceControl"); %>
    <%Html.RenderPartial("MSell/AppendDeliveryControl"); %>
    <%Html.RenderPartial("MSell/OrderRefundControl"); %>
    <%Html.RenderPartial("MSell/RefundOrderControl"); %>
    <%Html.RenderPartial("MSell/RefundPartOrderControl"); %>
    <%Html.RenderPartial("MSell/ReturnPartOrderControl"); %>
    <%Html.RenderPartial("MSell/ReturnOrderControl"); %>
    <%Html.RenderPartial("MSell/UpdataReceiveAddrControl"); %>
    <%Html.RenderPartial("MSell/ResetProductCodeControl"); %>
    <%Html.RenderPartial("MSell/CheckHYStateControl"); %>
    <div id="updateRemark-boxControl" class="moveBox" style="height: 260px; width: 520px;">
        <div class="name">
            设置订单备注
            <div class="close" v="atai-shade-close" title="关闭">
                &nbsp;
            </div>
        </div>
        <div class="clear">
            &nbsp;
        </div>
        <form action="" onsubmit="return postOrderRemark(this)">
            <input type="hidden" id="updateRemark-orderNumber" name="orderNumber" value="" />
            <table width="100%" border="0" cellspacing="4" cellpadding="0">
                <tr>
                    <td class="left">&nbsp;
                    </td>
                    <td>
                        <span class="tips-text" style="color: #ff6600">&nbsp;</span>
                    </td>
                </tr>
                <tr>
                    <td class="left" style="height: 36px;" valign="top">订 单 号：
                    </td>
                    <td>
                        <input type="text" id="oupdateRemark-orderNumber" class="input" value="" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td class="left" style="height: 36px;" valign="top">备&nbsp;&nbsp;注：
                    </td>
                    <td>
                        <textarea id="updateRemark-textarea" name="remark"></textarea>
                    </td>
                </tr>
                <tr>
                    <td class="left" style="height: 30px;">&nbsp;
                    </td>
                    <td>
                        <input type="submit" class="submit" value="  保 存  " />
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <script type="text/javascript">
        function postOrderRemark(form) {
            var postData = getPostDB(form);
            $.ajax({
                url: "/msell/updateRemark"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        $(_oupdateRemarkBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
			    } else {
			        window.location.href = window.location.href;
			    }
			}
            });
            return false;
        }
        var _oupdateRemarkBoxDialog = false;
        function updateRemarkBox(obj, orderNumber) {

            var boxId = "#updateRemark-boxControl";
            var box = Atai.$(boxId);
            var _dialog = false;
            if (!_dialog)
                _dialog = new AtaiShadeDialog();
            _dialog.init({
                obj: boxId
		    , sure: function () { }
		    , CWCOB: false
            });
            _oupdateRemarkBoxDialog = _dialog;
            $(_oupdateRemarkBoxDialog.dialog).find("#updateRemark-orderNumber").val(orderNumber);
            $(_oupdateRemarkBoxDialog.dialog).find("#oupdateRemark-orderNumber").val(orderNumber);
            return false;
        }

        //退订瀚医子订单
        function BalanceRefund(order_no, user_id, pay_type) {
            var postData = {
                "order_no": order_no
           , "user_id": user_id
                 , "pay_type": pay_type
            }
            jsbox.confirm('您确定要将订单 <span style="color:#ff6600">' + order_no + '</span> 退订吗？', function () {
                $.ajax({
                    url: "/MSell/BalanceRefundStates"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        alert(json.message);
			    } else {
			        jsbox.success(json.message, window.location.href);
			    }
			}
                });
            });
            return false;
        }

    </script>
    <br />
    <br />
    <br />
    <br />
    <br />
    <%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
