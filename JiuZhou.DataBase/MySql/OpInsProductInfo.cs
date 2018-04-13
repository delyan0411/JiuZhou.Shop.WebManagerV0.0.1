using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class OpInsProductInfo
    {
        public static Response<ResponseBodyEmpty> Do(int id, string add_proids, string del_proids,string addtypeids,string deltypeids)
        {
            RequestOpInsProductInfo insurance = new RequestOpInsProductInfo();
            insurance.id = id.ToString();
            insurance.add_proids = add_proids.Split(','); ;
            insurance.del_proids = del_proids.Split(','); ;
            insurance.addtypeids = addtypeids.Split(','); ;
            insurance.deltypeids = deltypeids.Split(','); ;
            Request<RequestOpInsProductInfo> request = new Request<RequestOpInsProductInfo>();
            request.Body = insurance;
            request.Header = request.NewHeader();
            request.Key = "OpInsproduct";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestOpInsProductInfo>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestOpInsProductInfo
    {
        [DataMember]
        public string id { set; get; }


        [DataMember]
        public string[] add_proids { set; get; }

        [DataMember]
        public string[] del_proids { set; get; }

        [DataMember]
        public string[] addtypeids { set; get; }

        [DataMember]
        public string[] deltypeids { set; get; }
    } 
}
