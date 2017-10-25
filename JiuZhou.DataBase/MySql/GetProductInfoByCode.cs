using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetProductInfoByCode
    {
        public static Response<ProductInfoByCode> Do(string productcode)
       {
           RequestProductByCodeBody productBody = new RequestProductByCodeBody();

           productBody.product_code = productcode;
           Request<RequestProductByCodeBody> request = new Request<RequestProductByCodeBody>();
           request.Body = productBody;
           request.Header = request.NewHeader();
           request.Key = "GetProductInfoByCode";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestProductByCodeBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ProductInfoByCode>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestProductByCodeBody {
        [DataMember]
        public string product_code { set; get; }
    }

   [DataContract]
    public class ProductInfoByCode
   { 
       [DataMember]
       public int product_id { set; get; }

       [DataMember]
       public string product_code { set; get; }

       [DataMember]
       public string product_name { set; get; }

       [DataMember]
       public string img_src { set; get; }
   } 
}
