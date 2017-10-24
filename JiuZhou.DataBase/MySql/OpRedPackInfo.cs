using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpRedPackInfo 
    {
        public static Response<ResponseBodyEmpty> Do(RedPackInfo info)
        {
            RequestRedPackInfo body = new RequestRedPackInfo();
            body.redpack_rule_id = info.redpack_rule_id.ToString();
            body.title = info.title;
            body.sum_money = info.sum_money.ToString();
            body.start_time = info.start_time;
            body.end_time = info.end_time;
            body.pack_money_max = info.pack_money_max.ToString();
            body.pack_money_min = info.pack_money_min.ToString();
            body.pack_numsum = info.pack_numsum.ToString();
            body.Redpack_distribution_id = info.Redpack_distribution_id.ToString();
            body.add_time = info.add_time;
            body.valid_time = info.valid_time;
            Request<RequestRedPackInfo> request = new Request<RequestRedPackInfo>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "OpRedPackInfo";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestRedPackInfo>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestRedPackInfo
    {
        [DataMember]
        public string redpack_rule_id { set; get; }

        [DataMember]
        public string title { set; get; }

        [DataMember]
        public string sum_money { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string pack_money_max { set; get; }

        [DataMember]
        public string pack_money_min { set; get; }

        [DataMember]
        public string pack_numsum { set; get; }

        [DataMember]
        public string Redpack_distribution_id { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public string valid_time { set; get; }

    }
}
