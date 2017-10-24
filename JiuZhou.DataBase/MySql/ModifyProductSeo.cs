using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyProductSeo
    {
        public static Response<ResponseBodyEmpty> Do(int productId, string seoTitle, string seoText, string seoKey)
       {
           RequestMProductSeoBody productSeoBody = new RequestMProductSeoBody();

           productSeoBody.product_id = productId.ToString();
           productSeoBody.seo_title = seoTitle;
           productSeoBody.seo_text = seoText;
           productSeoBody.seo_key = seoKey;

           Request<RequestMProductSeoBody> request = new Request<RequestMProductSeoBody>();
           request.Body = productSeoBody;
           request.Header = request.NewHeader();
           request.Key = "ModifyProductSeo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestMProductSeoBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestMProductSeoBody
    {
        [DataMember]
        public string product_id { set; get; }

        [DataMember]
        public string seo_title { set; get; }

        [DataMember]
        public string seo_text { set; get; }

        [DataMember]
        public string seo_key { set; get; }
    }
}
