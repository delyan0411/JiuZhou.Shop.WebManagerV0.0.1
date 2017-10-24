using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryBrandList
    {
        public static Response<ResponseQueryBrandBody> Do(int pagesize, int pageindex, string q, ref int dataCount, ref int pageCount)
       {
           RequestQueryBrand body = new RequestQueryBrand();
           body.page_size = pagesize.ToString();
           body.page_no = pageindex.ToString();
           body.search_key = q;

           Request<RequestQueryBrand> request = new Request<RequestQueryBrand>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "QueryBrandList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryBrand>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseQueryBrandBody>>(responseStr);

           if (response.Body != null && response != null && response.Body.rec_num !=null && response.Body.brand_list != null)
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
    public class RequestQueryBrand
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string search_key { set; get; }
    }

    [DataContract]
    public class ResponseQueryBrandBody {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<BrandInfo> brand_list { set; get; }
    }

    [DataContract]
    public class BrandInfo
    {
        [DataMember]
        public string brand_name { set; get; }

        [DataMember]
        public int brand_id { set; get; }

        [DataMember]
        public string brand_intro { set; get; }

        [DataMember]
        public string logo_src { set; get; }

        [DataMember]
        public int sort_no { set; get; }

        [DataMember]
        public int brand_state { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public List<BrandAuthInfo> auth_list { set; get; }
    }

    [DataContract]
    public class BrandAuthInfo {
        [DataMember]
        public int brand_auth_id { set; get; }

        [DataMember]
        public int brand_id { set; get; }

        [DataMember]
        public int shop_id { set; get; }

        [DataMember]
        public string authorization_src { set; get; }

        [DataMember]
        public string expired_time { set; get; }

        [DataMember]
        public string add_time { set; get; }
    }
}
