using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpRecommendPosition
    {
       public static Response<ResponseBodyEmpty> Do(List<RecommendPositionInfo> recommendlist, string deletecodes)
       {
           RequestOpRecommendBody recommendbody = new RequestOpRecommendBody();

           List<OpRecommendInfo> recommends = new List<OpRecommendInfo>();
           foreach (RecommendPositionInfo item in recommendlist)
           {
               OpRecommendInfo recommend = new OpRecommendInfo();
               recommend.rp_id = item.rp_id.ToString();
               recommend.parent_rp_code = item.parent_rp_code;
               recommend.rp_code = item.rp_code;
               recommend.rp_name = item.rp_name;
               recommend.sort_no = item.sort_no.ToString();
               recommend.use_plat = item.use_plat.ToString();
               recommend.op_flag = item.op_flag.ToString();
               recommends.Add(recommend);
           }
           recommendbody.recommend_list = recommends;
           recommendbody.del_codes = deletecodes;

           Request<RequestOpRecommendBody> request = new Request<RequestOpRecommendBody>();
           request.Body = recommendbody;
           request.Header = request.NewHeader();
           request.Key = "OpRecommendPosition";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpRecommendBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpRecommendBody
   {
       [DataMember]
       public List<OpRecommendInfo> recommend_list { set; get; }

       [DataMember]
       public string del_codes { set; get; }
   }

   [DataContract]
   public class OpRecommendInfo
   {
       [DataMember]
       public string rp_id { set; get; }

      [DataMember]
       public string parent_rp_code { set; get; }

       [DataMember]
       public string rp_code { set; get; }

       [DataMember]
       public string rp_name { set; get; }

       [DataMember]
       public string sort_no { set; get; }

       [DataMember]
       public string use_plat { set; get; }

       [DataMember]
       public string op_flag { set; get; }
   }
}
