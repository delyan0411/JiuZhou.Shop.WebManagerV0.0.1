using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace JiuZhou.ControllerBase
{
    public class Logger
    {
        static string ExistPath(string path)
        {
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            return path;
        }

        static void Write(string dir, string filename, string msg)
        {
            StreamWriter writer = null;
            try
            {
                string path = ExistPath(AppDomain.CurrentDomain.BaseDirectory + "\\" + dir + "\\" + DateTime.Now.ToString("yyyyMMdd")) + "\\";
                string fullname = path + DateTime.Now.ToString("yyyyMMdd_HH") + (string.IsNullOrEmpty(filename) ? "" : "_" + filename) + ".txt";
                writer = new StreamWriter(fullname, true, Encoding.UTF8);
                writer.WriteLine(msg);
            }
            catch (Exception)
            {
            }
            finally
            {
                if (writer != null)
                {
                    writer.Close();
                    writer.Dispose();
                }
            }
        }

        public static void Log(params string[] msg)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("======================="+DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")+"=============================\t\r\n");
            sb.Append(string.Join("\r\n", msg));
            sb.Append("\r\n");
            Write("Log", "", sb.ToString());
        }

        public static void Error(params string[] msg)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("=======================" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "=============================\t\r\n");
            sb.Append(string.Join("\r\n", msg));
            sb.Append("\r\n");
            Write("Error", "", sb.ToString());
        }
    }
}
