using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class UpCommentState
    {
        public static Response<ResponseBodyEmpty> Do(int id, int state)
       {
           RequestResetCommentStatus reset = new RequestResetCommentStatus();
           reset.product_comment_id = id.ToString();
           reset.comment_state = state.ToString();

           Request<RequestResetCommentStatus> request = new Request<RequestResetCommentStatus>();
           request.Body = reset;
           request.Header = request.NewHeader();
           request.Key = "UpdateCommentState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestResetCommentStatus>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
    public class RequestResetCommentStatus
   {
       [DataMember]
       public string product_comment_id { set; get; }

       [DataMember]
       public string comment_state { set; get; }
   }
}
