using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using System.Data;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class QueryDataBySql
    {
        public static ConfigInfo _config = ConnStringConfig.GetConfig;
        public static DataTable Do(string database,string sqlstring)
       {
           RequestQueryData remarkBody = new RequestQueryData();

           remarkBody.use_database = database;
           remarkBody.query_sql = sqlstring;

           Request<RequestQueryData> request = new Request<RequestQueryData>();
           request.Body = remarkBody;
           request.Header = request.NewHeader();
           request.Key = "QueryDataBySql";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryData>>(request);
           string responseStr = HttpUtils.HttpPost(_config.UrlData2, requestStr);
           ;
           var response = JsonHelper.JsonToDataTable(responseStr);
           return response;
       }
    }

   [DataContract]
   public class RequestQueryData
   {
       [DataMember]
       public string use_database { set; get; }

       [DataMember]
       public string query_sql { set; get; }
   }
}
