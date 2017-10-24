using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteProductJoins
    {
        public static Response<ResponseBodyEmpty> Do(string productjoinIds)
       {
           RequestDeleteJoinBody joinBody = new RequestDeleteJoinBody();

           joinBody.product_join_ids = productjoinIds;

           Request<RequestDeleteJoinBody> request = new Request<RequestDeleteJoinBody>();
           request.Body = joinBody;
           request.Header = request.NewHeader();
           request.Key = "DeleteProductJoins";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteJoinBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteJoinBody
    {
        [DataMember]
        public string product_join_ids { set; get; }
    }
}
