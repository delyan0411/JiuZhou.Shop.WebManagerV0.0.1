using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class AddRelationRecommend
    {
        public static Response<ResponseBodyEmpty> Do(int mainid, int type ,List<int> ids)
       {
           RelationnRecomment relation = new RelationnRecomment();

           relation.main_product_id = mainid.ToString();
           relation.recommend_type = type.ToString();

           List<RecommendList> recommendlist = new List<RecommendList>();
           foreach (int i in ids) {
               RecommendList recommend = new RecommendList();
               recommend.product_id = i.ToString();
               recommendlist.Add(recommend);
           }
           relation.recommend_list = recommendlist;

           Request<RelationnRecomment> request = new Request<RelationnRecomment>();
           request.Body = relation;
           request.Header = request.NewHeader();
           request.Key = "AddRelationRecommend";
           string requestStr = JsonHelper.ObjectToJson<Request<RelationnRecomment>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RelationnRecomment
    {
        [DataMember]
        public string main_product_id { set; get; }

        [DataMember]
        public string recommend_type { set; get; }

        [DataMember]
        public List<RecommendList> recommend_list { set; get; }
    }

    [DataContract]
    public class RecommendList
    {
        [DataMember]
        public string product_id { set; get; }
    }
}
