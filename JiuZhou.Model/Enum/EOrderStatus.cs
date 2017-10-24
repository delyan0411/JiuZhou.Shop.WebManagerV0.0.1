using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JiuZhou.Model
{
    public enum EOrderStatus
    {
        /// <summary>
        /// 取消订单
        /// </summary>
        OS_INVALID,
        /// <summary>
        /// 新订单
        /// </summary>
        OS_NEW,
        /// <summary>
        /// 订单已确认
        /// </summary>
        OS_ACCEPT,
        /// <summary>
        /// 订单成功
        /// </summary>
        OS_SUCCESS,
        /// <summary>
        /// 客户退订
        /// </summary>
        OS_UNSUBSCRIBE,
        /// <summary>
        /// 客户退货
        /// </summary>
        OS_RETURN
    }
}
