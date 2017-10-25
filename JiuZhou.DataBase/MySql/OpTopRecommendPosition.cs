using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
   public class OpTopRecommendPosition
    {
       public static Response<ResponseBodyEmpty> Do(RecommendPositionInfo recommend)
       {
           RequestOpTopRecommendBody recommendBody = new RequestOpTopRecommendBody();
           recommendBody.rp_id = recommend.rp_id.ToString();
           recommendBody.rp_name = recommend.rp_name;
           recommendBody.rp_code = recommend.rp_code;
           recommendBody.use_plat = recommend.use_plat.ToString();
           recommendBody.op_flag = recommend.op_flag.ToString();

           Request<RequestOpTopRecommendBody> request = new Request<RequestOpTopRecommendBody>();
           request.Body = recommendBody;
           request.Header = request.NewHeader();
           request.Key = "OpTopRecommendPosition";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpTopRecommendBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpTopRecommendBody
   {
       [DataMember]
       public string rp_id { set; get; }

       [DataMember]
       public string rp_code { set; get; }

       [DataMember]
       public string rp_name { set; get; }

       [DataMember]
       public string use_plat { set; get; }

       [DataMember]
       public string op_flag { set; get; }
   } 
}
