using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetOrderDetail
    {
        public static Response<OrderDetail> Do(string orderno)
        {
            RequestOrderInfoBody search = new RequestOrderInfoBody();

            search.order_no = orderno;

            Request<RequestOrderInfoBody> request = new Request<RequestOrderInfoBody>();
            request.Body = search;
            request.Header = request.NewHeader();
            request.Key = "GetOrderInfo";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestOrderInfoBody>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<OrderDetail>>(responseStr);

            return response;
        }
    }

    [DataContract]
    public class RequestOrderInfoBody
    {
        [DataMember]
        public string order_no { set; get; }
    }

    [DataContract]
    public class OrderDetail {
        [DataMember]
        public OrderPayList order_pay_list { set; get; }

        [DataMember]
        public int order_id { set; get; }

        [DataMember]
        public int user_id { set; get; }

        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public int delivery_state { set; get; }

        [DataMember]
        public string delivery_type { set; get; }

        [DataMember]
        public decimal total_money { set; get; }

        [DataMember]
        public int order_state { set; get; }

        [DataMember]
        public string receive_mobile_no { set; get; }

        [DataMember]
        public string receive_user_tel { set; get; }

        [DataMember]
        public string receive_addr { set; get; }

        [DataMember]
        public string receive_name { set; get; }

        [DataMember]
        public int shop_id { set; get; }

        [DataMember]
        public string inner_remark { set; get; }

        [DataMember]
        public string express_company { set; get; }

        [DataMember]
        public string express_number { set; get; }

        [DataMember]
        public string guest_remark { set; get; }

        [DataMember]
        public int service_state { set; get; }

        [DataMember]
        public List<OrderItemsInfo> order_item_list { set; get; }
    }

    [DataContract]
    public class OrderPayList {

        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public int order_type { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public decimal total_money { set; get; }

        [DataMember]
        public decimal order_money { set; get; }

        [DataMember]
        public decimal trans_money { set; get; }

        [DataMember]
        public decimal fulloff_money { set; get; }

        [DataMember]
        public string pay_type_name { set; get; }

        [DataMember]
        public int pay_type { set; get; }

        [DataMember]
        public decimal eb_pay_money { set; get; }

        [DataMember]
        public int pay_state { set; get; }

        [DataMember]
        public string pay_time { set; get; }

        [DataMember]
        public int use_integral { set; get; }

        [DataMember]
        public decimal integral_money { set; get; }

        [DataMember]
        public string coupon_money { set; get; }

        [DataMember]
        public string invoice_title { set; get; }

        [DataMember]
        public string vip_no { set; get; }

        [DataMember]
        public int expired_minute { set; get; }

        [DataMember]
        public int ywlx { set; get; }

        [DataMember]
        public decimal taxes_money { set; get; }
    }
}
