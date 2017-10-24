using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetShopDetail
    {
        public static Response<ShopInfo> Do(int shopId)
       {
           RequestShopInfoBody shopsBody = new RequestShopInfoBody();

           shopsBody.shop_id = shopId.ToString();
           Request<RequestShopInfoBody> request = new Request<RequestShopInfoBody>();
           request.Body = shopsBody;
           request.Header = request.NewHeader();
           request.Key = "GetShopDetail";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestShopInfoBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ShopInfo>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestShopInfoBody {
        [DataMember]
        public string shop_id { set; get; }
    }

   [DataContract]
    public class ShopInfo
   {
       [DataMember] 
       public int shop_id { set; get; }

       [DataMember]
       public string shop_name { set; get; }

       [DataMember]
       public int shop_state { set; get; }

       [DataMember]
       public string shop_addr { set; get; }

       [DataMember]
       public string company_name { set; get; }

       [DataMember]
       public string home_url { set; get; }

       [DataMember]
       public string link_way { set; get; }

       [DataMember]
       public string shop_remark { set; get; }

       [DataMember]
       public int area_id { set; get; }

       [DataMember]
       public string shop_key { set; get; }

       [DataMember]
       public string shop_pswd { set; get; }

       [DataMember]
       public string support_express { set; get; }

       [DataMember]
       public string delivery_intro { set; get; }

       [DataMember]
       public string service_intro { set; get; }

       [DataMember]
       public string shop_notice { set; get; }

       [DataMember]
       public string notice_btime { set; get; }

       [DataMember]
       public string notice_etime { set; get; }
   } 
}
