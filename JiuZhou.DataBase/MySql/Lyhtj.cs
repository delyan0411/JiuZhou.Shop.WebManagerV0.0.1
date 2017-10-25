using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class Lyhtj
    {
        public static ConfigInfo _config = ConnStringConfig.GetConfig;
        public static Response<ResponseLyhtjBody> Do(int pagesize, int pageindex, string stime, string etime)
       {
           RequestLyhtjBody search = new RequestLyhtjBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.start_time = stime;
           search.end_time = etime;

           Request<RequestLyhtjBody> request = new Request<RequestLyhtjBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "Lyhtj";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestLyhtjBody>>(request);
           string responseStr = HttpUtils.HttpPost(_config.UrlDataAnalysis,requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseLyhtjBody>>(responseStr);

           return response;
       }
    }

    [DataContract]
    public class RequestLyhtjBody
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
    public class ResponseLyhtjBody
    {
        [DataMember]
        public string total_count { set; get; }

        [DataMember]
        public List<LyhtjInfo> list { set; get; }
    }

    [DataContract]
    public class LyhtjInfo
    {
        [DataMember]
        public string query_date { set; get; }

        [DataMember]
        public string sale_amount { set; get; }

        [DataMember]
        public string amount_percet { set; get; }

        [DataMember]
        public string payment_count { set; get; }

        [DataMember]
        public string payment_percent { set; get; }

        [DataMember]
        public string order_count { set; get; }
    }
}
