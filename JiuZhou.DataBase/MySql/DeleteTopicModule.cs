using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteTopicModule
    {
        public static Response<ResponseBodyEmpty> Do(int stid, int moduleid)
       {
           RequestDeleteStopicModuleBody body = new RequestDeleteStopicModuleBody();

           body.st_id = stid.ToString();
           body.st_module_id = moduleid.ToString();

           Request<RequestDeleteStopicModuleBody> request = new Request<RequestDeleteStopicModuleBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteTopicModule";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteStopicModuleBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteStopicModuleBody
    {
        [DataMember]
        public string st_id { set; get; }

        [DataMember]
        public string st_module_id { set; get; }
    }
}
