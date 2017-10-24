using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryFullOffItem
    {
        public static Response<FullOffDetail> Do(int fullid)
       {
           RequestQueryFullOffItemsBody body = new RequestQueryFullOffItemsBody();

           body.fulloff_id = fullid.ToString();

           Request<RequestQueryFullOffItemsBody> request = new Request<RequestQueryFullOffItemsBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "QueryFullOffItem";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryFullOffItemsBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<FullOffDetail>>(responseStr);

           return response;
       }
    }

    [DataContract]
    public class RequestQueryFullOffItemsBody {
        [DataMember]
        public string fulloff_id { set; get; }
    }

    [DataContract]
    public class FullOffDetail
    {
        [DataMember]
        public int fulloff_id { set; get; }

        [DataMember]
        public string fulloff_name { set; get; }

        [DataMember]
        public string img_src { set; get; }

        [DataMember]
        public string fulloff_desc { set; get; }

        [DataMember]
        public string begin_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public decimal min_price { set; get; }

        [DataMember]
        public decimal off_price { set; get; }

        [DataMember]
        public List<FullOffItems> fulloff_item_list { set; get; }
    }

    [DataContract]
    public class FullOffItems
    {
        [DataMember]
        public int fulloff_item_id { set; get; }

        [DataMember]
        public int product_id { set; get; }  

        [DataMember]
        public string product_name { set; get; }

        [DataMember]
        public string img_src { set; get; }

        [DataMember]
        public string product_code { set; get; }

        [DataMember]
        public string sale_price { set; get; }

        [DataMember]
        public string begin_time { set; get; }

        [DataMember]
        public string end_time { set; get; }
    } 
}
