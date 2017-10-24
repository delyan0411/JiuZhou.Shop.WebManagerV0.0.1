using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyRecommendItemSortNo
    {
        public static Response<ResponseBodyEmpty> Do(List<ModifyRecommendList> recommendlist)
       {
           RequestModySortnoBody recommendBody = new RequestModySortnoBody();
           List<ModifyRecommendList> list = new List<ModifyRecommendList>();
           foreach (ModifyRecommendList item in recommendlist) {
               ModifyRecommendList recommend = new ModifyRecommendList();
               recommend.ri_id = item.ri_id;
               recommend.sort_no = item.sort_no;
               list.Add(recommend);
           }
           recommendBody.recommend_list = list;

           Request<RequestModySortnoBody> request = new Request<RequestModySortnoBody>();
           request.Body = recommendBody;
           request.Header = request.NewHeader();
           request.Key = "ModifyRecommendItemSortNo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModySortnoBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModySortnoBody
   {
       [DataMember]
       public List<ModifyRecommendList> recommend_list { set; get; }
   }

   [DataContract]
   public class ModifyRecommendList {
       [DataMember]
       public string ri_id { set; get; }

       [DataMember]
       public string sort_no { set; get; }
   }
}
