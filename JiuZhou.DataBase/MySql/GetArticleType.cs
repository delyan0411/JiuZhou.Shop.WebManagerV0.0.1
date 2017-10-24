using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetArticleType
    {
        public static Response<ResponseArticleTypeBody> Do(int typeid, int flag, int state)
       {
           RequestArticleTypeBody typeBody = new RequestArticleTypeBody();

           typeBody.article_type_id = typeid.ToString();
           typeBody.get_flag = flag.ToString();
           typeBody.type_state = state.ToString();
           Request<RequestArticleTypeBody> request = new Request<RequestArticleTypeBody>();
           request.Body = typeBody;
           request.Header = request.NewHeader();
           request.Key = "GetArticleType";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestArticleTypeBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseArticleTypeBody>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestArticleTypeBody {
        [DataMember]
        public string article_type_id { set; get; }

        [DataMember]
        public string get_flag { set; get; }

        [DataMember]
        public string type_state { set; get; }
    }

    [DataContract]
    public class ResponseArticleTypeBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<ArticleTypeInfo> article_type_list { set; get; }
    }

   [DataContract]
   public class ArticleTypeInfo
   {
       [DataMember]
       public int article_type_id { set; get; }

       [DataMember]
       public string article_type_name { set; get; }

       [DataMember]
       public string type_path { set; get; }

       [DataMember]
       public int parent_id { set; get; }

       [DataMember]
       public int sort_no { set; get; }

       [DataMember]
       public int type_state { set; get; }
   } 
}
