using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetHomePageType
    {
        public static Response<ResponseHomePageType> Do()
       {
           RequestBodyEmpty body = new RequestBodyEmpty();

           Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetHomePageType";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseHomePageType>>(responseStr);
           return response;
       }
    }


    [DataContract]
    public class ResponseHomePageType
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<CategSetInfo> type_list { set; get; }
    }

   [DataContract]
    public class CategSetInfo
   { 
       [DataMember]
       public int home_pt_id { set; get; }

       [DataMember]
       public string type_name { set; get; }

       [DataMember]
       public string type_url { set; get; }

       [DataMember]
       public int sort_no { set; get; }

       [DataMember]
       public int parent_id { set; get; }

       [DataMember]
       public int is_black { set; get; }

       [DataMember]
       public int is_color { set; get; }

       [DataMember]
       public int is_newline { set; get; }

       [DataMember]
       public int pos_type { set; get; }
   } 
}
