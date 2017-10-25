using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpUserRole
    {
        public static Response<ResponseBodyEmpty> Do(int userid, string ids, string delids)
       {
           RequestOpUserRoleBody body = new RequestOpUserRoleBody();
           body.user_id = userid.ToString();
           body.ins_role_ids = ids.Split(',');
           body.del_role_ids = delids.Split(',');

           Request<RequestOpUserRoleBody> request = new Request<RequestOpUserRoleBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpUserRole";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpUserRoleBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

   [DataContract]
   public class RequestOpUserRoleBody
   {
       [DataMember]
       public string user_id { set; get; }

       [DataMember]
       public string[] ins_role_ids { set; get; }

       [DataMember]
       public string[] del_role_ids { set; get; }
   }
}
