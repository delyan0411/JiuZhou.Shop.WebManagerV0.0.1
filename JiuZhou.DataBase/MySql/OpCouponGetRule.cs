using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpCouponGetRule
    {
        public static Response<ResponseBodyEmpty> Do(CouponGetRuleInfo info, string desids)
        {
            RequestOpCouponGetRuleBody body = new RequestOpCouponGetRuleBody();
            body.cget_rule_id = info.cget_rule_id.ToString();
            body.cget_name = info.cget_name;
            body.coupen_type = info.coupen_type.ToString();
            body.cget_remark = info.cget_remark;
            body.validity_days = info.validity_days.ToString();
            body.max_give_num = info.max_give_num.ToString();
            body.max_day_give_num = info.max_day_give_num.ToString();
            body.limit_per_user_total = info.limit_per_user_total.ToString();
            body.limit_per_user_day = info.limit_per_user_day.ToString();
            body.start_time = info.start_time;
            body.end_time = info.end_time;
            body.lqstart_time = info.lqstart_time;
            body.del_item_ids = desids.Split(',');

            List<CouponGetItem2> list = new List<CouponGetItem2>();
            foreach (CouponGetItem item in info.item_list)
            {
                CouponGetItem2 em = new CouponGetItem2();
                em.cget_item_id = item.cget_item_id.ToString();
                em.coupon_price = item.coupon_price.ToString();
                em.max_give_num = item.max_give_num.ToString();
                em.max_day_give_num = item.max_day_give_num.ToString();
                em.limit_per_user_total = item.limit_per_user_total.ToString();
                em.limit_per_user_day = item.limit_per_user_day.ToString();
                em.start_time = item.start_time;
                em.end_time = item.end_time;
                em.coupon_cond = item.coupon_cond.ToString();
                em.proids = item.proids;
                list.Add(em);
            }
            body.item_list = list;

            Request<RequestOpCouponGetRuleBody> request = new Request<RequestOpCouponGetRuleBody>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "OpCouponGetRule";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestOpCouponGetRuleBody>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }
    [DataContract]
    public class RequestOpCouponGetRuleBody
    {
        [DataMember]
        public string cget_rule_id { set; get; }

        [DataMember]
        public string cget_name { set; get; }

        [DataMember]
        public string coupen_type { set; get; }

        [DataMember]
        public string cget_remark { set; get; }

        [DataMember]
        public string validity_days { set; get; }

        [DataMember]
        public string max_give_num { set; get; }

        [DataMember]
        public string max_day_give_num { set; get; }

        [DataMember]
        public string limit_per_user_total { set; get; }

        [DataMember]
        public string limit_per_user_day { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string lqstart_time { set; get; }

        [DataMember]
        public string[] del_item_ids { set; get; }

        [DataMember]
        public List<CouponGetItem2> item_list { set; get; }
    }

   [DataContract]
   public class CouponGetItem2
   {
       [DataMember]
       public string cget_item_id { set; get; }

        [DataMember]
        public string coupon_cond { set; get; }

        [DataMember]
        public string proids { set; get; }

        [DataMember]
       public string coupon_price { set; get; }

       [DataMember]
       public string max_give_num { set; get; }

       [DataMember]
       public string max_day_give_num { set; get; }

       [DataMember]
       public string limit_per_user_total { set; get; }

       [DataMember]
       public string limit_per_user_day { set; get; }

       [DataMember]
       public string start_time { set; get; }

       [DataMember]
       public string end_time { set; get; }
   }
}
