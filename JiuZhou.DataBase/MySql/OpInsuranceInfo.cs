using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class OpInsuranceInfo
    {
        public static Response<ResponseBodyEmpty> Do(int insurance_id, string insurance_name, int paytype)
        {
            RequestOpInsuranceBody insurance = new RequestOpInsuranceBody();
            insurance.insurance_id = insurance_id.ToString();
            insurance.insurance_name = insurance_name;
            insurance.paytype = paytype.ToString();
            Logger.Log(insurance_id.ToString() + insurance_name + paytype.ToString());
            Request<RequestOpInsuranceBody> request = new Request<RequestOpInsuranceBody>();
            request.Body = insurance;
            request.Header = request.NewHeader();
            request.Key = "OpInsuranceInfo";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestOpInsuranceBody>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestOpInsuranceBody
    {
        [DataMember]
        public string insurance_id { set; get; }

        [DataMember]
        public string insurance_name { set; get; }

        [DataMember]
        public string paytype { set; get; }

    } 
}
