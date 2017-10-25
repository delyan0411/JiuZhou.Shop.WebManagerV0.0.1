using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetRecommendPositionInfo
    {
        public static Response<RecommendPositionInfo> Do(int rpid)
       {
           RequestRecommendPositionIdBody positionBody = new RequestRecommendPositionIdBody();

           positionBody.rp_id = rpid.ToString();
           Request<RequestRecommendPositionIdBody> request = new Request<RequestRecommendPositionIdBody>();
           request.Body = positionBody;
           request.Header = request.NewHeader();
           request.Key = "GetRecommendPositionInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestRecommendPositionIdBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<RecommendPositionInfo>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestRecommendPositionIdBody
    {
        [DataMember]
        public string rp_id { set; get; }
    }

   [DataContract]
    public class RecommendPositionInfo
   {
       [DataMember]
       public int rp_id { set; get; }

       [DataMember]
       public string rp_code { set; get; }

       [DataMember]
       public string parent_rp_code { set; get; }

       [DataMember]
       public string rp_name { set; get; }

       [DataMember]
       public string rp_path { set; get; }

       [DataMember]
       public string name_path { set; get; }

       [DataMember]
       public long sort_no { set; get; }

       [DataMember]
       public int use_plat { set; get; }

       [DataMember]
       public int op_flag { set; get; }
   } 
}
