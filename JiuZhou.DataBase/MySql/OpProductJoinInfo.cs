using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpProductJoinInfo
    {
       public static Response<ResponseOpProductJoinInfo> Do(ProductJoinInfo join)
       {
           RequestOpProductJoinInfo joininfo = new RequestOpProductJoinInfo();
           joininfo.product_join_id = join.product_join_id.ToString();
           joininfo.type_name = join.type_name;
           joininfo.join_name = join.join_name;
           joininfo.allow_refresh = join.allow_refresh.ToString();
           joininfo.view_type = join.view_type.ToString();
          
           Request<RequestOpProductJoinInfo> request = new Request<RequestOpProductJoinInfo>();
           request.Body = joininfo;
           request.Header = request.NewHeader();
           request.Key = "OpProductJoinInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpProductJoinInfo>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseOpProductJoinInfo>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpProductJoinInfo
   {
       [DataMember]
       public string product_join_id { set; get; }

       [DataMember]
       public string type_name { set; get; }

       [DataMember]
       public string join_name { set; get; }

       [DataMember]
       public string allow_refresh { set; get; }

       [DataMember]
       public string view_type { set; get; }
   }

   [DataContract]
   public class ResponseOpProductJoinInfo
   {
       [DataMember]
       public int product_join_id { set; get; }
   }
}
