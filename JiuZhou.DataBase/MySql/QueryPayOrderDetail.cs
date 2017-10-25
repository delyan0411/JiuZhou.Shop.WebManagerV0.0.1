using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryPayOrderDetail
    {
        public static Response<PayOrderDetails> Do(string orderno)
       {
           RequestPayOrderInfoBody search = new RequestPayOrderInfoBody();

           search.order_no = orderno;

           Request<RequestPayOrderInfoBody> request = new Request<RequestPayOrderInfoBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryPayOrderDetail";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestPayOrderInfoBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<PayOrderDetails>>(responseStr);

           return response;
       }
    }

    [DataContract]
    public class RequestPayOrderInfoBody
    {
        [DataMember]
        public string order_no { set; get; }
    }

    [DataContract]
    public class PayOrderDetails {
        [DataMember]
        public int order_pay_id { set; get; }

        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public int pay_type { set; get; }

        [DataMember]
        public string pay_time { set; get; }

        [DataMember]
        public int order_state { set; get; }

        [DataMember]
        public int pay_state { set; get; }

        [DataMember]
        public decimal total_money { set; get; }

        [DataMember]
        public decimal order_money { set; get; }

        [DataMember]
        public decimal trans_money { set; get; }

        [DataMember]
        public int use_integral { set; get; }

        [DataMember]
        public decimal integral_money { set; get; }

        [DataMember]
        public decimal coupon_money { set; get; }

        [DataMember]
        public decimal fulloff_money { set; get; }

        [DataMember]
        public decimal eb_money { set; get; }

        [DataMember]
        public decimal eb_pay_money { set; get; }

        [DataMember]
        public string expired_time { set; get; }

        [DataMember]
        public int service_state { set; get; }

        [DataMember]
        public List<OrderDetailsList> order_list { set; get; }
    }

    [DataContract]
    public class OrderDetailsList {
        [DataMember]
        public int order_id { set; get; }

        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public int order_state { set; get; }

        [DataMember]
        public int delivery_state { set; get; }

        [DataMember]
        public string delivery_type { set; get; }

        [DataMember]
        public string trans_time { set; get; }

        [DataMember]
        public string receive_time { set; get; }

        [DataMember]
        public int comment_state { set; get; }

        [DataMember]
        public string comment_time { set; get; }

        [DataMember]
        public decimal total_money { set; get; }

        [DataMember]
        public int shop_id { set; get; }

        [DataMember]
        public string shop_addr { set; get; }

        [DataMember]
        public List<PayOrderItems> order_item_list { set; get; }
    }

    [DataContract]
    public class PayOrderItems {
        [DataMember]
        public int product_id { set; get; }

        [DataMember]
        public string product_code { set; get; }

        [DataMember]
        public string product_name { set; get; }

        [DataMember]
        public int sku_id { set; get; }

        [DataMember]
        public string sku_name { set; get; }

        [DataMember]
        public decimal deal_price { set; get; }

        [DataMember]
        public int sale_num { set; get; }

        [DataMember]
        public string product_spec { set; get; }

        [DataMember]
        public string manu_facturer { set; get; }

        [DataMember]
        public string img_src { set; get; }

        [DataMember]
        public int allow_ebaolife { set; get; }

        [DataMember]
        public int item_state { set; get; }
    }
}
