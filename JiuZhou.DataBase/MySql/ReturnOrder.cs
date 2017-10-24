using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class ReturnOrder
    {
        public static Response<ResponseBodyEmpty> Do(string orderno, int servicestate, string remark, int coupon, int integral)
       {
           RequestReturnOrder body = new RequestReturnOrder();

           body.order_no = orderno;
           body.service_state = servicestate.ToString();
           body.inner_remark = remark;
           body.return_coupon = coupon.ToString();
           body.return_integral = integral.ToString();
          //body.refund_money = money;

           Request<RequestReturnOrder> request = new Request<RequestReturnOrder>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ReturnOrder";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestReturnOrder>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestReturnOrder
    {
        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public string service_state { set; get; }

        [DataMember]
        public string inner_remark { set; get; }

        [DataMember]
        public string return_coupon { set; get; }

        [DataMember]
        public string return_integral { set; get; }

    //    [DataMember]
     //   public string refund_money { set; get; }
    } 
}
