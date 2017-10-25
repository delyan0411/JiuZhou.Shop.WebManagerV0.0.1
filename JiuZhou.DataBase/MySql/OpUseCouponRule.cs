using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpUseCouponRule
    {
        public static Response<ResponseBodyEmpty> Do(UseCouponRuleDetail info)
        {
            OpUseCouponRuleInfo body = new OpUseCouponRuleInfo();

            body.uc_rule_id = info.uc_rule_id.ToString();
            body.min_price = info.min_price.ToString();
            body.coupon_price = info.coupon_price.ToString();
            body.rule_state = info.rule_state.ToString();

            Request<OpUseCouponRuleInfo> request = new Request<OpUseCouponRuleInfo>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "OpUseCouponRule";
            string requestStr = JsonHelper.ObjectToJson<Request<OpUseCouponRuleInfo>>(request);
            ;
            string responseStr = HttpUtils.HttpPost(requestStr);
            ;
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);

            return response;
        }
    }

    [DataContract]
    public class OpUseCouponRuleInfo
    {
        [DataMember]
        public string uc_rule_id { set; get; }

        [DataMember]
        public string min_price { set; get; }

        [DataMember]
        public string coupon_price { set; get; }

        [DataMember]
        public string rule_state { set; get; }
    }
}
