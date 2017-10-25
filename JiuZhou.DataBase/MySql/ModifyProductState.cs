using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyProductState
    {
       public static Response<ResponseBodyEmpty> Do(string productIds, int status ,string _type)
       {
           RequestOpProBody productBody = new RequestOpProBody();
           productBody.product_ids = productIds;
           productBody.product_state = status.ToString();
           productBody.modify_column = _type;


           Request<RequestOpProBody> request = new Request<RequestOpProBody>();
           request.Body = productBody;
           request.Header = request.NewHeader();
           request.Key = "ModifyProductState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpProBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpProBody
   {
       [DataMember]
       public string product_ids { set; get; }

       [DataMember]
       public string modify_column { set; get; }

       [DataMember]
       public string product_state { set; get; }
   } 
}
