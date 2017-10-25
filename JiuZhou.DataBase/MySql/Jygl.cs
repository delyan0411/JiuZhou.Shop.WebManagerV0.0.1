using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class Jygl
    {
        public static ConfigInfo _config = ConnStringConfig.GetConfig;
        public static Response<ResponseJyglBody> Do(int pagesize, int pageindex, string stime, string etime)
       {
           RequestJyglBody search = new RequestJyglBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.start_time = stime;
           search.end_time = etime;

           Request<RequestJyglBody> request = new Request<RequestJyglBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "Jygl";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestJyglBody>>(request);
           string responseStr = HttpUtils.HttpPost(_config.UrlDataAnalysis, requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseJyglBody>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestJyglBody
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
    public class ResponseJyglBody
    {
        [DataMember]
        public string total_count { set; get; }

        [DataMember]
        public List<JyglInfo> list { set; get; }

        [DataMember]
        public string sale_product_count_in_all { set; get; }

        [DataMember]
        public string pay_order_in_all { set; get; }

        [DataMember]
        public string people_num_in_all { set; get; }

        [DataMember]
        public string delivery_rate_in_all { set; get; }

        [DataMember]
        public string specific_delivery_rate_in_all { set; get; }
    }

    [DataContract]
    public class JyglInfo
    {
        [DataMember]
        public string query_date { set; get; }

        [DataMember]
        public string amount_by_chargetime { set; get; }

        [DataMember]
        public string amount_by_delivery_time { set; get; }

        [DataMember]
        public string sell_profit { set; get; }

        [DataMember]
        public string profit_percent { set; get; }

        [DataMember]
        public string payment_order_count { set; get; }

        [DataMember]
        public string total_order_count { set; get; }

        [DataMember]
        public string sale_product_count { set; get; }

        [DataMember]
        public string delivery_rate { set; get; }

        [DataMember]
        public string specific_delivery_rate { set; get; }

        [DataMember]
        public string page_view { set; get; }

        [DataMember]
        public string user_view { set; get; }

        [DataMember]
        public string transform_rate { set; get; }

        [DataMember]
        public string payment_per_client { set; get; }

        [DataMember]
        public string payment_rate { set; get; }

        [DataMember]
        public string people_num { set; get; }

        [DataMember]
        public string all_on_sale_product_num { set; get; }

        [DataMember]
        public string amount { set; get; }

        [DataMember]
        public string amount_web { set; get; }

        [DataMember]
        public string amount_mirco { set; get; }

        [DataMember]
        public string amount_ios { set; get; }

        [DataMember]
        public string amount_android { set; get; }
    }
}
