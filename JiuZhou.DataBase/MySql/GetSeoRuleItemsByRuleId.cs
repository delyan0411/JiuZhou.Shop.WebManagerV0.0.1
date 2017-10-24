using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetSeoRuleItemsByRuleId
    {
        public static Response<ResponseRuleItemsBody> Do(int ruleid)
       {
           RequestRuleItemsBody rulesBody = new RequestRuleItemsBody();
           rulesBody.rule_id = ruleid.ToString();
           Request<RequestRuleItemsBody> request = new Request<RequestRuleItemsBody>();
           request.Body = rulesBody;
           request.Header = request.NewHeader();
           request.Key = "GetSeoRuleItemsByRuleId";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestRuleItemsBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseRuleItemsBody>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestRuleItemsBody
    {
        [DataMember]
        public string rule_id { set; get; }
    }

    [DataContract]
    public class ResponseRuleItemsBody
    {
        [DataMember]
        public string rec_num { set; get; }
        [DataMember]
        public List<SeoRuleItemInfo> rule_list { set; get; }
    }

   [DataContract]
    public class SeoRuleItemInfo
   {
       [DataMember]
       public int rule_item_id { set; get; }

       [DataMember]
       public int rule_id { set; get; }

       [DataMember]
       public int elment_id { set; get; }

       [DataMember]
       public string seo_elment_code { set; get; }

       [DataMember]
       public string add_time { set; get; }

       [DataMember]
       public string add_user { set; get; }
   }
}
