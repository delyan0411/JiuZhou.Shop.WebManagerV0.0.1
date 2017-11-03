using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryProductAssembleDetail
    {
        public static Response<ResponseProductAssemble> Do(int assid)
        {
            RequestProductAssembleBody assBody = new RequestProductAssembleBody();

            assBody.ass_id = assid.ToString();
            Request<RequestProductAssembleBody> request = new Request<RequestProductAssembleBody>();
            request.Body = assBody;
            request.Header = request.NewHeader();
            request.Key = "QueryProductAssembleDetail";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestProductAssembleBody>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseProductAssemble>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestProductAssembleBody
    {
        [DataMember]
        public string ass_id { set; get; }
    }

    [DataContract]
    public class ResponseProductAssemble
    {
        [DataMember]
        public int ass_id { set; get; }

        [DataMember]
        public string ass_subject { set; get; }

        [DataMember]
        public string ass_summary { set; get; }

        [DataMember]
        public int ass_type { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string main_rec_num { set; get; }

        [DataMember]
        public List<MainProduct> main_product_list { set; get; }

        [DataMember]
        public string item_rec_num { set; get; }

        [DataMember]
        public List<AssembleProduct> item_product_list { set; get; }
    }

    [DataContract]
    public class MainProduct
    {
        [DataMember]
        public int ass_main_id { set; get; }

        [DataMember]
        public int product_id { set; get; }

        [DataMember]
        public string product_name { set; get; }

        [DataMember]
        public string img_src { set; get; }

        [DataMember]
        public string product_code { set; get; }

        [DataMember]
        public decimal sale_price { set; get; }

        [DataMember]
        public string product_type_path { set; get; }
    }

    [DataContract]
    public class AssembleProduct
    {
        [DataMember]
        public int ass_item_id { set; get; }

        [DataMember]
        public int product_id { set; get; }

        [DataMember]
        public string product_name { set; get; }

        [DataMember]
        public string img_src { set; get; }

        [DataMember]
        public string product_code { set; get; }

        [DataMember]
        public decimal sale_price { set; get; }

        [DataMember]
        public string product_type_path { set; get; }

        [DataMember]
        public decimal promotion_price { set; get; }
    }
}
