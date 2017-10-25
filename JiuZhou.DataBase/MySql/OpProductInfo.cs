using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
   public class OpProductInfo
    {
       public static Response<ResponseProductInfo> Do(ProductInfo productInfo)
       {
           RequestProductInfo reqproductInfo = new RequestProductInfo();
           reqproductInfo.product_id = productInfo.product_id.ToString();
           reqproductInfo.product_code = productInfo.product_code;
           reqproductInfo.product_name = productInfo.product_name;
           reqproductInfo.common_name = productInfo.common_name;
           reqproductInfo.img_src = productInfo.img_src;
           reqproductInfo.product_brand = productInfo.product_brand;
           reqproductInfo.sales_promotion = productInfo.sales_promotion;
           reqproductInfo.product_func = productInfo.product_func;
           reqproductInfo.product_type_id = productInfo.product_type_id.ToString();
           reqproductInfo.product_type_path = productInfo.product_type_path;
           reqproductInfo.shop_id = productInfo.shop_id.ToString();
           reqproductInfo.search_key = productInfo.search_key;
           reqproductInfo.sale_price = productInfo.sale_price.ToString();
           reqproductInfo.mobile_price = productInfo.mobile_price.ToString();
           reqproductInfo.allow_ebaolife = productInfo.allow_ebaolife.ToString();
           reqproductInfo.promotion_bdate = productInfo.promotion_bdate.ToString();
           reqproductInfo.promotion_edate = productInfo.promotion_edate.ToString();
           reqproductInfo.promotion_price = productInfo.promotion_price.ToString();
           reqproductInfo.fare_temp_id = productInfo.fare_temp_id.ToString();
           reqproductInfo.is_free_fare = productInfo.is_free_fare.ToString();
           reqproductInfo.free_fare_stime = productInfo.free_fare_stime.ToString();
           reqproductInfo.free_fare_etime = productInfo.free_fare_etime.ToString();
           reqproductInfo.give_integral = productInfo.give_integral.ToString();
           reqproductInfo.is_drug = productInfo.is_drug.ToString();
           reqproductInfo.product_join_id = productInfo.product_join_id.ToString();
           reqproductInfo.max_buy_num = productInfo.max_buy_num.ToString();
           reqproductInfo.virtual_stock_num = productInfo.virtual_stock_num.ToString();
           reqproductInfo.is_on_sale = productInfo.is_on_sale.ToString();
           reqproductInfo.is_visible = productInfo.is_visible.ToString();
           reqproductInfo.month_click_count = productInfo.month_click_count.ToString();
           reqproductInfo.manu_facturer = productInfo.manu_facturer;
           reqproductInfo.product_spec = productInfo.product_spec;
           reqproductInfo.product_weight = productInfo.product_weight.ToString();
           reqproductInfo.product_license = productInfo.product_license;
           reqproductInfo.invalid_date = productInfo.invalid_date.ToString();
           reqproductInfo.product_detail = productInfo.product_detail;
           if (productInfo.product_id == 0)
           {
               reqproductInfo.market_price = productInfo.sale_price.ToString();
           }
           else {
               reqproductInfo.market_price = productInfo.market_price.ToString();
           }
           reqproductInfo.brand_id = productInfo.brand_id.ToString();
           reqproductInfo.check_state = productInfo.check_state.ToString();

           Request<RequestProductInfo> request = new Request<RequestProductInfo>();
           request.Body = reqproductInfo;
           request.Header = request.NewHeader();
           request.Key = "OpProduct";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestProductInfo>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseProductInfo>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestProductInfo
   {
       [DataMember]
       public string product_id { set; get; }

       [DataMember]
       public string product_code { set; get; }

       [DataMember]
       public string product_name { set; get; }

       [DataMember]
       public string common_name { set; get; }

       [DataMember]
       public string img_src { set; get; }

       [DataMember]
       public string product_brand { set; get; }

       [DataMember]
       public string sales_promotion { set; get; }

       [DataMember]
       public string product_func { set; get; }

       [DataMember]
       public string product_type_id { set; get; }

       [DataMember]
       public string product_type_path { set; get; }

       [DataMember]
       public string shop_id { set; get; }

       [DataMember]
       public string search_key { set; get; }

       [DataMember]
       public string sale_price { set; get; }

       [DataMember]
       public string mobile_price { set; get; }

       [DataMember]
       public string allow_ebaolife { set; get; }

       [DataMember]
       public string promotion_bdate { set; get; }

       [DataMember]
       public string promotion_edate { set; get; }

       [DataMember]
       public string promotion_price { set; get; }

       [DataMember]
       public string fare_temp_id { set; get; }

       [DataMember]
       public string is_free_fare { set; get; }

       [DataMember]
       public string free_fare_stime { set; get; }

       [DataMember]
       public string free_fare_etime { set; get; }

       [DataMember]
       public string give_integral { set; get; }

       [DataMember]
       public string is_drug { set; get; }

       [DataMember]
       public string product_join_id { set; get; }

       [DataMember]
       public string max_buy_num { set; get; }

       [DataMember]
       public string virtual_stock_num { set; get; }

       [DataMember]
       public string is_on_sale { set; get; }

       [DataMember]
       public string is_visible { set; get; }

       [DataMember]
       public string manu_facturer { set; get; }

       [DataMember]
       public string product_spec { set; get; }

       [DataMember]
       public string product_weight { set; get; }

       [DataMember]
       public string product_license { set; get; }

       [DataMember]
       public string invalid_date { set; get; }

       [DataMember]
       public string product_detail { set; get; }

       [DataMember]
       public string month_click_count { set; get; }

       [DataMember]
       public string market_price { set; get; }

       [DataMember]
       public string brand_id { set; get; }

       [DataMember]
       public string check_state { set; get; }
   }

   [DataContract]
   public class ResponseProductInfo
   {
       [DataMember]
       public int product_id { set; get; }
   }
}
