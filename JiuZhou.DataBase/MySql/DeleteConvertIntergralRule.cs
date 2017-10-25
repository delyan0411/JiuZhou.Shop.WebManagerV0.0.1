using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteConvertIntergralRule
    {
        public static Response<ResponseBodyEmpty> Do(string ruleids)
       {
           RequestDeleteConvertIntergralRuleBody body = new RequestDeleteConvertIntergralRuleBody();

           body.ci_rule_ids = ruleids.Split(',');

           Request<RequestDeleteConvertIntergralRuleBody> request = new Request<RequestDeleteConvertIntergralRuleBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteConvertIntergralRule";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteConvertIntergralRuleBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteConvertIntergralRuleBody
    {
        [DataMember]
        public string[] ci_rule_ids { set; get; }
    }
}
