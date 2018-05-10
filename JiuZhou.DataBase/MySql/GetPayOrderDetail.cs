using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetPayOrderDetail
    {
        // public static Response<PayOrderInfo> Do(string orderno)
        //{
        //    RequestOrderInfoBody search = new RequestOrderInfoBody();

        //    search.order_no = orderno;

        //    Request<RequestOrderInfoBody> request = new Request<RequestOrderInfoBody>();
        //    request.Body = search;
        //    request.Header = request.NewHeader();
        //    request.Key = "GetOrderInfo";
        //    string requestStr = JsonHelper.ObjectToJson<Request<RequestOrderInfoBody>>(request);
        //    string responseStr = HttpUtils.HttpPost(requestStr);
        //    var response = JsonHelper.JsonToObject<Response<OrderDetail>>(responseStr);

        //    return response;
        //}
        public static Response<PayOrderInfo> Do(string orderNo, string flag = "0")
        {
            Request<RequestOrderOne> request = new Request<RequestOrderOne>();
            request.Body = new RequestOrderOne() { order_no = orderNo, flag = flag };
            request.Header = request.NewHeader();
            request.Key = "GetPayOrderDetailBg";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestOrderOne>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<PayOrderInfo>>(responseStr);
            return response;
            //{ key = "GetPayOrderDetail", header = Cookies.Header, body = new RequestOrderOne() { order_no = orderNo, flag = flag } };
        }
    }
    [Serializable]
    [DataContract]
    public class RequestOrderOne
    {
        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public string flag { set; get; }

        [DataMember(EmitDefaultValue = false, IsRequired = false)]
        public string cancel_reason { set; get; }
    }
    /// <summary>
    /// 已支付的订单详情类
    /// </summary>
    [Serializable]
    [DataContract]
    public class PayOrderInfo
    {
        /// <summary>
        /// 付款订单ID
        /// </summary>
        [DataMember]
        public long order_pay_id { set; get; }

        /// <summary>
        /// 订单编号
        /// </summary>
        [DataMember]
        public string order_no { set; get; }

        /// <summary>
        /// 订单类型，1-Web，2-wap，3-IOS，4-android
        /// </summary>
        [DataMember]
        public int order_type { set; get; }

        /// <summary>
        /// 支付类型
        /// </summary>
        [DataMember]
        public int pay_type { set; get; }

        /// <summary>
        /// 支付时间
        /// </summary>
        [DataMember]
        public string pay_time { set; get; }

        /// <summary>
        /// 总订单状态，0-未付款，1-部分付款，2-待发货，3-待收货，4-待评价，10-订单关闭（订单取消，过期，退订完毕，退货完毕）
        /// 11-订单成功，12-订单退订中，13-订单退货中，14-售后处理中
        /// </summary>
        [DataMember]
        public int total_state { set; get; }

        /// <summary>
        /// 订单状态，0-取消，1-新订单，2-已确认，3-订单成功，4-客户退订，5-客户退货
        /// </summary>
        [DataMember]
        public int order_state { set; get; }

        /// <summary>
        /// 支付状态,0=未付款;1=部分付款；2=全部付款
        /// </summary>
        [DataMember]
        public int pay_state { set; get; }

        /// <summary>
        /// 服务状态,0-无，1-处理中，2-处理完成
        /// </summary>
        [DataMember]
        public int service_state { set; get; }

        /// <summary>
        /// 总金额
        /// </summary>
        [DataMember]
        public decimal total_money { set; get; }

        /// <summary>
        /// 运费
        /// </summary>
        [DataMember]
        public decimal trans_money { set; get; }

        /// <summary>
        /// 付款金额
        /// </summary>
        [DataMember]
        public decimal order_money { set; get; }

        /// <summary>
        /// 使用积分数
        /// </summary>
        [DataMember]
        public int use_integral { set; get; }

        /// <summary>
        /// 积分抵换金额
        /// </summary>
        [DataMember]
        public decimal integral_money { set; get; }

        /// <summary>
        /// 优惠券金额
        /// </summary>
        [DataMember]
        public decimal coupon_money { set; get; }

        /// <summary>
        /// 满减金额
        /// </summary>
        [DataMember]
        public decimal fulloff_money { set; get; }

        /// <summary>
        /// 医卡通可支付金额
        /// </summary>
        [DataMember]
        public decimal eb_money { set; get; }

        /// <summary>
        /// 医卡通已付金额
        /// </summary>
        [DataMember]
        public decimal eb_pay_money { set; get; }

        /// <summary>
        /// 过期时间
        /// </summary>
        [DataMember]
        public string expired_time { set; get; }

        /// <summary>
        /// 贵宾卡号
        /// </summary>
        [DataMember]
        public string vip_no { set; get; }

        /// <summary>
        /// 子订单集合
        /// </summary>
        [DataMember]
        public List<OrderInfo2> order_list { set; get; }

        /// <summary>
        /// 订单添加时间
        /// </summary>
        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public int user_id { get; set; }

        [DataMember]
        public string invoice_title { get; set; }

    }

    [Serializable]
    [DataContract]
    public class OrderInfo2
    {

        /// <summary>
        /// 订单ID
        /// </summary>
        [DataMember]
        public int order_id { set; get; }

        /// <summary>
        /// 订单号
        /// </summary>
        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public int pay_type { set; get; }

        [DataMember]
        public string pay_time { set; get; }

        /// <summary>
        /// 订单类型，1-Web，2-wap，3-IOS，4-android
        /// </summary>
        [DataMember]
        public int order_type { set; get; }

        /// <summary>
        /// 订单状态，0-取消，1-新订单，2-已确认，3-订单成功，4-客户退订，5-客户退货,9-订单过期
        /// </summary>
        [DataMember]
        public int order_state { set; get; }

        /// <summary>
        /// 支付状态,0=未付款;1=部分付款；2=全部付款
        /// </summary>
        [DataMember]
        public int pay_state { set; get; }

        /// <summary>
        /// 订单总状态,0-未付款1-部分付款，2-待发货，3-待收货，4-待评价,10-订单关闭（订单取消，过期，退订完毕，退货完毕 ）
        /// 11-订单成功，12-订单退订中，13-订单退货中14-售后处理中
        /// </summary>
        [DataMember]
        public int total_state { set; get; }

        /// <summary>
        /// 过期时间
        /// </summary>
        [DataMember]
        public string expired_time { set; get; }

        /// <summary>
        /// 发货状态，0-待卖家发货，1-待买家收货,2-已收货
        /// </summary>
        [DataMember]
        public int delivery_state { set; get; }

        /// <summary>
        /// 快递方式
        /// </summary>
        [DataMember]
        public string delivery_type { get; set; }

        [DataMember]
        public string express_company { set; get; }

        [DataMember]
        public string express_number { set; get; }

        /// <summary>
        /// 发货日期
        /// </summary>
        [DataMember]
        public string trans_time { set; get; }

        /// <summary>
        /// 收货日期
        /// </summary>
        [DataMember]
        public string receive_time { set; get; }

        /// <summary>
        /// 收件人
        /// </summary>
        [DataMember]
        public string receive_name { set; get; }

        [DataMember]
        public string province_name { set; get; }

        [DataMember]
        public string city_name { set; get; }

        [DataMember]
        public string county_name { set; get; }

        /// <summary>
        /// 收件地址
        /// </summary>
        [DataMember]
        public string receive_addr { set; get; }

        /// <summary>
        /// 收件人电话
        /// </summary>
        [DataMember]
        public string receive_user_tel { set; get; }

        /// <summary>
        /// 收件人手机号
        /// </summary>
        [DataMember]
        public string receive_mobile_no { set; get; }

        /// <summary>
        /// 发票抬头
        /// </summary>
        [DataMember]
        public string voice_title { set; get; }

        /// <summary>
        /// 用户备注
        /// </summary>
        [DataMember]
        public string guest_remark { set; get; }

        /// <summary>
        /// 评价状态
        /// </summary>
        [DataMember]
        public int comment_state { set; get; }

        /// <summary>
        /// 评价时间
        /// </summary>
        [DataMember]
        public string comment_time { set; get; }

        /// <summary>
        /// 订单金额
        /// </summary>
        [DataMember]
        public decimal total_money { set; get; }

        [DataMember]
        public decimal trans_money { set; get; }

        [DataMember]
        public decimal order_money { set; get; }

        [DataMember]
        public decimal integral_money { set; get; }

        [DataMember]
        public decimal coupon_money { set; get; }

        [DataMember]
        public decimal fulloff_money { set; get; }


        /// <summary>
        /// 商家ID
        /// </summary>
        [DataMember]
        public int shop_id { set; get; }

        /// <summary>
        /// 商家名称
        /// </summary>
        [DataMember]
        public string shop_addr { set; get; }

        /// <summary>
        ///  
        /// </summary>
        [DataMember]
        public List<OrderItem> order_item_list { set; get; }

    }

    [Serializable]
    [DataContract]
    public class OrderItem
    {
        [DataMember]
        public int product_id { set; get; }

        /// <summary>
        /// 商品编码
        /// </summary>
        [DataMember]
        public string product_code { set; get; }

        [DataMember]
        public string product_name { set; get; }

        [DataMember]
        public int sku_id { set; get; }

        [DataMember]
        public string sku_name { set; get; }

        [DataMember]
        public decimal sale_price { set; get; }

        /// <summary>
        /// 成交价
        /// </summary>
        [DataMember]
        public decimal deal_price { set; get; }

        /// <summary>
        /// 购买数
        /// </summary>
        [DataMember]
        public int sale_num { set; get; }

        /// <summary>
        /// 商品规格
        /// </summary>
        [DataMember]
        public string product_spec { set; get; }

        /// <summary>
        /// 生产厂家
        /// </summary>
        [DataMember]
        public string manu_facturer { set; get; }

        /// <summary>
        /// 商品主图
        /// </summary>
        [DataMember]
        public string img_src { set; get; }

        /// <summary>
        /// 是否允许医卡通
        /// </summary>
        [DataMember]
        public int allow_ebaolife { set; get; }

        [DataMember]
        public int order_item_id { set; get; }

        /// <summary>
        /// 是否上架
        /// </summary>
        [DataMember]
        public int is_on_sale { set; get; }

        /// <summary>
        /// 是否删除
        /// </summary>
        [DataMember]
        public int is_visible { set; get; }

        /// <summary>
        /// 库存
        /// </summary>
        [DataMember]
        public int stock_num { set; get; }

    }

}
