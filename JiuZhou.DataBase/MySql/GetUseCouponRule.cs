using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetUseCouponRule
    {
        public static Response<ResponseQueryUseCouponRule> Do()
        {
            RequestBodyEmpty search = new RequestBodyEmpty();

            Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
            request.Body = search;
            request.Header = request.NewHeader();
            request.Key = "GetUseCouponRule";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseQueryUseCouponRule>>(responseStr);

            return response;
        }
    }

    [DataContract]
    public class ResponseQueryUseCouponRule
    {
        [DataMember]
        public List<UseCouponRuleInfo> coupon_rule_list { set; get; }
    }

    [DataContract]
    public class UseCouponRuleInfo
    {
        [DataMember]
        public int uc_rule_id { set; get; }

        [DataMember]
        public decimal min_price { set; get; }

        [DataMember]
        public decimal coupon_price { set; get; }

        [DataMember]
        public int rule_state { set; get; }

        [DataMember]
        public string add_time { set; get; }
    }
}
