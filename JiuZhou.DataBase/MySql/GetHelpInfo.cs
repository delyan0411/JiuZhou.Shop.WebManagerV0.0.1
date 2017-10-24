using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetHelpInfo
    {
        public static Response<HelpInfo> Do(int id)
       {
           RequestHelpInfoBody body = new RequestHelpInfoBody();
           body.help_type_id = id.ToString();

           Request<RequestHelpInfoBody> request = new Request<RequestHelpInfoBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetHelpInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestHelpInfoBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<HelpInfo>>(responseStr);
      
           return response;
       }
    }

    [DataContract]
    public class RequestHelpInfoBody
    {
        [DataMember]
        public string help_type_id { set; get; }
    }

    [DataContract]
    public class HelpInfo
    {
        [DataMember]
        public int help_id { set; get; }

        [DataMember]
        public string help_title { set; get; }

        [DataMember]
        public string help_summary { set; get; }

        [DataMember]
        public int help_type_id { set; get; }

        [DataMember]
        public string help_content { set; get; }

        [DataMember]
        public int click_count { set; get; }

        [DataMember]
        public string author_name { set; get; }

        [DataMember]
        public string key_word { set; get; }
    } 
}
