using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetInsuranceList
    {
        public static Response<InsuranceList> Do()
       {
            RequestBodyEmpty typeBody = new RequestBodyEmpty();

           Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
           request.Body = typeBody;
           request.Header = request.NewHeader();
           request.Key = "GetInsuranceList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
            Logger.Log(requestStr);
           string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<InsuranceList>>(responseStr);
           return response;
       }
    }

   [DataContract]
   public class InsuranceList
    {
       [DataMember]
       public string rec_num { set; get; }

       [DataMember]
       public List<InsuranceInfo> insurance_list { set; get; }
   }

}
