using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetRecommendPositionByCode
    {
        public static Response<ResponseRecommendPosition> Do(string code, int plat)
       {
           RequestRecommendPositionBody positionBody = new RequestRecommendPositionBody();

           positionBody.parent_rp_code = code;
           positionBody.use_plat = plat.ToString();
           Request<RequestRecommendPositionBody> request = new Request<RequestRecommendPositionBody>();
           request.Body = positionBody;
           request.Header = request.NewHeader();
           request.Key = "GetRecommendPositionByCode";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestRecommendPositionBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseRecommendPosition>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestRecommendPositionBody
    {
        [DataMember]
        public string parent_rp_code { set; get; }

        [DataMember]
        public string use_plat { set; get; }
    }

    [DataContract]
    public class ResponseRecommendPosition
    {
        [DataMember]
        public List<ShortRecommendPosition> recommend_list { set; get; }
    }

   [DataContract]
    public class ShortRecommendPosition
   {
       [DataMember]
       public int rp_id { set; get; }

       [DataMember]
       public string rp_name { set; get; }

       [DataMember]
       public string rp_path { set; get; }

       [DataMember]
       public string rp_code { set; get; }

       [DataMember]
       public string add_time { set; get; }

       [DataMember]
       public int use_plat { set; get; }
   } 
}
