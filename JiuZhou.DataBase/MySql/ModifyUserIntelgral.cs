using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyUserIntelgral
    {
        public static Response<ResponseBodyEmpty> Do(int userid, int intelval, string reason)
       {
           RequestModifyUserIntelgralBody body = new RequestModifyUserIntelgralBody();
           body.user_id = userid.ToString();
           body.intelval = intelval;
           body.reason = reason;

           Request<RequestModifyUserIntelgralBody> request = new Request<RequestModifyUserIntelgralBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyUserIntelgral";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModifyUserIntelgralBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
    public class RequestModifyUserIntelgralBody
   {
       [DataMember]
       public string user_id { set; get; }

       [DataMember]
       public int intelval { set; get; }

       [DataMember]
       public string reason { set; get; }
   } 
}
