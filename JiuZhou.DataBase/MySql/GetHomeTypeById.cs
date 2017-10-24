using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetHomeTypeById
    {
        public static Response<CategSetInfo> Do(int homeid)
       {
           RequestHomeTypeBody typeBody = new RequestHomeTypeBody();

           typeBody.home_pt_id = homeid.ToString();
           Request<RequestHomeTypeBody> request = new Request<RequestHomeTypeBody>();
           request.Body = typeBody;
           request.Header = request.NewHeader();
           request.Key = "GetHomeTypeById";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestHomeTypeBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<CategSetInfo>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestHomeTypeBody {
        [DataMember]
        public string home_pt_id { set; get; }
    }
 
}
