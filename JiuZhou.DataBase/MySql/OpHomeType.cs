using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpHomeType
    {
       public static Response<ResponseBodyEmpty> Do(CategSetInfo item)
       {
           RequestOpHomeTypeBody body = new RequestOpHomeTypeBody();
           body.home_pt_id = item.home_pt_id.ToString();
           body.parent_id = item.parent_id.ToString();
           body.type_name = item.type_name;
           body.type_url = item.type_url;
           body.sort_no = item.sort_no.ToString();
           body.is_black = item.is_black.ToString();
           body.is_color = item.is_color.ToString();
           body.is_newline = item.is_newline.ToString();
           body.pos_type = item.pos_type.ToString();

           Request<RequestOpHomeTypeBody> request = new Request<RequestOpHomeTypeBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpHomeType";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpHomeTypeBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpHomeTypeBody
   {
       [DataMember]
       public string home_pt_id { set; get; }

       [DataMember]
       public string type_name { set; get; }

       [DataMember]
       public string type_url { set; get; }

       [DataMember]
       public string sort_no { set; get; }

       [DataMember]
       public string parent_id { set; get; }

       [DataMember]
       public string is_black { set; get; }

       [DataMember]
       public string is_color { set; get; }

       [DataMember]
       public string is_newline { set; get; }

       [DataMember]
       public string pos_type { set; get; }
   } 
}
