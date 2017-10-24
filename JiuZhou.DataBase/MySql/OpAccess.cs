using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpAccess
    {
       public static Response<ResponseBodyEmpty> Do(AccessInfo item)
       {
           RequestOpAccessBody body = new RequestOpAccessBody();
           body.access_id = item.access_id.ToString();
           body.parent_id = item.parent_id.ToString();
           body.access_name = item.access_name;
           body.access_desc = item.access_desc;
           body.sort_no = item.sort_no.ToString();

           Request<RequestOpAccessBody> request = new Request<RequestOpAccessBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpAccess";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpAccessBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpAccessBody
   {
       [DataMember]
       public string access_id { set; get; }

       [DataMember]
       public string parent_id { set; get; }

       [DataMember]
       public string access_name { set; get; }

       [DataMember]
       public string access_desc { set; get; }

       [DataMember]
       public string sort_no { set; get; }
   } 
}
