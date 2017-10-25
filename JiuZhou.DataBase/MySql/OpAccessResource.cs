using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpAccessResource
    {
        public static Response<ResponseBodyEmpty> Do(int accessid, string ids, string delids)
       {
           RequestOpAccessResourceBody body = new RequestOpAccessResourceBody();
           body.access_id = accessid.ToString();
           body.res_ids = ids.Split(',');
           body.del_res_ids = delids.Split(',');

           Request<RequestOpAccessResourceBody> request = new Request<RequestOpAccessResourceBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpAccessResource";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpAccessResourceBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

   [DataContract]
   public class RequestOpAccessResourceBody
   {
       [DataMember]
       public string access_id { set; get; }

       [DataMember]
       public string[] res_ids { set; get; }

       [DataMember]
       public string[] del_res_ids { set; get; }
   }
}
