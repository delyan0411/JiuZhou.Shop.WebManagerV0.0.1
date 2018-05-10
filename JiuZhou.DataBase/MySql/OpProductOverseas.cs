using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class OpProductOverseas
    {
        public static Response<ResponseBodyEmpty> Do(OverseasInfo overseasinfo)
        {
            Request<OverseasInfo> request = new Request<OverseasInfo>();
            request.Body = overseasinfo;
            request.Header = request.NewHeader();
            request.Key = "OpProductOverseas";
            string requestStr = JsonHelper.ObjectToJson<Request<OverseasInfo>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }
    [DataContract]
    public class OverseasInfo
    {
        [DataMember]
        public string id  { set; get; }

        [DataMember]
        public string product_id { set; get; }

        [DataMember]
        public string countrycode { set; get; }

        [DataMember]
        public string hscode { set; get; }

        [DataMember]
        public string taxrate { set; get; }

        [DataMember]
        public string isfreetax { set; get; }

        [DataMember]
        public string freestarttime { set; get; }

        [DataMember]
        public string freeendtime { set; get; }
    }

}
