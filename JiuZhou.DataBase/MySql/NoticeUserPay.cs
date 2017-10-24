using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class NoticeUserPay
    {
       public static Response<ResponseBodyEmpty> Do(string orderno, string message)
       {
           RequestUpSendMessage messageBody = new RequestUpSendMessage();
           messageBody.order_no = orderno;
           messageBody.notice_msg = message;
           Request<RequestUpSendMessage> request = new Request<RequestUpSendMessage>();
           request.Body = messageBody;
           request.Header = request.NewHeader();
           request.Key = "NoticeUserPay";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestUpSendMessage>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestUpSendMessage
   {
       [DataMember]
       public string order_no { set; get; }

       [DataMember]
       public string notice_msg { set; get; }
   } 
}
