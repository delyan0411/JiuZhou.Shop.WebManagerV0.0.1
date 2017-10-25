using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetSysPicFile
    {
        public static Response<ResponseSpicBody> Do(int pagesize, int pageindex, int classid, DateTime starttime, DateTime endtime, string _skey, ref int dataCount, ref int pageCount)
       {
           RequestSearchPicBody search = new RequestSearchPicBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.sp_type_id = classid.ToString();
           search.start_time = starttime.ToString() ;
           search.end_time = endtime.ToString();
           search.search_word = _skey;

           Request<RequestSearchPicBody> request = new Request<RequestSearchPicBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "GetSysPicFile";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchPicBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseSpicBody>>(responseStr);

           dataCount = int.Parse(response.Body.rec_num);
           if (dataCount % pagesize == 0)
           {
               pageCount = dataCount / pagesize;
           }
           else {
               pageCount = dataCount / pagesize + 1;
           }
           return response;
       }
    }

    [DataContract]
    public class RequestSearchPicBody {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string sp_type_id { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string search_word { set; get; }
    }

    [DataContract]
    public class ResponseSpicBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<PicFile> pic_file_list { set; get; }
    }

    [DataContract]
    public class PicFile
    {
        [DataMember]
        public string save_path { set; get; }

        [DataMember]
        public string file_name { set; get; }
    } 
}
