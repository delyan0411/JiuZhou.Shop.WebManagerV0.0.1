using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteFareTemplate
    {
        public static Response<ResponseBodyEmpty> Do(int tempid)
       {
           RequestDeleteFareTemplateBody body = new RequestDeleteFareTemplateBody();

           body.template_id = tempid.ToString();

           Request<RequestDeleteFareTemplateBody> request = new Request<RequestDeleteFareTemplateBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteFareTemplate";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteFareTemplateBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteFareTemplateBody
    {
        [DataMember]
        public string template_id { set; get; }
    }
}
