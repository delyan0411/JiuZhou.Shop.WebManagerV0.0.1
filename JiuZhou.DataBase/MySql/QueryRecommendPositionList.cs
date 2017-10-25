using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryRecommendPositionList
    {
        public static Response<ResponseSearchRecommendBody> Do(int pagesize, int pageindex, int _posid, int plat, string _skey, ref int dataCount, ref int pageCount)
       {
           RequestSearchRecommendBody search = new RequestSearchRecommendBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.rp_id = _posid.ToString();
           search.search_key = _skey;
           search.use_plat = plat.ToString();

           Request<RequestSearchRecommendBody> request = new Request<RequestSearchRecommendBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryRecommendPositionList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchRecommendBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseSearchRecommendBody>>(responseStr);

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
    public class RequestSearchRecommendBody {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string rp_id { set; get; }

        [DataMember]
        public string search_key { set; get; }

        [DataMember]
        public string use_plat { set; get; }
    }

    [DataContract]
    public class ResponseSearchRecommendBody {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<RecommendPositionList> recommend_list { set; get; }
    }

    [DataContract]
    public class RecommendPositionList
    {
        [DataMember]
        public int rp_id { set; get; }  

        [DataMember]
        public string name_path { set; get; }

        [DataMember]
        public int use_plat { set; get; }
    } 
}
