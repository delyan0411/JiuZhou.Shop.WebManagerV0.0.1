using System;
using System.IO;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.Script.Serialization;
using System.Data;
using System.Collections;
using System.Collections.Generic;

namespace JiuZhou.HttpTools
{
    public class JsonHelper
    {
        public static string ObjectToJson<T>(object obj)
        {
            string jsonString = string.Empty;

            DataContractJsonSerializer js = new DataContractJsonSerializer(typeof(T)) ;
            MemoryStream stream = new MemoryStream();

            try
            {
                js.WriteObject(stream,obj);
                jsonString = Encoding.UTF8.GetString(stream.ToArray());
                stream.Close();
                //替换Json的Date字符串
                //string p = @"\\/Date\((\d+)\+\d+\)\\/";
                //MatchEvaluator matchEvaluator = new MatchEvaluator(ConvertJsonDateToDateString);
                //Regex reg = new Regex(p);
                //jsonString = reg.Replace(jsonString, matchEvaluator);
            }
            catch (Exception e)
            {
                Logger.Error(e.ToString());
            }
            return jsonString;
        }


        public static T JsonToObject<T>(string json) where T : class
        {
            try
            {
                //将"yyyy-MM-dd HH:mm:ss"格式的字符串转为"\/Date(1294499956278+0800)\/"格式
                //string p = @"\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}";
                //MatchEvaluator matchEvaluator = new MatchEvaluator(ConvertDateStringToJsonDate);
                //Regex reg = new Regex(p);
                //json = reg.Replace(json, matchEvaluator);
                DataContractJsonSerializer js = new DataContractJsonSerializer(typeof(T));
                MemoryStream stream = new MemoryStream(Encoding.UTF8.GetBytes(json));
                T obj = (T)js.ReadObject(stream);
                return obj;
            }
            catch (Exception e)
            {
                Logger.Error(e.ToString());
                Logger.Error(ObjectToJson(default(T)));
                return default(T);
            }
        }

        /// <summary>
        /// 将时间字符串转为Json时间
        /// </summary>
        private static string ConvertDateStringToJsonDate(Match m)
        {
            string result = string.Empty;
            DateTime dt = DateTime.Parse(m.Groups[0].Value);
            dt = dt.ToUniversalTime();
            TimeSpan ts = dt - DateTime.Parse("1970-01-01");
            result = string.Format("\\/Date({0}+0800)\\/", ts.TotalMilliseconds);
            return result;
        }

        /// <summary>
        /// 将Json序列化的时间由/Date(1294499956278+0800)转为字符串
        /// </summary>
        private static string ConvertJsonDateToDateString(Match m)
        {
            string result = string.Empty;
            DateTime dt = new DateTime(1970, 1, 1);
            dt = dt.AddMilliseconds(long.Parse(m.Groups[1].Value));
            dt = dt.ToLocalTime();
            result = dt.ToString("yyyy-MM-dd HH:mm:ss");
            return result;
        }

        public static string ObjectToJson(object obj)
        {
            JavaScriptSerializer js = new JavaScriptSerializer();
            try
            {
                return js.Serialize(obj);
            }
            catch (Exception)
            {
                return string.Empty;
            }
        }

        public static object JsonToObject(string json)
        {
            JavaScriptSerializer js = new JavaScriptSerializer();
            try
            {
                return js.DeserializeObject(json);
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static DataTable JsonToDataTable(string strJson)
        {
            // 取出表名   
            var rg = new Regex(@"(?<={)[^:]+(?=:\[)", RegexOptions.IgnoreCase);
            string strName = rg.Match(strJson).Value;
            DataTable tb = null;
           
            // 去除表名   
            if (strJson.IndexOf("[") > 0 && strJson.IndexOf("]") > 0)
            {
                strJson = strJson.Substring(strJson.IndexOf("[") + 1);
                strJson = strJson.Substring(0, strJson.LastIndexOf("]"));
            }
            else {
                return tb;
            }
            // 获取数据   
            rg = new Regex(@"(?<={)[^}]+(?=})");
            MatchCollection mc = rg.Matches(strJson);
            
            for (var i = 0; i < mc.Count; i++)
            {
                string strRow = mc[i].Value;
                string[] strRows = strRow.Split(',');
                // 创建表   
                if (tb == null)
                {
                    tb = new DataTable();
                    tb.TableName = strName;
                    foreach (string str in strRows)
                    {
                        var dc = new DataColumn();
                        string[] strCell = str.Split(':');
                        dc.ColumnName = strCell[0].Replace("\"", "");
                        tb.Columns.Add(dc);
                    }
                    tb.AcceptChanges();
                }
                // 增加内容   
                DataRow dr = tb.NewRow();
                for (var j = 0; j < strRows.Length; j++)
                {
                    dr[j] = strRows[j].Split(':')[1].Replace("\\\"", "\"").Replace("!@#$%", ",").Replace("@#$%&",":");
                    dr[j] = dr[j].ToString().Substring(1, dr[j].ToString().Length-2);
                }
                tb.Rows.Add(dr);
                tb.AcceptChanges();
            }
            return tb;
        }
    }
}
