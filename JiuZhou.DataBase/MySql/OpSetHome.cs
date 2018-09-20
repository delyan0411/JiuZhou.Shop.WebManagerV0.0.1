using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpSetHome
    {
        public static Response<ResponseBodyEmpty> Do(RequestSetHome info)
        {
            RequestSetHome body = info;
            Request<RequestSetHome> request = new Request<RequestSetHome>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "SetHomePage";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestSetHome>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);      
            return response;
        }
    }

    [DataContract]
    public class RequestSetHome
    {
        [DataMember]
        public string st_id { set; get; }

        [DataMember]
        public string type { set; get; }

    }
}
