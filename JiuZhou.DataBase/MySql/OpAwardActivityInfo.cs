using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpAwardActivityInfo 
    {
        public static Response<ResponseBodyEmpty> Do(AwardActivityInfo info, string delids)
        {
            OAwardActivityInfo body = new OAwardActivityInfo();

            body.award_activity_id = info.award_activity_id.ToString();
            body.activity_name = info.activity_name;
            body.activity_desc = info.activity_desc;
            body.award_desc = info.award_desc;
            body.begin_time = info.begin_time;
            body.end_time = info.end_time;
            body.activity_bg_img = info.activity_bg_img;
            body.award_bg_img = info.award_bg_img;
            body.dial_bg_img = info.dial_bg_img;

            List<OpAwardRuleInfo> rules = new List<OpAwardRuleInfo>();
            foreach (AwardRuleInfo em in info.rule_list) {
                OpAwardRuleInfo rule = new OpAwardRuleInfo();
                rule.award_rule_id = em.award_rule_id.ToString();
                rule.rule_type = em.rule_type.ToString();
                rule.corr_value = em.corr_value.ToString();
                rule.lottery_num = em.lottery_num.ToString();
                rule.begin_time = em.begin_time;
                rule.end_time = em.end_time;
                rules.Add(rule);
            }
            body.rule_list = rules;

            List<OpAwardInfo> awards = new List<OpAwardInfo>();
            foreach (AwardInfo em in info.award_list) {
                OpAwardInfo award = new OpAwardInfo();
                award.award_id = em.award_id.ToString();
                award.award_type = em.award_type.ToString();
                award.award_name = em.award_name;
                award.award_value = em.award_value.ToString();
                award.award_percent = em.award_percent.ToString();
                award.award_num = em.award_num.ToString();
               // award.give_num = em.give_num.ToString();
                award.award_state = em.award_state.ToString();
                award.sort_no = em.sort_no.ToString();

                awards.Add(award);
            }

            body.award_list = awards;

            body.del_rule_ids = delids.Split(',');

            Request<OAwardActivityInfo> request = new Request<OAwardActivityInfo>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "OpAwardActivityInfo";
            string requestStr = JsonHelper.ObjectToJson<Request<OAwardActivityInfo>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);

            return response;
        }
    }

    [DataContract]
    public class OAwardActivityInfo
    {
        [DataMember]
        public string award_activity_id { set; get; }

        [DataMember]
        public string activity_name { set; get; }

        [DataMember]
        public string activity_desc { set; get; }

        [DataMember]
        public string award_desc { set; get; }

        [DataMember]
        public string begin_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string award_bg_img { set; get; }

        [DataMember]
        public string activity_bg_img { set; get; }

        [DataMember]
        public string dial_bg_img { set; get; }

        [DataMember]
        public List<OpAwardRuleInfo> rule_list { set; get; }

        [DataMember]
        public List<OpAwardInfo> award_list { set; get; }

        [DataMember]
        public string[] del_rule_ids { set; get; }
    }

    [DataContract]
    public class OpAwardRuleInfo
    {
        [DataMember]
        public string award_rule_id { set; get; }

        [DataMember]
        public string rule_type { set; get; }

        [DataMember]
        public string corr_value { set; get; }

        [DataMember]
        public string lottery_num { set; get; }

        [DataMember]
        public string begin_time { set; get; }

        [DataMember]
        public string end_time { set; get; }
    }

    [DataContract]
    public class OpAwardInfo
    {
        [DataMember]
        public string award_id { set; get; }

        [DataMember]
        public string award_name { set; get; }

        [DataMember]
        public string award_type { set; get; }

        [DataMember]
        public string award_value { set; get; }

        [DataMember]
        public string award_percent { set; get; }

        [DataMember]
        public string award_num { set; get; }

        [DataMember]
        public string award_state { set; get; }

        [DataMember]
        public string sort_no { set; get; }
    }
}
