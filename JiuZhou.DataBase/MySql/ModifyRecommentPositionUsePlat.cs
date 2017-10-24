using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyRecommentPositionUsePlat
    {
        public static Response<ResponseBodyEmpty> Do(int pid, int plat)
       {
           RequestModyUsePlatBody body = new RequestModyUsePlatBody();
           body.rp_id = pid.ToString();
           body.use_plat = plat.ToString();

           Request<RequestModyUsePlatBody> request = new Request<RequestModyUsePlatBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyRecommentPositionUsePlat";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModyUsePlatBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModyUsePlatBody
   {
       [DataMember]
       public string rp_id { set; get; }

       [DataMember]
       public string use_plat { set; get; }
   } 
}
