using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class UpdateOrderProductCode
    {
        public static Response<ResponseBodyEmpty> Do(string orderid, string productid, string productcode)
       {
           RequestResetProductCode body = new RequestResetProductCode();
           body.order_id = orderid;
           body.product_id = productid;
           body.product_code = productcode;

           Request<RequestResetProductCode> request = new Request<RequestResetProductCode>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "UpdateOrderProductCode";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestResetProductCode>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
    public class RequestResetProductCode
   {
       [DataMember]
       public string order_id { set; get; }

       [DataMember]
       public string product_id { set; get; }

       [DataMember]
       public string product_code { set; get; }
   }
}
