using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpLtimeDiscount
    {
        public static Response<ResponseBodyEmpty> Do(DiscountInfo info, string desids)
       {
           RequestOpDiscountBody body = new RequestOpDiscountBody();
           body.lt_discount_id = info.lt_discount_id.ToString();
           body.subject_name = info.subject_name;
           body.discount_name = info.discount_name;
           body.discount_mode = info.discount_mode.ToString();
           body.brand_id = info.brand_id.ToString();
           body.product_type_id = info.product_type_id.ToString();
           body.product_type_path = info.product_type_path;
           body.shop_id = info.shop_id.ToString();
           body.cut_type = info.cut_type.ToString();
           body.cut_rate = info.cut_rate.ToString();
           body.cut_price = info.cut_price.ToString();
           body.start_time = info.start_time;
           body.end_time = info.end_time;
           body.is_cover = info.is_cover.ToString();
           body.delete_discount_ids = desids.Split(',');

           List<DiscountItem2> list = new List<DiscountItem2>();
           foreach (DiscountItems item in info.item_list)
           {
               DiscountItem2 em = new DiscountItem2();
               em.lt_discount_item_id = item.lt_discount_item_id.ToString();
               em.product_id = item.product_id.ToString();
               em.cut_type = item.cut_type.ToString();
               em.cut_rate = item.cut_rate.ToString();
               em.cut_price = item.cut_price.ToString();
               em.copy_by_main = item.copy_by_main.ToString();
               em.start_time = item.start_time;
               em.end_time = item.end_time;
               list.Add(em);
           }
           body.item_list = list;

           Request<RequestOpDiscountBody> request = new Request<RequestOpDiscountBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpLtimeDiscount";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpDiscountBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpDiscountBody
   {
       [DataMember]
       public string lt_discount_id { set; get; }

       [DataMember]
       public string subject_name { set; get; }

       [DataMember]
       public string discount_name { set; get; }

       [DataMember]
       public string discount_mode { set; get; }

       [DataMember]
       public string brand_id { set; get; }

       [DataMember]
       public string product_type_id { set; get; }

       [DataMember]
       public string product_type_path { set; get; }

       [DataMember]
       public string shop_id { set; get; }

       [DataMember]
       public string cut_type { set; get; }

       [DataMember]
       public string cut_rate { set; get; }

       [DataMember]
       public string cut_price { set; get; }

       [DataMember]
       public string start_time { set; get; }

       [DataMember]
       public string end_time { set; get; }

       [DataMember]
       public string is_cover { set; get; }

       [DataMember]
       public string[] delete_discount_ids { set; get; }

       [DataMember]
       public List<DiscountItem2> item_list { set; get; }
   }

   [DataContract]
   public class DiscountItem2
   {
       [DataMember]
       public string lt_discount_item_id { set; get; }

       [DataMember]
       public string product_id { set; get; }

       [DataMember]
       public string cut_type { set; get; }

       [DataMember]
       public string cut_rate { set; get; }

       [DataMember]
       public string cut_price { set; get; }

       [DataMember]
       public string copy_by_main { set; get; }

       [DataMember]
       public string start_time { set; get; }

       [DataMember]
       public string end_time { set; get; }
   }
}
