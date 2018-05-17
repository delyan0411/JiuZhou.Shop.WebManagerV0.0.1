using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetProductInfo
    {
        public static Response<ProductInfo> Do(int productId)
        {
            RequestProductBody giftsBody = new RequestProductBody();

            giftsBody.product_id = productId.ToString();
            Request<RequestProductBody> request = new Request<RequestProductBody>();
            request.Body = giftsBody;
            request.Header = request.NewHeader();
            request.Key = "QueryProductInfo";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestProductBody>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ProductInfo>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestProductBody {

        [DataMember]
        public string product_id { set; get; }
    }

    [DataContract]
    public class ProductInfo
    {
        [DataMember]
        public int product_id { set; get; }

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
        public int product_type_id { set; get; }

        [DataMember]
        public string product_type_path { set; get; }

        [DataMember]
        public int shop_id { set; get; }

        [DataMember]
        public string search_key { set; get; }

        [DataMember]
        public decimal sale_price { set; get; }

        [DataMember]
        public decimal mobile_price { set; get; }

        [DataMember]
        public decimal market_price { set; get; }

        [DataMember]
        public int allow_ebaolife { set; get; }

        private string promotionbdate = DateTime.Now.ToString();

        [DataMember]
        public string promotion_bdate { set { promotionbdate = value; } get { return promotionbdate; } }

        private string promotionedate = DateTime.Now.ToString();

        [DataMember]
        public string promotion_edate { set { promotionedate = value; } get { return promotionedate; } }

        [DataMember]
        public decimal promotion_price { set; get; }

        [DataMember]
        public int fare_temp_id { set; get; }

        [DataMember]
        public int is_free_fare { set; get; }

        private string freefare_stime = DateTime.Now.ToString();

        [DataMember]
        public string free_fare_stime { set { freefare_stime = value; } get { return freefare_stime; } }

        private string freefare_etime = DateTime.Now.ToString();

        [DataMember]
        public string free_fare_etime { set { freefare_etime = value; } get { return freefare_etime; } }

        [DataMember]
        public int total_sale_count { set; get; }

        [DataMember]
        public int comment_count { set; get; }

        [DataMember]
        public decimal total_mark { set; get; }

        [DataMember]
        public int give_integral { set; get; }

        [DataMember]
        public int is_drug { set; get; }

        [DataMember]
        public int product_join_id { set; get; }

        [DataMember]
        public int max_buy_num { set; get; }

        [DataMember]
        public int stock_num { set; get; }

        [DataMember]
        public int is_on_sale { set; get; }

        [DataMember]
        public int is_visible { set; get; }

        [DataMember]
        public string manu_facturer { set; get; }

        [DataMember]
        public string product_spec { set; get; }

        [DataMember]
        public decimal product_weight { set; get; }

        [DataMember]
        public string product_license { set; get; }

        private string invaliddate = DateTime.Now.ToString();

        [DataMember]
        public string invalid_date { set { invaliddate = value; } get { return invaliddate; } }

        [DataMember]
        public string product_detail { set; get; }

        [DataMember]
        public int month_click_count { set; get; }

        [DataMember]
        public int virtual_stock_num { set; get; }

        [DataMember]
        public int brand_id { set; get; }

        [DataMember]
        public string shop_name { set; get; }

        [DataMember]
        public int check_state { set; get; }

        [DataMember]
        public string check_time { set; get; }

        [DataMember]
        public int check_user_id { set; get; }

        /// <summary>
        /// 是否海外购
        /// </summary>
        [DataMember]
        public int sea_flag { set; get; }
    }
}
