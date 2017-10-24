using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteSeoRule
    {
        public static Response<ResponseBodyEmpty> Do(int ruleid)
       {
           RequestDeleteSeoRuleBody body = new RequestDeleteSeoRuleBody();

           body.seorule_id = ruleid.ToString();

           Request<RequestDeleteSeoRuleBody> request = new Request<RequestDeleteSeoRuleBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteSeoRule";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteSeoRuleBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteSeoRuleBody
    {
        [DataMember]
        public string seorule_id { set; get; }
    }
}
