using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JiuZhou.Model
{
    public class ConvertToType
    {
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
                case 0:
                    _rVal = EStatus.UNCHECKED;
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

        #region StringToECheckedStatus
        public static ECheckedStatus StringToECheckedStatus(string val)
        {
            ECheckedStatus _rVal = ECheckedStatus.NULL;
            if (string.IsNullOrEmpty(val))
                return ECheckedStatus.NULL;
            val = val.ToUpper().Trim();
            switch (val)
            {
                case "":
                case "NULL":
                    _rVal = ECheckedStatus.NULL;
                    break;
                case "CHECKING":
                    _rVal = ECheckedStatus.CHECKING;
                    break;
                case "BACK":
                    _rVal = ECheckedStatus.BACK;
                    break;
                case "PASS":
                    _rVal = ECheckedStatus.PASS;
                    break;
                case "DISABLE":
                    _rVal = ECheckedStatus.DISABLE;
                    break;
                default:
                    break;
            }

            return _rVal;
        }
        #endregion

        #region StringToEApiUserType
        public static EApiUserType StringEApiUserType(string val)
        {
            EApiUserType _rVal = EApiUserType.NULL;
            if (string.IsNullOrEmpty(val))
                return EApiUserType.NULL;
            val = val.ToUpper().Trim();
            switch (val)
            {
                case "":
                case "NULL":
                    _rVal = EApiUserType.NULL;
                    break;
                case "QQ":
                    _rVal = EApiUserType.QQ;
                    break;
                case "SINA":
                    _rVal = EApiUserType.SINA;
                    break;
                case "ALIPAY":
                    _rVal = EApiUserType.ALIPAY;
                    break;
                case "TAOBAO":
                    _rVal = EApiUserType.TAOBAO;
                    break;
                default:
                    break;
            }

            return _rVal;
        }
        #endregion

        #region StringToEUOPType
        public static EUOPType StringToEUOPType(string val)
        {
            EUOPType _rVal = EUOPType.NULL;
            if (string.IsNullOrEmpty(val))
                return EUOPType.NULL;
            val = val.ToUpper().Trim();
            switch (val)
            {
                case "":
                case "NULL":
                    _rVal = EUOPType.NULL;
                    break;
                case "REGISTER":
                    _rVal = EUOPType.REGISTER;
                    break;
                case "LOGINFAILED":
                    _rVal = EUOPType.LOGINFAILED;
                    break;
                case "LOGINSUCCEED":
                    _rVal = EUOPType.LOGINSUCCEED;
                    break;
                case "RESETPASSWORD":
                    _rVal = EUOPType.RESETPASSWORD;
                    break;
                case "OTHER":
                    _rVal = EUOPType.OTHER;
                    break;
                default:
                    break;
            }

            return _rVal;
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

        #region IntEFileType
        public static EFileType IntEFileType(int val)
        {
            EFileType _rVal = EFileType.NULL;
            switch (val)
            {
                case 3:
                    _rVal = EFileType.DOCUMENT_IMPORT;
                    break;
                case 2:
                    _rVal = EFileType.FILE;
                    break;
                case 1:
                    _rVal = EFileType.IMAGE;
                    break;
                default:
                    break;
            }

            return _rVal;
        }
        #endregion

        #region StringEAttType
        public static EAttType StringEAttType(string val)
        {
            EAttType _rVal = EAttType.NULL;
            if (string.IsNullOrEmpty(val))
                return EAttType.NULL;
            val = val.ToUpper().Trim();
            switch (val)
            {
                case "":
                case "NULL":
                    _rVal = EAttType.NULL;
                    break;
                case "TEXT":
                    _rVal = EAttType.TEXT;
                    break;
                case "SELECT":
                    _rVal = EAttType.SELECT;
                    break;
                case "CHECKBOX":
                    _rVal = EAttType.CHECKBOX;
                    break;
                case "RADIO":
                    _rVal = EAttType.RADIO;
                    break;
                default:
                    break;
            }

            return _rVal;
        }
        #endregion

        #region ToCommentSettingType
        public static CommentSettingType ToCommentSettingType(object obj)
        {
            CommentSettingType rVal = CommentSettingType.USERS;

            if (obj == null) return rVal;
            string val = obj.ToString().Trim().ToLower();

            switch (val)
            {
                case "admin":
                    rVal = CommentSettingType.ADMIN;
                    break;
                case "users":
                    rVal = CommentSettingType.USERS;
                    break;
                case "all":
                    rVal = CommentSettingType.ALL;
                    break;
                case "close":
                    rVal = CommentSettingType.CLOSE;
                    break;
            }

            return rVal;
        }
        #endregion

        #region ToDisallowsRegisterRuleType
        public static DisallowsRegisterRuleType ToDisallowsRegisterRuleType(object obj)
        {
            DisallowsRegisterRuleType rVal = DisallowsRegisterRuleType.HAS;

            if (obj == null) return rVal;
            string val = obj.ToString().Trim().ToLower();

            switch (val)
            {
                case "has":
                    rVal = DisallowsRegisterRuleType.HAS;
                    break;
                case "rule":
                    rVal = DisallowsRegisterRuleType.RULE;
                    break;
            }

            return rVal;
        }
        #endregion

        #region ToOnOff
        public static OnOff ToOnOff(object obj)
        {
            OnOff rVal = OnOff.OFF;

            if (obj == null) return rVal;
            string val = obj.ToString().Trim().ToLower();

            switch (val)
            {
                case "on":
                    rVal = OnOff.ON;
                    break;
                case "off":
                    rVal = OnOff.OFF;
                    break;
            }

            return rVal;
        }
        #endregion

        #region ToRegisterSettingType
        public static RegisterSettingType ToRegisterSettingType(object obj)
        {
            RegisterSettingType rVal = RegisterSettingType.AUTO;

            if (obj == null) return rVal;
            string val = obj.ToString().Trim().ToLower();

            switch (val)
            {
                case "auto":
                    rVal = RegisterSettingType.AUTO;
                    break;
                case "mail":
                    rVal = RegisterSettingType.MAIL;
                    break;
                case "check":
                    rVal = RegisterSettingType.CHECK;
                    break;
                case "invite":
                    rVal = RegisterSettingType.INVITE;
                    break;
                case "close":
                    rVal = RegisterSettingType.CLOSE;
                    break;
            }

            return rVal;
        }
        #endregion

        #region GetEStatusName
        public static string GetEStatusName(EStatus status)
        {
            string rt = "未知";
            switch (status)
            {
                case EStatus.NORMAL:
                    rt = "正常";
                    break;
                case EStatus.LOCK:
                    rt = "锁定";
                    break;
                case EStatus.DISABLE:
                    rt = "禁用";
                    break;
                case EStatus.DELETE:
                    rt = "删除";
                    break;
                default:
                    break;
            }
            return rt;
        }
        #endregion

        #region StringToERStatus
        public static ERStatus StringToERStatus(string val)
        {
            ERStatus _status = ERStatus.LOCK;
            if (val == null || val.Trim() == "")
                return ERStatus.NULL;
            val = val.ToUpper().Trim();
            switch (val)
            {
                case "":
                case "NULL":
                    _status = ERStatus.NULL;
                    break;
                case "UNTREATED":
                    _status = ERStatus.UNTREATED;
                    break;
                case "PROCESSING":
                    _status = ERStatus.PROCESSING;
                    break;
                case "DISPOSED":
                    _status = ERStatus.DISPOSED;
                    break;
                case "LOCK":
                    _status = ERStatus.LOCK;
                    break;
                default:
                    break;
            }

            return _status;
        }
        #endregion

        #region GetERStatusName
        public static string GetERStatusName(ERStatus status)
        {
            string rt = "未分类";
            switch (status)
            {
                case ERStatus.UNTREATED:
                    rt = "未处理";
                    break;
                case ERStatus.PROCESSING:
                    rt = "处理中";
                    break;
                case ERStatus.DISPOSED:
                    rt = "处理完毕";
                    break;
                case ERStatus.LOCK:
                    rt = "锁定";
                    break;
                default:
                    break;
            }
            return rt;
        }
        #endregion

        #region StringToEBadWordsType
        public static EBadWordsType StringToEBadWordsType(string val)
        {
            EBadWordsType _rVal = EBadWordsType.REPLACE;
            if (val == null)
                return EBadWordsType.REPLACE;
            val = val.ToUpper().Trim();
            switch (val)
            {
                case "":
                case "NULL":
                    _rVal = EBadWordsType.NULL;
                    break;
                case "REPLACE":
                    _rVal = EBadWordsType.REPLACE;
                    break;
                case "AUDIT":
                    _rVal = EBadWordsType.AUDIT;
                    break;
                case "DISALLOW":
                    _rVal = EBadWordsType.DISALLOW;
                    break;
                default:
                    break;
            }

            return _rVal;
        }
        #endregion

        #region GetEApiUserTypeName
        public static string GetEApiUserTypeName(EApiUserType type)
        {
            string rt = "默认账户";
            switch (type)
            {
                case EApiUserType.SINA:
                    rt = "新浪微博账户";
                    break;
                case EApiUserType.QQ:
                    rt = "腾讯QQ账户";
                    break;
                case EApiUserType.ALIPAY:
                    rt = "支付宝账户";
                    break;
                case EApiUserType.TAOBAO:
                    rt = "淘宝账户";
                    break;
                default:
                    break;
            }
            return rt;
        }
        #endregion

        #region GetEUOPTypeName
        public static string GetEUOPTypeName(EUOPType type)
        {
            string rt = "其它操作";
            switch (type)
            {
                case EUOPType.LOGINFAILED:
                    rt = "登录失败";
                    break;
                case EUOPType.LOGINSUCCEED:
                    rt = "登录成功";
                    break;
                case EUOPType.REGISTER:
                    rt = "用户注册";
                    break;
                case EUOPType.RESETMAIL:
                    rt = "重绑邮箱";
                    break;
                case EUOPType.RESETMOBILE:
                    rt = "重绑手机";
                    break;
                case EUOPType.RESETPASSWORD:
                    rt = "重设密码";
                    break;
                case EUOPType.OTHER:
                    rt = "其它操作";
                    break;
                default:
                    break;
            }
            return rt;
        }
        #endregion

        #region GetECheckedStatusName
        public static string GetECheckedStatusName(ECheckedStatus status)
        {
            string rt = "未知";
            switch (status)
            {
                case ECheckedStatus.CHECKING:
                    rt = "<strong style='color:#FF0000'>待审</strong>";
                    break;
                case ECheckedStatus.BACK:
                    rt = "驳回";
                    break;
                case ECheckedStatus.PASS:
                    rt = "通过";
                    break;
                case ECheckedStatus.DISABLE:
                    rt = "禁止";
                    break;
                default:
                    break;
            }
            return rt;
        }
        #endregion        
    }
}
