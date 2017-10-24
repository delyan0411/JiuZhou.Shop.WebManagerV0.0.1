using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetAreaByParentId
    {
        public static Response<ShortAreaList> Do(int parentid, int visible)
       {
           RequestAreasBody shopsBody = new RequestAreasBody();

           shopsBody.parent_id = parentid.ToString();
           shopsBody.is_visible = visible.ToString(); 
           Request<RequestAreasBody> request = new Request<RequestAreasBody>();
           request.Body = shopsBody;
           request.Header = request.NewHeader();
           request.Key = "GetAreaByParentId";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestAreasBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ShortAreaList>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestAreasBody {
        [DataMember]
        public string parent_id { set; get; }

        [DataMember]
        public string is_visible { set; get; }
    }

    [DataContract]
    public class ShortAreaList
    {
        [DataMember]
        public string rec_no { set; get; }

        [DataMember]
        public List<ShortAreaInfo> area_list { set; get; }
    }

   [DataContract]
    public class ShortAreaInfo
   {
       [DataMember]
       public int area_id { set; get; }

       [DataMember]
       public string area_name { set; get; }

       [DataMember]
       public string full_name { set; get; }
   } 
}
