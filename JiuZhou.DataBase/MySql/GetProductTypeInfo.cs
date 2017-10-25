using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetProductTypeInfo
    {
        public static Response<ProTypeList> Do(int type_id)
       {
           RequestProTypeBody typeBody = new RequestProTypeBody();

           typeBody.product_type_id = type_id.ToString();
           Request<RequestProTypeBody> request = new Request<RequestProTypeBody>();
           request.Body = typeBody;
           request.Header = request.NewHeader();
           request.Key = "GetProductTypeInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestProTypeBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ProTypeList>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestProTypeBody {
        [DataMember]
        public string product_type_id { set; get; }
    }

   [DataContract]
   public class ProTypeList
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
       public int add_user_id { set; get; }

       [DataMember]
       public string seo_title { set; get; }

       [DataMember]
       public string seo_text { set; get; }

       [DataMember]
       public string seo_key { set; get; }

       [DataMember]
       public int is_visible { set; get; }

       [DataMember]
       public string img_src { set; get; }
   } 
}
