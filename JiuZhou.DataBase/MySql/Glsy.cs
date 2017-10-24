using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class Glsy
    {
        public static ConfigInfo _config = ConnStringConfig.GetConfig;
        public static Response<GlsyInfo> Do()
       {
           RequestBodyEmpty search = new RequestBodyEmpty();

           Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "Glsy";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
           string responseStr = HttpUtils.HttpPost(_config.UrlDataAnalysis,requestStr);
           var response = JsonHelper.JsonToObject<Response<GlsyInfo>>(responseStr);

           return response;
       }
    }

    [DataContract]
    public class GlsyInfo
    {
        [DataMember]
        public string new_order_num { set; get; }

        [DataMember]
        public string non_pay_order { set; get; }

        [DataMember]
        public string non_deliver_order { set; get; }

        [DataMember]
        public string new_user_add { set; get; }

        [DataMember]
        public string sale_money { set; get; }

        [DataMember]
        public string per_client_price { set; get; }

        [DataMember]
        public string new_comment_add { set; get; }

        [DataMember]
        public string non_solve { set; get; }

        [DataMember]
        public List<PayInfo> list {set;get;}
    }

    [DataContract]
    public class PayInfo
    {
        [DataMember]
        public string date { set; get; }

        [DataMember]
        public string amount_by_deliver_time { set; get; }

        [DataMember]
        public string amount_by_chargetime { set; get; }

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
