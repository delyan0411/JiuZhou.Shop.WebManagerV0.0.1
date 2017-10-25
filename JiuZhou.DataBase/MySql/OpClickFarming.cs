using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpClickFarming
    {
        public static Response<ResponseBodyEmpty> Do(int id, string comment)
       {
           RequestOpClickFarmingBody body = new RequestOpClickFarmingBody();
           body.product_id = id.ToString();
           body.comment_content = comment;

           Request<RequestOpClickFarmingBody> request = new Request<RequestOpClickFarmingBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpClickFarming";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpClickFarmingBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpClickFarmingBody
   {
       [DataMember]
       public string product_id { set; get; }

       [DataMember]
       public string comment_content { set; get; }
   } 
}
