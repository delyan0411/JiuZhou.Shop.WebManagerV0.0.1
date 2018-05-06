using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class OpInsuranceTypeInfo
    {
        public static Response<ResponseBodyEmpty> Do(int id, int insurancetype, string usertype)
        {
            RequestOpInsuranceTypeBody insurance = new RequestOpInsuranceTypeBody();
            insurance.id = id.ToString();
            insurance.insurancetype = insurancetype.ToString();
            insurance.usertype = usertype.ToString();
            Request<RequestOpInsuranceTypeBody> request = new Request<RequestOpInsuranceTypeBody>();
            request.Body = insurance;
            request.Header = request.NewHeader();
            request.Key = "OpInsusertype";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestOpInsuranceTypeBody>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestOpInsuranceTypeBody
    {
        [DataMember]
        public string id { set; get; }

        [DataMember]
        public string insurancetype { set; get; }

        [DataMember]
        public string usertype { set; get; }

    } 
}
