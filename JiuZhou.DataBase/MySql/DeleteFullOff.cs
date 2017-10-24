using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteFullOff
    {
        public static Response<ResponseBodyEmpty> Do(string ids)
       {
           RequestDeleteFullOffBody body = new RequestDeleteFullOffBody();

           body.fulloff_ids = ids.Split(',');

           Request<RequestDeleteFullOffBody> request = new Request<RequestDeleteFullOffBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteFullOff";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteFullOffBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteFullOffBody
    {
        [DataMember]
        public string[] fulloff_ids { set; get; }
    }
}
