using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpTopicPhoneModuleItems
    {
        public static Response<ResponseBodyEmpty> Do(STModuleInfo info, string delids)
        {
            RequestOpPhoneModuleItem body = new RequestOpPhoneModuleItem();

            body.st_id = info.st_id.ToString();
            body.st_module_id = info.st_module_id.ToString();
            body.module_desc = info.module_desc;
            List<HotAreaList> list = new List<HotAreaList>();
            if (info.topic_item_list != null)
            {
                foreach (STItemInfo item in info.topic_item_list)
                {
                    HotAreaList em = new HotAreaList();
                    em.itemid = item.st_item_id.ToString();
                    em.area = item.item_name.ToString();
                    em.sort_no = item.sort_no.ToString();
                    em.url = item.item_img_src;
                    em.product_id = item.product_id.ToString();
                    list.Add(em);
                }
            }
            body.hotarealist = list;
            body.del_item_ids = delids.Split(',');
            Request<RequestOpPhoneModuleItem> request = new Request<RequestOpPhoneModuleItem>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "OpTopicPhoneItemsModule";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestOpPhoneModuleItem>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }

   [DataContract]
   public class RequestOpPhoneModuleItem
    {
       [DataMember]
       public string st_id { set; get; }

       [DataMember]
       public string st_module_id { set; get; }

       [DataMember]
       public string module_desc { set; get; }

       
       [DataMember]
       public string[] del_item_ids { set; get; }

       [DataMember]
       public List<HotAreaList> hotarealist { set; get; }
   }
    [DataContract]
    public class HotAreaList
    {
        [DataMember]
        public string itemid { set; get; }

        [DataMember]
        public string url { set; get; }

        [DataMember]
        public string area { set; get; }

        [DataMember]
        public string sort_no { get; set; }

        [DataMember]
        public string product_id { get; set; }
    }
}
