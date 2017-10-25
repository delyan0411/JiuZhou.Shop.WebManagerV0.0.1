using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpCommentReply
    {
       public static Response<ResponseBodyEmpty> Do(int id, string text)
       {
           RequestOpCommentReplyBody body = new RequestOpCommentReplyBody();
           body.product_comment_id = id.ToString();
           body.reply_text = text;

           Request<RequestOpCommentReplyBody> request = new Request<RequestOpCommentReplyBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpCommentReply";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpCommentReplyBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpCommentReplyBody
   {
       [DataMember]
       public string product_comment_id { set; get; }

       [DataMember]
       public string reply_text { set; get; }
   } 
}
