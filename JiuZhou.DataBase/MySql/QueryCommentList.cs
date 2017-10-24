using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryCommentList
    {
        public static Response<ResponseSearchCommentBody> Do(int pagesize, int pageindex, int state, int mark, int _type, string _skey, string sdate, string edate, string colname, string type, ref int dataCount, ref int pageCount)
       {
           RequestSearchCommentBody search = new RequestSearchCommentBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.comment_state = state.ToString();
           search.user_mark = mark.ToString();
           search.search_key = _skey;
           search.start_date = sdate;
           search.end_date = edate;
           search.sort_column = colname;
           search.sort_type = type;
           search.auto_comment = _type.ToString();

           Request<RequestSearchCommentBody> request = new Request<RequestSearchCommentBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryCommentList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchCommentBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseSearchCommentBody>>(responseStr);
           if (response != null && response.Body != null && response.Body.comment_list != null)
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
    public class RequestSearchCommentBody {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string comment_state { set; get; }

        [DataMember]
        public string user_mark { set; get; }

        [DataMember]
        public string search_key { set; get; }

        [DataMember]
        public string start_date { set; get; }

        [DataMember]
        public string end_date { set; get; }

        [DataMember]
        public string sort_column { set; get; }

        [DataMember]
        public string sort_type { set; get; }

        [DataMember]
        public string auto_comment { set; get; }
    }

    [DataContract]
    public class ResponseSearchCommentBody {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<CommentInfo> comment_list { set; get; }
    }

    [DataContract]
    public class CommentInfo
    {
        [DataMember]
        public int product_comment_id { set; get; }  

        [DataMember]
        public int product_id { set; get; }

        [DataMember]
        public string comment_user_name { set; get; }

        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public int user_mark { set; get; }

        [DataMember]
        public int comment_state { set; get; }

        [DataMember]
        public string comment_content { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public string reply_user_id { set; get; }

        [DataMember]
        public string reply_text { set; get; }

        [DataMember]
        public string reply_time { set; get; }

        [DataMember]
        public int auto_comment { set; get; }

    } 
}
