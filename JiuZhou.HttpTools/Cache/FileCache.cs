using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

using JiuZhou.Common;

namespace JiuZhou.Cache
{
    //缓存类(文件缓存)
    public class FileCache
    {
        #region 属性
        private int _expires = 300;
        /// <summary>
        /// 设置缓存过期时间，单位秒，默认为300秒(5分钟)
        /// </summary>
        public int Expires
        {
            get { return this._expires; }
            set { this._expires = value; }
        }
        private bool _error = false;
        /// <summary>
        /// 是否出错
        /// </summary>
        public bool Error
        {
            get { return _error; }
        }
        private string _errorMsg = "";
        /// <summary>
        /// 错误信息
        /// </summary>
        public string ErrorMsg
        {
            get { return _errorMsg; }
        }
        #endregion

        private string _folder = "";//缓存文件存储的目录
        /// <summary>
        /// 文件缓存
        /// </summary>
        /// <param name="path">缓存文件存储的目录(物理路径)</param>
        public FileCache(string path)
        {
            if (!path.EndsWith(@"\"))
                path += @"\";
            this._folder = path;
        }
    }
}
