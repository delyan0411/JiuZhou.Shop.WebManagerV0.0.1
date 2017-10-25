using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryConvertIntergralRuleDetail
    {
        public static Response<ConvertIntergralRuleDetail> Do(int ruleid)
        {
            RequestConvertIntergralRuleDetail body = new RequestConvertIntergralRuleDetail();
            body.ci_rule_id = ruleid.ToString();

            Request<RequestConvertIntergralRuleDetail> request = new Request<RequestConvertIntergralRuleDetail>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "QueryConvertIntergralRuleDetail";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestConvertIntergralRuleDetail>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ConvertIntergralRuleDetail>>(responseStr);

            return response;
        }
    }

    [DataContract]
    public class RequestConvertIntergralRuleDetail
    {
        [DataMember]
        public string ci_rule_id { set; get; }
    }

    [DataContract]
    public class ConvertIntergralRuleDetail
    {
        [DataMember]
        public int ci_rule_id { set; get; }

        [DataMember]
        public int coupon_type { set; get; }

        [DataMember]
        public int integral_count { set; get; }

        [DataMember]
        public decimal coupon_price { set; get; }

        [DataMember]
        public int rule_state { set; get; }

        [DataMember]
        public int valid_days { set; get; }

        [DataMember]
        public string begin_time { set; get; }

        [DataMember]
        public string end_time { set; get; }
    }
}
