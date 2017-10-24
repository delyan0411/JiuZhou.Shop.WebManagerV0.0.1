using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetSTopicModuleInfo
    {
        public static Response<STModuleInfo> Do(int mid)
        {
            RequestSTopicModuleBody body = new RequestSTopicModuleBody();
            body.st_module_id = mid.ToString();
            Request<RequestSTopicModuleBody> request = new Request<RequestSTopicModuleBody>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "GetTopicModuleInfo";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestSTopicModuleBody>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<STModuleInfo>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestSTopicModuleBody {
        [DataMember]
        public string st_module_id { set; get; }
    }
}
