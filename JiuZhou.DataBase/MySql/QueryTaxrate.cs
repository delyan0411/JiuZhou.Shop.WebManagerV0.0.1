using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryTaxrate
    {
        public static Response<TaxrateList> Do()
        {
            RequestBodyEmpty CountryBody = new RequestBodyEmpty();

            Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
            request.Body = CountryBody;
            request.Header = request.NewHeader();
            request.Key = "QueryTaxrate";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
            //Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            //Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<TaxrateList>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class TaxrateList
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<TaxrateInfo> taxrate_list { set; get; }
    }

    [DataContract]
    public class TaxrateInfo
    {
        [DataMember]
        public int id { set; get; }

        [DataMember]
        public string category { set; get; }

        [DataMember]
        public string type { set; get; }

        [DataMember]
        public string taxrate { set; get; }
    }
}
