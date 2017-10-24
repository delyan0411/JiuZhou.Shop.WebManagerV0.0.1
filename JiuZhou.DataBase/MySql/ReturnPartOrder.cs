using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class ReturnPartOrder
    {
        public static Response<ResponseBodyEmpty> Do(string orderno, int servicestate, string productids, string remark)
       {
           RequestReturnPartOrder body = new RequestReturnPartOrder();

           body.order_no = orderno;
           body.service_state = servicestate.ToString();
          // body.refund_money = money;
           body.inner_remark = remark;
           body.product_ids = productids.Split(',');

           Request<RequestReturnPartOrder> request = new Request<RequestReturnPartOrder>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ReturnPartOrder";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestReturnPartOrder>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestReturnPartOrder
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
