using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyStockNumAndPrice
    {
        public static Response<ResponseBodyEmpty> Do(int productId, decimal saleprice, decimal mobileprice, int virtualstocknum)
       {
           RequestModyStockAndPriceBody productBody = new RequestModyStockAndPriceBody();
           productBody.product_id = productId.ToString();
           productBody.sale_price = saleprice.ToString();
           productBody.mobile_price = mobileprice.ToString();
           productBody.virtual_stock_num = virtualstocknum.ToString();

           Request<RequestModyStockAndPriceBody> request = new Request<RequestModyStockAndPriceBody>();
           request.Body = productBody;
           request.Header = request.NewHeader();
           request.Key = "ModifyStockNumAndPrice";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModyStockAndPriceBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModyStockAndPriceBody
   {
       [DataMember]
       public string product_id { set; get; }

       [DataMember]
       public string sale_price { set; get; }

       [DataMember]
       public string mobile_price { set; get; }

       [DataMember]
       public string virtual_stock_num { set; get; }
   } 
}
