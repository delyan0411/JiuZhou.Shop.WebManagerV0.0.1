using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class Szlmxlph
    {
        public static ConfigInfo _config = ConnStringConfig.GetConfig;
        public static Response<ResponseSzlmxlphBody> Do(int pagesize, int pageindex, string stime, string etime, ref int dataCount, ref int pageCount)
       {
           RequestSzlmxlphBody search = new RequestSzlmxlphBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.start_time = stime;
           search.end_time = etime;

           Request<RequestSzlmxlphBody> request = new Request<RequestSzlmxlphBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "Szlmxlph";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSzlmxlphBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(_config.UrlDataAnalysis,requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseSzlmxlphBody>>(responseStr);

           if (response != null && response.Body!=null && response.Body.list!=null)
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
    public class RequestSzlmxlphBody
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
    public class ResponseSzlmxlphBody
    {
        [DataMember]
        public string total_count { set; get; }

        [DataMember]
        public List<SzlmxlphInfo> list { set; get; }
    }

    [DataContract]
    public class SzlmxlphInfo
    {
        [DataMember]
        public string type_name { set; get; }

        [DataMember]
        public string product_code { set; get; }

        [DataMember]
        public string product_name { set; get; }

        [DataMember]
        public string product_num { set; get; }

        [DataMember]
        public string sale_money { set; get; }
    }
}
