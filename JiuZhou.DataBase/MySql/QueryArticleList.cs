using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryArticleList
    {
        public static Response<ResponseQueArticleListBody> Do(int pagesize, int pageindex, int id, string _skey, ref int dataCount, ref int pageCount)
       {
           RequestSearchArticelListBody search = new RequestSearchArticelListBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.article_type_id = id.ToString();
           search.search_key = _skey;

           Request<RequestSearchArticelListBody> request = new Request<RequestSearchArticelListBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryArticleList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchArticelListBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseQueArticleListBody>>(responseStr);
           if (response != null && response.Body != null && response.Body.rec_num!=null)
           {
               dataCount = int.Parse(response.Body.rec_num);
               if (dataCount % pagesize == 0)
               {
                   pageCount = dataCount / pagesize;
               }
               else
               {
                   pageCount = dataCount / pagesize + 1;
               }
           }
           return response;
       }
    }

    [DataContract]
    public class RequestSearchArticelListBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string article_type_id { set; get; }

        [DataMember]
        public string search_key { set; get; }
    }

    [DataContract]
    public class ResponseQueArticleListBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<ShortArticleInfo> article_list { set; get; }
    }

    [DataContract]
    public class ShortArticleInfo
    {
        [DataMember]
        public int article_id { set; get; }

        [DataMember]
        public string article_title { set; get; }

        [DataMember]
        public int article_type_id {set;get;}

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public string author_name { set; get; }

        [DataMember]
        public int sort_no { set; get; }

        [DataMember]
        public int article_state { set; get; }
    } 
}
