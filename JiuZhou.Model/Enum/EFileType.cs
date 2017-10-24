using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JiuZhou.Model
{
    public enum EFileType
    {
        /// <summary>
        /// 忽略
        /// </summary>
        NULL = -1,
        /// <summary>
        /// 图片
        /// </summary>
        IMAGE = 1,
        /// <summary>
        /// 用于导入的文档
        /// </summary>
        DOCUMENT_IMPORT = 2,
        /// <summary>
        /// 其他文件
        /// </summary>
        FILE = 3
    }
}
