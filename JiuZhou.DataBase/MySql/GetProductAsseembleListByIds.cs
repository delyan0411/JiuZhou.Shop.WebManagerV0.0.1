using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetProductAsseembleListByIds
    {
        public static Response<ResponseProductAssembleList> Do(string productids)
       {
           RequestProductAssembleByIdBody productBody = new RequestProductAssembleByIdBody();

           productBody.product_ids = productids;
           Request<RequestProductAssembleByIdBody> request = new Request<RequestProductAssembleByIdBody>();
           request.Body = productBody;
           request.Header = request.NewHeader();
           request.Key = "GetProductAsseembleListByIds";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestProductAssembleByIdBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseProductAssembleList>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestProductAssembleByIdBody {
        [DataMember]
        public string product_ids { set; get; }
    }

    [DataContract]
    public class ResponseProductAssembleList
    {
        [DataMember]
        public string rec_num { get; set; }

        [DataMember]
        public List<ProductAssembleList> ass_list { set; get; }
    }

   [DataContract]
    public class ProductAssembleList
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
       public string product_type_name { set; get; }

       [DataMember]
       public decimal sale_price { set; get; }

       [DataMember]
       public decimal promotion_price { set; get; }

       [DataMember]
       public string promotion_bdate { set; get; }

       [DataMember]
       public string promotion_edate { set; get; }
   } 
}
