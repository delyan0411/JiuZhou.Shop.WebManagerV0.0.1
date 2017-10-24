using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ResetShopPswd
    {
       public static Response<ResponseBodyEmpty> Do(int shopid)
       {
           RequestOpShopPasBody body = new RequestOpShopPasBody();
           body.shop_id = shopid.ToString();


           Request<RequestOpShopPasBody> request = new Request<RequestOpShopPasBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ResetShopPswd";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpShopPasBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpShopPasBody
   {
       [DataMember]
       public string shop_id { set; get; }
   } 
}
