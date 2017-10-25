using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyRecommentItemsUsePlat
    {
        public static Response<ResponseBodyEmpty> Do(int iid, int plat)
       {
           RequestModyItemUsePlatBody body = new RequestModyItemUsePlatBody();
           body.ri_id = iid.ToString();
           body.use_plat = plat.ToString();

           Request<RequestModyItemUsePlatBody> request = new Request<RequestModyItemUsePlatBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyRecommentItemUsePlat";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModyItemUsePlatBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModyItemUsePlatBody
   {
       [DataMember]
       public string ri_id { set; get; }

       [DataMember]
       public string use_plat { set; get; }
   } 
}
