using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifySysFileState
    {
       public static Response<ResponseBodyEmpty> Do(string ids, int status)
       {
           RequestModySysFileState body = new RequestModySysFileState();
           body.sp_file_ids = ids.Split(',');
           body.is_visible = status.ToString();

           Request<RequestModySysFileState> request = new Request<RequestModySysFileState>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifySysFileState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModySysFileState>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModySysFileState
   {
       [DataMember]
       public string[] sp_file_ids { set; get; }

       [DataMember]
       public string is_visible { set; get; }
   } 
}
