using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryProductJoin
    {
        public static Response<ResponseQueJoinBody> Do(int pagesize, int pageindex, string _type, string _skey, ref int dataCount, ref int pageCount)
       {
           RequestSearchJoinBody search = new RequestSearchJoinBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.type_name = _type;
           search.search_key = _skey;

           Request<RequestSearchJoinBody> request = new Request<RequestSearchJoinBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryProductJoin";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchJoinBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseQueJoinBody>>(responseStr);
           if (response.Body != null && response != null && response.Body.join_list != null)
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
    public class RequestSearchJoinBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string type_name { set; get; }

        [DataMember]
        public string search_key { set; get; }
    }

    [DataContract]
    public class ResponseQueJoinBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<ProductJoinInfo> join_list { set; get; }
    }

    [DataContract]
    public class ProductJoinInfo
    {
        [DataMember]
        public int product_join_id { set; get; }

        [DataMember]
        public string type_name { set; get; }

        [DataMember]
        public string join_name { set; get; }

        [DataMember]
        public int allow_refresh { set; get; }

        [DataMember]
        public int view_type { set; get; }
    } 
}
