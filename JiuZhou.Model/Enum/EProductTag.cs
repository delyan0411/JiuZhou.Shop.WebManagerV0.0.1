using System;

namespace JiuZhou.Model
{
    public enum EProductTag
    {
        /// <summary>
        /// 忽略
        /// </summary>
        NULL = -1,
        /// <summary>
        /// 新品
        /// </summary>
        NEW = 1,
        /// <summary>
        /// 热卖
        /// </summary>
        HOT = 2,
        /// <summary>
        /// 推荐
        /// </summary>
        RECOMMEND = 3,
        //bargain price
        /// <summary>
        /// 促销
        /// </summary>
        BARGAINPRICE = 4,
        /// <summary>
        /// 楼层推荐
        /// </summary>
        FLOOR = 5,
        /// <summary>
        /// 特价(首页)special
        /// </summary>
        SPECIAL = 6,
        /// <summary>
        /// 限时抢购
        /// </summary>
        LIMIT = 7
    }
}
