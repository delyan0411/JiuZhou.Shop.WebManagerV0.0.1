using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpHelp
    {
       public static Response<ResponseBodyEmpty> Do(HelpInfo item)
       {
           RequestOpHelpBody body = new RequestOpHelpBody();
           body.help_id = item.help_id.ToString();
           body.help_title = item.help_title;
           body.help_type_id = item.help_type_id.ToString();
           body.help_content = item.help_content;
           body.help_summary = item.help_summary;
           body.key_word = item.key_word;
           body.author_name = item.author_name;
           body.click_count = item.click_count.ToString();

           Request<RequestOpHelpBody> request = new Request<RequestOpHelpBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpHelp";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpHelpBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpHelpBody
   {
       [DataMember]
       public string help_id { set; get; }

       [DataMember]
       public string help_title { set; get; }

       [DataMember]
       public string help_type_id { set; get; }

       [DataMember]
       public string help_content { set; get; }

       [DataMember]
       public string help_summary { set; get; }

       [DataMember]
       public string key_word { set; get; }

       [DataMember]
       public string author_name { set; get; }

       [DataMember]
       public string click_count { set; get; }
   } 
}
