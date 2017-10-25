using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyProductTypeVisible
    {
       public static Response<ResponseBodyEmpty> Do(int productTypeId, int status)
       {
           RequestModyTypeBody typeBody = new RequestModyTypeBody();
           typeBody.product_type_id = productTypeId.ToString();
           typeBody.is_visible = status.ToString();


           Request<RequestModyTypeBody> request = new Request<RequestModyTypeBody>();
           request.Body = typeBody;
           request.Header = request.NewHeader();
           request.Key = "ModifyProductTypeVisible";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModyTypeBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModyTypeBody
   {
       [DataMember]
       public string product_type_id { set; get; }

       [DataMember]
       public string is_visible { set; get; }
   } 
}
