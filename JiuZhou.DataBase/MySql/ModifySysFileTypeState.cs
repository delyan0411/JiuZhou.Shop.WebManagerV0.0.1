using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifySysFileTypeState
    {
       public static Response<ResponseBodyEmpty> Do(int id, int status)
       {
           RequestModySysFileTypeState body = new RequestModySysFileTypeState();
           body.sp_type_id = id.ToString();
           body.sp_type_state = status.ToString();

           Request<RequestModySysFileTypeState> request = new Request<RequestModySysFileTypeState>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifySysFileTypeState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModySysFileTypeState>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModySysFileTypeState
   {
       [DataMember]
       public string sp_type_id { set; get; }

       [DataMember]
       public string sp_type_state { set; get; }
   } 
}
