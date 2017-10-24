using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpTopicCarouselModule
    {
        public static Response<ResponseBodyEmpty> Do(STModuleInfo info,string delids)
       {
           RequestOpCarouselModuleItem body = new RequestOpCarouselModuleItem();

           body.st_id = info.st_id.ToString();
           body.st_module_id = info.st_module_id.ToString();
           body.allow_show_name = info.allow_show_name;
           body.module_name = info.module_name;
           body.module_height = info.module_height;

           List<CarouselModuleItem> list = new List<CarouselModuleItem>();
           foreach (STItemInfo item in info.topic_item_list) {
               CarouselModuleItem em = new CarouselModuleItem();
               em.st_item_id = item.st_item_id.ToString();
               em.sort_no = item.sort_no.ToString();
               em.item_img_src = item.item_img_src;
               em.item_name = item.item_name;
               em.page_src = item.page_src;
               list.Add(em);
           }
           body.item_list = list;
           body.del_item_ids = delids.Split(',');
           Request<RequestOpCarouselModuleItem> request = new Request<RequestOpCarouselModuleItem>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpTopicCarouselModule";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpCarouselModuleItem>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

   [DataContract]
   public class RequestOpCarouselModuleItem
   {
       [DataMember]
       public string st_id { set; get; }

       [DataMember]
       public string st_module_id { set; get; }

       [DataMember]
       public string allow_show_name { set; get; }

       [DataMember]
       public string module_name { set; get; }

       [DataMember]
       public string module_height { set; get; }

       [DataMember]
       public string[] del_item_ids { set; get; }

       [DataMember]
       public List<CarouselModuleItem> item_list { set; get; }
   }

    [DataContract]
   public class CarouselModuleItem 
    {
        [DataMember]
        public string st_item_id { set; get; }

        [DataMember]
        public string item_img_src { set; get; }

        [DataMember]
        public string item_name { set; get; }

        [DataMember]
        public string page_src { set; get; }

        [DataMember]
        public string sort_no { set; get; }
    }
}
