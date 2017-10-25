using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JiuZhou.Model
{
    public class ConvertToType
    {
        #region StringToEProductTag
        public static EProductTag StringToEProductTag(string val)
        {
            EProductTag _rVal = EProductTag.NULL;
            if (val == null || val.Trim() == "")
                return EProductTag.NULL;
            val = val.ToUpper().Trim();
            switch (val)
            {
                case "":
                case "NULL":
                    _rVal = EProductTag.NULL;
                    break;
                case "NEW":
                    _rVal = EProductTag.NEW;
                    break;
                case "HOT":
                    _rVal = EProductTag.HOT;
                    break;
                case "RECOMMEND":
                    _rVal = EProductTag.RECOMMEND;
                    break;
                case "BARGAINPRICE":
                    _rVal = EProductTag.BARGAINPRICE;
                    break;
                default:
                    break;
            }

            return _rVal;
        }
        #endregion

        #region IntToEProductTag
        public static EProductTag IntToEProductTag(int val)
        {
            EProductTag _rVal = EProductTag.NULL;
            if (val == null)
                return EProductTag.NULL;
            switch (val)
            {
                case -1:
                    _rVal = EProductTag.NULL;
                    break;
                case 1:
                    _rVal = EProductTag.NEW;
                    break;
                case 2:
                    _rVal = EProductTag.HOT;
                    break;
                case 3:
                    _rVal = EProductTag.RECOMMEND;
                    break;
                case 4:
                    _rVal = EProductTag.BARGAINPRICE;
                    break;
                default:
                    break;
            }

            return _rVal;
        }
        #endregion

        #region IntToESaleType
        public static ESaleType IntToESaleType(int val)
        {
            ESaleType _rVal = ESaleType.OFF;
            if (val == null)
                return ESaleType.OFF;
            switch (val)
            {
                case -1:
                    _rVal = ESaleType.NULL;
                    break;
                case 0:
                    _rVal = ESaleType.OFF;
                    break;
                case 1:
                    _rVal = ESaleType.ON;
                    break;
                default:
                    break;
            }

            return _rVal;
        }
        #endregion

        #region IntToEBadWordsType
        public static EBadWordsType IntToEBadWordsType(int val)
        {
            EBadWordsType _rVal = EBadWordsType.REPLACE;
            if (val == null)
                return EBadWordsType.REPLACE;
            switch (val)
            {
                case -1:
                    _rVal = EBadWordsType.NULL;
                    break;
                case 0:
                    _rVal = EBadWordsType.REPLACE;
                    break;
                case 1:
                    _rVal = EBadWordsType.DISALLOW;
                    break;
                default:
                    break;
            }

            return _rVal;
        }
        #endregion

        #region IntToEOrderStatus
        public static EOrderStatus IntToEOrderStatus(int val)
        {
            EOrderStatus _rVal = EOrderStatus.OS_INVALID;
            if (val == null)
                return EOrderStatus.OS_INVALID;
            switch (val)
            {
                case 0:
                    _rVal = EOrderStatus.OS_INVALID;
                    break;
                case 1:
                    _rVal = EOrderStatus.OS_NEW;
                    break;
                case 2:
                    _rVal = EOrderStatus.OS_ACCEPT;
                    break;
                case 3:
                    _rVal = EOrderStatus.OS_SUCCESS;
                    break;
                case 4:
                    _rVal = EOrderStatus.OS_UNSUBSCRIBE;
                    break;
                case 5:
                    _rVal = EOrderStatus.OS_RETURN;
                    break;
                default:
                    break;
            }

            return _rVal;
        }
        #endregion

        #region EOrderStatusClientShow
        /// <summary>
        /// 前台显示状态
        /// </summary>
        /// <param name="os"></param>
        /// <returns></returns>
        public static string EOrderStatusClientShow(int os)
        {
            string status = "";
            switch (ConvertToType.IntToEOrderStatus(os))
            {
                case EOrderStatus.OS_INVALID:
                    status = "<span style='color:#999'>订单已取消</span>";
                    break;
                case EOrderStatus.OS_NEW:
                    status = "等待审核";
                    break;
                case EOrderStatus.OS_ACCEPT:
                    status = "<span style='color:blue'>订单已确认</span>";
                    break;
                case EOrderStatus.OS_SUCCESS:
                    status = "<span style='color:green'>订单已成功</span>";
                    break;
                case EOrderStatus.OS_UNSUBSCRIBE:
                    status = "<span style='color:#999'>订单已退订</span>";
                    break;
                case EOrderStatus.OS_RETURN:
                    status = "<span style='color:red'>订单已退货</span>";
                    break;
            }

            return status;
        }
        #endregion

        #region StringEFileType
        public static EFileType StringEFileType(string val)
        {
            EFileType _rVal = EFileType.NULL;
            if (string.IsNullOrEmpty(val))
                return EFileType.NULL;
            val = val.ToUpper().Trim();
            switch (val)
            {
                case "":
                case "NULL":
                    _rVal = EFileType.NULL;
                    break;
                case "DOCUMENT_IMPORT":
                    _rVal = EFileType.DOCUMENT_IMPORT;
                    break;
                case "FILE":
                    _rVal = EFileType.FILE;
                    break;
                case "IMAGE":
                    _rVal = EFileType.IMAGE;
                    break;
                default:
                    break;
            }

            return _rVal;
        }
        #endregion

        #region StringToEProductTag
        public static ELuceneIndexType StringToELuceneIndexType(string val)
        {
            ELuceneIndexType _rVal = ELuceneIndexType.PRODUCT;
            if (val == null || val.Trim() == "")
                return ELuceneIndexType.PRODUCT;
            val = val.ToUpper().Trim();
            switch (val)
            {
                case "":
                case "PRODUCT":
                    _rVal = ELuceneIndexType.PRODUCT;
                    break;
                case "ARTICLE":
                    _rVal = ELuceneIndexType.ARTICLE;
                    break;
                case "TOPIC":
                    _rVal = ELuceneIndexType.TOPIC;
                    break;
                default:
                    break;
            }

            return _rVal;
        }
        #endregion

        #region StringToEStatus
        public static EStatus StringToEStatus(string val)
        {
            EStatus _rVal = EStatus.NULL;
            if (string.IsNullOrEmpty(val))
                return EStatus.NULL;
            val = val.ToUpper().Trim();
            switch (val)
            {
                case "":
                case "NULL":
                    _rVal = EStatus.NULL;
                    break;
                case "NORMAL":
                    _rVal = EStatus.NORMAL;
                    break;
                case "LOCK":
                    _rVal = EStatus.LOCK;
                    break;
                case "DISABLE":
                    _rVal = EStatus.DISABLE;
                    break;
                case "DELETE":
                    _rVal = EStatus.DELETE;
                    break;
                default:
                    break;
            }

            return _rVal;
        }
        #endregion

        #region IntToEStatus
        public static EStatus IntToEStatus(int val)
        {
            EStatus _rVal = EStatus.NULL;

            switch (val)
            {
                case -1:
                    _rVal = EStatus.NULL;
                    break;
                case 1:
                    _rVal = EStatus.NORMAL;
                    break;
                case 2:
                    _rVal = EStatus.LOCK;
                    break;
                case 3:
                    _rVal = EStatus.DISABLE;
                    break;
                case 4:
                    _rVal = EStatus.DELETE;
                    break;
                default:
                    break;
            }

            return _rVal;
        }
        #endregion

        #region IntToEActivityType
        public static EActivityType IntToEActivityType(int val)
        {
            EActivityType _rVal = EActivityType.Normal;

            switch (val)
            {
                case 1:
                    _rVal = EActivityType.Exchange;
                    break;
                case 2:
                    _rVal = EActivityType.GroupBuy;
                    break;
                case 3:
                    _rVal = EActivityType.GroupProduct;
                    break;
                default:
                    break;
            }

            return _rVal;
        }
        #endregion
    }
}
