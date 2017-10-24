using JiuZhou.HttpTools;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace JiuZhou.MySql
{
    public class QueryStoreOrderList
    {
        public static Response<ResponseQueStoreOrderListBody> Do(int pagesize, int pageindex,string _skey, ref int dataCount, ref int pageCount)
        {
            RequestSearchStoreOrderListBody search = new RequestSearchStoreOrderListBody();

            search.page_size = pagesize.ToString();
            search.page_no = pageindex.ToString();
            search.search_key = _skey;

            Request<RequestSearchStoreOrderListBody> request = new Request<RequestSearchStoreOrderListBody>();
            request.Body = search;
            request.Header = request.NewHeader();
            request.Key = "QueryStoreOrderList";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchStoreOrderListBody>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseQueStoreOrderListBody>>(responseStr);
            if (response != null && response.Body != null && response.Body.rec_num != null)
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
    public class RequestSearchStoreOrderListBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string search_key { set; get; }
    }

    [DataContract]
    public class ResponseQueStoreOrderListBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<FullStoreOrderInfo> order_list { set; get; }
    }

    [DataContract]
    public class FullStoreOrderInfo
    {
        
        [DataMember]
        public int id { set; get; }

        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public string store_id { set; get; }

        [DataMember]
        public string store_name { set; get; }

        [DataMember]
        public string create_time { set; get; }

        [DataMember]
        public string state { set; get; }
    }
}
