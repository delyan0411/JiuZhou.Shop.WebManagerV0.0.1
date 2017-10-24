using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class Dpph
    {
        public static ConfigInfo _config = ConnStringConfig.GetConfig;
        public static Response<ResponseDpphBody> Do(int pagesize, int pageindex, string stime, string etime, string column, string sorttype, int typeid, ref int dataCount, ref int pageCount)
       {
           RequestDpphBody search = new RequestDpphBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.start_time = stime;
           search.end_time = etime;
           search.sort_column = column;
           search.sort_type = sorttype;
           search.filter_column = "product_type_id";
           search.filter_value = typeid.ToString();

           Request<RequestDpphBody> request = new Request<RequestDpphBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "Dpph";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDpphBody>>(request);
           string responseStr = HttpUtils.HttpPost(_config.UrlDataAnalysis,requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseDpphBody>>(responseStr);

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
    public class RequestDpphBody
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
        public string sort_column { set; get; }

        [DataMember]
        public string sort_type { set; get; }

        [DataMember]
        public string filter_value { set; get; }

        [DataMember]
        public string filter_column { set; get; }
    }

    [DataContract]
    public class ResponseDpphBody
    {
        [DataMember]
        public string total_count { set; get; }

        [DataMember]
        public List<DpphInfo> list { set; get; }
    }

    [DataContract]
    public class DpphInfo
    {
        [DataMember]
        public string query_date { set; get; }

        [DataMember]
        public string product_code { set; get; }

        [DataMember]
        public string product_name { set; get; }

        [DataMember]
        public string manu_facturer { set; get; }

        [DataMember]
        public string type_name { set; get; }

        [DataMember]
        public string sale_price { set; get; }

        [DataMember]
        public string sale_num { set; get; }

        [DataMember]
        public string sale_money { set; get; }

        [DataMember]
        public string stock_num { set; get; }

        [DataMember]
        public string page_view { set; get; }

        [DataMember]
        public string user_view { set; get; }

        [DataMember]
        public string transform_rate { set; get; }

        [DataMember]
        public string product_id { set; get; }
    }
}
