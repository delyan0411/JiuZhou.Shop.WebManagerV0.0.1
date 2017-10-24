using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyConvertIntergralRuleState
    {
       public static Response<ResponseBodyEmpty> Do(int ruleid, int status)
       {
           RequestModifyConvertIntergralRuleBody body = new RequestModifyConvertIntergralRuleBody();
           body.ci_rule_id = ruleid.ToString(); ;
           body.rule_state = status.ToString();


           Request<RequestModifyConvertIntergralRuleBody> request = new Request<RequestModifyConvertIntergralRuleBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyConvertIntergralRuleState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModifyConvertIntergralRuleBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
    public class RequestModifyConvertIntergralRuleBody
   {
       [DataMember]
       public string ci_rule_id { set; get; }

       [DataMember]
       public string rule_state { set; get; }
   } 
}
