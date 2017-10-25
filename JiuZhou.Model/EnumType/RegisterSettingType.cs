using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JiuZhou.Model
{
    /// <summary>
    /// 注册功能设定
    /// </summary>
    public enum RegisterSettingType
    {
        /// <summary>
        /// 直接注册(不审核)
        /// </summary>
        AUTO = 0,
        /// <summary>
        /// 邮件验证
        /// </summary>
        MAIL = 1,
        /// <summary>
        /// 管理员审核
        /// </summary>
        CHECK =2,
        /// <summary>
        /// 邀请注册
        /// </summary>
        INVITE = 3,
        /// <summary>
        /// 关闭注册
        /// </summary>
        CLOSE=4
    }
}
