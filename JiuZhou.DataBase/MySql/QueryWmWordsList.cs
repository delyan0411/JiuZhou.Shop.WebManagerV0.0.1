using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryWmWordsList
    {
        public static Response<ResponseQueryWmWordsListBody> Do(int pagesize, int pageindex, string searchwords, string stime, string etime, ref int dataCount, ref int pageCount)
       {
            RequestWmWordsBody search = new RequestWmWordsBody();

            search.page_size = pagesize.ToString();
            search.page_no = pageindex.ToString();
            search.search_key = searchwords.ToString();
            search.start_time = stime.ToString();
            search.end_time = etime.ToString();
            Request<RequestWmWordsBody> request = new Request<RequestWmWordsBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "GetSearchWordList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestWmWordsBody>>(request);
            Logger.Log(requestStr);
           string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseQueryWmWordsListBody>>(responseStr);
           return response;
       }
    }
    [DataContract]
    public class RequestWmWordsBody
    {
        [DataMember]
        public string search_key { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }
    }

    [DataContract]
    public class ResponseQueryWmWordsListBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<WmWordsInfo> word_list { set; get; }
    }

    [DataContract]
    public class WmWordsInfo
    {
        [DataMember]
        public string word_id { set; get; }

        [DataMember]
        public string word_name { set; get; }

        [DataMember]
        public int user_id { set; get; }

        [DataMember]
        public string add_time { set; get; }
    } 
}
