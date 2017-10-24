using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetTopicDetails
    {
        public static Response<STopicDetails> Do(int stid)
        {
            RequestTopicInfoBody body = new RequestTopicInfoBody();

            body.st_id = stid.ToString();

            Request<RequestTopicInfoBody> request = new Request<RequestTopicInfoBody>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "GetTopicDetail";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestTopicInfoBody>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<STopicDetails>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class STopicDetails
    {
        [DataMember]
        public int st_id { set; get; }

        [DataMember]
        public string st_dir { set; get; }

        [DataMember]
        public string st_summary { set; get; }

        [DataMember]
        public string st_subject { set; get; }

        [DataMember]
        public string style_text { set; get; }

        [DataMember]
        public int st_state { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public List<STModuleInfo> topic_module_list { set; get; }
    }

    [DataContract]
    public class STModuleInfo {
        [DataMember]
        public int st_module_id { set; get; }

        [DataMember]
        public int st_id { set; get; }

        [DataMember]
        public string is_full_screen { set; get; }

        [DataMember]
        public int module_type { set; get; }

        [DataMember]
        public string allow_show_name { set; get; }

        [DataMember]
        public string module_name { set; get; }

        [DataMember]
        public string module_desc { set; get; }

        [DataMember]
        public string module_content { set; get; }

        [DataMember]
        public string cell_count { set; get; }

        [DataMember]
        public string allow_paging { set; get; }

        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string product_type { set; get; }

        [DataMember]
        public string shop_id { set; get; }

        [DataMember]
        public string product_brand { set; get; }

        [DataMember]
        public string sort_column { set; get; }

        [DataMember]
        public string module_height { set; get; }

        [DataMember]
        public List<STItemInfo> topic_item_list { set; get; }
    }

    [DataContract]
    public class STItemInfo
    {
        [DataMember]
        public int st_id { set; get; }

        [DataMember]
        public int st_module_id { set; get; }

        [DataMember]
        public int st_item_id { set; get; }

        [DataMember]
        public int product_id { set; get; }

        [DataMember]
        public string product_code { set; get; }

        [DataMember]
        public string product_name { set; get; }

        [DataMember]
        public string product_brand { set; get; }

        [DataMember]
        public string img_src { set; get; }

        [DataMember]
        public string sales_promotion { set; get; }

        [DataMember]
        public int sort_no { set; get; }

        [DataMember]
        public decimal sale_price { set; get; }

        [DataMember]
        public decimal market_price { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string item_img_src { set; get; }

        [DataMember]
        public string item_img_src2 { set; get; }

        [DataMember]
        public string item_name { set; get; }

        [DataMember]
        public string page_src { set; get; }
    }
}
