using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetOverseasProductId
    {
        public static Response<OverseasInfo> Do(int productId)
        {
            RequestOverseasBody overseasBody = new RequestOverseasBody();
            overseasBody.product_id = productId.ToString();
            Request<RequestOverseasBody> request = new Request<RequestOverseasBody>();
            request.Body = overseasBody;
            request.Header = request.NewHeader();
            request.Key = "GetOverseasProductId";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestOverseasBody>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<OverseasInfo>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestOverseasBody
    {
        [DataMember]
        public string product_id { set; get; }
    }
    [DataContract]
    public class OverseasInfo
    {
        [DataMember]
        public int id { set; get; }

        [DataMember]
        public string product_id { set; get; }

        [DataMember]
        public string countrycode { set; get; }

        [DataMember]
        public string hscode { set; get; }

        [DataMember]
        public string taxrate { set; get; }

        [DataMember]
        public int isfreetax { set; get; }

        [DataMember]
        public string freestarttime { set; get; }

        [DataMember]
        public string freeendtime { set; get; }
    }
}
