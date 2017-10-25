using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpRefoudReqReply
    {
       public static Response<ResponseBodyEmpty> Do(int id, string text,int state)
       {
           RequestOpRefoudReqReplyBody body = new RequestOpRefoudReqReplyBody();
           body.id = id.ToString();
           body.refoudresp_reason = text;
           body.state = state.ToString();
           Request<RequestOpRefoudReqReplyBody> request = new Request<RequestOpRefoudReqReplyBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpRefoudReqReply";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpRefoudReqReplyBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
    public class RequestOpRefoudReqReplyBody
   {
       [DataMember]
       public string id { set; get; }

       [DataMember]
       public string refoudresp_reason { set; get; }

       [DataMember]
       public string state { set; get; }
   } 
}
