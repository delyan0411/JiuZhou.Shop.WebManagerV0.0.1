using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetShopInfo
    {
        public static Response<ShopInfos> Do(int shopId)
       {
           RequestShopsBody shopsBody = new RequestShopsBody();

           shopsBody.shop_id = shopId.ToString();
           Request<RequestShopsBody> request = new Request<RequestShopsBody>();
           request.Body = shopsBody;
           request.Header = request.NewHeader();
           request.Key = "GetShopInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestShopsBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ShopInfos>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestShopsBody {
        [DataMember]
        public string shop_id { set; get; }
    }

    [DataContract]
    public class ShopInfos
    {
        [DataMember]
        public List<ShopList> shop_list { set; get; }
    }
   [DataContract]
    public class ShopList
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
   } 
}
