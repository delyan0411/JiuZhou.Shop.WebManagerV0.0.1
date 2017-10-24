using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpRole
    {
       public static Response<ResponseBodyEmpty> Do(RoleInfo item)
       {
           RequestOpRoleBody body = new RequestOpRoleBody();
           body.role_id = item.role_id.ToString();
           body.role_name = item.role_name;
           body.role_desc = item.role_desc;
           body.role_type = item.role_type.ToString();

           Request<RequestOpRoleBody> request = new Request<RequestOpRoleBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpRole";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpRoleBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpRoleBody
   {
       [DataMember]
       public string role_id { set; get; }

       [DataMember]
       public string role_name { set; get; }

       [DataMember]
       public string role_desc { set; get; }

       [DataMember]
       public string role_type { set; get; }
   } 
}
