using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpFareTemplate
    {
       public static Response<ResponseBodyEmpty> Do(FareTempInfo fare , List<FareRuleInfo> rule, string del_ruleids)
       {
           RequestOpFareBody fareBody = new RequestOpFareBody();
           fareBody.template_id = fare.template_id.ToString();
           fareBody.template_name = fare.template_name;
           fareBody.first_weight = fare.first_weight.ToString();
           fareBody.min_free_price = fare.min_free_price.ToString();
           fareBody.continue_weight = fare.continue_weight.ToString();
           fareBody.template_remark = fare.template_remark;
           fareBody.template_priority = fare.template_priority.ToString();
           fareBody.template_state = fare.template_state.ToString();
           fareBody.is_system = fare.is_system.ToString();
           List<OpFareRuleInfo> rulelists = new List<OpFareRuleInfo>();
           foreach (FareRuleInfo item in rule) {
               OpFareRuleInfo rulelist = new OpFareRuleInfo();
               rulelist.rule_id = item.rule_id.ToString();
               rulelist.express_allow = item.express_allow.ToString();
               rulelist.express_first_price = item.express_first_price.ToString();
               rulelist.express_continue_price = item.express_continue_price.ToString();
               rulelist.ems_allow = item.ems_allow.ToString();
               rulelist.ems_first_price = item.ems_first_price.ToString();
               rulelist.ems_continue_price = item.ems_continue_price.ToString();
               rulelist.urgent_allow = item.urgent_allow.ToString();
               rulelist.urgent_first_price = item.urgent_first_price.ToString();
               rulelist.urgent_continue_price = item.urgent_continue_price.ToString();
               rulelist.cod_allow = item.cod_allow.ToString();
               rulelist.cod_first_price = item.cod_first_price.ToString();
               rulelist.cod_continue_price = item.cod_continue_price.ToString();
               rulelist.min_free_price = item.min_free_price.ToString();
               rulelist.rule_remark = item.rule_remark;
               List<OpRuleItemArea> areas = new List<OpRuleItemArea>();
               foreach (RuleItemArea item2 in item.rule_item_list) {
                   OpRuleItemArea area = new OpRuleItemArea();
                   area.area_id = item2.area_id.ToString();
                   areas.Add(area);
               }
               rulelist.rule_item_list = areas;
               rulelists.Add(rulelist);
           }
           fareBody.rule_list = rulelists;
           fareBody.del_rule_ids = del_ruleids;

           Request<RequestOpFareBody> request = new Request<RequestOpFareBody>();
           request.Body = fareBody;
           request.Header = request.NewHeader();
           request.Key = "OpFareTemplate";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpFareBody>>(request);
           
           string responseStr = HttpUtils.HttpPost(requestStr);
           
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           
           return response;
       }
    }

   [DataContract]
   public class RequestOpFareBody
   {
       [DataMember]
       public string template_id { set; get; }

       [DataMember]
       public string template_name { set; get; }

       [DataMember]
       public string first_weight { set; get; }

       [DataMember]
       public string min_free_price { set; get; }

       [DataMember]
       public string continue_weight { set; get; }

       [DataMember]
       public string template_remark { set; get; }

       [DataMember]
       public string template_priority { set; get; }

       [DataMember]
       public string template_state { set; get; }

       [DataMember]
       public string is_system { set; get; }

       [DataMember]
       public List<OpFareRuleInfo> rule_list { set; get; }

       [DataMember]
       public string del_rule_ids { set; get; }
   }

   [DataContract]
   public class OpFareRuleInfo {
       [DataMember]
       public string rule_id { set; get; }

       [DataMember]
       public string express_first_price { set; get; }

       [DataMember]
       public string express_continue_price { set; get; }

       [DataMember]
       public string express_allow { set; get; }

       [DataMember]
       public string ems_first_price { set; get; }

       [DataMember]
       public string ems_continue_price { set; get; }

       [DataMember]
       public string ems_allow { set; get; }

       [DataMember]
       public string urgent_first_price { set; get; }

       [DataMember]
       public string urgent_continue_price { set; get; }

       [DataMember]
       public string urgent_allow { set; get; }

       [DataMember]
       public string cod_first_price { set; get; }

       [DataMember]
       public string cod_continue_price { set; get; }

       [DataMember]
       public string cod_allow { set; get; }

       [DataMember]
       public string rule_remark { set; get; }

       [DataMember]
       public string min_free_price { set; get; }

       [DataMember]
       public List<OpRuleItemArea> rule_item_list { set; get; }
   }
   [DataContract]
   public class OpRuleItemArea {
       [DataMember]
       public string area_id { set; get; }
   } 
}
