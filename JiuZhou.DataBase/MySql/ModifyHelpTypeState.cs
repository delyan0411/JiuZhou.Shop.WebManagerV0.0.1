using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyHelpTypeState
    {
       public static Response<ResponseBodyEmpty> Do(int id, int status)
       {
           RequestModyHelpTypeState body = new RequestModyHelpTypeState();
           body.help_type_id = id.ToString();
           body.type_state = status.ToString();

           Request<RequestModyHelpTypeState> request = new Request<RequestModyHelpTypeState>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyHelpTypeState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModyHelpTypeState>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModyHelpTypeState
   {
       [DataMember]
       public string help_type_id { set; get; }

       [DataMember]
       public string type_state { set; get; }
   } 
}
