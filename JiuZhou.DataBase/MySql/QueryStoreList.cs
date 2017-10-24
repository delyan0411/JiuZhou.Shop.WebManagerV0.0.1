using JiuZhou.HttpTools;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace JiuZhou.MySql
{
    public class QueryStoreList
    {
        public static Response<ResponseQueryStoreReqBody> Do(int pagesize, int pageindex,  string _skey,ref int dataCount, ref int pageCount)
       {
            RequestQueryStoreReqBody search = new RequestQueryStoreReqBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.search_key = _skey;

           Request<RequestQueryStoreReqBody> request = new Request<RequestQueryStoreReqBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryStoreList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryStoreReqBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseQueryStoreReqBody>>(responseStr);
           if (response != null && response.Body != null && response.Body.store_list != null)
           {
               dataCount = int.Parse(response.Body.rec_num);
               if (dataCount % pagesize == 0)
               {
                   pageCount = dataCount / pagesize;
               }
               else
               {
                   pageCount = dataCount / pagesize + 1;
               }
           }
           return response;
       }
    }

    [DataContract]
    public class RequestQueryStoreReqBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string search_key { set; get; }

    }

    [DataContract]
    public class ResponseQueryStoreReqBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<StoreInfo> store_list { set; get; }
    }

    [DataContract]
    public class StoreInfo
    {
        [DataMember]
        public string store_id { set; get; }  

        [DataMember]
        public string store_name { set; get; }


        [DataMember]
        public string create_time { set; get; }

    } 
}
