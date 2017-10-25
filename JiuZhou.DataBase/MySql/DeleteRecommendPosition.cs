using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteRecommendPosition
    {
        public static Response<ResponseBodyEmpty> Do(string rpids)
       {
           RequestDeleteRecommendBody recommendBody = new RequestDeleteRecommendBody();

           recommendBody.rp_ids = rpids;

           Request<RequestDeleteRecommendBody> request = new Request<RequestDeleteRecommendBody>();
           request.Body = recommendBody;
           request.Header = request.NewHeader();
           request.Key = "DeleteRecommendPosition";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteRecommendBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteRecommendBody
    {
        [DataMember]
        public string rp_ids { set; get; }
    }
}
