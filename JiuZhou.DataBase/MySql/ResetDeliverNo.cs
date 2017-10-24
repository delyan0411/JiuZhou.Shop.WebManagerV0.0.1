using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ResetDeliverNo
    {
        public static Response<ResponseBodyEmpty> Do(string oldorderno, string neworderno)
       {
           RequestResetOrderCode body = new RequestResetOrderCode();
           body.old_order_no = oldorderno;
           body.new_order_no = neworderno;

           Request<RequestResetOrderCode> request = new Request<RequestResetOrderCode>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ResetDeliverNo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestResetOrderCode>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
    public class RequestResetOrderCode
   {
       [DataMember]
       public string old_order_no { set; get; }

       [DataMember]
       public string new_order_no { set; get; }
   }
}
