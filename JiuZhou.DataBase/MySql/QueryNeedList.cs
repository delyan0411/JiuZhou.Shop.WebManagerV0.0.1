using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryNeedList
    {
        public static Response<ResponseQueNeedBody> Do(int pagesize, int pageindex, int needstate, string stime, string etime,string _ot, ref int dataCount, ref int pageCount)
        {
            RequestSearchNeedBody search = new RequestSearchNeedBody();

            search.page_size = pagesize.ToString();
            search.page_no = pageindex.ToString();
            search.need_state = needstate.ToString();
            //search.search_type = searchtype.ToString();
            search.start_time = stime;
            search.end_time = etime;
            //search.search_key = _skey;
            //search.sort_column = _ocol;
            //search.sort_type = _ot;

            Request<RequestSearchNeedBody> request = new Request<RequestSearchNeedBody>();
            request.Body = search;
            request.Header = request.NewHeader();
            request.Key = "GetNeeds";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchNeedBody>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseQueNeedBody>>(responseStr);

            if (response != null && response.Body != null && response.Body.need_list != null)
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
    public class RequestSearchNeedBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string need_state { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        //[DataMember]
        //public string search_type { set; get; }

        //[DataMember]
        //public string search_key { set; get; }

        //[DataMember]
        //public string sort_column { set; get; }

        //[DataMember]
        //public string sort_type { set; get; }
    }

    [DataContract]
    public class ResponseQueNeedBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<NeedInfo> need_list { set; get; }
    }

    [Serializable]
    [DataContract]
    public class NeedInfo
    {

        /// <summary>
        /// 需求ID
        /// </summary>
        [DataMember]
        public string need_id { set; get; }

        /// <summary>
        /// 用户id
        /// </summary>
        [DataMember]
        public string user_id { set; get; }

        /// <summary>
        /// 需求来源：1电脑，2手机
        /// </summary>
        [DataMember]
        public string need_type { set; get; }

        /// <summary>
        /// 需求日期
        /// </summary>
        [DataMember]
        public string add_time { set; get; }

        /// <summary>
        /// 联系电话
        /// </summary>
        [DataMember]
        public string receive_mobile_no { set; get; }

        /// <summary>
        /// 省份
        /// </summary>
        [DataMember]
        public string province_name { set; get; }

        /// <summary>
        /// 市区
        /// </summary>
        [DataMember]
        public string city_name { set; get; }

        /// <summary>
        /// 街道
        /// </summary>
        [DataMember]
        public string county_name { set; get; }

        /// <summary>
        /// 地址
        /// </summary>
        [DataMember]
        public string receive_addr { set; get; }

        /// <summary>
        /// 需求说明
        /// </summary>
        [DataMember]
        public string remark { set; get; }

        /// <summary>
        /// 状态0需求下达，1需求审批通过，2审批不通过，5取消
        /// </summary>
        [DataMember]
        public string need_state { set; get; }

        /// <summary>
        ///  
        /// </summary>
        [DataMember]
        public List<NeedItem> need_item_list { set; get; }
        /// <summary>
        /// 
        /// </summary>
        [DataMember]
        public string receive_name { set; get; }
        /// <summary>
        /// 
        /// </summary>
        [DataMember]
        public string link_name { set; get; }
        /// <summary>
        /// 
        /// </summary>
        [DataMember]
        public string link_mobile_no { set; get; }
        /// <summary>
        /// 
        /// </summary>
        [DataMember]
        public string inner_remark { set; get; }
        /// <summary>
        /// 
        /// </summary>
        [DataMember]
        public string file_name { set; get; }
        /// <summary>
        /// 
        /// </summary>
        [DataMember]
        public string file_url { set; get; }

        /// <summary>
        /// 
        /// </summary>
        [DataMember]
        public string trans_money { set; get; }


    }

    [Serializable]
    [DataContract]
    public class NeedItem
    {
        /// <summary>
        /// 需求明细ID
        /// </summary>
        [DataMember]
        public string need_item_id { set; get; }

        /// <summary>
        /// 需求ID
        /// </summary>
        [DataMember]
        public string need_id { set; get; }

        /// <summary>
        ///商品ID
        /// </summary>
        [DataMember]
        public string product_id { set; get; }

        /// <summary>
        ///商品代码
        /// </summary>
        [DataMember]
        public string product_code { set; get; }

        /// <summary>
        ///商品名称
        /// </summary>
        [DataMember]
        public string product_name { set; get; }

        /// <summary>
        ///商品图片url
        /// </summary>
        [DataMember]
        public string img_src { set; get; }

        /// <summary>
        ///skuid
        /// </summary>
        [DataMember]
        public string sku_id { set; get; }

        /// <summary>
        ///sku名称
        /// </summary>
        [DataMember]
        public string sku_name { set; get; }

        /// <summary>
        ///商品规格
        /// </summary>
        [DataMember]
        public string product_spec { set; get; }

        /// <summary>
        ///生产厂家
        /// </summary>
        [DataMember]
        public string manu_facturer { set; get; }

        /// <summary>
        ///批准号
        /// </summary>
        [DataMember]
        public string product_license { set; get; }

        /// <summary>
        ///销售价格
        /// </summary>
        [DataMember]
        public string sale_price { set; get; }

        /// <summary>
        ///销售数量
        /// </summary>
        [DataMember]
        public string sale_num { set; get; }

        /// <summary>
        ///实际价格
        /// </summary>
        [DataMember]
        public string deal_price { set; get; }

        /// <summary>
        ///市场价格
        /// </summary>
        [DataMember]
        public string market_price { set; get; }

        /// <summary>
        ///商铺ID
        /// </summary>
        [DataMember]
        public string shop_id { set; get; }

        /// <summary>
        ///状态0
        /// </summary>
        [DataMember]
        public string item_state { set; get; }   
    }
}
