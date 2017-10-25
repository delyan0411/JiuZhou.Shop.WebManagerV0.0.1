using System;
using System.IO;
using System.Text;
using System.Reflection;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Security.Cryptography;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;

using Microsoft.VisualBasic;

namespace JiuZhou.Common
{
    /// <summary>
    /// 工具类 1.0
    /// Version: 1.0
    /// Author: Atai Lu
    /// </summary>
    [Serializable]
    public class Utils
    {
        private static Random ra = new Random();

        #region 返回字符串真实长度(一个汉字为两个字符)
        /// <summary>
        /// 返回字符串真实长度(一个汉字为两个字符)
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static int GetStringLength(string str)
        {
            return Encoding.Default.GetBytes(str).Length;
        }
        #endregion
        //
        #region 从字符串的指定位置截取指定长度的子字符串
        /// <summary>
        /// 从字符串的指定位置截取指定长度的子字符串
        /// </summary>
        /// <param name="str">原字符串</param>
        /// <param name="startIndex">子字符串的起始位置</param>
        /// <param name="length">子字符串的长度</param>
        /// <returns>子字符串</returns>
        public static string CutString(string str, int startIndex, int length)
        {
            if (startIndex >= 0)
            {
                if (length < 0)
                {
                    length = length * -1;
                    if (startIndex - length < 0)
                    {
                        length = startIndex;
                        startIndex = 0;
                    }
                    else
                    {
                        startIndex = startIndex - length;
                    }
                }

                if (startIndex > str.Length) return "";
            }
            else
            {
                if (length < 0)
                {
                    return "";
                }
                else
                {
                    if (length + startIndex > 0)
                    {
                        length = length + startIndex;
                        startIndex = 0;
                    }
                    else
                    {
                        return "";
                    }
                }
            }

            if (str.Length - startIndex < length)
            {
                length = str.Length - startIndex;
            }

            try
            {
                return str.Substring(startIndex, length);
            }
            catch
            {
                return str;
            }
        }

        public static string CutString(string str, int startIndex)
        {
            return CutString(str, startIndex, str.Length);
        }
        #endregion


        #region MD5函数
        /// <summary>
        /// MD5函数
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static string MD5(string str)
        {
            byte[] b = Encoding.Default.GetBytes(str);
            b = new MD5CryptoServiceProvider().ComputeHash(b);
            string ret = "";
            for (int i = 0; i < b.Length; i++)
                ret += b[i].ToString("x").PadLeft(2, '0');
            return ret;
        }
        #endregion
        //
        #region SHA256函数
        /// <summary>
        /// SHA256函数
        /// </summary>
        /// /// <param name="str">原始字符串</param>
        /// <returns>SHA256结果</returns>
        public static string SHA256(string str)
        {
            byte[] SHA256Data = Encoding.UTF8.GetBytes(str);
            SHA256Managed Sha256 = new SHA256Managed();
            byte[] Result = Sha256.ComputeHash(SHA256Data);
            return Convert.ToBase64String(Result);  //返回长度为44字节的字符串
        }
        #endregion
        //
        #region 格式化字节数字符串
        /// <summary>
        /// 格式化字节数字符串(转换体积单位)
        /// </summary>
        /// <param name="bytes"></param>
        /// <returns></returns>
        public static string FormatBytesStr(long bytes)
        {
            if (bytes > 1073741824)
            {
                return ((double)(bytes / 1073741824)).ToString("0") + "G";
            }
            if (bytes > 1048576)
            {
                return ((double)(bytes / 1048576)).ToString("0") + "M";
            }
            if (bytes > 1024)
            {
                return ((double)(bytes / 1024)).ToString("0") + "K";
            }
            return bytes.ToString().Trim() + "Bytes";
        }
        /// <summary>
        /// 单位K
        /// </summary>
        /// <param name="bytes">单位K</param>
        /// <returns></returns>
        public static string FormatKBytesStr(long bytes)
        {
            if (bytes > 1048576)
            {
                return ((double)(bytes / 1048576)).ToString("0") + "G";
            }
            if (bytes > 1024)
            {
                return ((double)(bytes / 1024)).ToString("0") + "M";
            }
            return bytes.ToString().Trim() + "K";
        }
        #endregion
        //
        #region 返回相差的时间
        /// <summary>
        /// 返回time2-time1相差的秒数
        /// </summary>
        /// <param name="time1"></param>
        /// <param name="time2"></param>
        /// <returns></returns>
        public static long DateDiffSeconds(DateTime time1, DateTime time2)
        {
            TimeSpan ts = time2 - time1;
            if (ts.TotalSeconds > long.MaxValue)
            {
                return long.MaxValue;
            }
            else if (ts.TotalSeconds < long.MinValue)
            {
                return long.MinValue;
            }
            return (long)ts.TotalSeconds;
        }

        /// <summary>
        /// 返回time2-time1相差的分钟数
        /// </summary>
        /// <param name="time1"></param>
        /// <param name="time2"></param>
        /// <returns></returns>
        public static long DateDiffMinutes(DateTime time1, DateTime time2)
        {
            TimeSpan ts = time2 - time1;
            if (ts.TotalMinutes > long.MaxValue)
            {
                return long.MaxValue;
            }
            else if (ts.TotalMinutes < long.MinValue)
            {
                return long.MinValue;
            }
            return (long)ts.TotalMinutes;
        }

        /// <summary>
        /// 返回time2-time1相差的小时数
        /// </summary>
        /// <param name="time1"></param>
        /// <param name="time2"></param>
        /// <returns></returns>
        public static long DateDiffHours(DateTime time1, DateTime time2)
        {
            TimeSpan ts = time2 - time1;
            if (ts.TotalHours > long.MaxValue)
            {
                return long.MaxValue;
            }
            else if (ts.TotalHours < long.MinValue)
            {
                return long.MinValue;
            }
            return (long)ts.TotalHours;
        }
        #endregion
        //
        #region 获取指定时间所在周的星期日的日期，注意：星期日为每周的第一天
        /// <summary>
        /// 获取指定时间所在周的星期日的日期，注意：星期日为每周的第一天
        /// </summary>
        /// <param name="dt"></param>
        /// <returns></returns>
        public static DateTime GetSunday(DateTime dt)
        {
            //0:星期日 1:星期一 2:星期二 3:星期三
            //4:星期四 5:星期五 6:星期六
            return dt.AddDays(-dt.DayOfWeek.GetHashCode());//
        }
        #endregion
        //
        #region 获取指定日期的星期几
        /// <summary>
        /// 获取指定日期的星期几
        /// </summary>
        /// <param name="dt"></param>
        /// <returns>星期日、星期一、...、星期六</returns>
        public string GetWeekDayString(DateTime dt)
        {
            return "星期" + Utils.CutString("日一二三四五六", dt.DayOfWeek.GetHashCode(), 1);
        }
        #endregion
        //
        #region 用正则判断是否匹配特定字符
        /// <summary>
        /// 用正则判断是否匹配特定字符
        /// </summary>
        /// <param name="str">待验证的字符串</param>
        /// <param name="reg">正则表达式</param>
        /// <returns></returns>
        public static bool IsMatch(string val, string reg, RegexOptions opts)
        {
            if (string.IsNullOrEmpty(val))
                return false;
            if (opts == RegexOptions.None)
                return new Regex(@reg).IsMatch(val);

            return new Regex(@reg, opts).IsMatch(val);
        }
        public static bool IsMatch(string val, string reg)
        {
            return IsMatch(val, reg, RegexOptions.None);
        }
        #endregion
        //
        #region 分割字符串
        /// <summary>
        /// 分割字符串
        /// </summary>
        public static string[] SplitString(string strContent, string strSplit)
        {
            if (strContent.IndexOf(strSplit) < 0)
            {
                string[] tmp = { strContent };
                return tmp;
            }
            if (strContent == null || strContent == "")
            {
                string[] tmp = { strContent };
                return tmp;
            }
            RegexOptions options;
            if (Environment.Version.Major == 1)
                options = RegexOptions.Compiled | RegexOptions.IgnoreCase | RegexOptions.Singleline;
            else
                options = RegexOptions.IgnoreCase | RegexOptions.Singleline;
            if (@strSplit == @"{$page$}")
                @strSplit = @"\{\$page\$\}";
            return Regex.Split(strContent, @strSplit, options);
        }
        #endregion
        //
        #region 日期格式化
        public static string FormatDateString(object obj, string format)
        {
            DateTime t = Convert.ToDateTime(obj);
            return t.ToString(format);
        }
        public static string GetShortDateTimeString(object obj)
        {
            return FormatDateString(obj, "yy-MM-dd HH:mm");
        }
        #endregion
        //
        #region string型转换为int型
        /// <summary>
        /// string型转换为int型
        /// </summary>
        /// <param name="strValue">要转换的字符串</param>
        /// <param name="defValue">缺省值</param>
        /// <returns>转换后的int类型结果</returns>
        public static int StrToInt(object strValue, int defValue)
        {
            if (strValue == null || strValue.ToString().Trim() == string.Empty)
                return defValue;
            string _value = strValue.ToString().Trim();
            if (IsInt(_value))
            {
                if (long.Parse(_value) <= (long)int.MaxValue && long.Parse(_value) >= (long)int.MinValue)
                    return Convert.ToInt32(_value);
            }
            return defValue;
        }
        public static int StrToInt(object strValue)
        {
            return StrToInt(strValue, 0);
        }
        #endregion
        //
        #region 获取随机数
        public static float GetRandom
        {
            get
            {
                Random r = new Random();
                return (float)r.NextDouble() * 1000f;
            }
        }
        #endregion
        //
        #region 产生验证码
        /// <summary>
        /// 产生验证码
        /// </summary>
        /// <param name="len">长度</param>
        /// <returns>验证码</returns>
        public static string GetRandomString(int len)
        {
            int number;
            StringBuilder checkCode = new StringBuilder();

            Random random = new Random();

            for (int i = 0; i < len; i++)
            {
                number = random.Next();

                if (number % 2 == 0)
                {
                    checkCode.Append((char)('0' + (char)(number % 10)));
                }
                else
                {
                    checkCode.Append((char)('A' + (char)(number % 26)));
                }

            }

            return checkCode.ToString();
        }
        #endregion
        //
        #region 得到由当前时间的年、月、日、时、分、秒、毫秒组成的字符串
        /// <summary>
        /// 得到由当前时间的年、月、日、时、分、秒、毫秒组成的字符串
        /// </summary>
        public static string GetDateTimeString
        {
            get
            {
                return DateTime.Now.ToString("yyyyMMddHHmmssffff");
            }
        }
        #endregion
        //
        #region 得到当前时间的时间刻度
        /// <summary>
        /// 得到当前时间的时间刻度(当前日期减去2012年)
        /// </summary>
        public static string GetDateTimeTicksString
        {
            get
            {
                return GetDateTimeTicks.ToString();
            }
        }
        public static long GetDateTimeTicks
        {
            get
            {
                long ticks = DateTime.Now.AddYears(-2012).Ticks;
                ticks += ra.Next(0, 49);
                return ticks;
            }
        }
        #endregion

        #region 得到当前时间的时间刻度
        /// <summary>
        /// 得到当前时间的时间刻度(当前日期减去1900年)
        /// </summary>
        public static string GetDateTimeTicksString2
        {
            get
            {
                return GetDateTimeTicks2.ToString();
            }
        }
        public static long GetDateTimeTicks2
        {
            get
            {
                long ticks = DateTime.Now.AddYears(-1900).Ticks;
                ticks += ra.Next(0, 49);
                return ticks;
            }
        }
        #endregion
        //
        #region 生成订单号
        /*
        /// <summary>
        /// 生成订单号
        /// </summary>
        /// <param name="count">最多一次性生成100个</param>
        /// <returns></returns>
        public static List<long> GetOrderNumber(int count)
        {
            List<long> list = new List<long>();
            DateTime date = DateTime.Now.AddYears(44);
            if (count < 1) count = 1;
            if (count > 100) count = 100;
            for (int i = 0; i < count; i++)
            {
                long returnValue = 0;
                System.Text.StringBuilder sb = new StringBuilder();
                string mill = date.ToString("fff");
                string iStr = count > 1 ? i.ToString() : ra.Next(0, 99).ToString();
                if (i < 10) iStr = "0" + iStr;
                sb.Append(date.ToString("yy"));
                sb.Append(((date.Ticks - DateTime.Parse(date.ToString("yyyy") + "-01-01 00:00:00").Ticks) / 10000).ToString());
                sb.Append(iStr);
                long.TryParse(sb.ToString(), out returnValue);
                if (!list.Contains(returnValue))
                {
                    list.Add(returnValue);
                }
                //else
                //{
                //    list.Add(DateAndTime.Now.AddYears(-2012).Ticks);
                //}
            }
            return list;
        }
        public static long GetSingleOrderNumber
        {
            get
            {
                List<long> list = Utils.GetOrderNumber(1);
                if(list.Count>0)
                    return list[0];
                return DateAndTime.Now.AddYears(-2012).Ticks;
            }
        }*/
        #endregion
        //
        #region yyyy-MM-dd HH:mm:ss格式的当前时间字串
        /// <summary>
        /// yyyy-MM-dd HH:mm:ss格式的当前时间字串
        /// </summary>
        public static string GetNowString
        {
            get
            {
                return DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            }
        }
        #endregion
        //
        #region 字符串与数组的关系的几个函数
        /// <summary>
        /// 判断指定字符串在指定字符串数组中的位置
        /// </summary>
        /// <param name="strSearch">字符串</param>
        /// <param name="stringArray">字符串数组</param>
        /// <param name="caseInsensetive">是否不区分大小写, true为区分, false为不区分</param>
        /// <returns>字符串在指定字符串数组中的位置, 如不存在则返回-1</returns>
        public static int GetInArrayID(string strSearch, string[] stringArray, bool caseInsensetive)
        {
            for (int i = 0; i < stringArray.Length; i++)
            {
                if (!caseInsensetive)
                {
                    if (strSearch.ToLower() == stringArray[i].ToLower())
                    {
                        return i;
                    }
                }
                else
                {
                    if (strSearch == stringArray[i])
                    {
                        return i;
                    }
                }

            }
            return -1;
        }


        /// <summary>
        /// 判断指定字符串在指定字符串数组中的位置
        /// </summary>
        /// <param name="strSearch">字符串</param>
        /// <param name="stringArray">字符串数组</param>
        /// <returns>字符串在指定字符串数组中的位置, 如不存在则返回-1</returns>		
        public static int GetInArrayID(string strSearch, string[] stringArray)
        {
            return GetInArrayID(strSearch, stringArray, false);
        }

        /// <summary>
        /// 判断指定字符串是否属于指定字符串数组中的一个元素
        /// </summary>
        /// <param name="strSearch">字符串</param>
        /// <param name="stringArray">字符串数组</param>
        /// <param name="caseInsensetive">是否不区分大小写, true为区分, false为不区分</param>
        /// <returns>判断结果</returns>
        public static bool InArray(string strSearch, string[] stringArray, bool caseInsensetive)
        {
            return GetInArrayID(strSearch, stringArray, caseInsensetive) >= 0;
        }

        /// <summary>
        /// 判断指定字符串是否属于指定字符串数组中的一个元素
        /// </summary>
        /// <param name="str">字符串</param>
        /// <param name="stringarray">字符串数组</param>
        /// <returns>判断结果</returns>
        public static bool InArray(string str, string[] stringarray)
        {
            return InArray(str, stringarray, false);
        }

        /// <summary>
        /// 判断指定字符串是否属于指定字符串数组中的一个元素
        /// </summary>
        /// <param name="str">字符串</param>
        /// <param name="stringarray">内部以逗号分割单词的字符串</param>
        /// <returns>判断结果</returns>
        public static bool InArray(string str, string stringarray)
        {
            return InArray(str, SplitString(stringarray, ","), false);
        }

        /// <summary>
        /// 判断指定字符串是否属于指定字符串数组中的一个元素
        /// </summary>
        /// <param name="str">字符串</param>
        /// <param name="stringarray">内部以特定符号分割单词的字符串</param>
        /// <param name="strsplit">设置内部以此符号(字符串)分割单词</param>
        /// <returns>判断结果</returns>
        public static bool InArray(string str, string stringarray, string strsplit)
        {
            return InArray(str, SplitString(stringarray, strsplit), false);
        }

        /// <summary>
        /// 判断指定字符串是否属于指定字符串数组中的一个元素
        /// </summary>
        /// <param name="str">字符串</param>
        /// <param name="stringarray">内部以特定符号分割单词的字符串</param>
        /// <param name="strsplit">设置内部以此符号(字符串)分割单词</param>
        /// <param name="caseInsensetive">是否不区分大小写, true为区分, false为不区分</param>
        /// <returns>判断结果</returns>
        public static bool InArray(string str, string stringarray, string strsplit, bool caseInsensetive)
        {
            return InArray(str, SplitString(stringarray, strsplit), caseInsensetive);
        }
        #endregion
        //
        #region 创建/删除文件夹
        /// <summary>
        /// 创建文件夹
        /// </summary>
        /// <param name="path">待创建的目录名(物理路径)</param>
        public static void CreateDir(string path)
        {
            if (!Directory.Exists(path))
            {
                //不存在,创建目录
                Directory.CreateDirectory(path);
            }
        }
        //
        /// <summary>
        /// 删除文件夹
        /// </summary>
        /// <param name="str">物理路径</param>
        public static void DeleteDir(string path)
        {
            if (Directory.Exists(path))
            {
                Directory.Delete(path);
            }
        }
        #endregion
        //
        #region 判断文件是否存在
        /// <summary>
        /// 判断文件是否存在
        /// </summary>
        /// <param name="path">物理路径</param>
        /// <returns></returns>
        public static bool FileExists(string path)
        {
            if (path == null || path == "") return false;
            return System.IO.File.Exists(path);
        }
        #endregion
        //
        #region 删除文件
        /// <summary>
        /// 删除文件
        /// </summary>
        /// <param name="path">物理路径</param>
        public static void DeleteFile(string path)
        {
            if (System.IO.File.Exists(path))
                System.IO.File.Delete(path);

        }
        #endregion
        //
        #region 清除html代码
        /// <summary>
        /// 清除html代码
        /// </summary>
        /// <param name="strHtml"></param>
        /// <returns></returns>
        public static string ClearHtml(string strHtml, bool clearSpace)
        {
            if (strHtml != "")
            {
                strHtml = Regex.Replace(strHtml, @"<script[^>]*>[\s\S]*?</script>", "", GetRegexOptions);//清除所有script标签
                strHtml = Regex.Replace(strHtml, @"<style[^>]*>[\s\S]*?</style>", "", GetRegexOptions);//清除所有style标签

                strHtml = Regex.Replace(strHtml, @"<object[^>]*>[\s\S]*?</object>", "", GetRegexOptions);//清除所有object标签
                strHtml = Regex.Replace(strHtml, @"<embed[^>]*>[\s\S]*?</embed>", "", GetRegexOptions);//清除所有style标签
                strHtml = Regex.Replace(strHtml, @"<\/?[^>]*>", "", GetRegexOptions);//清除所有HTML标签
            }//end if
            if (clearSpace)
            {
                strHtml = Regex.Replace(strHtml, "\\s", "", GetRegexOptions);
                //strHtml = strHtml.Replace("&lt;", "<").Replace("&gt;", ">").Replace("&amp;", "&");
                strHtml = strHtml.Replace("&nbsp;", "");
                //strHtml = HttpContext.Current.Server.HtmlEncode(strHtml);
            }
            return strHtml.Replace("'", "‘");
        }
        public static string ClearHtml(string strHtml)
        {
            return ClearHtml(strHtml, false);
        }
        #endregion

        #region RemoveUBB
        public static string RemoveUBB(string strHtml)
        {
            if (strHtml != "")
            {
                Regex r = null;
                Match m = null;
                r = new Regex(@"\[\/?\w+[^\]]*\]", GetRegexOptions);
                for (m = r.Match(strHtml); m.Success; m = m.NextMatch())
                {
                    strHtml = strHtml.Replace(m.Groups[0].ToString().Trim(), "");
                }//exit for
            }//end if
            return strHtml;
        }
        #endregion

        #region ReplaceText
        public static string ReplaceText(string val, string reg)
        {
            if (!string.IsNullOrEmpty(val))
            {
                Regex r = null;
                Match m = null;
                r = new Regex(reg, GetRegexOptions);
                for (m = r.Match(val); m.Success; m = m.NextMatch())
                {
                    val = val.Replace(m.Groups[0].ToString().Trim(), "");
                }//exit for
            }//end if
            return val;
        }
        #endregion
        //
        #region 获得Assembly的信息
        /// <summary>
        /// 获得Assembly版本号
        /// </summary>
        /// <returns></returns>
        public static string GetAssemblyVersion()
        {
            Assembly myAssembly = Assembly.GetExecutingAssembly();
            FileVersionInfo myFileVersion = FileVersionInfo.GetVersionInfo(myAssembly.Location);
            return string.Format("{0}.{1}.{2}", myFileVersion.FileMajorPart, myFileVersion.FileMinorPart, myFileVersion.FileBuildPart);
        }

        /// <summary>
        /// 获得Assembly产品名称
        /// </summary>
        /// <returns></returns>
        public static string GetAssemblyProductName()
        {
            Assembly myAssembly = Assembly.GetExecutingAssembly();
            FileVersionInfo myFileVersion = FileVersionInfo.GetVersionInfo(myAssembly.Location);
            return myFileVersion.ProductName;
        }

        /// <summary>
        /// 获得Assembly产品版权
        /// </summary>
        /// <returns></returns>
        public static string GetAssemblyCopyright()
        {
            Assembly myAssembly = Assembly.GetExecutingAssembly();
            FileVersionInfo myFileVersion = FileVersionInfo.GetVersionInfo(myAssembly.Location);
            return myFileVersion.LegalCopyright;
        }
        #endregion
        //
        #region 简体转繁体
        public static string Simplified2Traditional(string val)
        {
            return Strings.StrConv(val as String, VbStrConv.TraditionalChinese, 0);
        }
        #endregion
        //
        #region 繁体转简体
        public static string Traditional2Simplified(string val)
        {
            return Strings.StrConv(val as String, VbStrConv.SimplifiedChinese, 0);
        }
        #endregion
        //
        #region 写文本
        /// <summary>
        /// 写文件
        /// </summary>
        /// <param name="filePath">物理路径</param>
        /// <param name="val">文本内容</param>
        public static void WriteText(string filePath, string val)
        {
            //filePath = Utils.GetMapPath(filePath);
            //Utils.coutln(filePath);
            try
            {
                StreamWriter writer = null;
                //
                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }
                writer = File.CreateText(filePath);
                writer.Write(val);
                writer.Close();
                writer.Dispose();
            }
            catch (Exception) { }
        }
        #endregion
        //
        #region 向指定文本追加内容
        /// <summary>
        /// 向指定文本追加内容
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="val"></param>
        public static void AppenText(string filePath, string val)
        {
            try
            {
                StreamWriter writer = null;
                if (File.Exists(filePath))
                {
                    writer = File.AppendText(filePath);
                }
                else
                {
                    writer = File.CreateText(filePath);
                }
                writer.WriteLine(val);
                writer.Close();
                writer.Dispose();
            }
            catch (Exception) { }
        }
        #endregion
        //
        #region 读取文件
        /// <summary>
        /// 读取文件
        /// </summary>
        /// <param name="filePath">物理路径</param>
        public static string LoadFile(string filePath, string charset)
        {
            string result = "";
            if (charset == "") charset = "utf-8";
            Encoding encoding = Encoding.GetEncoding(charset);
            try
            {
                if (!File.Exists(filePath))
                {
                    result = "文件" + filePath + "不存在...";
                }
                else
                {
                    StreamReader objReader = new StreamReader(filePath, encoding);
                    result = objReader.ReadToEnd();
                    objReader.Close();
                    objReader.Dispose();
                }
            }
            catch (Exception) { }
            return result;
        }
        #endregion
        //
        #region GetRegexOptions
        public static RegexOptions GetRegexOptions
        {
            get
            {
                RegexOptions options;
                if (Environment.Version.Major == 1)
                    options = RegexOptions.Compiled | RegexOptions.IgnoreCase | RegexOptions.Singleline;
                else
                    options = RegexOptions.IgnoreCase | RegexOptions.Singleline;
                return options;
            }
        }
        #endregion

        #region 将字符串编码为Base64字符串
        /// <summary>
        /// 将字符串编码为Base64字符串
        /// </summary>
        /// <param name="value">要编码的字符串</param>
        public static string Base64Encode(string value)
        {
            byte[] barray;
            barray = Encoding.Default.GetBytes(value);
            return Convert.ToBase64String(barray);
        }
        #endregion
        //
        #region IsEmail 判断指定字符串是否邮箱地址
        public static bool IsEmail(string val)
        {
            if (string.IsNullOrEmpty(val))
                return false;
            return IsMatch(val, @"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$");
        }
        #endregion
        //
        #region 判断给定的字符串(val)是否是数值型
        /// <summary>
        /// 判断给定的字符串(val)是否是数值型
        /// </summary>
        /// <param name="val">要确认的字符串</param>
        /// <returns>是则返加true 不是则返回 false</returns>
        public static bool IsNumber(string val)
        {
            return IsMatch(val, @"^[-\.]?\d{1,30}(\.\d{1,20})?$");
        }
        /// <summary>
        /// 是否1-12位整数(包括正整数、负整数、0)
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        public static bool IsInt(string val)
        {
            return IsMatch(val, @"^-?\d{1,12}$");
        }
        /// <summary>
        /// 是否1-20位整数(包括正整数、负整数、0)
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        public static bool IsLong(string val)
        {
            return IsMatch(val, @"^-?\d{1,20}$");
        }
        #endregion
        //
        #region 判断时间类型
        /// <summary>
        /// 判断是否yyyy-MM-dd的日期格式
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        public static bool IsDateString(string val)
        {
            string r = @"^\d{4}-\d{1,2}-\d{1,2}$";
            if (IsMatch(val, r))
            {
                string[] arr = val.Split("-".ToCharArray());
                int month = int.Parse(arr[1]);
                int day = int.Parse(arr[2]);
                if (month >= 1 && month <= 12 && day >= 1 && day <= 31)
                    return true;
            }
            return false;
        }
        /// <summary>
        /// 判断是否HH:mm:ss时间格式
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        public static bool IsTimeString(string val)
        {
            string r = @"^\d{1,2}:\d{1,2}:\d{1,2}$";
            if (IsMatch(val, r))
            {
                string[] arr = val.Split(":".ToCharArray());
                int hours = int.Parse(arr[0]);
                int minute = int.Parse(arr[1]);
                int second = int.Parse(arr[2]);
                if (hours >= 0 && hours <= 24
                    && minute >= 0 && minute <= 60
                    && second >= 0 && second <= 60)
                    return true;
            }
            return false;
        }
        /// <summary>
        /// 是否yyyy-MM-dd HH:mm:ss的时间类型
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        public static bool IsDateTime(string val)
        {
            string r = @"^\d{4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}:\d{1,2}$";
            if (IsMatch(val, r))
            {
                return true;
            }
            return false;
        }
        /// <summary>
        /// 是否yyyy-MM-dd HH:mm的时间类型
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        public static bool IsDateTime2(string val)
        {
            string r = @"^\d{4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}$";
            if (IsMatch(val, r))
            {
                val = val + ":0";
                string[] arr = val.Split(" ".ToCharArray());
                if (IsDateString(arr[0]) && IsTimeString(arr[1]))
                    return true;
            }
            return false;
        }
        #endregion

        #region IsGuid
        public static bool IsGuid(string val)
        {
            return IsMatch(val, @"^[a-zA-Z\d]{8}-[a-zA-Z\d]{4}-[a-zA-Z\d]{4}-[a-zA-Z\d]{4}-[a-zA-Z\d]{12}$");
        }
        public static bool IsGuid(object val)
        {
            return IsGuid(val.ToString());
        }
        /// <summary>
        /// 是否用逗号隔开的guid型字串
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        public static bool IsGuidList(string val)
        {
            if (val.Length < 1)
                return false;
            string[] arr = val.Split(",".ToCharArray());
            for (int i = 0; i < arr.Length; i++)
            {
                if (!IsGuid(arr[i]))
                    return false;
            }
            return true;
        }
        #endregion
        //
        #region IsGuidInit
        public bool IsGuidInit(string val)
        {
            return val.Equals("00000000-0000-0000-0000-000000000000");
        }
        #endregion

        #region IsIdList
        /// <summary>
        /// 判断给定字符串是否以逗号隔开的数字
        /// 字符长度超过1000则判定为false
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        public static bool IsIdList(string val)
        {
            if (val == null || val.Equals("") || val.Length > 3000) return false;
            return IsMatch(val, @"^\d{1,20}(,\d{1,20})*$");
        }
        #endregion

        #region IsIPV4
        /// <summary>
        /// 判断是否IPV4
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        public static bool IsIPV4(string val)
        {
            if (val == null || val.Equals("")) return false;
            if (IsMatch(val, @"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"))
            {
                string[] arr = val.Split(".".ToCharArray());
                int _tem=0;
                for (int i = 0; i < arr.Length; i++)
                {
                    _tem=int.Parse(arr[i]);
                    if (_tem < 0 || _tem > 255)
                        return false;
                }
            }
            return true;
        }
        #endregion

        #region IsUserName
        public static bool IsUserName(string val)
        {
            if (string.IsNullOrEmpty(val))
                return false;
            return IsMatch(val, "^[^&'\"<>]{2,30}$");
            //return IsMatch(val, "^[\\u4E00-\\u9FA5\\uF900-\\uFA2D\\w]{2,30}$");
        }
        #endregion

        #region IsPassword
        public static bool IsPassword(string val)
        {
            if (string.IsNullOrEmpty(val))
                return false;
            return IsMatch(val, "^[\\w@#$\\.,-]{3,20}$");
        }
        #endregion

        #region IsMobile
        public static bool IsMobile(string val)
        {
            if (string.IsNullOrEmpty(val))
                return false;
            return IsMatch(val, "^1[1-9]{1}[0-9]{1}[0-9]{8}$");
        }
        #endregion

        #region IsPhone
        public static bool IsPhone(string val)
        {
            if (string.IsNullOrEmpty(val))
                return false;
            return IsMatch(val, @"^\d[\d-]{1,20}$");
        }
        #endregion

        #region 隐藏IP最后一位
        /// <summary>
        /// 隐藏IP最后一位
        /// </summary>
        public static string HiddenIP(string ip)
        {
            if (IsIPV4(ip))
            {
                string[] arr = ip.Split(".".ToCharArray());
                return arr[0] + "." + arr[1] + "." + arr[2] + ".***";
            }
            return "";
        }
        #endregion

        #region IPV4ToLong
        /// <summary>
        /// IPV4ToLong
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        public static long IPV4ToLong(string val)
        {
            if (!IsIPV4(val))
                return -1;
            //long result = 0;
            string[] arr=val.Split(".".ToCharArray());
            return 255L * 255L * 255L * long.Parse(arr[0])
                + 255L * 255L * long.Parse(arr[1])
                + 255L * long.Parse(arr[2])
                + long.Parse(arr[3]);
        }
        #endregion

        #region 解析name1=value1&name2=value2...
        public static Dictionary<string, string> ParseParame(string val)
        {
            Dictionary<string, string> list = new Dictionary<string, string>();
            if (val == null || val.Trim().Equals("") || val.IndexOf("=") <= 0)
                return list;
            val = val.Replace("&amp;", "§§§§§§");
            string[] arr = val.Split("&".ToCharArray());
            for (int i = 0; i < arr.Length; i++)
            {
                string[] arr2 = arr[i].Split("=".ToCharArray());
                if (arr2.Length == 1)
                {
                    if (!list.ContainsKey(arr2[0]))
                        list.Add(arr2[0], "");
                }
                else if (arr2.Length > 1)
                {
                    if (!list.ContainsKey(arr2[0]))
                        list.Add(arr2[0], arr[i].Substring(arr[i].IndexOf("=") + 1).Replace("§§§§§§", "&"));
                    else
                        list[arr2[0]] = arr[i].Substring(arr[i].IndexOf("=") + 1).Replace("§§§§§§", "&");
                }
            }
            return list;
        }
        #endregion

        #region GetDictionaryValue
        public static string GetDictionaryValue(Dictionary<string, string> list, string key)
        {
            if (list.ContainsKey(key))
                return list[key];
            return "";
        }
        #endregion

        #region 将UNIX时间戳转换成系统时间
        public static DateTime GetTime(string timeStamp)
        {
            DateTime dtStart = TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1));
            long lTime = long.Parse(timeStamp + "0000000");
            TimeSpan toNow = new TimeSpan(lTime);
            return dtStart.Add(toNow);
        }
        #endregion

        #region 将c# DateTime时间格式转换为Unix时间戳格式
        /// <summary>
        /// 将c# DateTime时间格式转换为Unix时间戳格式
        /// </summary>
        /// <param name="time">时间</param>
        /// <returns>long</returns>
        public static long ConvertDateTimeLong(System.DateTime time)
        {
            long intResult = 0;
            System.DateTime startTime = TimeZone.CurrentTimeZone.ToLocalTime(new System.DateTime(1970, 1, 1));
            intResult = (long)(time - startTime).TotalSeconds;
            return intResult;
        }
        #endregion

        #region ParseJsonArray
        ///// <summary>
        ///// 解析Json数组(即数组的元素为json格式)
        ///// </summary>
        ///// <param name="source"></param>
        ///// <returns></returns>
        //public static List<KeyValuePair<string, string>> ParseJsonArray(string source)
        //{
        //    List<KeyValuePair<string, string>> list = new List<KeyValuePair<string, string>>();
        //    if (string.IsNullOrEmpty(source))
        //        return list;

        //    char[] charList = source.ToCharArray();
        //    long sLen = charList.Length;
        //    KeyValuePair<string, string> keyValue = new KeyValuePair<string, string>();
        //    StringBuilder sb = new StringBuilder();
        //    for (long i = 0; i < sLen; i++)
        //    {
        //        string val = charList[i].ToString();
        //        if (string.IsNullOrEmpty(val))
        //            continue;

        //    }
        //    return list;
        //}
        #endregion

        #region ToUnicode
        /// <summary>
        /// 将字符串转换成Unicode编码
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        public static string ToUnicode(string val)
        {
            string result = "";
            char[] chs = val.ToCharArray();
            foreach (char c in chs)
            {
                string s = char.ConvertToUtf32(c.ToString(), 0).ToString("x");
                string _s = "";
                for (int i = s.Length; i < 4; i++)
                    _s += "0";
                result += @"\u" + _s + s;
            }
            return result;
        }
        #endregion

        #region Unicode解码
        public static string DeUnicode(string val)
        {
            StringBuilder strResult = new StringBuilder();
            if (!string.IsNullOrEmpty(val))
            {
                string[] arr = val.Replace("\\", "").Split('u');
                try
                {
                    for (int i = 1; i < arr.Length; i++)
                    {
                        int charCode = Convert.ToInt32(arr[i], 16);
                        strResult.Append((char)charCode);
                    }
                }
                catch (FormatException)
                {
                    return Regex.Unescape(val);
                }
            }
            return strResult.ToString();
        }
        #endregion
    }
}