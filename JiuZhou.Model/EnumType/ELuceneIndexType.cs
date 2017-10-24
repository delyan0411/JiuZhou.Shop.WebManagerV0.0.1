using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JiuZhou.Model
{
    public enum ELuceneIndexType
    {
        /// <summary>
        /// 产品索引
        /// </summary>
        PRODUCT = 0,
        /// <summary>
        /// 文章索引
        /// </summary>
        ARTICLE = 1,
        /// <summary>
        /// 问答
        /// </summary>
        TOPIC = 2,
        /// <summary>
        /// 词库
        /// </summary>
        WORDS = 3
    }
}
