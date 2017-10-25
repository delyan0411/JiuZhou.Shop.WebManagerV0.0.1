using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryRoleList
    {
        public static Response<ResponseQueryRoleBody> Do()
       {
           RequestBodyEmpty search = new RequestBodyEmpty();

           Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryRoleList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseQueryRoleBody>>(responseStr);

           return response;
       }
    }


    [DataContract]
    public class ResponseQueryRoleBody {
        [DataMember]
        public List<RoleInfo> role_list { set; get; }
    }

    [DataContract]
    public class RoleInfo
    {
        [DataMember]
        public int role_id { set; get; }  

        [DataMember]
        public string role_name { set; get; }

        [DataMember]
        public string role_desc { set; get; }

        [DataMember]
        public int role_type { set; get; }

        [DataMember]
        public string add_time { set; get; }
    } 
}
