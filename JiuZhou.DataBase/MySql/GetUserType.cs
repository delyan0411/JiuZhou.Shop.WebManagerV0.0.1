using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetUserType
    {
        public static Response<UserType> Do()
        {
            RequestBodyEmpty typeBody = new RequestBodyEmpty();
            Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
            request.Body = typeBody;
            request.Header = request.NewHeader();
            request.Key = "GetUserType";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<UserType>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class UserType
    {
        [DataMember]
        public int user_type { set; get; }
    }
}
