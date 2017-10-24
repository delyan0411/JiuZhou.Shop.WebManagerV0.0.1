using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetSkusByProductId
    {
        public static Response<ResponseSkusBody> Do(int productId)
       {
           RequestSkusBody giftsBody = new RequestSkusBody();

           giftsBody.product_id = productId.ToString();
           Request<RequestSkusBody> request = new Request<RequestSkusBody>();
           request.Body = giftsBody;
           request.Header = request.NewHeader();
           request.Key = "GetSkusByProductId";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSkusBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseSkusBody>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestSkusBody
    {
        [DataMember]
        public string product_id { set; get; }
    }

    [DataContract]
    public class ResponseSkusBody
    {
        [DataMember]
        public List<SkuList> sku_list { set; get; }
    }
   [DataContract]
    public class SkuList
   {
       [DataMember]
       public int sku_id { set; get; }

       [DataMember]
       public int product_id { set; get; }

       [DataMember]
       public string sku_name { set; get; }

       [DataMember]
       public string sku_code { set; get; }

       [DataMember]
       public decimal sku_weight { set; get; }

       [DataMember]
       public int sku_stock { set; get; }

       [DataMember]
       public decimal sale_price { set; get; }

       [DataMember]
       public decimal mobile_price { set; get; }

       [DataMember]
       public decimal promotion_price { set; get; }

       [DataMember]
       public int is_visible { set; get; }

       [DataMember]
       public int virtual_sku_stock { set; get; }
   } 
}
