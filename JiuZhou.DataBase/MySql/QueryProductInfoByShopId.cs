using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryProductInfoByShopId
    {
        public static Response<ResponseSearchProductByShopIdBody> Do(string pagesize, int pageindex, string classid, int isonsale, int isVisible, string shopid, string brand, string _ocol, string _ot, ref int dataCount, ref int pageCount)
       {
           RequestSearchProductByShopBody search = new RequestSearchProductByShopBody();

           search.page_size = pagesize;
           search.page_no = pageindex.ToString();
           search.product_type_id = classid;
           search.is_on_sale = isonsale.ToString();
           search.is_visible = isVisible.ToString();
           search.shop_id = shopid;
           search.product_brand = brand;
           search.sort_column = _ocol;
           search.sort_type = _ot;

           Request<RequestSearchProductByShopBody> request = new Request<RequestSearchProductByShopBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryProductByShopId";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchProductByShopBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseSearchProductByShopIdBody>>(responseStr);

           if (response != null && response.Body != null && response.Body.rec_num != null) {              
               dataCount = int.Parse(response.Body.rec_num);
               if (dataCount % int.Parse(pagesize) == 0)
               {
                   pageCount = dataCount / int.Parse(pagesize);
               }
               else
               {
                   pageCount = dataCount / int.Parse(pagesize) + 1;
               }
          }

           return response;
       }
    }

    [DataContract]
    public class RequestSearchProductByShopBody {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string product_type_id { set; get; }

        [DataMember]
        public string is_on_sale { set; get; }

        [DataMember]
        public string is_visible { set; get; }

        [DataMember]
        public string shop_id { set; get; }

        [DataMember]
        public string product_brand { set; get; }

        [DataMember]
        public string sort_column { set; get; }

        [DataMember]
        public string sort_type { set; get; }
    }

    [DataContract]
    public class ResponseSearchProductByShopIdBody {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<ShortProductInfo> product_list { set; get; }
    }
}
