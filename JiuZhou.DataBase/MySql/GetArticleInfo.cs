using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetArticleInfo
    {
        public static Response<ArticleInfo> Do(int id, string flag)
       {
           RequestArticelInfoBody body = new RequestArticelInfoBody();
           body.article_id = id.ToString();
           body.get_flag = flag;

           Request<RequestArticelInfoBody> request = new Request<RequestArticelInfoBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetArticleInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestArticelInfoBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ArticleInfo>>(responseStr);
      
           return response;
       }
    }

    [DataContract]
    public class RequestArticelInfoBody
    {
        [DataMember]
        public string article_id { set; get; }

        [DataMember]
        public string get_flag { set; get; }
    }

    [DataContract]
    public class ArticleInfo
    {
        [DataMember]
        public int article_id { set; get; }

        [DataMember]
        public string article_title { set; get; }

        [DataMember]
        public string article_content { set; get; }

        [DataMember]
        public int article_type_id {set;get;}

        [DataMember]
        public string author_name { set; get; }

        [DataMember]
        public int article_state { set; get; }

        [DataMember]
        public string key_word { set; get; }

        [DataMember]
        public string article_source { set; get; }

        [DataMember]
        public string title_img { set; get; }

        [DataMember]
        public string title_color { set; get; }

        [DataMember]
        public int click_count { set; get; }

        [DataMember]
        public int is_top { set; get; }
    } 
}
