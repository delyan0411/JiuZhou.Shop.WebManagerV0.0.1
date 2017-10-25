using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpSeoHomeRule
    {
       public static Response<ResponseBodyEmpty> Do(SeoRuleInfo sri)
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
           seoBody.del_rule_ids = "";
           seoBody.rule_list = new List<ReqSeoRuleItemInfo>();
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

}
