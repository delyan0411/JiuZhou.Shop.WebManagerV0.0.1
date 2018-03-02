using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetUserDetail
    {
        public static Response<UserInfo> Do(int id)
       {
           RequestUserDetailBody body = new RequestUserDetailBody();
           body.user_id = id.ToString();

           Request<RequestUserDetailBody> request = new Request<RequestUserDetailBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetUserDetail";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestUserDetailBody>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<UserInfo>>(responseStr);
            return response;
       }
    }
    [DataContract]
    public class RequestUserDetailBody
    {
        [DataMember]
        public string user_id { set; get; }
    }

    [DataContract]
    public class UserInfo
    {
        [DataMember]
        public int user_id { set; get; }

        [DataMember]
        public string user_name { set; get; }

        [DataMember]
        public string real_name { set; get; }

        [DataMember]
        public string user_email { set; get; }

        [DataMember]
        public string mobile_no { set; get; }

        [DataMember]
        public string add_time { set; get; }

        [DataMember]
        public string last_login_time { set; get; }

        [DataMember]
        public string last_login_ip { set; get; }

        [DataMember]
        public int user_state { set; get; }

        [DataMember]
        public string head_thumb { set; get; }

        [DataMember]
        public string province_name { set; get; }

        [DataMember]
        public string city_name { set; get; }

        [DataMember]
        public string county_name { set; get; }

        [DataMember]
        public string user_tel { set; get; }

        [DataMember]
        public string user_sex { set; get; }

        [DataMember]
        public string birth_day { set; get; }

        [DataMember]
        public string user_addr { set; get; }

        [DataMember]
        public string user_remark { set; get; }

        [DataMember]
        public int user_type { set; get; }

        [DataMember]
        public string eb_card_no { set; get; }

        [DataMember]
        public string eb_mobile_no { set; get; }

        [DataMember]
        public string zip_code { set; get; }

        [DataMember]
        public string user_qq { set; get; }

        [DataMember]
        public int total_user_integral { set; get; }

        [DataMember]
        public int user_integral { set; get; }

        [DataMember]
        public string acc_money { set; get; }
    } 
}
