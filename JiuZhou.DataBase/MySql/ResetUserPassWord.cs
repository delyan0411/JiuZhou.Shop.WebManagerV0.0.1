using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ResetUserPassWord
    {
       public static Response<ResponseBodyEmpty> Do(int userid)
       {
           RequestOpUserPasBody body = new RequestOpUserPasBody();
           body.user_id = userid.ToString();


           Request<RequestOpUserPasBody> request = new Request<RequestOpUserPasBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ResetUserPassWord";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpUserPasBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpUserPasBody
   {
       [DataMember]
       public string user_id { set; get; }
   } 
}
