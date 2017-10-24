using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetHelpType
    {
        public static Response<ResponseHelpTypeBody> Do(int typeid, int flag, int state)
       {
           RequestHelpTypeBody typeBody = new RequestHelpTypeBody();

           typeBody.help_type_id = typeid.ToString();
           typeBody.get_flag = flag.ToString();
           typeBody.type_state = state.ToString();
           Request<RequestHelpTypeBody> request = new Request<RequestHelpTypeBody>();
           request.Body = typeBody;
           request.Header = request.NewHeader();
           request.Key = "GetHelpType";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestHelpTypeBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseHelpTypeBody>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestHelpTypeBody {
        [DataMember]
        public string help_type_id { set; get; }

        [DataMember]
        public string get_flag { set; get; }

        [DataMember]
        public string type_state { set; get; }
    }

    [DataContract]
    public class ResponseHelpTypeBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<HelpTypeInfo> help_type_list { set; get; }
    }

   [DataContract]
   public class HelpTypeInfo
   {
       [DataMember]
       public int help_type_id { set; get; }

       [DataMember]
       public string type_name { set; get; }

       [DataMember]
       public string type_path { set; get; }

       [DataMember]
       public int parent_id { set; get; }

       [DataMember]
       public int sort_no { set; get; }

       [DataMember]
       public int type_state { set; get; }
   } 
}
