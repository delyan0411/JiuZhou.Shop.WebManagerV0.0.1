using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryOrderList
    {
        public static Response<ResponseQueOrderPayBody> Do(int pagesize, int pageindex, int orderstate, string stime, string etime, int searchtype, int paytype, string _skey, string _ocol, string _ot, ref int dataCount, ref int pageCount)
        {
            RequestSearchOrderPayBody search = new RequestSearchOrderPayBody();

            search.page_size = pagesize.ToString();
            search.page_no = pageindex.ToString();
            search.order_state = orderstate.ToString();
            search.search_type = searchtype.ToString();
            search.pay_type = paytype.ToString();
            search.start_time = stime;
            search.end_time = etime;
            search.search_key = _skey;
            search.sort_column = _ocol;
            search.sort_type = _ot;

            Request<RequestSearchOrderPayBody> request = new Request<RequestSearchOrderPayBody>();
            request.Body = search;
            request.Header = request.NewHeader();
            request.Key = "QueryOrderList";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchOrderPayBody>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseQueOrderPayBody>>(responseStr);

            if (response != null && response.Body != null && response.Body.order_pay_list != null)
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
    public class RequestSearchOrderPayBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string order_state { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string search_type { set; get; }

        [DataMember]
        public string pay_type { set; get; }


        [DataMember]
        public string search_key { set; get; }

        [DataMember]
        public string sort_column { set; get; }

        [DataMember]
        public string sort_type { set; get; }
    }

    [DataContract]
    public class ResponseQueOrderPayBody {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<OrderPayInfo> order_pay_list { set; get; }
    }

    [DataContract]
    public class OrderPayInfo
    {
        [DataMember]
        public int order_pay_id { set; get; }

        [DataMember]
        public int user_id { set; get; }

        [DataMember]
        public string user_name { set; get; }

        [DataMember]
        public string pay_order_no { set; get; }

        [DataMember]
        public int order_type { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public int pay_type { set; get; }

        [DataMember]
        public string pay_type_name { set; get; }

        [DataMember]
        public int expired_minute { set; get; }

        [DataMember]
        public decimal pay_total_money { set; get; }

        [DataMember]
        public decimal pay_order_money { set; get; }

        [DataMember]
        public decimal pay_trans_money { set; get; }

        [DataMember]
        public int pay_order_state { set; get; }

        [DataMember]
        public int pay_state { set; get; }

        [DataMember]
        public string receive_mobile_no { set; get; }

        [DataMember]
        public int send_msg_count { set; get; }

        [DataMember]
        public int is_delete { set; get; }

        [DataMember]
        public int pay_delivery_state { set; get; }

        [DataMember]
        public int pay_service_state { set; get; }

        [DataMember]
        public List<OrderInfo> order_list { set; get; }


        [DataMember]
        public int ywlx { set; get; }

        [DataMember]
        public decimal taxes_money { set; get; }
    }

    [DataContract]
    public class OrderInfo
    {
        [DataMember]
        public int order_id { set; get; }

        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public int delivery_state { set; get; }

        [DataMember]
        public decimal total_money { set; get; }

        [DataMember]
        public decimal order_money { set; get; }

        [DataMember]
        public decimal trans_money { set; get; }

        [DataMember]
        public int order_state { set; get; }

        [DataMember]
        public string receive_mobile_no { set; get; }

        [DataMember]
        public string receive_user_tel { set; get; }

        [DataMember]
        public string receive_addr { set; get; }

        [DataMember]
        public string receive_name { set; get; }

        [DataMember]
        public int service_state { set; get; }

        [DataMember]
        public int shop_id { set; get; }

        [DataMember]
        public string inner_remark { set; get; }

        [DataMember]
        public string province_name { set; get; }

        [DataMember]
        public string city_name { set; get; }

        [DataMember]
        public string county_name { set; get; }

        [DataMember]
        public string zip_code { set; get; }

        [DataMember]
        public string id_card { set; get; }

        [DataMember]
        public List<OrderItemsInfo> item_list { set; get; }
    }

    [DataContract]
    public class OrderItemsInfo
    {
        [DataMember]
        public int product_id { set; get; }

        [DataMember]
        public string product_code { set; get; }

        [DataMember]
        public string product_name { set; get; }

        [DataMember]
        public string product_spec { set; get; }

        [DataMember]
        public string sku_name { set; get; }

        [DataMember]
        public decimal sale_price { set; get; }

        [DataMember]
        public decimal deal_price { set; get; }

        [DataMember]
        public int sale_num { set; get; }

        [DataMember]
        public int item_state { set; get; }

        [DataMember]
        public string img_src { set; get; }

        [DataMember]
        public decimal taxes_money { set; get; }
        
    } 
}
