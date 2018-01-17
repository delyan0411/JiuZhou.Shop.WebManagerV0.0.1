using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class RefundPartOrder
    {
        public static Response<ResponseBodyEmpty> Do(string orderno, int servicestate, string productids, string remark)
        {
            RequestRefundPartOrder body = new RequestRefundPartOrder();

            body.order_no = orderno;
            body.service_state = servicestate.ToString();
            // body.refund_money = money;
            body.inner_remark = remark;
            body.product_ids = productids.Split(',');

            Request<RequestRefundPartOrder> request = new Request<RequestRefundPartOrder>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "RefundPartOrder";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestRefundPartOrder>>(request);
            //Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            //string responseStr = null;
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestRefundPartOrder
    {
        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public string service_state { set; get; }

        [DataMember]
        public string inner_remark { set; get; }

        [DataMember]
        public string[] product_ids { set; get; }
    } 
}
