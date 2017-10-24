using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryAccessResource
    {
        public static Response<RoleAccess> Do(int id)
        {
            RequestQueryAccessResource search = new RequestQueryAccessResource();
            search.access_id = id.ToString();

            Request<RequestQueryAccessResource> request = new Request<RequestQueryAccessResource>();
            request.Body = search;
            request.Header = request.NewHeader();
            request.Key = "QueryAccessResource";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryAccessResource>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<RoleAccess>>(responseStr);

            return response;
        }
    }

    [DataContract]
    public class RequestQueryAccessResource
    {
        [DataMember]
        public string access_id { set; get; }
    }

    [DataContract]
    public class RoleAccess
    {
        [DataMember]
        public string[] res_ids { set; get; }
    }
}
