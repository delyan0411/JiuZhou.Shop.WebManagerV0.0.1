using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetRedPackInfo
    {
        public static Response<RedPackInfo> Do(int id)
       {
           RequestRedPackBody body = new RequestRedPackBody();
           body.redpack_rule_id = id.ToString();
           Request<RequestRedPackBody> request = new Request<RequestRedPackBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetRedPackInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestRedPackBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<RedPackInfo>>(responseStr);
      
           return response;
       }
    }

    [DataContract]
    public class RequestRedPackBody
    {
        [DataMember]
        public string redpack_rule_id { set; get; }
    }
}
