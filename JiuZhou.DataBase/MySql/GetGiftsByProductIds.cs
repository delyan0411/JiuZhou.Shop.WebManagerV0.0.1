using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetGiftsByProductIds
    {
        public static Response<ResponseGiftsBody> Do(string productIds)
       {
           RequestGiftsBody giftsBody = new RequestGiftsBody();

           giftsBody.product_ids = productIds;
           Request<RequestGiftsBody> request = new Request<RequestGiftsBody>();
           request.Body = giftsBody;
           request.Header = request.NewHeader();
           request.Key = "GetGiftsByProductIds";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestGiftsBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseGiftsBody>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestGiftsBody {
        [DataMember]
        public string product_ids { set; get; }
    }

    [DataContract]
    public class ResponseGiftsBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<GiftsList> gift_list { set; get; }
    }

   [DataContract]
    public class GiftsList
   {
       [DataMember]
       public int product_gift_id { set; get; }

       [DataMember]
       public string product_name { set; get; }

       [DataMember]
       public string img_src { set; get; }

       [DataMember]
       public string product_code { set; get; }

       [DataMember]
       public int gift_id { set; get; }

       [DataMember]
       public int product_count { set; get; }

       [DataMember]
       public int gift_count { set; get; }

       [DataMember]
       public string start_time { set; get; }

       [DataMember]
       public string end_time { set; get; }
   } 
}
