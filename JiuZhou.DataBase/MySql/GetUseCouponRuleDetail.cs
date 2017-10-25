using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetUseCouponRuleDetail
    {
        public static Response<UseCouponRuleDetail> Do(int ruleid)
        {
            RequestUseCouponRuleDetail body = new RequestUseCouponRuleDetail();
            body.uc_rule_id = ruleid.ToString();

            Request<RequestUseCouponRuleDetail> request = new Request<RequestUseCouponRuleDetail>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "GetUseCouponRuleDetail";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestUseCouponRuleDetail>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<UseCouponRuleDetail>>(responseStr);

            return response;
        }
    }

    [DataContract]
    public class RequestUseCouponRuleDetail
    {
        [DataMember]
        public string uc_rule_id { set; get; }
    }

    [DataContract]
    public class UseCouponRuleDetail
    {
        [DataMember]
        public int uc_rule_id { set; get; }

        [DataMember]
        public decimal min_price { set; get; }

        [DataMember]
        public decimal coupon_price { set; get; }

        [DataMember]
        public int rule_state { set; get; }
    }
}
