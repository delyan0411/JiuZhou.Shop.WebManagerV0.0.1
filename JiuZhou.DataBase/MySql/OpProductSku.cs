using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpProductSku
    {
       public static Response<ResponseBodyEmpty> Do(int productid,List<SkuList> skulist)
       {
           RequestProductSku reqproductsku = new RequestProductSku();
           reqproductsku.product_id = productid.ToString();
           List<ResSkuList> sku_lists = new List<ResSkuList>();
           foreach (SkuList item in skulist) {
               ResSkuList sku = new ResSkuList();
               sku.sku_id = item.sku_id.ToString();
               sku.sku_code = item.sku_code;
               sku.sku_name = item.sku_name;
               sku.sku_weight = item.sku_weight.ToString();
               sku.virtual_sku_stock = item.virtual_sku_stock.ToString();
               sku.sale_price = item.sale_price.ToString();
               sku.mobile_price = item.mobile_price.ToString();
               sku.promotion_price = item.promotion_price.ToString();
               sku.is_visible = item.is_visible.ToString();
               sku_lists.Add(sku);
           }
           reqproductsku.sku_list = sku_lists;

           Request<RequestProductSku> request = new Request<RequestProductSku>();
           request.Body = reqproductsku;
           request.Header = request.NewHeader();
           request.Key = "OpProductSku";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestProductSku>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

   [DataContract]
   public class RequestProductSku
   {
       [DataMember]
       public string product_id { set; get; }

       [DataMember]
       public List<ResSkuList> sku_list { set; get; }    
   }

   [DataContract]
   public class ResSkuList
   {
       [DataMember]
       public string sku_id { set; get; }

       [DataMember]
       public string sku_name { set; get; }

       [DataMember]
       public string sku_code { set; get; }

       [DataMember]
       public string sku_weight { set; get; }

       [DataMember]
       public string sale_price { set; get; }

       [DataMember]
       public string mobile_price { set; get; }

       [DataMember]
       public string promotion_price { set; get; }

       [DataMember]
       public string is_visible { set; get; }

       [DataMember]
       public string virtual_sku_stock { set; get; }
   } 
}
