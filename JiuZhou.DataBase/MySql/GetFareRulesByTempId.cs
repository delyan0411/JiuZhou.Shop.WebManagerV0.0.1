using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetFareRulesByTempId
    {
        public static Response<ResponseRulesBody> Do(int templateId)
       {
           RequestRulesBody rulesBody = new RequestRulesBody();

           rulesBody.template_id = templateId.ToString();
           Request<RequestRulesBody> request = new Request<RequestRulesBody>();
           request.Body = rulesBody;
           request.Header = request.NewHeader();
           request.Key = "GetFareRulesByTempId";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestRulesBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseRulesBody>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestRulesBody {
        [DataMember]
        public string template_id { set; get; }
    }

    [DataContract]
    public class ResponseRulesBody
    {
        [DataMember]
        public string rec_num { set; get; }
        [DataMember]
        public List<FareRuleInfo> rule_list { set; get; }
    }

   [DataContract]
    public class FareRuleInfo
   {
       [DataMember]
       public int rule_id { set; get; }

       [DataMember]
       public int template_id { set; get; }

       [DataMember]
       public decimal express_first_price { set; get; }

       [DataMember]
       public decimal express_continue_price { set; get; }

       [DataMember]
       public int express_allow { set; get; }

       [DataMember]
       public decimal ems_first_price { set; get; }

       [DataMember]
       public decimal ems_continue_price { set; get; }

       [DataMember]
       public int ems_allow { set; get; }

       [DataMember]
       public decimal urgent_first_price { set; get; }

       [DataMember]
       public decimal urgent_continue_price { set; get; }

       [DataMember]
       public int urgent_allow { set; get; }

       [DataMember]
       public decimal cod_first_price { set; get; }

       [DataMember]
       public decimal cod_continue_price { set; get; }

       [DataMember]
       public int cod_allow { set; get; }

       [DataMember]
       public decimal min_free_price { set; get; }

       [DataMember]
       public string rule_remark { set; get; }

       [DataMember]
       public List<RuleItemArea> rule_item_list { set; get; }
   }

   [DataContract]
   public class RuleItemArea {
       [DataMember]
       public int area_id { set; get; }

       [DataMember]
       public string area_name { set; get; }
   }
}
