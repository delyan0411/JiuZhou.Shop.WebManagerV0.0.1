using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyModuleSortNo
    {
       public static Response<ResponseBodyEmpty> Do(string ids)
       {
           RequestModyModuleSortNo body = new RequestModyModuleSortNo();
           body.st_module_ids = ids.Split(','); 

           Request<RequestModyModuleSortNo> request = new Request<RequestModyModuleSortNo>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyTopicModuleSortNo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModyModuleSortNo>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModyModuleSortNo
   {
       [DataMember]
       public string[] st_module_ids { set; get; }
   } 
}
