using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryAccessList
    {
        public static Response<ResponseQueryAccessBody> Do()
       {
           RequestBodyEmpty search = new RequestBodyEmpty();


           Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryAccessList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseQueryAccessBody>>(responseStr);

           return response;
       }
    }


    [DataContract]
    public class ResponseQueryAccessBody {
        [DataMember]
        public List<AccessInfo> access_list { set; get; }
    }

    [DataContract]
    public class AccessInfo
    {
        [DataMember]
        public int access_id { set; get; }

        [DataMember]
        public int parent_id { set; get; }

        [DataMember]
        public string access_path { set; get; }

        [DataMember]
        public string access_name { set; get; }

        [DataMember]
        public int sort_no { set; get; }

        [DataMember]
        public string access_desc { set; get; }

        [DataMember]
        public string add_time { set; get; }
    } 
}
