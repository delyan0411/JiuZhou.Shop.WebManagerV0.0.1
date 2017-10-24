using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteRole
    {
        public static Response<ResponseBodyEmpty> Do(int id)
       {
           RequestDeleteRoleBody body = new RequestDeleteRoleBody();

           body.role_id = id.ToString();

           Request<RequestDeleteRoleBody> request = new Request<RequestDeleteRoleBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteRole";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteRoleBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteRoleBody
    {
        [DataMember]
        public string role_id { set; get; }
    }
}
