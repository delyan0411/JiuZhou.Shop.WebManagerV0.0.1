using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpBrust
    {
       public static Response<ResponseBodyEmpty> Do(string product_id, string brust_intro)
       {
            RequestOpBrust reqOpbrust = new RequestOpBrust();
            reqOpbrust.product_id = product_id;
            reqOpbrust.brust_intro = brust_intro;
           Request<RequestOpBrust> request = new Request<RequestOpBrust>();
           request.Body = reqOpbrust;
           request.Header = request.NewHeader();
           request.Key = "OpBrust";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpBrust>>(request);
            Logger.Log(requestStr);
           string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpBrust
    {
       [DataMember]
       public string product_id { set; get; }

       [DataMember]
       public string brust_intro { set; get; }
   }
}
