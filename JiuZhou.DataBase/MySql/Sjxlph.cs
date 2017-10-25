using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class Sjxlph
    {
        public static ConfigInfo _config = ConnStringConfig.GetConfig;
        public static Response<ResponseSjxlphBody> Do(int pagesize, int pageindex, string stime, string etime, ref int dataCount, ref int pageCount)
       {
           RequestSjxlphBody search = new RequestSjxlphBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.start_time = stime;
           search.end_time = etime;

           Request<RequestSjxlphBody> request = new Request<RequestSjxlphBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "Sjxlph";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSjxlphBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(_config.UrlDataAnalysis,requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseSjxlphBody>>(responseStr);

           if (response != null && response.Body!=null && response.Body.all_list!=null)
           {
               dataCount = int.Parse(response.Body.total_count);
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
    public class RequestSjxlphBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }
    }

    [DataContract]
    public class ResponseSjxlphBody
    {
        [DataMember]
        public string total_count { set; get; }

        [DataMember]
        public List<SjxlphInfo> list { set; get; }

        [DataMember]
        public List<SjxlphInfo> all_list { set; get; }
    }

    [DataContract]
    public class SjxlphInfo
    {
        [DataMember]
        public string query_date { set; get; }

        [DataMember]
        public string shop_name { set; get; }

        [DataMember]
        public string product_num { set; get; }

        [DataMember]
        public string sale_amount { set; get; }
    }
}
