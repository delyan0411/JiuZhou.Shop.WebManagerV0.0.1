using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetNoReadMsgCount
    {
        public static Response<ResponseNoReadMsgCount> Do()
       {
           RequestBodyEmpty body = new RequestBodyEmpty();
           
           Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetNoReadMsgCount";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseNoReadMsgCount>>(responseStr);
           return response;
       }
    }


    [DataContract]
    public class ResponseNoReadMsgCount
    {
        [DataMember]
        public int msg_count { set; get; }
    }
}
