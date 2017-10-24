using JiuZhou.HttpTools;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace JiuZhou.MySql
{
    public class QueryHelpList
    {
        public static Response<ResponseQueHelpListBody> Do(int pagesize, int pageindex, int id, string _skey, ref int dataCount, ref int pageCount)
       {
           RequestSearchHelpListBody search = new RequestSearchHelpListBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.help_type_id = id.ToString();
           search.search_key = _skey;

           Request<RequestSearchHelpListBody> request = new Request<RequestSearchHelpListBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryHelpList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchHelpListBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseQueHelpListBody>>(responseStr);
           ;
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
    public class RequestSearchHelpListBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string help_type_id { set; get; }

        [DataMember]
        public string search_key { set; get; }
    }

    [DataContract]
    public class ResponseQueHelpListBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<ShortHelpInfo> help_list { set; get; }
    }

    [DataContract]
    public class ShortHelpInfo
    {
        [DataMember]
        public int help_id { set; get; }

        [DataMember]
        public string help_title { set; get; }

        [DataMember]
        public int help_type_id {set;get;}

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public string author_name { set; get; }

        [DataMember]
        public int sort_no { set; get; }

        [DataMember]
        public int help_state { set; get; }
    } 
}
