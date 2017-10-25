using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ResetBrandState
    {
       public static Response<ResponseBodyEmpty> Do(int id, int status)
       {
           RequestModyBrandState body = new RequestModyBrandState();
           body.brand_id = id.ToString();
           body.brand_state = status.ToString();

           Request<RequestModyBrandState> request = new Request<RequestModyBrandState>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ResetBrandState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModyBrandState>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModyBrandState
   {
       [DataMember]
       public string brand_id { set; get; }

       [DataMember]
       public string brand_state { set; get; }
   } 
}
