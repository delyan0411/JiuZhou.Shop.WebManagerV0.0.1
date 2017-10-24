using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpConvertIntergralRule
    {
        public static Response<ResponseBodyEmpty> Do(ConvertIntergralRuleDetail info)
       {
           OpConvertIntergralRuleInfo body = new OpConvertIntergralRuleInfo();

           body.ci_rule_id = info.ci_rule_id.ToString();
           body.coupon_type = info.coupon_type.ToString();
           body.integral_count = info.integral_count.ToString();
           body.coupon_price = info.coupon_price.ToString();
           body.rule_state = info.rule_state.ToString();
           body.valid_days = info.valid_days.ToString();
           body.begin_time = info.begin_time;
           body.end_time = info.end_time;

           Request<OpConvertIntergralRuleInfo> request = new Request<OpConvertIntergralRuleInfo>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpConvertIntergralRule";
           string requestStr = JsonHelper.ObjectToJson<Request<OpConvertIntergralRuleInfo>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class OpConvertIntergralRuleInfo
    {
        [DataMember]
        public string ci_rule_id { set; get; }

        [DataMember]
        public string coupon_type { set; get; }

        [DataMember]
        public string integral_count { set; get; }

        [DataMember]
        public string coupon_price { set; get; }

        [DataMember]
        public string rule_state { set; get; }

        [DataMember]
        public string valid_days { set; get; }

        [DataMember]
        public string begin_time { set; get; }

        [DataMember]
        public string end_time { set; get; }
    }
}
