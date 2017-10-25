using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyUseCouponRuleState
    {
       public static Response<ResponseBodyEmpty> Do(int ruleid, int status)
       {
           RequestModifyUseCouponRuleBody body = new RequestModifyUseCouponRuleBody();
           body.uc_rule_id = ruleid.ToString(); ;
           body.rule_state = status.ToString();


           Request<RequestModifyUseCouponRuleBody> request = new Request<RequestModifyUseCouponRuleBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyUseCouponRuleState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModifyUseCouponRuleBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
    public class RequestModifyUseCouponRuleBody
   {
       [DataMember]
       public string uc_rule_id { set; get; }

       [DataMember]
       public string rule_state { set; get; }
   } 
}
