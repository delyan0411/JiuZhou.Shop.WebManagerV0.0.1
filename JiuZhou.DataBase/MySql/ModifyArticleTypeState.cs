using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyArticleTypeState
    {
       public static Response<ResponseBodyEmpty> Do(int id, int status)
       {
           RequestModyArticleTypeState body = new RequestModyArticleTypeState();
           body.article_type_id = id.ToString();
           body.type_state = status.ToString();

           Request<RequestModyArticleTypeState> request = new Request<RequestModyArticleTypeState>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyArticleTypeState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModyArticleTypeState>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModyArticleTypeState
   {
       [DataMember]
       public string article_type_id { set; get; }

       [DataMember]
       public string type_state { set; get; }
   } 
}
