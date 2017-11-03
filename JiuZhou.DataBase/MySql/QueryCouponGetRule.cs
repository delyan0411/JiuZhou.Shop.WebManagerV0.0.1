using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryCouponGetRule
    {
        public static Response<ResponseQueryCouponGetRuleBody> Do(int pagesize, int pageindex, string _skey, ref int dataCount, ref int pageCount)
       {
           RequestQueryCouponGetRuleBody search = new RequestQueryCouponGetRuleBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.search_key = _skey;

           Request<RequestQueryCouponGetRuleBody> request = new Request<RequestQueryCouponGetRuleBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryCouponGetRule";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryCouponGetRuleBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseQueryCouponGetRuleBody>>(responseStr);

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
    public class RequestQueryCouponGetRuleBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string search_key { set; get; }
    }

    [DataContract]
    public class ResponseQueryCouponGetRuleBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<CouponGetRuleInfo> rule_list { set; get; }
    }

    [DataContract]
    public class CouponGetRuleInfo
    {
        [DataMember]
        public int cget_rule_id { set; get; }

        [DataMember]
        public int coupen_type { set; get; }

        [DataMember]
        public string cget_name { set; get; }

        [DataMember]
        public string cget_remark { set; get; }

        [DataMember]
        public int validity_days { set; get; }

        [DataMember]
        public int max_give_num { set; get; }

        [DataMember]
        public int max_day_give_num { set; get; }

        [DataMember]
        public int limit_per_user_total { set; get; }

        [DataMember]
        public int limit_per_user_day { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string lqstart_time { set; get; }

        [DataMember]
        public int add_user_id { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public List<CouponGetItem> item_list { set; get; }
    }

    [DataContract]
    public class CouponGetItem
    {
        [DataMember]
        public int cget_item_id { set; get; }

        [DataMember]
        public int cget_rule_id { set; get; }

        [DataMember]
        public decimal coupon_price { set; get; }
     
        [DataMember]
        public int max_give_num { set; get; }

        [DataMember]
        public int max_day_give_num { set; get; }

        [DataMember]
        public int limit_per_user_total { set; get; }

        [DataMember]
        public int limit_per_user_day { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public int add_user_id { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public decimal coupon_cond { set; get; }

        [DataMember]
        public string proids { set; get; }
    }
}
