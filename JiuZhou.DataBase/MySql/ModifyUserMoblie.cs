using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyUserMoblie
    {
       public static Response<ResponseBodyEmpty> Do(int userid, string mobile)
       {
           RequestModifyUserMobileBody body = new RequestModifyUserMobileBody();
           body.user_id = userid.ToString();
           body.mobile_no = mobile;

           Request<RequestModifyUserMobileBody> request = new Request<RequestModifyUserMobileBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyUserMoblie";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModifyUserMobileBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModifyUserMobileBody
   {
       [DataMember]
       public string user_id { set; get; }

       [DataMember]
       public string mobile_no { set; get; }
   } 
}
