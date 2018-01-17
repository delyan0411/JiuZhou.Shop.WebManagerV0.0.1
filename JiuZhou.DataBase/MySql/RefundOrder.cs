using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class RefundOrder
    {
        public static Response<ResponseBodyEmpty> Do(string orderno, int servicestate, int returnintergral, int returncoupon, string remark)
        {
            RequestRefundOrder body = new RequestRefundOrder();

            body.order_no = orderno;
            body.service_state = servicestate.ToString();
            // body.refund_money = money;
            body.inner_remark = remark;
            body.return_coupon = returncoupon.ToString();
            body.return_integral = returnintergral.ToString();

            Request<RequestRefundOrder> request = new Request<RequestRefundOrder>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "RefundOrder";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestRefundOrder>>(request);
            //Logger.Log(requestStr);
            //string responseStr = null;
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestRefundOrder
    {
        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public string service_state { set; get; }

        [DataMember]
        public string inner_remark { set; get; }

    //    [DataMember]
     //   public string refund_money { set; get; }

        [DataMember]
        public string return_coupon { set; get; }

        [DataMember]
        public string return_integral { set; get; }
    } 
}
