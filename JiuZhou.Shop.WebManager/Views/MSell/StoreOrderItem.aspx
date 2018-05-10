<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="JiuZhou.Model" %>
<%@ Import Namespace="JiuZhou.Common" %>
<%@ Import Namespace="JiuZhou.MySql" %>
<%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%Html.RenderPartial("Base/_PageHeadControl"); %>
    <link href="/style/style.css" rel="stylesheet" type="text/css" />
    <title><%=ViewData["pageTitle"]%></title>
    <style>       
    table {
        width: 100%;
        /* font-size: 13px; */
        line-height: 28px;
    }

    .order-message table th {
        font-size: 15px;
        background-color: #f1f7fb;
    }

    .order-message table td,
    .order-message .trh th {
        border-top: 1px solid gray;
        border-right: 1px solid gray;
    }

    .trh a {
        text-decoration: underline;
    }

    .ttd {
        border-right: 0px;
        text-align: center;
    }

    .t_border {
        border-left: 1px solid gray;
        border-bottom: 1px solid gray;
    }

    .tdcols {
        font-size: 14px;
        font-weight: bold;
    }

    table span.on {
        color: Green;
        font-weight: bold;
    }

    table span.off {
        color: Red;
        font-weight: bold;
    }

    table td a {
        color: blue;
    }

    table td span.pp {
        color: #f60;
    }
    </style>
</head>
<body>
    <%Html.RenderPartial("Base/_SimplePageTopControl"); %>
    <%
        ConfigInfo config = (ConfigInfo)(ViewData["config"]);
         var payOrder = ViewData["payOrderInfo"] as PayOrderInfo;
    %>

    <div id="container-syscp">
        <div class="container-left">
            <%Html.RenderPartial("Base/LeftControl"); %>
        </div>
        <div class="container-right">
            <div class="position">
                当前位置：
                <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>订单详情</span>
            </div>
          <div class="order-message" style="border: 0px;">
                    <%
                        var totalMoney = payOrder.total_money;
                        var orderMoney = payOrder.order_money;
                        var transMoney = payOrder.trans_money;

                        var intergralMoney = payOrder.integral_money;
                        var couponMoney = payOrder.coupon_money;
                        var fullOffMoney = payOrder.fulloff_money;

                        var totalDiscount = totalMoney - orderMoney;
                        var payType = "";
                        var payTypeList = ViewData["payType"] as List<PayTypeInfo>;
                        if (payTypeList != null && payTypeList.Count > 0 && payTypeList.Exists(t => t.pay_type_id == payOrder.pay_type))
                        {
                            payType = payTypeList.FirstOrDefault(t => t.pay_type_id == payOrder.pay_type).pay_type_name;
                        }
                        var ebPayMoney = payOrder.eb_pay_money;
                        var payTime = payOrder.pay_time;

                        var receiveInfo = "";
                        var userRemark = "";
                        if (payOrder.order_list != null && payOrder.order_list.Count > 0)
                        {
                            var o = payOrder.order_list[0];
                            if (!string.IsNullOrEmpty(o.province_name))
                            {
                                receiveInfo += o.province_name + ",";
                            }
                            if (!string.IsNullOrEmpty(o.city_name) && !o.city_name.Equals("市辖区"))
                            {
                                receiveInfo += o.city_name + ",";
                            }
                            if (!string.IsNullOrEmpty(o.county_name))
                            {
                                receiveInfo += o.county_name + ",";
                            }
                            receiveInfo += o.receive_addr + "," + o.receive_name + "," + (string.IsNullOrEmpty(o.receive_mobile_no) ? o.receive_user_tel : o.receive_mobile_no);
                            userRemark = o.guest_remark;
                        }
                    %>
                    <form id="post-form" method="post" action="">
                        <table cellpadding="0" cellspacing="0" id="tbPayInfo" class="t_border">
                            <thead>
                                <tr class="trh">
                                    <th colspan="3">支付信息</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>合并单号：<%= payOrder.order_no %></td>
                                    <td>创建时间：<%= payOrder.add_time %></td>
                                    <td>发票抬头 <%=payOrder.invoice_title %></td>
                                </tr>
                                <tr>
                                    <td>实付金额：<span class="off"><%= orderMoney + transMoney %></span></td>
                                    <td>订单金额：<span class="off"><%= totalMoney + transMoney %></span><%=(transMoney > 0 ? "(含运费<span class='off'>" + transMoney + "</span>元)" : "") %></td>
                                    <td>总优惠金额：<span class='on'><%= totalDiscount %></span></td>
                                </tr>
                                <tr>
                                    <td>积分抵扣：<span class='on'><%= intergralMoney %></span></td>
                                    <td>优惠券：<span class='on'><%= couponMoney %></span></td>
                                    <td>满减金额：<span class='on'><%= fullOffMoney %></span></td>
                                </tr>
                                <tr>
                                    <td>贵宾卡 <%= payOrder.vip_no %></td>
                                    <td>支付方式：<%= payType + (ebPayMoney > 0 ? "(医卡通支付：<span class='off'>" + ebPayMoney + "</span>元)" : "") %></td>
                                    <td>支付时间：<%= string.IsNullOrEmpty(payTime) ? "未支付" : payTime %></td>
                                </tr>
                                <tr>
                                    <td colspan="3">收货地址：<%= receiveInfo %></td>
                                </tr>
                                <tr>
                                    <td colspan="3">用户备注：<%= userRemark %></td>
                                </tr>
                            </tbody>
                        </table>
                        <br />
                        <%
                            for (int orderIndex = 0; orderIndex < payOrder.order_list.Count; orderIndex++)
                            {
                                var order = payOrder.order_list[orderIndex];
                                var orderNo = order.order_no;
                                var shopInfo = order.shop_addr;
                                var shopId = order.shop_id;
                                shopInfo += " #" + (shopId < 10 ? "0" : "") + shopId + "号仓";
                                var orderState = order.order_state;
                                //订单总状态,0-未付款,1-部分付款，2-待发货，3-待收货，4-待评价,10-订单关闭（订单取消，过期，退订完毕，退货完毕 ）
                                // 11-订单成功，12-订单退订中，13-订单退货中，14-售后处理中
                                var totalStatei = order.total_state;
                                var stateDesc = "未知状态";
                                switch (totalStatei)
                                {
                                    case 0:
                                        stateDesc = "未付款" + "&nbsp;&nbsp;<a href='" + config.UrlHome + "OrderInfo/SuccessComm/" + payOrder.order_no + "'>去支付</a>";
                                        break;
                                    case 1:
                                        stateDesc = "待付款" + "&nbsp;&nbsp;<a href='" + config.UrlHome + "OrderInfo/SuccessComm/" + payOrder.order_no + "'>去支付</a>"; ;
                                        break;
                                    case 2:
                                        stateDesc = "待发货";
                                        break;
                                    case 3:
                                        stateDesc = "待收货";
                                        break;
                                    case 4:
                                        stateDesc = "待评价";
                                        break;
                                    case 10:
                                        stateDesc = "订单关闭";
                                        stateDesc += "(";
                                        switch (orderState)
                                        {
                                            case 0:
                                                stateDesc += "订单取消";
                                                break;
                                            case 4:
                                                stateDesc += "用户退订";
                                                break;
                                            case 5:
                                                stateDesc += "用户退货";
                                                break;
                                            case 9:
                                                stateDesc += "订单过期";
                                                break;
                                            default:
                                                break;
                                        }
                                        stateDesc += ")";
                                        break;
                                    case 11:
                                        stateDesc = "交易成功";
                                        break;
                                    case 12:
                                        stateDesc = "订单退订中";
                                        break;
                                    case 13:
                                        stateDesc = "订单退货中";
                                        break;
                                    case 14:
                                        stateDesc = "售后处理中";
                                        break;
                                    default:
                                        break;
                                }
                                var expressNo = order.express_number;
                        %>
                        <table cellpadding="0" cellspacing="0" id="tbOrder<%= orderNo %>" class="t_border">
                            <thead>
                                <tr class="trh">
                                    <th colspan="2">订单编号 <a href="javascript:;" onclick="orderClick('<%= orderNo %>')"><%= orderNo %></a></th>
                                    <th>订单总额：<span class="off"><%= order.total_money %></span></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>发货仓库：<%= shopInfo %></td>
                                    <td>订单状态：<%= stateDesc %></td>
                                    <td>快递单号：<%= string.IsNullOrEmpty(expressNo) ? "" : (expressNo + "(" + order.express_company + ")") %></td>
                                </tr>
                                <tr>
                                    <td colspan="3">

                                        <table cellpadding="0" cellspacing="0">
                                            <thead>
                                                <tr>
                                                    <th colspan="5">商品清单</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr style="font-weight: bold; text-align: center;">
                                                    <td>商家编码</td>
                                                    <td>商品名称</td>
                                                    <td>售价</td>
                                                    <td>购买数量</td>
                                                    <td class="ttd">小计</td>
                                                </tr>
                                                <%
                                                    for (int itemIndex = 0; (order.order_item_list != null && itemIndex < order.order_item_list.Count); itemIndex++)
                                                    {
                                                        var oi = order.order_item_list[itemIndex];
                                                        //var img = FormatImage.GetProductImageUrl(oi.img_src, 60, 60);
                                                        var img = "";
                                                        var title = oi.product_name;
                                                        var _ischk = "";
                                                        if (oi.is_on_sale == 1 && oi.is_visible == 1 && oi.stock_num > 0 && oi.allow_ebaolife == 1)
                                                            _ischk = "checked=\"checked\"";
                                                        var _msg = "";
                                                        if (oi.is_visible != 1)
                                                        {
                                                            _msg = "(已下架)";
                                                        }
                                                        else
                                                        {
                                                            if (oi.is_on_sale != 1)
                                                            {
                                                                _msg = "(已下架)";
                                                            }
                                                            else
                                                            {
                                                                if (oi.stock_num <= 0)
                                                                {
                                                                    _msg = "(库存不足)";
                                                                }
                                                            }
                                                        }
                                                %>
                                                <tr>
                                                    <td align="center"><%= oi.product_code %></td>
                                                    <td><a href="<%= config.UrlHome + oi.product_id+".html" %>" target="_blank">
                                                        <%= title %></a><%=_msg %>
                                                        <div>规格：<%= oi.product_spec + (string.IsNullOrEmpty(oi.sku_name) ? "" : "" + " / " + oi.sku_name) %></div>
                                                    </td>
                                                    <td align="center"><%= oi.sale_price > oi.deal_price ? "<del>" + oi.sale_price + "</del><br />" : "" %><span class="pp"><%= oi.deal_price %></span></td>
                                                    <td align="center"><%= oi.sale_num %></td>
                                                    <td class="ttd"><span class="off"><%= oi.sale_num * oi.deal_price %></span></td>
                                                </tr>
                                                <%    
                                                    }
                                                %>
                                            </tbody>
                                        </table>

                                    </td>
                                </tr>                               
                            </tbody>
                        </table>

                        <br />
                        <%
                            }
                        %>
                    </form>
                </div>
        </div>

    </div>
    <br />
    <br />
    <br />
    <br />
    <br />
    <%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
