using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetInsuranceInfo
    {
        public static Response<InsuranceInfo> Do(int id)
       {
            RequestInsuranceInfoBody body = new RequestInsuranceInfoBody();
           body.insurance_id = id.ToString();

           Request<RequestInsuranceInfoBody> request = new Request<RequestInsuranceInfoBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetInsuranceInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestInsuranceInfoBody>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<InsuranceInfo>>(responseStr);
      
           return response;
       }
    }

    [DataContract]
    public class RequestInsuranceInfoBody
    {
        [DataMember]
        public string insurance_id { set; get; }
    }

    [DataContract]
    public class InsuranceInfo
    {
        [DataMember]
        public int insurance_id { set; get; }

        [DataMember]
        public string insurance_name { set; get; }

        [DataMember]
        public int paytype { set; get; }

    } 
}
