using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpTopicModulePaging
    {
       public static Response<ResponseBodyEmpty> Do(STModuleInfo info)
       {
           RequestOpModulePaging body = new RequestOpModulePaging();

           body.st_id = info.st_id.ToString();
           body.st_module_id = info.st_module_id.ToString();
           body.is_full_screen = info.is_full_screen.ToString();
           body.allow_show_name = info.allow_show_name.ToString();
           body.module_name = info.module_name;
           body.module_desc = info.module_desc;
           body.module_content = info.module_content;
           body.cell_count = info.cell_count.ToString();
           body.sort_column = info.sort_column;
           body.allow_paging = info.allow_paging.ToString();
           body.product_brand = info.product_brand;
           body.product_type = info.product_type.ToString();
           body.page_size = info.page_size.ToString();
           body.shop_id = info.shop_id.ToString();

           Request<RequestOpModulePaging> request = new Request<RequestOpModulePaging>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpTopicPagingModule";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpModulePaging>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

   [DataContract]
   public class RequestOpModulePaging
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
       public string module_content { set; get; }

       [DataMember]
       public string cell_count { set; get; }

       [DataMember]
       public string sort_column { set; get; }

       [DataMember]
       public string allow_paging { set; get; }

       [DataMember]
       public string product_brand { set; get; }

       [DataMember]
       public string product_type { set; get; }

       [DataMember]
       public string shop_id { set; get; }

       [DataMember]
       public string page_size { set; get; }
   }
}
