using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class Xptj
    {
        public static ConfigInfo _config = ConnStringConfig.GetConfig;
        public static Response<ResponseXptjBody> Do(int pagesize, int pageindex, string stime, string etime)
       {
           RequestXptjBody search = new RequestXptjBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.start_time = stime;
           search.end_time = etime;

           Request<RequestXptjBody> request = new Request<RequestXptjBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "Xptj";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestXptjBody>>(request);
           string responseStr = HttpUtils.HttpPost(_config.UrlDataAnalysis,requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseXptjBody>>(responseStr);

           return response;
       }
    }

    [DataContract]
    public class RequestXptjBody
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
    public class ResponseXptjBody
    {
        [DataMember]
        public string total_count { set; get; }

        [DataMember]
        public List<XptjInfo> list { set; get; }
    }

    [DataContract]
    public class XptjInfo
    {
        [DataMember]
        public string query_date { set; get; }

        [DataMember]
        public string sale_count { set; get; }

        [DataMember]
        public string product_count { set; get; }

        [DataMember]
        public string sale_amount { set; get; }
    }
}
