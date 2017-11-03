using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryProductInfo
    {
        public static Response<ResponseSearchBody> Do(int pagesize, int pageindex, int checktype, int shopid, int classid, int _stype, int promotion, int isonsale, int isVisible, string _skey, string _ocol, string _ot, ref int dataCount, ref int pageCount)
        {
            RequestSearchBody search = new RequestSearchBody();

            search.page_size = pagesize.ToString();
            search.page_no = pageindex.ToString();
            search.product_type_id = classid.ToString();
            search.search_type = _stype.ToString();
            search.promotion = promotion.ToString();
            search.is_on_sale = isonsale.ToString();
            search.is_visible = isVisible.ToString();
            search.key_word = _skey;
            search.sort_column = _ocol;
            search.sort_type = _ot;
            search.shop_id = shopid.ToString();
            search.check_state = checktype.ToString();

            Request<RequestSearchBody> request = new Request<RequestSearchBody>();
            request.Body = search;
            request.Header = request.NewHeader();
            request.Key = "QueryProductList";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchBody>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseSearchBody>>(responseStr);

            if (response != null && response.Body != null && response.Body.rec_num != null)
            {
                dataCount = int.Parse(response.Body.rec_num);
                if (dataCount % pagesize == 0)
                {
                    pageCount = dataCount / pagesize;
                }
                else
                {
                    pageCount = dataCount / pagesize + 1;
                }
            }

            return response;
        }
    }

    [DataContract]
    public class RequestSearchBody {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string product_type_id { set; get; }

        [DataMember]
        public string search_type { set; get; }

        [DataMember]
        public string is_on_sale { set; get; }

        [DataMember]
        public string promotion { set; get; }

        [DataMember]
        public string is_visible { set; get; }

        [DataMember]
        public string key_word { set; get; }

        [DataMember]
        public string sort_column { set; get; }

        [DataMember]
        public string sort_type { set; get; }

        [DataMember]
        public string shop_id { set; get; }

        [DataMember]
        public string check_state { set; get; }
    }

    [DataContract]
    public class ResponseSearchBody {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<ProductsInfo> product_list { set; get; }
    }

    [DataContract]
    public class ProductsInfo
    {
        [DataMember]
        public int product_id { set; get; }

        [DataMember]
        public string product_code { set; get; }

        [DataMember]
        public string product_name { set; get; }

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
        public decimal market_price { set; get; }   

        [DataMember]
        public string modify_time { set; get; }    

        [DataMember]
        public string seo_title { set; get; }            

        [DataMember]
        public decimal sale_price { set; get; }

        [DataMember]
        public decimal mobile_price { set; get; }

        [DataMember]
        public int allow_ebaolife { set; get; }

        [DataMember]
        public string promotion_bdate { set; get; }

        [DataMember]
        public string promotion_edate { set; get; }

        [DataMember]
        public decimal promotion_price { set; get; }

        [DataMember]
        public int fare_temp_id { set; get; }

        [DataMember]
        public int free_fare { set; get; }

        [DataMember]
        public string free_fare_stime { set; get; }

        [DataMember]
        public string free_fare_etime { set; get; }

        [DataMember]
        public int total_sale_count { set; get; }

        [DataMember]
        public int comment_count { set; get; }

        [DataMember]
        public string total_mark { set; get; }

        [DataMember]
        public int give_integral { set; get; }

        [DataMember]
        public int is_drug { set; get; }

        [DataMember]
        public int product_join_id { set; get; }

        [DataMember]
        public int max_buy_count { set; get; }

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

        [DataMember]
        public string invalid_date { set; get; }

        [DataMember]
        public string product_detail { set; get; }

        [DataMember]
        public int sku_count { set; get; }

        [DataMember]
        public int virtual_stock_num { set; get; }

        [DataMember]
        public int check_state { set; get; }

        [DataMember]
        public string check_time { set; get; }

        [DataMember]
        public int check_user_id { set; get; }

        [DataMember]
        public int pro_flag { set; get; }

        //[DataMember]
        //public int has_fulloff { set; get; }

        [DataMember]
        public int gift_flag { set; get; }

        [DataMember]
        public int coupon_flag { set; get; }
    } 
}
