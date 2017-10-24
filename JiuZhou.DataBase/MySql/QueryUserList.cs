using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryUserList
    {
        public static Response<ResponseQueUserBody> Do(int pagesize, int pageindex, int userstate, int usertype, string stime, string etime, string _skey, ref int dataCount, ref int pageCount)
       {
           RequestSearchUserBody search = new RequestSearchUserBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.user_state = userstate.ToString();
           search.user_type = usertype.ToString();
           search.start_time = stime;
           search.end_time = etime;
           search.search_key = _skey;

           Request<RequestSearchUserBody> request = new Request<RequestSearchUserBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryUserList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchUserBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseQueUserBody>>(responseStr);

           if (response != null && response.Body!=null && response.Body.user_list!=null)
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
    public class RequestSearchUserBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string user_state { set; get; }

        [DataMember]
        public string user_type { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string search_key { set; get; }
    }

    [DataContract]
    public class ResponseQueUserBody {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<ShortUserInfo> user_list { set; get; }
    }

    [DataContract]
    public class ShortUserInfo
    {
        [DataMember]
        public int user_id { set; get; }

        [DataMember]
        public string user_name { set; get; }

        [DataMember]
        public string real_name { set; get; }

        [DataMember]
        public string mobile_no { set; get; }

        [DataMember]
        public string user_email { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public string last_login_time { set; get; }

        [DataMember]
        public string last_login_ip { set; get; }

        [DataMember]
        public int user_state { set; get; }

        [DataMember]
        public string unlock_time { set; get; }

        [DataMember]
        public int user_type { set; get; }
    }
}
