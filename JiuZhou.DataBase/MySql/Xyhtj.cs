using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class Xyhtj
    {
        public static ConfigInfo _config = ConnStringConfig.GetConfig;
        public static Response<ResponseXyhtjBody> Do(int pagesize, int pageindex, string stime, string etime)
       {
           RequestXyhtjBody search = new RequestXyhtjBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.start_time = stime;
           search.end_time = etime;

           Request<RequestXyhtjBody> request = new Request<RequestXyhtjBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "Xyhtj";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestXyhtjBody>>(request);
           string responseStr = HttpUtils.HttpPost(_config.UrlDataAnalysis,requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseXyhtjBody>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestXyhtjBody
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
    public class ResponseXyhtjBody
    {
        [DataMember]
        public string total_count { set; get; }

        [DataMember]
        public List<XyhtjInfo> list { set; get; }
    }

    [DataContract]
    public class XyhtjInfo
    {
        [DataMember]
        public string query_date { set; get; }

        [DataMember]
        public string register_count { set; get; }

        [DataMember]
        public string payment_count { set; get; }

        [DataMember]
        public string order_count { set; get; }
    }
}
