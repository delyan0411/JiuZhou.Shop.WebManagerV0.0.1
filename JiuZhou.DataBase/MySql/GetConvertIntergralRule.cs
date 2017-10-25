using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetConvertIntergralRule
    {
        public static Response<ResponseQueryConvertIntergralRule> Do()
        {
            RequestBodyEmpty search = new RequestBodyEmpty();

            Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
            request.Body = search;
            request.Header = request.NewHeader();
            request.Key = "GetConvertIntergralRule";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseQueryConvertIntergralRule>>(responseStr);

            return response;
        }
    }

    [DataContract]
    public class ResponseQueryConvertIntergralRule
    {
        [DataMember]
        public List<ConvertIntergralRuleInfo> intergral_rule_list { set; get; }
    }

    [DataContract]
    public class ConvertIntergralRuleInfo
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

        [DataMember]
        public string add_time { set; get; }
    }
}
