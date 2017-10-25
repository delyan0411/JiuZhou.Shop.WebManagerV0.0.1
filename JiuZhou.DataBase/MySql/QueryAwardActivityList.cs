using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryAwardActivityList
    {
        public static Response<ResponseQueryAwardActivityBody> Do(int pagesize, int pageindex, string _skey, ref int dataCount, ref int pageCount)
       {
           RequestQueryAwardActivityBody search = new RequestQueryAwardActivityBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.search_key = _skey;

           Request<RequestQueryAwardActivityBody> request = new Request<RequestQueryAwardActivityBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryAwardActivityList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryAwardActivityBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseQueryAwardActivityBody>>(responseStr);

           if (response != null && response.Body != null && response.Body.activity_list != null)
           {
               dataCount = int.Parse(response.Body.rec_num);
               if (dataCount % pagesize == 0)
               {
                   pageCount = dataCount / pagesize;
               }
               else
               {
                   pageCount = dataCount / pagesize + 1;
               }
           }
           return response;
       }
    }

    [DataContract]
    public class RequestQueryAwardActivityBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string search_key { set; get; }
    }

    [DataContract]
    public class ResponseQueryAwardActivityBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<AwardActivityInfo> activity_list { set; get; }
    }

    [DataContract]
    public class AwardActivityInfo
    {
        [DataMember]
        public int award_activity_id { set; get; }  

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
        public int modify_user_id { set; get; }

        [DataMember]
        public string modify_time { set; get; }

        [DataMember]
        public string award_bg_img { set; get; }

        [DataMember]
        public string activity_bg_img { set; get; }

        [DataMember]
        public string dial_bg_img { set; get; }

        [DataMember]
        public List<AwardRuleInfo> rule_list { set; get; }

        [DataMember]
        public List<AwardInfo> award_list { set; get; }
    }

    [DataContract]
    public class AwardRuleInfo
    {
        [DataMember]
        public int award_rule_id { set; get; }

        [DataMember]
        public int award_activity_id { set; get; }

        [DataMember]
        public int rule_type { set; get; }

        [DataMember]
        public decimal corr_value { set; get; }

        [DataMember]
        public int lottery_num { set; get; }

        [DataMember]
        public string begin_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string add_time { set; get; }
    }

    [DataContract]
    public class AwardInfo 
    {
        [DataMember]
        public int award_id { set; get; }

        [DataMember]
        public int award_activity_id { set; get; }

        [DataMember]
        public string award_name { set; get; }

        [DataMember]
        public int award_type { set; get; }

        [DataMember]
        public decimal award_value { set; get; }

        [DataMember]
        public decimal award_percent { set; get; }

        [DataMember]
        public int award_num { set; get; }

        [DataMember]
        public int give_num { set; get; }

        /*
        [DataMember]
        public string begin_time { set; get; }

        [DataMember]
        public string end_time { set; get; }
         * 
         * */
        [DataMember]
        public int award_state { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public int sort_no { set; get; }
    }
}
