using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyArticleSort
    {
       public static Response<ResponseBodyEmpty> Do(int id, int sort)
       {
           RequestModyArticleSort body = new RequestModyArticleSort();
           body.article_id = id.ToString();
           body.sort_no = sort.ToString();

           Request<RequestModyArticleSort> request = new Request<RequestModyArticleSort>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyArticleSort";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModyArticleSort>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModyArticleSort
   {
       [DataMember]
       public string article_id { set; get; }

       [DataMember]
       public string sort_no { set; get; }
   } 
}
