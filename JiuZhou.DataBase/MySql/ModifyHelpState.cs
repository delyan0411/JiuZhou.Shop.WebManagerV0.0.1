using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyHelpState
    {
       public static Response<ResponseBodyEmpty> Do(int id, int status)
       {
           RequestModyHelpState body = new RequestModyHelpState();
           body.help_id = id.ToString();
           body.help_state = status.ToString();

           Request<RequestModyHelpState> request = new Request<RequestModyHelpState>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyHelpState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModyHelpState>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModyHelpState
   {
       [DataMember]
       public string help_id { set; get; }

       [DataMember]
       public string help_state { set; get; }
   } 
}
