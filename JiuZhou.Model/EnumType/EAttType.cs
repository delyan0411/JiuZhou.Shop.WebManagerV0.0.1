using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JiuZhou.Model
{
    public enum EAttType
    {
        /// <summary>
        /// 忽略
        /// </summary>
        NULL = -1,
        /// <summary>
        /// 文本
        /// </summary>
        TEXT = 1,
        /// <summary>
        /// 下拉选择框
        /// </summary>
        SELECT = 2,
        /// <summary>
        /// 复选框
        /// </summary>
        CHECKBOX = 3,
        /// <summary>
        /// 单选框
        /// </summary>
        RADIO = 4
    }
}
