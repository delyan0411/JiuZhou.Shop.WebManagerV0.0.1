using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JiuZhou.Model
{
    /// <summary>
    /// 评论/问答发帖权限类型
    /// </summary>
    public enum CommentSettingType
    {
        /// <summary>
        /// 管理员
        /// </summary>
        ADMIN=0,
        /// <summary>
        /// 注册会员
        /// </summary>
        USERS = 1,
        /// <summary>
        /// 所有访客(包括游客)
        /// </summary>
        ALL = 2,
        /// <summary>
        /// 关闭评论
        /// </summary>
        CLOSE = 3
    }
}
