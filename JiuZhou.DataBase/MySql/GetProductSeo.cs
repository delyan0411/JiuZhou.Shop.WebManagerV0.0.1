using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetProductSeo
    {
        public static Response<ProductSeo> Do(int productId)
       {
           RequestProductSeoBody productSecBody = new RequestProductSeoBody();

           productSecBody.product_id = productId.ToString();
           Request<RequestProductSeoBody> request = new Request<RequestProductSeoBody>();
           request.Body = productSecBody;
           request.Header = request.NewHeader();
           request.Key = "GetProductSeo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestProductSeoBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ProductSeo>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestProductSeoBody
    {
        [DataMember]
        public string product_id { set; get; }
    }

   [DataContract]
    public class ProductSeo
   {
       [DataMember] 
       public string product_name { set; get; }

       [DataMember]
       public string seo_title { set; get; }

       [DataMember]
       public string  seo_text { set; get; }

       [DataMember]
       public string  seo_key { set; get; }
   } 
}
