using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteArticle
    {
        public static Response<ResponseBodyEmpty> Do(string ids)
       {
           RequestDeleteArticleBody body = new RequestDeleteArticleBody();

           body.article_ids = ids.Split(',');

           Request<RequestDeleteArticleBody> request = new Request<RequestDeleteArticleBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteArticle";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteArticleBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteArticleBody
    {
        [DataMember]
        public string[] article_ids { set; get; }
    }
}
