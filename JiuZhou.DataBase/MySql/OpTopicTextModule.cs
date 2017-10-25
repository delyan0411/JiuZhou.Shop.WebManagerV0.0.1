using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpTopicTextModule
    {
       public static Response<ResponseBodyEmpty> Do(STModuleInfo info)
       {
           RequestOpModuleText body = new RequestOpModuleText();
           
           body.st_module_id = info.st_module_id.ToString();
           body.is_full_screen = info.is_full_screen.ToString();
           body.allow_show_name = info.allow_show_name.ToString();
           body.module_name = info.module_name;
           body.module_desc = info.module_desc;
           body.module_content = info.module_content;

           Request<RequestOpModuleText> request = new Request<RequestOpModuleText>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpTopicTextModule";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpModuleText>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

   [DataContract]
   public class RequestOpModuleText
   {
       [DataMember]
       public string st_module_id { set; get; }

       [DataMember]
       public string is_full_screen { set; get; }

       [DataMember]
       public string allow_show_name { set; get; }

       [DataMember]
       public string module_name { set; get; }

       [DataMember]
       public string module_desc { set; get; }

       [DataMember]
       public string module_content { set; get; }
   }
}
