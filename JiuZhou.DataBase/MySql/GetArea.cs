using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetArea
    {
        public static Response<AreaList> Do(int areaid)
       {
           RequestAreaBody shopsBody = new RequestAreaBody();

           shopsBody.area_id = areaid.ToString();
           Request<RequestAreaBody> request = new Request<RequestAreaBody>();
           request.Body = shopsBody;
           request.Header = request.NewHeader();
           request.Key = "GetArea";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestAreaBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<AreaList>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestAreaBody {
        [DataMember]
        public string area_id { set; get; }
    }

    [DataContract]
    public class AreaList
    {
        [DataMember]
        public string rec_no { set; get; }

        [DataMember]
        public List<AreaInfo> area_list { set; get; }
    }

   [DataContract]
    public class AreaInfo
   {
       [DataMember]
       public int area_id { set; get; }

       [DataMember]
       public int parent_id { set; get; }

       [DataMember]
       public string area_path { set; get; }

       [DataMember]
       public string area_name { set; get; }

       [DataMember]
       public int is_visible { set; get; }
   } 
}
