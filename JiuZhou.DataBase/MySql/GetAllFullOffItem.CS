using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetAllFullOffItem
    {
        public static Response<ResponseFullOffAll> Do()
       {
           RequestBodyEmpty body = new RequestBodyEmpty();

           Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetAllFullOffItem";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseFullOffAll>>(responseStr);

           return response;
       }
    }

    [DataContract]
    public class ResponseFullOffAll
    {
        [DataMember]
        public List<FullOffItemAll> item_list { set; get; }
    }

    [DataContract]
    public class FullOffItemAll
    {
        [DataMember]
        public int fulloff_item_id { set; get; }

        [DataMember]
        public int product_id { set; get; }

        [DataMember]
        public string begin_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

    }

    public class ShortFullOffItem
    {
        public int fulloff_item_id { set; get; }

        public int product_id { set; get; }
    }
}
