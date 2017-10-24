using System;

namespace JiuZhou.Model
{
    public class LoginInfo
    {
        
        /// <summary>
        /// 用户ID
        /// </summary>
        public int UserID { set; get; }
        /// <summary>
        /// 登录用户名
        /// </summary>
        public string UserName { set; get; }
        /// <summary>
        /// 显示名
        /// </summary>
        public string ShowName { set; get; }
        /// <summary>
        /// 认证信息
        /// </summary>
        public string Authentication { set; get; }

        /// <summary>
        /// 活动时间
        /// </summary>
        public DateTime ActionTime { set; get; }

        /// <summary>
        /// 随机串
        /// </summary>
        public string Guid { set; get; }

        /// <summary>
        /// 用户等级
        /// </summary>
        public int UserLevel { set; get; }

        /// <summary>
        /// 用户类型，1-普通用户，2-操作员
        /// </summary>
        public int UserType { set; get; }

        /// <summary>
        /// 手机号
        /// </summary>
        public string MobileNo { set; get; }

        /// <summary>
        /// 上次登录IP
        /// </summary>
        public string LastLogionIp { set; get; }

        /// <summary>
        /// 上次登录时间
        /// </summary>
        public string LastLogionTime { set; get; }

        /// <summary>
        /// 所属商家ID
        /// </summary>
        public string ShopId { set; get; }

        /// <summary>
        /// 认证信息(DES.Encode(userid&username&userlevel&guid&actiontime&ip))
        /// </summary>
        public string KeyCode { set; get; }
        /// <summary>
        /// 返回UserName+CreateTime+Cookies加密混淆器
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            return this.UserName + this.Guid + "2#d_+c.dSo%" + this.UserID.ToString();
        }

        public LoginInfo()
        {

        }
    }
}
