using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteTopicInfo
    {
        public static Response<ResponseBodyEmpty> Do(string ids)
       {
           RequestDeleteStopicBody body = new RequestDeleteStopicBody();

           body.st_ids = ids;

           Request<RequestDeleteStopicBody> request = new Request<RequestDeleteStopicBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteTopicInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteStopicBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteStopicBody
    {
        [DataMember]
        public string st_ids { set; get; }
    }
}
