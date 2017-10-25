using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryResource
    {
        public static Response<ResponseQueResBody> Do(int resId,int resFlag)
        {
            RequestQueResBody resourceBody = new RequestQueResBody();
            resourceBody.parent_id = resId.ToString();
            resourceBody.res_state = resFlag.ToString();
            Request<RequestQueResBody> request = new Request<RequestQueResBody>();
            request.Body = resourceBody;
            request.Header = request.NewHeader();
            request.Key = "QueryResource";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestQueResBody>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseQueResBody>>(responseStr);

            return response;

        }
    }
    [DataContract]
    public class RequestQueResBody {
        [DataMember]
        public string parent_id { set; get; }

        [DataMember]
        public string res_state { set; get; }
    }

    [DataContract]
    public class ResponseQueResBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<UserResBody> resource_list { set; get; }
    }

    [DataContract]
    public class UserResBody
    {

        [DataMember]
        public int res_id { set; get; }

        [DataMember]
        public int parent_id { set; get; }

        [DataMember]
        public string res_path { set; get; }

        [DataMember]
        public int res_type { set; get; }

        [DataMember]
        public string res_name { set; get; }

        [DataMember]
        public int res_state { set; get; }

        [DataMember]
        public string res_src { set; get; }

        [DataMember]
        public int sort_no { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public string res_desc { set; get; }

        [DataMember]
        public string res_code { set; get; }
    }
}
