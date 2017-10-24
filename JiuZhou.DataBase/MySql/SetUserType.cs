using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class SetUserType
    {
       public static Response<ResponseBodyEmpty> Do(int id, int type)
       {
           RequestOpUserTypeBody body = new RequestOpUserTypeBody();
           body.user_id = id.ToString();
           body.user_type = type.ToString();

           Request<RequestOpUserTypeBody> request = new Request<RequestOpUserTypeBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "SetUserType";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpUserTypeBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpUserTypeBody
   {
       [DataMember]
       public string user_id { set; get; }

       [DataMember]
       public string user_type { set; get; }
   } 
}
