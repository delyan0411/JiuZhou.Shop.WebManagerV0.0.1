using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetSeoRuleList
    {
        public static Response<SeoRuleList> Do(int ruleid)
       {
           RequestSeoRuleBody seoBody = new RequestSeoRuleBody();

           seoBody.seo_rule_id = ruleid.ToString();
           Request<RequestSeoRuleBody> request = new Request<RequestSeoRuleBody>();
           request.Body = seoBody;
           request.Header = request.NewHeader();
           request.Key = "GetSeoRuleList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSeoRuleBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<SeoRuleList>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestSeoRuleBody
    {
        [DataMember]
        public string seo_rule_id { set; get; }
    }

    [DataContract]
    public class SeoRuleList
    {
        [DataMember]
        public string rec_num {set; get;}

        [DataMember]
        public List<SeoRuleInfo> seo_rule_list { set; get; }
    }
   [DataContract]
    public class SeoRuleInfo
   {
       [DataMember]
       public int rule_id { set; get; }

       [DataMember]
       public string rule_name { set; get; }

       [DataMember]
       public string rule_element { set; get; }

       [DataMember]
       public int priority_level { set; get; }

       [DataMember]
       public string title { set; get; }

       [DataMember]
       public string keywords { set; get; }

       [DataMember]
       public string description { set; get; }

       [DataMember]
       public string add_time { set; get; }

       [DataMember]
       public string add_user { set; get; }

       [DataMember]
       public string update_time { set; get; }
   } 
}
