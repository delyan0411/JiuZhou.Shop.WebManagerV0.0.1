using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class SendManagerVerifyCode
    {
        public static Response<ResponseBodyEmpty> Do(int type)
       {
           RequestSendCode body = new RequestSendCode();
           body.send_type = type.ToString();
           Request<RequestSendCode> request = new Request<RequestSendCode>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "SendManagerVerifyCode";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSendCode>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestSendCode {
        [DataMember]
        public string send_type { set; get; }
    }
}
