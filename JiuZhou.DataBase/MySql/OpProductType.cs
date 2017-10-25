using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
   public class OpProductType
    {
       public static Response<ResponseBodyEmpty> Do(ProTypeList type)
       {
           RequestProductType reqproductType = new RequestProductType();
           reqproductType.product_type_id = type.product_type_id.ToString();
           reqproductType.type_name = type.type_name;
           reqproductType.parent_type_id = type.parent_type_id.ToString();
           reqproductType.sort_no = type.sort_no.ToString();
           reqproductType.seo_title = type.seo_title;
           reqproductType.seo_key = type.seo_key;
           reqproductType.seo_text = type.seo_text;
           reqproductType.is_visible = type.is_visible.ToString();
           reqproductType.img_src = type.img_src;
           Request<RequestProductType> request = new Request<RequestProductType>();
           request.Body = reqproductType;
           request.Header = request.NewHeader();
           request.Key = "OpProductType";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestProductType>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestProductType
   {
       [DataMember]
       public string product_type_id { set; get; }

       [DataMember]
       public string type_name { set; get; }

       [DataMember]
       public string parent_type_id { set; get; }

       [DataMember]
       public string sort_no { set; get; }

       [DataMember]
       public string seo_title { set; get; }

       [DataMember]
       public string seo_text { set; get; }

       [DataMember]
       public string seo_key { set; get; }

       [DataMember]
       public string is_visible { set; get; }

       [DataMember]
       public string img_src { set; get; }
   }
}
