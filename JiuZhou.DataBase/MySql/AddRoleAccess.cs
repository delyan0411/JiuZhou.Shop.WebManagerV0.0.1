using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class AddRoleAccess
    {
        public static Response<ResponseBodyEmpty> Do(int roleid, string ids, string delids)
       {
           RequestOpRoleAccessBody body = new RequestOpRoleAccessBody();
           body.role_id = roleid.ToString();
           body.access_id = ids.Split(',');
           body.del_access_id = delids.Split(',');

           Request<RequestOpRoleAccessBody> request = new Request<RequestOpRoleAccessBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "AddRoleAccess";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpRoleAccessBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

   [DataContract]
   public class RequestOpRoleAccessBody
   {
       [DataMember]
       public string role_id { set; get; }

       [DataMember]
       public string[] access_id { set; get; }

       [DataMember]
       public string[] del_access_id { set; get; }
   }
}
