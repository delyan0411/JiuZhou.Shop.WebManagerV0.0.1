using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetInsusertype
    {
        public static Response<InsurancetypeInfo> Do(int id)
        {
            RequestInsurancetypeInfoBody body = new RequestInsurancetypeInfoBody();
            body.id = id.ToString();
            Request<RequestInsurancetypeInfoBody> request = new Request<RequestInsurancetypeInfoBody>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "GetInsusertype";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestInsurancetypeInfoBody>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<InsurancetypeInfo>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestInsurancetypeInfoBody
    {
        [DataMember]
        public string id { set; get; }
    }

    [DataContract]
    public class InsurancetypeInfo
    {
        [DataMember]
        public int id { set; get; }

        [DataMember]
        public int  insurancetype { set; get; }

        [DataMember]
        public string usertype { set; get; }

        [DataMember]
        public string addtime { set; get; }

    } 
}
