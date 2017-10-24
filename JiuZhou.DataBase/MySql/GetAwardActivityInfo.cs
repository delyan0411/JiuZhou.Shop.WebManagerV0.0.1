using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetAwardActivityInfo
    {
        public static Response<AwardActivityInfo> Do(int id)
       {
           RequestRewardActivityBody body = new RequestRewardActivityBody();

           body.award_activity_id = id.ToString();

           Request<RequestRewardActivityBody> request = new Request<RequestRewardActivityBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetAwardActivityInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestRewardActivityBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<AwardActivityInfo>>(responseStr);
      
           return response;
       }
    }

    [DataContract]
    public class RequestRewardActivityBody
    {
        [DataMember]
        public string award_activity_id { set; get; }
    }
}
