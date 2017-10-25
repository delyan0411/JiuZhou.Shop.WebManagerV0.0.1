using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetTypeListAll
    {
        public static Response<ResponseTypeBody> Do(int isVisible)
       {
           RequestTypeBody typeBody = new RequestTypeBody();

           typeBody.is_visible = isVisible.ToString();
           Request<RequestTypeBody> request = new Request<RequestTypeBody>();
           request.Body = typeBody;
           request.Header = request.NewHeader();
           request.Key = "GetTypeListAll";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestTypeBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseTypeBody>>(responseStr);
           if (response == null)
               response = new Response<ResponseTypeBody>();
           return response;
       }
    }

    [DataContract]
    public class RequestTypeBody {
        [DataMember]
        public string is_visible { set; get; }
    }

    [DataContract]
    public class ResponseTypeBody
    {
        [DataMember]
        public string rec_num { set; get; }
        [DataMember]
        public List<TypeList> type_list { set; get; }
    }

   [DataContract]
   public class TypeList
   {
       [DataMember]
       public int product_type_id { set; get; }

       [DataMember]
       public string type_name { set; get; }

       [DataMember]
       public int parent_type_id { set; get; }

       [DataMember]
       public int sort_no { set; get; }

       [DataMember]
       public string product_type_path { set; get; }

       [DataMember]
       public string seo_text { set; get; }

       [DataMember]
       public int is_visible { set; get; }

       [DataMember]
       public string img_src { set; get; }
   } 
}
