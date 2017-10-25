using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryTopicList
    {
        public static Response<ResponseQueryTopicBody> Do(int pagesize, int pageindex, string _skey, ref int dataCount, ref int pageCount)
       {
           RequestQueryTopicBody search = new RequestQueryTopicBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.search_key = _skey;

           Request<RequestQueryTopicBody> request = new Request<RequestQueryTopicBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryTopicList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryTopicBody>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseQueryTopicBody>>(responseStr);

           if (response != null && response.Body != null && response.Body.topic_list != null)
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
    public class RequestQueryTopicBody {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string search_key { set; get; }
    }

    [DataContract]
    public class ResponseQueryTopicBody {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<TopicInfo> topic_list { set; get; }
    }

    [DataContract]
    public class TopicInfo
    {
        [DataMember]
        public int st_id { set; get; }  

        [DataMember]
        public string st_dir { set; get; }

        [DataMember]
        public string st_subject { set; get; }

        [DataMember]
        public int st_state { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public int module_count { set; get; }

        [DataMember]
        public int type { set; get; }
        
    } 
}
