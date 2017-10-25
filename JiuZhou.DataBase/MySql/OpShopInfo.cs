using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpShopInfo
    {
       public static Response<ResponseBodyEmpty> Do(ShopInfo shop)
       {
           RequestOpShopBody shopBody = new RequestOpShopBody();
           shopBody.shop_id = shop.shop_id.ToString();
           shopBody.shop_name = shop.shop_name;
           shopBody.company_name = shop.company_name;
           shopBody.shop_addr = shop.shop_addr;
           shopBody.link_way = shop.link_way;
           shopBody.shop_remark = shop.shop_remark;
           shopBody.area_id = shop.area_id.ToString();
           shopBody.shop_key = shop.shop_key;
           shopBody.shop_pswd = shop.shop_pswd;
           shopBody.support_express = shop.support_express;
           shopBody.delivery_intro = shop.delivery_intro;
           shopBody.service_intro = shop.service_intro;
           shopBody.shop_notice = shop.shop_notice;
           shopBody.notice_btime = shop.notice_btime;
           shopBody.notice_etime = shop.notice_etime;

           Request<RequestOpShopBody> request = new Request<RequestOpShopBody>();
           request.Body = shopBody;
           request.Header = request.NewHeader();
           request.Key = "OpShop";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpShopBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpShopBody
   {
       [DataMember]
       public string shop_id { set; get; }

       [DataMember]
       public string shop_name { set; get; }

       [DataMember]
       public string shop_addr { set; get; }

       [DataMember]
       public string company_name { set; get; }

       [DataMember]
       public string link_way { set; get; }

       [DataMember]
       public string shop_remark { set; get; }

       [DataMember]
       public string area_id { set; get; }

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
