using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class OrderAmount
    {
        public static ConfigInfo _config = ConnStringConfig.GetConfig;
        public static Response<ResponseOrderAmountBody> Do()
       {
           RequestBodyEmpty search = new RequestBodyEmpty();

           Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "OrderAmount";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
           string responseStr = HttpUtils.HttpPost(_config.UrlDataAnalysis,requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseOrderAmountBody>>(responseStr);

           return response;
       }
    }

    [DataContract]
    public class ResponseOrderAmountBody
    {
        [DataMember]
        public string total_count { set; get; }

        [DataMember]
        public List<OrderAmountInfo> list { set; get; }
    }

    [DataContract]
    public class OrderAmountInfo
    {
        [DataMember]
        public string amount_by_chargetime { set; get; }

        [DataMember]
        public string payment_order_count { set; get; }

        [DataMember]
        public string total_order_count { set; get; }
    }
}
