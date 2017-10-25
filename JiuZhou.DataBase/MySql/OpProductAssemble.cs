using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpProductAssemble
    {
        public static Response<ResponseBodyEmpty> Do(ResponseProductAssemble assemble, string mainids, List<OpAssembleInfo> assembleproduct, string delitemids, string delmainids)
       {
           RequestOpProductAssembleBody assemblebody = new RequestOpProductAssembleBody();

           assemblebody.ass_id = assemble.ass_id.ToString();
           assemblebody.ass_subject = assemble.ass_subject;
           assemblebody.ass_summary = assemble.ass_summary ;
           assemblebody.ass_type = assemble.ass_type.ToString();
           assemblebody.main_product_ids = mainids;
           List<OpAssembleInfo> list = new List<OpAssembleInfo>();
           foreach (OpAssembleInfo item in assembleproduct) {
               OpAssembleInfo ass = new OpAssembleInfo();
               ass.ass_item_id = item.ass_item_id;
               ass.product_id = item.product_id;
               ass.sort_no = item.sort_no;
               ass.promotion_price = item.promotion_price;
               list.Add(ass);
           }
           assemblebody.ass_item_list = list;
           assemblebody.delete_ass_item_ids = delitemids;
           assemblebody.delete_ass_main_ids = delmainids;
           Request<RequestOpProductAssembleBody> request = new Request<RequestOpProductAssembleBody>();
           request.Body = assemblebody;
           request.Header = request.NewHeader();
           request.Key = "OpProductAssemble";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpProductAssembleBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestOpProductAssembleBody
    {
        [DataMember]
        public string ass_id { set; get; }

        [DataMember]
        public string ass_subject { set; get; }

        [DataMember]
        public string ass_summary { set; get; }

        [DataMember]
        public string ass_type { set; get; }

        [DataMember]
        public string main_product_ids { set; get; }

        [DataMember]
        public List<OpAssembleInfo> ass_item_list { set; get; }

        [DataMember]
        public string delete_ass_item_ids { set; get; }

        [DataMember]
        public string delete_ass_main_ids { set; get; }
    }

    [DataContract]
    public class OpAssembleInfo
    {
        [DataMember]
        public string ass_item_id { set; get; }

        [DataMember]
        public string product_id { set; get; }

        [DataMember]
        public string sort_no { set; get; }

        [DataMember]
        public string promotion_price { set; get; }
    }
}
