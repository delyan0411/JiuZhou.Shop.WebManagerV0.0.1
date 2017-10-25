using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpSysFileType
    {
        public static Response<ResponseBodyEmpty> Do(PicTypeList item)
       {
           RequestOpSysFileBody body = new RequestOpSysFileBody();
           body.sp_type_id = item.sp_type_id.ToString();
           body.type_code = item.type_code;
           body.parent_code = item.parent_code;
           body.sp_type_name = item.sp_type_name;
           body.sp_type_state = item.sp_type_state.ToString();
           body.is_sys = item.is_sys.ToString();
           body.sort_no = item.sort_no.ToString();

           Request<RequestOpSysFileBody> request = new Request<RequestOpSysFileBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpSysFileType";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpSysFileBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestOpSysFileBody
   {
       [DataMember]
       public string sp_type_id { set; get; }

       [DataMember]
       public string type_code { set; get; }

       [DataMember]
       public string parent_code { set; get; }

       [DataMember]
       public string sp_type_name { set; get; }

       [DataMember]
       public string sp_type_state { set; get; }

       [DataMember]
       public string is_sys { set; get; }

       [DataMember]
       public string sort_no { set; get; }
   } 
}
