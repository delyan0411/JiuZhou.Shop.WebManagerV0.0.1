using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
   public class OpResource
    {
       public static Response<ResponseBodyEmpty> Do(UserResBody user)
       {
           RequestOpResBody resourceBody = new RequestOpResBody();
           resourceBody.res_id = user.res_id.ToString();
           resourceBody.parent_id = user.parent_id.ToString();
           resourceBody.res_name = user.res_name;
           resourceBody.res_type = user.res_type.ToString();
           resourceBody.res_state = user.res_state.ToString();
           resourceBody.res_src = user.res_src;
           resourceBody.sort_no = user.sort_no.ToString();
           resourceBody.res_desc = "";
           resourceBody.res_code = user.res_code;

           Request<RequestOpResBody> request = new Request<RequestOpResBody>();
           request.Body = resourceBody;
           request.Header = request.NewHeader();
           request.Key = "OpResource";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpResBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpResBody
   {
       [DataMember]
       public string res_id { set; get; }

       [DataMember]
       public string parent_id { set; get; }

       [DataMember]
       public string res_type { set; get; }

       [DataMember]
       public string res_name { set; get; }

       [DataMember]
       public string res_state { set; get; }

       [DataMember]
       public string res_src { set; get; }

       [DataMember]
       public string sort_no { set; get; }
       
       [DataMember]
       public string res_desc { set; get; }

       [DataMember]
       public string res_code { set; get; }
   } 
}
