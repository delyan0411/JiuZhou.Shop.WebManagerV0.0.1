using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetProductGift
    {
        public static Response<ResponseGiftBody> Do(string productId)
       {
           RequestGiftBody giftsBody = new RequestGiftBody();

           giftsBody.product_id = productId;
           Request<RequestGiftBody> request = new Request<RequestGiftBody>();
           request.Body = giftsBody;
           request.Header = request.NewHeader();
           request.Key = "GetProductGift";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestGiftBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseGiftBody>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestGiftBody {
        [DataMember]
        public string product_id { set; get; }
    }

    [DataContract]
    public class ResponseGiftBody
    {
        [DataMember]
        public List<GiftsList> gift_list { set; get; }
    }
}
