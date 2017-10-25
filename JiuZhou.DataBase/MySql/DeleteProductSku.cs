using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteProductSku
    {
        public static Response<ResponseBodyEmpty> Do(int productId, string skuIds)
       {
           RequestDeleteSkusBody productSkusBody = new RequestDeleteSkusBody();

           productSkusBody.product_id = productId.ToString();
           productSkusBody.sku_ids = skuIds;

           Request<RequestDeleteSkusBody> request = new Request<RequestDeleteSkusBody>();
           request.Body = productSkusBody;
           request.Header = request.NewHeader();
           request.Key = "DeleteProductSku";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteSkusBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteSkusBody
    {
        [DataMember]
        public string product_id { set; get; }

        [DataMember]
        public string sku_ids { set; get; }
    }
}
