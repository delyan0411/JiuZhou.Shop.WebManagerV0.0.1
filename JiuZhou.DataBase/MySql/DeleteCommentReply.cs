using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteCommentReply
    {
        public static Response<ResponseBodyEmpty> Do(int commentid)
       {
           RequestDeleteCommentReplyBody body = new RequestDeleteCommentReplyBody();

           body.product_comment_id = commentid.ToString();

           Request<RequestDeleteCommentReplyBody> request = new Request<RequestDeleteCommentReplyBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteCommentReply";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteCommentReplyBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteCommentReplyBody
    {
        [DataMember]
        public string product_comment_id { set; get; }
    }
}
