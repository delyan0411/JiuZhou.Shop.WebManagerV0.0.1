using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyUserState
    {
       public static Response<ResponseBodyEmpty> Do(string userids, int status)
       {
           RequestOpUserStateBody body = new RequestOpUserStateBody();
           body.user_ids = userids.Split(',');
           body.user_state = status.ToString();


           Request<RequestOpUserStateBody> request = new Request<RequestOpUserStateBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyUserState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpUserStateBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpUserStateBody
   {
       [DataMember]
       public string[] user_ids { set; get; }

       [DataMember]
       public string user_state { set; get; }
   } 
}
