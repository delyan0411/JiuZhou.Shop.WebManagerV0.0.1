using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryAssembleList
    {
        public static Response<ResponseQueAssembleBody> Do(int pagesize, int pageindex, int _type, string _skey, ref int dataCount, ref int pageCount)
       {
           RequestSearchAssembleBody search = new RequestSearchAssembleBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.query_type = _type.ToString();
           search.search_key = _skey;

           Request<RequestSearchAssembleBody> request = new Request<RequestSearchAssembleBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryAssembleList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchAssembleBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseQueAssembleBody>>(responseStr);
           if (response != null && response.Body != null && response.Body.rec_num!=null)
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
    public class RequestSearchAssembleBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string query_type { set; get; }

        [DataMember]
        public string search_key { set; get; }
    }

    [DataContract]
    public class ResponseQueAssembleBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<ProductAssembleInfo> assemble_list { set; get; }
    }

    [DataContract]
    public class ProductAssembleInfo
    {
        [DataMember]
        public int ass_id { set; get; }

        [DataMember]
        public string ass_subject { set; get; }

        [DataMember]
        public string ass_summary { set; get; }

        [DataMember]
        public int ass_type { set; get; }
    } 
}
