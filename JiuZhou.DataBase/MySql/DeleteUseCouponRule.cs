using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteUseCouponRule
    {
        public static Response<ResponseBodyEmpty> Do(string ruleids)
       {
           RequestDeleteUseCouponRuleBody body = new RequestDeleteUseCouponRuleBody();

           body.uc_rule_ids = ruleids.Split(',');

           Request<RequestDeleteUseCouponRuleBody> request = new Request<RequestDeleteUseCouponRuleBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteUseCouponRule";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteUseCouponRuleBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteUseCouponRuleBody
    {
        [DataMember]
        public string[] uc_rule_ids { set; get; }
    }
}
