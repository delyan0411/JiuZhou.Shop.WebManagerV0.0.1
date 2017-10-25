using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QuerySysFile
    {
        public static Response<ResponseQueSysBody> Do(int pagesize, int pageindex, int typeid, int isvisible, string stime, string etime, string _skey, ref int dataCount, ref int pageCount)
       {
           RequestSearchSysFileBody search = new RequestSearchSysFileBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.sp_type_id = typeid.ToString();
           search.is_visible = isvisible.ToString();
           search.start_time = stime;
           search.end_time = etime;
           search.search_key = _skey;

           Request<RequestSearchSysFileBody> request = new Request<RequestSearchSysFileBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QuerySysFile";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchSysFileBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseQueSysBody>>(responseStr);

           if (response != null && response.Body!=null && response.Body.file_list!=null)
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
    public class RequestSearchSysFileBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string sp_type_id { set; get; }

        [DataMember]
        public string is_visible { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string search_key { set; get; }
    }

    [DataContract]
    public class ResponseQueSysBody {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<SysFiles> file_list { set; get; }
    }

    [DataContract]
    public class SysFiles
    {
        [DataMember]
        public int sp_file_id { set; get; }

        [DataMember]
        public int sp_type_id { set; get; }

        [DataMember]
        public string type_code { set; get; }

        [DataMember]
        public string file_name { set; get; }

        [DataMember]
        public string save_name { set; get; }

        [DataMember]
        public string save_path { set; get; }

        [DataMember]
        public string add_time { set; get; }
    }
}
