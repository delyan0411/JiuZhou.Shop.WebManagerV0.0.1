using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class DeleteRelationRecommend
    {
        public static Response<ResponseBodyEmpty> Do(int mainid, int relationid)
       {
           DRelationnRecomment relation = new DRelationnRecomment();

           relation.main_product_id = mainid.ToString();
           relation.recommend_product_id = relationid.ToString();

           Request<DRelationnRecomment> request = new Request<DRelationnRecomment>();
           request.Body = relation;
           request.Header = request.NewHeader();
           request.Key = "DeleteRelationRecommend";
           string requestStr = JsonHelper.ObjectToJson<Request<DRelationnRecomment>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class DRelationnRecomment
    {
        [DataMember]
        public string main_product_id { set; get; }

        [DataMember]
        public string recommend_product_id { set; get; }
    } 
}
