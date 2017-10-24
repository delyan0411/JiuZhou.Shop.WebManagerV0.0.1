using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyTopicInfoState
    {
       public static Response<ResponseBodyEmpty> Do(int id, int status)
       {
           RequestModyState body = new RequestModyState();
           body.st_id = id.ToString();
           body.st_state = status.ToString();

           Request<RequestModyState> request = new Request<RequestModyState>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyTopicInfoState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModyState>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModyState
   {
       [DataMember]
       public string st_id { set; get; }

       [DataMember]
       public string st_state { set; get; }
   } 
}
