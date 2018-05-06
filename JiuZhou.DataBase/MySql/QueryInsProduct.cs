using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryInsProduct
    {
        public static Response<InsProductDetail> Do(int instypeid)
        {
            RequestQueryInsProductBody body = new RequestQueryInsProductBody();
            body.instypeid = instypeid.ToString();
            Request<RequestQueryInsProductBody> request = new Request<RequestQueryInsProductBody>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "QueryInsproductList";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryInsProductBody>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<InsProductDetail>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestQueryInsProductBody
    {
        [DataMember]
        public string instypeid { set; get; }
    }

    [DataContract]
    public class InsProductDetail
    {
        [DataMember]
        public List<InsProItem> insproduct_list { set; get; }

        [DataMember]
        public List<InsTypeItem> instype_list { set; get; }
    }
    [DataContract]
    public class InsProItem
    {
        [DataMember]
        public string id { set; get; }
        [DataMember]
        public string product_id { set; get; }
        [DataMember]
        public string product_code { set; get; }
        [DataMember]
        public string product_name { set; get; }
        [DataMember]
        public string sale_price { set; get; }
        [DataMember]
        public string img_src { set; get; }
    }
    [DataContract]
    public class InsTypeItem
    {
        [DataMember]
        public string id { set; get; }
        [DataMember]
        public string type_name { set; get; }
        [DataMember]
        public string product_type_id { set; get; }
    } 
}
