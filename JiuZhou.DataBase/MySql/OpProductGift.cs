using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpProductGift
    {
       public static Response<ResponseBodyEmpty> Do(int productid, List<GiftsList> giftlist, string dlist)
       {
           RequestProductGiftBody reqproductgiftInfo = new RequestProductGiftBody();
           reqproductgiftInfo.product_id = productid.ToString();
           List<GiftsInfo> gift = new List<GiftsInfo>();
           
           foreach (GiftsList item in giftlist) {
               GiftsInfo giftinfo = new GiftsInfo();
               giftinfo.product_gift_id = item.product_gift_id.ToString();
               giftinfo.gift_id = item.gift_id.ToString();
               giftinfo.product_count = item.product_count.ToString();
               giftinfo.gift_count = item.gift_count.ToString();
               giftinfo.start_time = item.start_time;
               giftinfo.end_time = item.end_time;
               gift.Add(giftinfo);
           }
         
           reqproductgiftInfo.gift_list = gift;
           reqproductgiftInfo.delete_gift_ids = dlist;
           Request<RequestProductGiftBody> request = new Request<RequestProductGiftBody>();
           request.Body = reqproductgiftInfo;
           request.Header = request.NewHeader();
           request.Key = "OpProductGift";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestProductGiftBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestProductGiftBody
    {
        [DataMember]
        public string product_id { set; get; }

        [DataMember]
        public List<GiftsInfo> gift_list { set; get; }

        [DataMember]
        public string delete_gift_ids { set; get; }
    }

    [DataContract]
    public class GiftsInfo
    {
        [DataMember]
        public string product_gift_id { set; get; }

        [DataMember]
        public string gift_id { set; get; }

        [DataMember]
        public string product_count { set; get; }

        [DataMember]
        public string gift_count { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }
    } 
}
