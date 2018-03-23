using JiuZhou.HttpTools;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace JiuZhou.MySql
{
    public class QueryReChargeList
    {
        public static Response<ResponseReChargeReqBody> Do(int pagesize, int pageindex,int searchtype, string _skey, ref int dataCount, ref int pageCount)
        {
            RequestQueryReChargeReqBody search = new RequestQueryReChargeReqBody();

            search.page_size = pagesize.ToString();
            search.page_no = pageindex.ToString();
            search.keyword = _skey;
            search.searchtype = searchtype.ToString();
            Request<RequestQueryReChargeReqBody> request = new Request<RequestQueryReChargeReqBody>();
            request.Body = search;
            request.Header = request.NewHeader();
            request.Key = "QueryRechargeList";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryReChargeReqBody>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseReChargeReqBody>>(responseStr);
            if (response != null && response.Body != null && response.Body.recharge_list != null)
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
    public class RechargeInfo
    {
        /// <summary>
        /// 充值ID
        /// </summary>
        [DataMember]
        public int id { set; get; }
        /// <summary>
        /// 流水号
        /// </summary>
        [DataMember]
        public string serialno { set; get; }
        /// <summary>
        /// 生成时间
        /// </summary>
        [DataMember]
        public string add_time { set; get; }
        /// <summary>
        /// 支付状态
        /// </summary>
        [DataMember]
        public string pay_state { set; get; }
        /// <summary>
        /// 充值金额
        /// </summary>
        [DataMember]
        public string total_money { set; get; }
        /// <summary>
        /// 支付类型
        /// </summary>
        [DataMember]
        public string pay_type { set; get; }
        /// <summary>
        /// 支付时间
        /// </summary>
        [DataMember]
        public string pay_time { set; get; }

        /// <summary>
        /// 用户ID
        /// </summary>
        [DataMember]
        public string user_id { set; get; }
    }

    [DataContract]
    public class RequestQueryReChargeReqBody
    {
        [DataMember]
        public string page_size { set; get; }
        [DataMember]
        public string page_no { set; get; }
        [DataMember]
        public string keyword { set; get; }
        [DataMember]
        public string searchtype { set; get; }
    }

    [DataContract]
    public class ResponseReChargeReqBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<RechargeInfo> recharge_list { set; get; }
    }
}
