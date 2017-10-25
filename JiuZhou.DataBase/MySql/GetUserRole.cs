using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetUserRole
    {
        public static Response<ResponseUserRole> Do(int id)
       {
           RequestUserRole body = new RequestUserRole();
           body.user_id = id.ToString();

           Request<RequestUserRole> request = new Request<RequestUserRole>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetUserRole";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestUserRole>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseUserRole>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestUserRole
    {
        [DataMember]
        public string user_id { set; get; }
    }

    [DataContract]
    public class ResponseUserRole 
    {
        [DataMember]
        public List<UserRoleList> user_role_list { set; get; }
    }

    [DataContract]
    public class UserRoleList
    {
        [DataMember]
        public int role_id { set; get; }

        [DataMember]
        public int user_role_id { set; get; }

        [DataMember]
        public string role_name { set; get; }
    }
}
