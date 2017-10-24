using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetUserResource
    {
        public static Response<ResponseUserResBody> Do(int resId,int resFlag)
        {
            RequestUserResBody resourceBody = new RequestUserResBody();
            resourceBody.res_id = resId.ToString();
            resourceBody.get_flag = resFlag.ToString();
            Request<RequestUserResBody> request = new Request<RequestUserResBody>();
            request.Body = resourceBody;
            request.Header = request.NewHeader();
            request.Key = "GetUserResource";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestUserResBody>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseUserResBody>>(responseStr);
    
            return response;
        }
    }
    [DataContract]
    public class RequestUserResBody {
        [DataMember]
        public string res_id { set; get; }

        [DataMember]
        public string get_flag { set; get; }
    }

    [DataContract]
    public class ResponseUserResBody
    {
        [DataMember]
        public string rec_num { set; get; }
        [DataMember]
        public List<UserResBody> resource_list { set; get; }
    }
}
