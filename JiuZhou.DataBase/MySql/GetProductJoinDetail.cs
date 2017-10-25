using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetProductJoinDetail
    {
        public static Response<ResponseProductJoinItem> Do(int join_id)
       {
           RequestProductJoinItemBody joinBody = new RequestProductJoinItemBody();

           joinBody.product_join_id = join_id.ToString();
           Request<RequestProductJoinItemBody> request = new Request<RequestProductJoinItemBody>();
           request.Body = joinBody;
           request.Header = request.NewHeader();
           request.Key = "GetProductJoinDetail";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestProductJoinItemBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseProductJoinItem>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestProductJoinItemBody {
        [DataMember]
        public string product_join_id { set; get; }
    }

    [DataContract]
    public class ResponseProductJoinItem
    {
        [DataMember]
        public int product_join_id { set; get; }

        [DataMember]
        public string type_name { set; get; }

        [DataMember]
        public string join_name { set; get; }

        [DataMember]
        public int allow_refresh { set; get; }

        [DataMember]
        public int view_type { set; get; }

        [DataMember]
        public string item_rec_num { set; get; }

        [DataMember]
        public List<ProductJoinItemInfo> join_item_list { set; get; }
    }

    [DataContract]
    public class ProductJoinItemInfo
    {
        [DataMember]
        public int join_item_id { set; get; }

        [DataMember]
        public string item_name { set; get; }

        [DataMember]
        public int product_id { set; get; }

        [DataMember]
        public int sort_no { set; get; }

        [DataMember]
        public string product_name { set; get; }

        [DataMember]
        public string img_src { set; get; }

        [DataMember]
        public string product_code { set; get; }

        [DataMember]
        public decimal sale_price { set; get; }

        [DataMember]
        public decimal mobile_price { set; get; }

        [DataMember]
        public int sku_count { set; get; }
    }
}
