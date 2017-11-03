using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetCouponGetRuleDetail
    {
        public static Response<CouponGetRuleInfo> Do(int id)
       {
           RequestCouponGetRuleBody body = new RequestCouponGetRuleBody();

           body.cget_rule_id = id.ToString();

           Request<RequestCouponGetRuleBody> request = new Request<RequestCouponGetRuleBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetCouponGetRuleDetail";          
            string requestStr = JsonHelper.ObjectToJson<Request<RequestCouponGetRuleBody>>(request);   
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<CouponGetRuleInfo>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestCouponGetRuleBody {
        [DataMember]
        public string cget_rule_id { set; get; }
    }
}
