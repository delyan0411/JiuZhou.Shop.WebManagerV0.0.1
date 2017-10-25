using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryProductByGiftId
    {
        public static Response<ResponseGitgCounterBody> Do(int productid)
       {
           RequestGiftCounterBody body = new RequestGiftCounterBody();

           body.gift_id = productid.ToString();

           Request<RequestGiftCounterBody> request = new Request<RequestGiftCounterBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "QueryProductByGiftId";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestGiftCounterBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseGitgCounterBody>>(responseStr);
           
           return response;
       }
    }

    [DataContract]
    public class RequestGiftCounterBody {
        [DataMember]
        public string gift_id { set; get; }
    }

    [DataContract]
    public class ResponseGitgCounterBody {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<ShortProductInfo> product_list { set; get; }
    }
}
