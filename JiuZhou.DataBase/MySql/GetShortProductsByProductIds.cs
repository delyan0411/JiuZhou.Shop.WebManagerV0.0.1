using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetShortProductsByProductIds
    {
        public static Response<ResponseShortProduct> Do(string productIds)
       {
           RequestShortProductBody shortproductBody = new RequestShortProductBody();

           shortproductBody.product_ids = productIds;
           Request<RequestShortProductBody> request = new Request<RequestShortProductBody>();
           request.Body = shortproductBody;
           request.Header = request.NewHeader();
           request.Key = "GetShortProductsByProductIds";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestShortProductBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseShortProduct>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestShortProductBody {
        [DataMember]
        public string product_ids { set; get; }
    }

    [DataContract]
    public class ResponseShortProduct {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<ShortProductInfo> product_list { set; get; }
    }
   [DataContract]
    public class ShortProductInfo
   { 
       [DataMember]
       public int product_id { set; get; }

       [DataMember]
       public string product_code { set; get; }

       [DataMember]
       public string product_name { set; get; }

       [DataMember]
       public int product_type_id { set; get; }

       [DataMember]
       public string product_type_path { set; get; }

       public int shop_id { set; get;}

       [DataMember]
       public string img_src { set; get; }

       [DataMember]
       public decimal market_price { set; get; }

       public string type_name { set; get; }

       [DataMember]
       public decimal sale_price { set; get; }

       [DataMember]
       public decimal mobile_price { set; get; }

       private string promotionbdate = DateTime.Now.ToString();

       [DataMember]
       public string promotion_bdate { set { promotionbdate = value; } get { return promotionbdate; } }

       private string promotionedate = DateTime.Now.ToString();

       [DataMember]
       public string promotion_edate { set { promotionedate = value; } get { return promotionedate; } }

       [DataMember]
       public decimal promotion_price { set; get; }

       [DataMember]
       public string product_brand { set; get; }

       [DataMember]
       public string sales_promotion { set; get; }

       [DataMember]
       public int stock_num { set; get; }

       [DataMember]
       public decimal product_weight { set; get; }

       [DataMember]
       public string product_func { set; get; }

       [DataMember]
       public int total_sale_count { set; get; }

       [DataMember]
       public int click_count { set; get; }

       [DataMember]
       public int is_on_sale { set; get; }

       [DataMember]
       public int is_visible { set; get; }

       [DataMember]
       public string product_spec { set; get; }

       [DataMember]
       public int max_buy_num { set; get; }

       [DataMember]
       public string manu_facturer { set; get; }

       [DataMember]
       public int allow_ebaolife { set; get; }

       [DataMember]
       public int is_free_fare { set; get; }

       private string freefare_stime = DateTime.Now.ToString();

       [DataMember]
       public string free_fare_stime { set { freefare_stime = value; } get { return freefare_stime; } }

       private string freefare_etime = DateTime.Now.ToString();

       [DataMember]
       public string free_fare_etime { set { freefare_etime = value; } get { return freefare_etime; } }

       [DataMember]
       public int sku_count { set; get; }
   } 
}
