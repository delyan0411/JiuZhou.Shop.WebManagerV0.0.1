using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteBrust
    {
        public static Response<ResponseBodyEmpty> Do(string id)
       {
            RequestDeleteBrustBody body = new RequestDeleteBrustBody();

            body.product_id = id;

           Request<RequestDeleteBrustBody> request = new Request<RequestDeleteBrustBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteBrust";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteBrustBody>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteBrustBody
    {
        [DataMember]
        public string product_id { set; get; }
    }
}
