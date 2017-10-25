using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyArticleState
    {
       public static Response<ResponseBodyEmpty> Do(int id, int status)
       {
           RequestModyArticleState body = new RequestModyArticleState();
           body.article_id = id.ToString();
           body.article_state = status.ToString();

           Request<RequestModyArticleState> request = new Request<RequestModyArticleState>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyArticleState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModyArticleState>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModyArticleState
   {
       [DataMember]
       public string article_id { set; get; }

       [DataMember]
       public string article_state { set; get; }
   } 
}
