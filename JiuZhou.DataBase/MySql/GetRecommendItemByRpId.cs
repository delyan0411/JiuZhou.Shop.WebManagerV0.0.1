using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetRecommendItemByRpId
    {
        public static Response<ResponseRecommendList> Do(int posid)
       {
           RequestRecommendListBody recommendlist = new RequestRecommendListBody();

           recommendlist.rp_id = posid.ToString();

           Request<RequestRecommendListBody> request = new Request<RequestRecommendListBody>();
           request.Body = recommendlist;
           request.Header = request.NewHeader();
           request.Key = "GetRecommendItemByRpId";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestRecommendListBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseRecommendList>>(responseStr);

           return response;
       }
    }

    [DataContract]
    public class RequestRecommendListBody {
        [DataMember]
        public string rp_id { set; get; }
    }

    [DataContract]
    public class ResponseRecommendList {
        [DataMember]
        public List<RecommendListInfo> item_list { set; get; }
    }

    [DataContract]
    public class RecommendListInfo {
        [DataMember]
        public int rp_id { set; get; }

        [DataMember]
        public int ri_id { set; get; }

        [DataMember]
        public int ri_type { set; get; }

        [DataMember]
        public string ri_value { set; get; }

        [DataMember]
        public int product_id { set; get; }

        [DataMember]
        public string product_brand { set; get; }

        [DataMember]
        public string page_src { set; get; }

        [DataMember]
        public string img_src { set; get; }

        [DataMember]
        public string ri_subject { set; get; }

        [DataMember]
        public string ri_summary { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public int use_plat { set; get; }

        [DataMember]
        public string icon_name { set; get; }
    }
}
