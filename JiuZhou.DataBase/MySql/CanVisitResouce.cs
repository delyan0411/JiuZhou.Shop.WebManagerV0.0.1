using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class CanVisitResouce
    {
        public static Response<ResponseBodyEmpty> Do(int resid)
       {
           RequestCanVisitResBody body = new RequestCanVisitResBody();

           body.res_id = resid.ToString();

           Request<RequestCanVisitResBody> request = new Request<RequestCanVisitResBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "CanVisitResouce";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestCanVisitResBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestCanVisitResBody
    {
        [DataMember]
        public string res_id { set; get; }
    }
}
