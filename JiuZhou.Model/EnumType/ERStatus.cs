using System;

namespace JiuZhou.Model
{
    public enum ERStatus
    {
        /// <summary>
        /// 忽略
        /// </summary>
        NULL = -1,
        /// <summary>
        /// 未处理Untreated
        /// </summary>
        UNTREATED = 0,
        /// <summary>
        /// 处理中Processing
        /// </summary>
        PROCESSING = 1,
        /// <summary>
        /// 处理完毕Disposed
        /// </summary>
        DISPOSED = 2,
        /// <summary>
        /// 锁定(禁止)Lock
        /// </summary>
        LOCK = 3
    }
}
