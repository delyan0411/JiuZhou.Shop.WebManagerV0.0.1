using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteAccess
    {
        public static Response<ResponseBodyEmpty> Do(int id)
       {
           RequestDeleteAccessBody body = new RequestDeleteAccessBody();

           body.access_id = id.ToString();

           Request<RequestDeleteAccessBody> request = new Request<RequestDeleteAccessBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteAccess";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteAccessBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteAccessBody
    {
        [DataMember]
        public string access_id { set; get; }
    }
}
