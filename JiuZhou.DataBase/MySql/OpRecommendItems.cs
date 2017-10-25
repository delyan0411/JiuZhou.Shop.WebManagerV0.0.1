using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpRecommendItems
    {
       public static Response<ResponseBodyEmpty> Do(RecommendListInfo items)
       {
           OpRecommendListInfo recommendbody = new OpRecommendListInfo();
           recommendbody.ri_id = items.ri_id.ToString();
           recommendbody.rp_id = items.rp_id.ToString();
           recommendbody.ri_type = items.ri_type.ToString();
           recommendbody.ri_value = items.ri_value;
           recommendbody.product_id = items.product_id.ToString();
           recommendbody.product_brand = items.product_brand;
           recommendbody.page_src = items.page_src;
           recommendbody.img_src = items.img_src;
           recommendbody.ri_subject = items.ri_subject;
           recommendbody.ri_summary = items.ri_summary;
           recommendbody.start_time = items.start_time;
           recommendbody.end_time = items.end_time;
           recommendbody.use_plat = items.use_plat.ToString();
           recommendbody.icon_name = items.icon_name;

           Request<OpRecommendListInfo> request = new Request<OpRecommendListInfo>();
           request.Body = recommendbody;
           request.Header = request.NewHeader();
           request.Key = "OpRecommendItem";
           string requestStr = JsonHelper.ObjectToJson<Request<OpRecommendListInfo>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
    [DataContract]
    public class OpRecommendListInfo
    {
        [DataMember]
        public string rp_id { set; get; }

        [DataMember]
        public string ri_id { set; get; }

        [DataMember]
        public string ri_type { set; get; }

        [DataMember]
        public string ri_value { set; get; }

        [DataMember]
        public string product_id { set; get; }

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
        public string use_plat { set; get; }

        [DataMember]
        public string icon_name { set; get; }
    }
}
