using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryRedPackList
    {
        public static Response<ResponseQueryRedPackBody> Do(int pagesize, int pageindex, ref int dataCount, ref int pageCount)
       {
           RequestQueryRedPackBody search = new RequestQueryRedPackBody();
           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           Request<RequestQueryRedPackBody> request = new Request<RequestQueryRedPackBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryRedPackList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryRedPackBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseQueryRedPackBody>>(responseStr);
           if (response != null && response.Body != null && response.Body.rule_list != null)
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
    public class RequestQueryRedPackBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }
    }

    [DataContract]
    public class ResponseQueryRedPackBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<RedPackInfo> rule_list { set; get; }
    }

    [DataContract]
    public class RedPackInfo
    {
        [DataMember]
        public int redpack_rule_id { set; get; }  

        [DataMember]
        public string title { set; get; }

        [DataMember]
        public decimal sum_money { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public decimal pack_money_max { set; get; }

        [DataMember]
        public decimal pack_money_min { set; get; }

        [DataMember]
        public int pack_numsum { set; get; }

        [DataMember]
        public int Redpack_distribution_id { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public string valid_time { set; get; }
    }
}
