using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetRoleDetail
    {
        public static Response<RoleInfo> Do(int id)
       {
           RequestRoleInfoBody body = new RequestRoleInfoBody();
           body.role_id = id.ToString();

           Request<RequestRoleInfoBody> request = new Request<RequestRoleInfoBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetRoleDetail";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestRoleInfoBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<RoleInfo>>(responseStr);
      
           return response;
       }
    }

    [DataContract]
    public class RequestRoleInfoBody
    {
        [DataMember]
        public string role_id { set; get; }
    } 
}
