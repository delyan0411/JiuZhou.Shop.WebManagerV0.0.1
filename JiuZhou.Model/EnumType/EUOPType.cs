using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JiuZhou.Model
{
    public enum EUOPType
    {
        /// <summary>
        /// 忽略
        /// </summary>
        NULL = -1,
        /// <summary>
        /// 注册
        /// </summary>
        REGISTER = 0,
        /// <summary>
        /// 登录失败
        /// </summary>
        LOGINFAILED = 1,
        /// <summary>
        /// 登录成功
        /// </summary>
        LOGINSUCCEED = 2,
        /// <summary>
        /// 重设密码
        /// </summary>
        RESETPASSWORD = 3,
        /// <summary>
        /// 重新绑定邮箱
        /// </summary>
        RESETMAIL = 4,
        /// <summary>
        /// 重新绑定手机
        /// </summary>
        RESETMOBILE = 5,
        /// <summary>
        /// 其它
        /// </summary>
        OTHER = 6
    }
}
