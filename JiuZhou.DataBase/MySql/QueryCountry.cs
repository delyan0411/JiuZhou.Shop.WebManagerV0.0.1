using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryCountry
    {
        public static Response<ContryList> Do()
        {
            RequestBodyEmpty CountryBody = new RequestBodyEmpty();

            Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
            request.Body = CountryBody;
            request.Header = request.NewHeader();
            request.Key = "QueryCountry";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
            //Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            //Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ContryList>>(responseStr);
            return response;
        }
    }

   [DataContract]
   public class ContryList
   {
       [DataMember]
       public string rec_num { set; get; }

       [DataMember]
       public List<CountryInfo> country_list { set; get; }
   }

   [DataContract]
   public class CountryInfo {
       [DataMember]
       public int id { set; get; }

       [DataMember]
       public string code { set; get; }

       [DataMember]
       public string en { set; get; }

       [DataMember]
       public string cn { set; get; }

       [DataMember]
       public string flagimg { set; get; }
   }
}
