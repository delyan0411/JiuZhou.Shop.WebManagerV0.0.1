using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpArticle
    {
       public static Response<ResponseBodyEmpty> Do(ArticleInfo item)
       {
           RequestOpArticleBody body = new RequestOpArticleBody();
           body.article_id = item.article_id.ToString();
           body.article_title = item.article_title;
           body.article_content = item.article_content;
           body.article_type_id = item.article_type_id.ToString();
           body.click_count = item.click_count.ToString();
           body.key_word = item.key_word;
           body.article_source = item.article_source;
           body.author_name = item.author_name;
           body.title_img = item.title_img;
           body.title_color = item.title_color;
           body.is_top = item.is_top.ToString();

           Request<RequestOpArticleBody> request = new Request<RequestOpArticleBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpArticle";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpArticleBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpArticleBody
   {
       [DataMember]
       public string article_id { set; get; }

       [DataMember]
       public string article_title { set; get; }

       [DataMember]
       public string article_content { set; get; }

       [DataMember]
       public string article_type_id { set; get; }

       [DataMember]
       public string click_count { set; get; }

       [DataMember]
       public string key_word { set; get; }

       [DataMember]
       public string article_source { set; get; }

       [DataMember]
       public string author_name { set; get; }

       [DataMember]
       public string title_img { set; get; }

       [DataMember]
       public string title_color { set; get; }

       [DataMember]
       public string is_top { set; get; }
   } 
}
