using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpBrand
    {
       public static Response<ResponseBodyEmpty> Do(BrandInfo item,string delids)
       {
           BrandInfo2 body = new BrandInfo2();
           body.brand_id = item.brand_id.ToString();
           body.brand_name = item.brand_name;
           body.brand_intro = item.brand_intro;
           body.logo_src = item.logo_src;
           body.sort_no = item.sort_no.ToString();
           body.brand_state = item.brand_state.ToString();

           List<BrandAuthInfo2> list = new List<BrandAuthInfo2>();
           foreach (BrandAuthInfo em in item.auth_list) {
               BrandAuthInfo2 info = new BrandAuthInfo2();
               info.brand_auth_id = em.brand_auth_id.ToString();
               info.shop_id = em.shop_id.ToString();
               info.authorization_src = em.authorization_src;
               info.expired_time = em.expired_time;
               list.Add(info);
           }
           body.auth_list = list;
           body.del_auth_list = delids.Split(',');

           Request<BrandInfo2> request = new Request<BrandInfo2>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpBrand";
           string requestStr = JsonHelper.ObjectToJson<Request<BrandInfo2>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class BrandInfo2
    {
        [DataMember]
        public string brand_name { set; get; }

        [DataMember]
        public string brand_id { set; get; }

        [DataMember]
        public string brand_intro { set; get; }

        [DataMember]
        public string logo_src { set; get; }

        [DataMember]
        public string sort_no { set; get; }

        [DataMember]
        public string brand_state { set; get; }

        [DataMember]
        public List<BrandAuthInfo2> auth_list { set; get; }

        [DataMember]
        public string[] del_auth_list { set; get; }
    }

    [DataContract]
    public class BrandAuthInfo2 {
        [DataMember]
        public string brand_auth_id { set; get; }

        [DataMember]
        public string shop_id { set; get; }

        [DataMember]
        public string authorization_src { set; get; }

        [DataMember]
        public string expired_time { set; get; }
    }
}
