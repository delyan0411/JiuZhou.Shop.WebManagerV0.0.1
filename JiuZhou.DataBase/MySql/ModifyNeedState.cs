using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyNeedState
    {
       public static Response<ResponseBodyEmpty> Do(string id, int status ,string _type)
       {
           RequestOpNeedBody needBody = new RequestOpNeedBody();
           needBody.need_id = id;
           needBody.flag = status.ToString();


           Request<RequestOpNeedBody> request = new Request<RequestOpNeedBody>();
           request.Body = needBody;
           request.Header = request.NewHeader();
           request.Key = "AuditeNeeds";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpNeedBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpNeedBody
   {
       [DataMember]
       public string need_id { set; get; }

       [DataMember]
       public string flag { set; get; }
   } 
}
