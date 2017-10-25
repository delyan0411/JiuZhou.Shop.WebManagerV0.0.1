using System;

namespace JiuZhou.Model
{
    public enum EApiUserType
    {
        /// <summary>
        /// 忽略参数
        /// </summary>
        NULL = -1,
        /// <summary>
        /// QQ账号
        /// </summary>
        QQ = 1,
        /// <summary>
        /// 新浪微博账号
        /// </summary>
        SINA = 2,
        /// <summary>
        /// 支付宝账号
        /// </summary>
        ALIPAY = 3,
        /// <summary>
        /// 淘宝账号
        /// </summary>
        TAOBAO = 4
    }
}
