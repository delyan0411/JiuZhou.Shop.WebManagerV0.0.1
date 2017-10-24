using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetRelationRecommend
    {
        public static Response<ResponseRelationProduct> Do(int mainproductId,int type)
       {
           RequestRelationProductBody relationproductBody = new RequestRelationProductBody();

           relationproductBody.main_product_id = mainproductId.ToString();
           relationproductBody.recommend_type = type.ToString();
           Request<RequestRelationProductBody> request = new Request<RequestRelationProductBody>();
           request.Body = relationproductBody;
           request.Header = request.NewHeader();
           request.Key = "GetRelationRecommend";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestRelationProductBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseRelationProduct>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestRelationProductBody
    {
        [DataMember]
        public string main_product_id { set; get; }

        [DataMember]
        public string recommend_type { set; get; }
    }

    [DataContract]
    public class ResponseRelationProduct
    {
        [DataMember]
        public int relation_rec_id { set; get; }

        [DataMember]
        public int product_id { set; get; }

        [DataMember]
        public string product_name { set; get; }

        [DataMember]
        public string product_code { set; get; }

        [DataMember]
        public string img_src { set; get; }

        [DataMember]
        public int product_type_id { set; get; }

        [DataMember]
        public string product_type_path { set; get; }

        [DataMember]
        public decimal market_price { set; get; }

        [DataMember]
        public decimal sale_price { set; get; }

        [DataMember]
        public decimal mobile_price { set; get; }

        [DataMember]
        public decimal promotion_price { set; get; }

        [DataMember]
        public string promotion_bdate { set; get; }

        [DataMember]
        public string promotion_edate { set; get; }

        [DataMember]
        public int stock_num { set; get; }

        [DataMember]
        public int is_on_sale { set; get; }

        [DataMember]
        public int is_visible{ set; get; }

        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<RelationProductInfo> relation_list { set; get; }
    }
   [DataContract]
    public class RelationProductInfo
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
       public decimal market_price { set; get; }

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
       public int stock_num { set; get; }

       [DataMember]
       public int is_on_sale { set; get; }
   } 
}
