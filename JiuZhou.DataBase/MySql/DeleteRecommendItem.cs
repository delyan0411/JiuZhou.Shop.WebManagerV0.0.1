using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteRecommendItem
    {
        public static Response<ResponseBodyEmpty> Do(string riids)
       {
           RequestDeleteRecommendListBody recommendBody = new RequestDeleteRecommendListBody();

           recommendBody.ri_ids = riids;

           Request<RequestDeleteRecommendListBody> request = new Request<RequestDeleteRecommendListBody>();
           request.Body = recommendBody;
           request.Header = request.NewHeader();
           request.Key = "DeleteRecommendItem";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteRecommendListBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteRecommendListBody
    {
        [DataMember]
        public string ri_ids { set; get; }
    }
}
