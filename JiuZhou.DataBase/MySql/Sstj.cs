using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class Sstj
    {
        public static ConfigInfo _config = ConnStringConfig.GetConfig;
        public static Response<ResponseSstjBody> Do()
       {
           RequestBodyEmpty search = new RequestBodyEmpty();

           Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "Sstj";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
           string responseStr = HttpUtils.HttpPost(_config.UrlDataAnalysis,requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseSstjBody>>(responseStr);

           return response;
       }
    }


    [DataContract]
    public class ResponseSstjBody
    {
        [DataMember]
        public string total_count { set; get; }

        [DataMember]
        public List<SstjInfo> list { set; get; }
    }

    [DataContract]
    public class SstjInfo
    {
        [DataMember]
        public string query_date { set; get; }

        [DataMember]
        public string amount_by_chargetime { set; get; }

        [DataMember]
        public string payment_order_count { set; get; }
    }
}
