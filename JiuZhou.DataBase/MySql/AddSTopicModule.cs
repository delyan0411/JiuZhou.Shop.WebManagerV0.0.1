using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class AddSTopicModule
    {
        public static Response<ResponseAddModule> Do(int id, int type)
        {
            RequestAddModuleBody body = new RequestAddModuleBody();

            body.st_id = id.ToString();
            body.module_type = type.ToString();

            Request<RequestAddModuleBody> request = new Request<RequestAddModuleBody>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "AddTopicModule";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestAddModuleBody>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);            
            var response = JsonHelper.JsonToObject<Response<ResponseAddModule>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestAddModuleBody
    {
        [DataMember]
        public string st_id { set; get; }

        [DataMember]
        public string module_type { set; get; }
    }

    [DataContract]
    public class ResponseAddModule {
        [DataMember]
        public int st_module_id { set; get; }
    }
}
