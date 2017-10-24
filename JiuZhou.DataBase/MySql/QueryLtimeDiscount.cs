using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryLtimeDiscount
    {
        public static Response<ResponseQueryDiscountBody> Do(int pagesize, int pageindex, string q, ref int dataCount, ref int pageCount)
       {
           RequestQueryDiscount search = new RequestQueryDiscount();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.search_key = q;

           Request<RequestQueryDiscount> request = new Request<RequestQueryDiscount>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryLtimeDiscount";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryDiscount>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseQueryDiscountBody>>(responseStr);

           if (response.Body != null && response != null && response.Body.discount_list != null)
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
    public class RequestQueryDiscount {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string search_key { set; get; }
    }

    [DataContract]
    public class ResponseQueryDiscountBody {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<DiscountInfo> discount_list { set; get; }
    }

    [DataContract]
    public class DiscountInfo
    {
        [DataMember]
        public int lt_discount_id { set; get; }  

        [DataMember]
        public string subject_name { set; get; }

        [DataMember]
        public string discount_name { set; get; }

        [DataMember]
        public int discount_mode { set; get; }

        [DataMember]
        public int brand_id { set; get; }

        [DataMember]
        public int product_type_id { set; get; }

        [DataMember]
        public string product_type_path { set; get; }

        [DataMember]
        public int shop_id { set; get; }

        [DataMember]
        public int cut_type { set; get; }

        [DataMember]
        public decimal cut_rate { set; get; }

        [DataMember]
        public decimal cut_price { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public int add_user_id { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public int is_cover { set; get; }

        [DataMember]
        public string shop_name { set; get; }

        [DataMember]
        public string brand_name { set; get; }

        [DataMember]
        public List<DiscountItems> item_list { set; get; }
    }

    [DataContract]
    public class DiscountItems
    {
        [DataMember]
        public int lt_discount_item_id { set; get; }

        [DataMember]
        public int lt_discount_id { set; get; }

        [DataMember]
        public int product_id { set; get; }

        [DataMember]
        public string product_name { set; get; }

        [DataMember]
        public string img_src { set; get; }

        [DataMember]
        public string product_code { set; get; }

        [DataMember]
        public string product_type_path { set; get; }

        [DataMember]
        public int cut_type { set; get; }

        [DataMember]
        public decimal cut_rate { set; get; }

        [DataMember]
        public decimal cut_price { set; get; }

        [DataMember]
        public int copy_by_main { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }
    }
}
