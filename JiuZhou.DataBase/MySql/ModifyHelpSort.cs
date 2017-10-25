using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class ModifyHelpSort
    {
       public static Response<ResponseBodyEmpty> Do(int id, int sort)
       {
           RequestModyHelpSort body = new RequestModyHelpSort();
           body.help_id = id.ToString();
           body.sort_no = sort.ToString();

           Request<RequestModyHelpSort> request = new Request<RequestModyHelpSort>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "ModifyHelpSort";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestModyHelpSort>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestModyHelpSort
   {
       [DataMember]
       public string help_id { set; get; }

       [DataMember]
       public string sort_no { set; get; }
   } 
}
