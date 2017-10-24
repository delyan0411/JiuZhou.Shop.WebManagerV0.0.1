using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class Ppph
    {
        public static ConfigInfo _config = ConnStringConfig.GetConfig;
        public static Response<ResponsePpphBody> Do(int pagesize, int pageindex, string stime, string etime, ref int dataCount, ref int pageCount)
       {
           RequestPpphBody search = new RequestPpphBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.start_time = stime;
           search.end_time = etime;

           Request<RequestPpphBody> request = new Request<RequestPpphBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "Ppph";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestPpphBody>>(request);
           string responseStr = HttpUtils.HttpPost(_config.UrlDataAnalysis,requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponsePpphBody>>(responseStr);

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
    public class RequestPpphBody
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
    public class ResponsePpphBody
    {
        [DataMember]
        public string total_count { set; get; }

       // [DataMember]
       // public List<PpphInfo> list { set; get; }

        [DataMember]
        public List<PpphInfo> all_list { set; get; }
    }

    [DataContract]
    public class PpphInfo
    {
        [DataMember]
        public string query_date { set; get; }

        [DataMember]
        public string brand_name { set; get; }

        [DataMember]
        public string sale_amount { set; get; }

        [DataMember]
        public string week_sku_rate { set; get; }

        [DataMember]
        public string product_num { set; get; }
    }
}
