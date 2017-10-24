using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JiuZhou.Model
{
    public enum ECheckedStatus
    {
        /// <summary>
        /// 忽略
        /// </summary>
        NULL = -1,
        /// <summary>
        /// 审核中
        /// </summary>
        CHECKING = 1,
        /// <summary>
        /// 驳回
        /// </summary>
        BACK = 2,
        /// <summary>
        /// 通过
        /// </summary>
        PASS = 3,
        /// <summary>
        /// 禁止申请
        /// </summary>
        DISABLE = 4
    }
}