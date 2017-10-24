using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetSysFileType
    {
        public static Response<ResponsePicTypeBody> Do(int state)
       {
           RequestPicTypeBody typeBody = new RequestPicTypeBody();

           typeBody.sp_type_state = state.ToString();
           Request<RequestPicTypeBody> request = new Request<RequestPicTypeBody>();
           request.Body = typeBody;
           request.Header = request.NewHeader();
           request.Key = "GetSysFileType";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestPicTypeBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponsePicTypeBody>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestPicTypeBody {
        [DataMember]
        public string sp_type_state { set; get; }
    }

    [DataContract]
    public class ResponsePicTypeBody
    {
        [DataMember]
        public List<PicTypeList> type_list { set; get; }
    }
   [DataContract]
   public class PicTypeList
   {
       [DataMember]
       public int sp_type_id { set; get; }

       [DataMember]
       public string parent_code { set; get; }

       [DataMember]
       public string type_code { set; get; }

       [DataMember]
       public int sp_type_state { set; get; }

       [DataMember]
       public string sp_type_name { set; get; }

       [DataMember]
       public int is_sys { set; get; }

       [DataMember]
       public int sort_no { set; get; }

       [DataMember]
       public string type_path { set; get; }
   } 
}
