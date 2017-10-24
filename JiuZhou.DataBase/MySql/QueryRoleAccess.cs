using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryRoleAccess
    {
        public static Response<ResponseQueryRoleAccessBody> Do(int id)
        {
            RequestQueryRoleAccess search = new RequestQueryRoleAccess();
            search.role_id = id.ToString();

            Request<RequestQueryRoleAccess> request = new Request<RequestQueryRoleAccess>();
            request.Body = search;
            request.Header = request.NewHeader();
            request.Key = "QueryRoleAccess";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryRoleAccess>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseQueryRoleAccessBody>>(responseStr);

            return response;
        }
    }

    [DataContract]
    public class RequestQueryRoleAccess
    {
        [DataMember]
        public string role_id { set; get; }
    }

    [DataContract]
    public class ResponseQueryRoleAccessBody
    {
        [DataMember]
        public List<RoleAccessInfo> access_list { set; get; }
    }

    [DataContract]
    public class RoleAccessInfo
    {
        [DataMember]
        public int access_id { set; get; }

        [DataMember]
        public int role_access_id { set; get; }
    }
}
