using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JiuZhou.Model
{
    public enum EBadWordsType
    {
        /// <summary>
        /// 忽略
        /// </summary>
        NULL = -1,
        /// <summary>
        /// 替换
        /// </summary>
        REPLACE = 0,
        /// <summary>
        /// 禁止提交
        /// </summary>
        DISALLOW = 1
    }
}
