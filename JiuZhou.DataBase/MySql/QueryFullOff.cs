using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryFullOff
    {
        public static Response<ResponseQueryFullOffBody> Do(int pagesize, int pageindex, string _skey, ref int dataCount, ref int pageCount)
       {
           RequestQueryFullOffBody search = new RequestQueryFullOffBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.search_key = _skey;

           Request<RequestQueryFullOffBody> request = new Request<RequestQueryFullOffBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryFullOff";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryFullOffBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseQueryFullOffBody>>(responseStr);

           if (response != null && response.Body != null && response.Body.fulloff_list != null)
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
    public class RequestQueryFullOffBody {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string search_key { set; get; }
    }

    [DataContract]
    public class ResponseQueryFullOffBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<FullOffInfo> fulloff_list { set; get; }
    }

    [DataContract]
    public class FullOffInfo
    {
        [DataMember]
        public int fulloff_id { set; get; }  

        [DataMember]
        public string fulloff_name { set; get; }

        [DataMember]
        public string fulloff_desc { set; get; }

        [DataMember]
        public string begin_time { set; get; }

        [DataMember]
        public string end_time { set; get; }
    } 
}
