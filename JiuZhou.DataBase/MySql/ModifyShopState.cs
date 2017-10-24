using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyShopState
    {
       public static Response<ResponseBodyEmpty> Do(int id, int status)
       {
           RequestOpShopStateBody body = new RequestOpShopStateBody();
           body.shop_id = id.ToString();
           body.shop_state = status.ToString();


           Request<RequestOpShopStateBody> request = new Request<RequestOpShopStateBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyShopState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpShopStateBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpShopStateBody
   {
       [DataMember]
       public string shop_id { set; get; }

       [DataMember]
       public string shop_state { set; get; }
   } 
}
