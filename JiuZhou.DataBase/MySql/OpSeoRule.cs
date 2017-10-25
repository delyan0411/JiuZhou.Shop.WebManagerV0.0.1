using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpSeoRule
    {
       public static Response<ResponseBodyEmpty> Do(SeoRuleInfo sri , List<SeoRuleItemInfo> rule, string del_ruleids)
       {
           RequestOpSeoRuleBody seoBody = new RequestOpSeoRuleBody();
           seoBody.rule_id = sri.rule_id.ToString();
           seoBody.rule_name = sri.rule_name.ToString();
           seoBody.rule_element = sri.rule_element.ToString();
           seoBody.priority_level = sri.priority_level.ToString();
           seoBody.title = sri.title.ToString();
           seoBody.keywords = sri.keywords;
           seoBody.description = sri.description.ToString();
           seoBody.add_time = sri.add_time;
           seoBody.update_time = sri.update_time;
           seoBody.add_user = "";
           List<ReqSeoRuleItemInfo> rulelists = new List<ReqSeoRuleItemInfo>();
           foreach (SeoRuleItemInfo item in rule)
           {
               ReqSeoRuleItemInfo rulelist = new ReqSeoRuleItemInfo();
               rulelist.rule_item_id = item.rule_item_id.ToString();
               rulelist.elment_id = item.elment_id.ToString();
               rulelist.seo_elment_code = item.seo_elment_code.ToString();
               rulelist.add_time = item.add_time.ToString();
               rulelist.rule_id = item.rule_id.ToString();
               rulelist.add_user = "";
               rulelists.Add(rulelist);
           }
           seoBody.rule_list = rulelists;
           seoBody.del_rule_ids = del_ruleids;
           Request<RequestOpSeoRuleBody> request = new Request<RequestOpSeoRuleBody>();
           request.Body = seoBody;
           request.Header = request.NewHeader();
           request.Key = "OpSeoRule";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpSeoRuleBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);           
           return response;
       }
    }

    [DataContract]
    public class RequestOpSeoRuleBody
    {
        [DataMember]
        public string rule_id { set; get; }

        [DataMember]
        public string rule_name { set; get; }

        [DataMember]
        public string rule_element { set; get; }

        [DataMember]
        public string priority_level { set; get; }

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


        [DataMember]
        public List<ReqSeoRuleItemInfo> rule_list { set; get; }

        [DataMember]
        public string del_rule_ids { set; get; }
    }

   [DataContract]
   public class ReqSeoRuleItemInfo
   {
       [DataMember]
       public string rule_item_id { set; get; }

       [DataMember]
       public string rule_id { set; get; }

       [DataMember]
       public string elment_id { set; get; }

       [DataMember]
       public string seo_elment_code { set; get; }

       [DataMember]
       public string add_time { set; get; }

       [DataMember]
       public string add_user { set; get; }
   }
}
