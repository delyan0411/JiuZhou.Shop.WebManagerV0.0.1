using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetExpressInfo
    {
        public static Response<ResponseExpressInfo> Do(string orderno)
        {
            RequestGetExpress typeBody = new RequestGetExpress();
            typeBody.order_no = orderno;
            Request<RequestGetExpress> request = new Request<RequestGetExpress>();
            request.Body = typeBody;
            request.Header = request.NewHeader();
            request.Key = "GetExpressInfo";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestGetExpress>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseExpressInfo>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestGetExpress
    {
        [DataMember]
        public string order_no { set; get; }
    }

    [DataContract]
    public class ResponseExpressInfo 
    {
        [DataMember]
        public List<ExpressInfo> list { set; get; }
    }

    [DataContract]
    public class ExpressInfo
    {
        [DataMember]
        public string time { set; get; }

        [DataMember]
        public string context { set; get; }
    }
}
