using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class UpCommentStateList
    {
        public static Response<ResponseBodyEmpty> Do(string ids)
       {
           RequestResetCommentStatusList reset = new RequestResetCommentStatusList();
           reset.product_comment_ids = ids;
           reset.comment_state = "0";

           Request<RequestResetCommentStatusList> request = new Request<RequestResetCommentStatusList>();
           request.Body = reset;
           request.Header = request.NewHeader();
           request.Key = "BulkUpdateCommentState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestResetCommentStatusList>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
    public class RequestResetCommentStatusList
   {
       [DataMember]
       public string product_comment_ids { set; get; }

       [DataMember]
       public string comment_state { set; get; }
   }
}
