using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryShopList
    {
        public static Response<ResponseQueryShopBody> Do(int pagesize, int pageindex, string _skey, ref int dataCount, ref int pageCount)
       {
           RequestQueryShopBody search = new RequestQueryShopBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.search_key = _skey;

           Request<RequestQueryShopBody> request = new Request<RequestQueryShopBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryShopList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryShopBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseQueryShopBody>>(responseStr);

           if (response != null && response.Body != null)
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
    public class RequestQueryShopBody {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string search_key { set; get; }
    }

    [DataContract]
    public class ResponseQueryShopBody {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<ShortShopInfo> shop_list { set; get; }
    }

    [DataContract]
    public class ShortShopInfo
    {
        [DataMember]
        public int shop_id { set; get; }  

        [DataMember]
        public string shop_name { set; get; }

        [DataMember]
        public string shop_addr { set; get; }

        [DataMember]
        public string company_name { set; get; }

        [DataMember]
        public string shop_remark { set; get; }

        [DataMember]
        public string link_way { set; get; }

        [DataMember]
        public int shop_type { set; get; }

        [DataMember]
        public int shop_state { set; get; }
    } 
}
