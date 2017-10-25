using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetOrderMoney
    {
        public static Response<OrderMoney> Do(string orderno)
       {
           RequestOrderMoneyBody search = new RequestOrderMoneyBody();

           search.order_no = orderno;

           Request<RequestOrderMoneyBody> request = new Request<RequestOrderMoneyBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "GetOrderMoney";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOrderMoneyBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<OrderMoney>>(responseStr);

           return response;
       }
    }

    [DataContract]
    public class RequestOrderMoneyBody
    {
        [DataMember]
        public string order_no { set; get; }
    }

    [DataContract]
    public class OrderMoney {
        [DataMember]
        public decimal order_money { set; get; }

        [DataMember]
        public decimal trans_money { set; get; }

        [DataMember]
        public decimal integral_money { set; get; }

        [DataMember]
        public decimal fulloff_money { set; get; }

        [DataMember]
        public decimal coupon_money { set; get; }

        [DataMember]
        public decimal refund_money { set; get; }
    }
}
