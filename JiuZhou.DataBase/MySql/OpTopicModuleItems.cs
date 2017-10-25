using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpTopicModuleItems
    {
        public static Response<ResponseBodyEmpty> Do(STModuleInfo info,string delids)
       {
           RequestOpModuleItem body = new RequestOpModuleItem();

           body.st_id = info.st_id.ToString();
           body.st_module_id = info.st_module_id.ToString();
           body.is_full_screen = info.is_full_screen.ToString();
           body.allow_show_name = info.allow_show_name.ToString();
           body.module_name = info.module_name;
           body.module_desc = info.module_desc;
           body.cell_count = info.cell_count.ToString();
           List<ModuleProduct> list = new List<ModuleProduct>();
           foreach (STItemInfo item in info.topic_item_list) {
               ModuleProduct em = new ModuleProduct();
               em.st_item_id = item.st_item_id.ToString();
               em.product_id = item.product_id.ToString();
               em.sort_no = item.sort_no.ToString();
               em.start_time = item.start_time;
               em.end_time = item.end_time;
               list.Add(em);
           }
           body.product_list = list;
           body.del_item_ids = delids.Split(',');
           Request<RequestOpModuleItem> request = new Request<RequestOpModuleItem>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpTopicItemsModule";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpModuleItem>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

   [DataContract]
   public class RequestOpModuleItem
   {
       [DataMember]
       public string st_id { set; get; }

       [DataMember]
       public string st_module_id { set; get; }

       [DataMember]
       public string is_full_screen { set; get; }

       [DataMember]
       public string allow_show_name { set; get; }

       [DataMember]
       public string module_name { set; get; }

       [DataMember]
       public string module_desc { set; get; }

       [DataMember]
       public string cell_count { set; get; }
       
       [DataMember]
       public string[] del_item_ids { set; get; }

       [DataMember]
       public List<ModuleProduct> product_list { set; get; }
   }

    [DataContract]
    public class ModuleProduct 
    {
        [DataMember]
        public string st_item_id { set; get; }

        [DataMember]
        public string product_id { set; get; }

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
        public string sort_no { set; get; }

        [DataMember]
        public string sale_price { set; get; }

        [DataMember]
        public string market_price { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }
    }
}
