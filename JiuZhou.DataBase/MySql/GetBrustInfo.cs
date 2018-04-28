using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetBrustInfo
    {
        public static Response<BrustInfoList> Do()
       {
            RequestBodyEmpty Body = new RequestBodyEmpty();

           Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
           request.Body = Body;
           request.Header = request.NewHeader();
           request.Key = "GetBrustInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<BrustInfoList>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class BrustInfoList
    {
        [DataMember]
        public List<BrustInfo> brust_list { set; get; }
    }
    [DataContract]
    public class BrustInfo
    {
        [DataMember]
        public int product_id { set; get; }
        [DataMember]
        public string brust_intro { set; get; }
    }
}
