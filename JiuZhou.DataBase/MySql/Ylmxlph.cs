using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class Ylmxlph
    {
        public static ConfigInfo _config = ConnStringConfig.GetConfig;
        public static Response<ResponseYlmxlphBody> Do(int pagesize, int pageindex, string stime, string etime, string column, int value) 
       {
           RequestYlmxlphBody search = new RequestYlmxlphBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.start_time = stime;
           search.end_time = etime;
           search.filter_column = column;
           search.filter_value = value.ToString();

           Request<RequestYlmxlphBody> request = new Request<RequestYlmxlphBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "Ylmxlph";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestYlmxlphBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(_config.UrlDataAnalysis,requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseYlmxlphBody>>(responseStr);

           return response;
       }
    }

    [DataContract]
    public class RequestYlmxlphBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string filter_column { set; get; }

        [DataMember]
        public string filter_value { set; get; }
    }

    [DataContract]
    public class ResponseYlmxlphBody
    {
        [DataMember]
        public string total_count { set; get; }

        [DataMember]
        public string sku { set; get; }

        [DataMember]
        public string sku_rate { set; get; }

        [DataMember]
        public List<YlmxlphInfo> list { set; get; }

        [DataMember]
        public List<YlmxlphInfo> countAll { set; get; }
    }

    [DataContract]
    public class YlmxlphInfo
    {
        [DataMember]
        public string query_date { set; get; }

        [DataMember]
        public string shop_name { set; get; }

        [DataMember]
        public string sale_percent { set; get; }

        [DataMember]
        public List<YlmxlphDetails> type_details { set; get; }
    }

    [DataContract]
    public class YlmxlphDetails
    {
        [DataMember]
        public string type_name { set; get; }

        [DataMember]
        public string product_num { set; get; }

        [DataMember]
        public string sale_money { set; get; }

        [DataMember]
        public string type_sku { set; get; }

        [DataMember]
        public string type_sku_rate { set; get; }

        [DataMember]
        public string month_sku_rate { set; get; }

        [DataMember]
        public string week_sku_rate { set; get; }
    }
}
