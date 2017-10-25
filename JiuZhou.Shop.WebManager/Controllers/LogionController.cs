using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;

using JiuZhou.ControllerBase;
using JiuZhou.MySql;
using JiuZhou.HttpTools;
using JiuZhou.Common;
using System.IO;
using System.Text;

namespace JiuZhou.Shop.WebManager.Controllers
{
    [HandleError]
    public class LogionController : ForeSysBaseController2
    {
  
        #region 主页
        public ActionResult Index()
        {
            return View();
        }
        #endregion

        #region 第三方主页
        public ActionResult ShopLogionIndex()
        {


            return View();
        }
        #endregion


        #region 发送手机验证码
        [HttpPost]
        public ActionResult SendVerifyCode()
        {
            if (Session["SendVerifyCodeTime"] != null)
            {
                try
                {
                    DateTime time = DateTime.Parse(Session["SendVerifyCodeTime"].ToString());
                    if (time.AddSeconds(60) > DateTime.Now)
                    {
                        return Json(new { error = true, message = "请稍后再申请发送验证码" });
                    }
                }
                catch (Exception)
                {
                    return Json(new { error = true, message = "Error" });
                }
            }
            int type = DoRequest.GetFormInt("sendType",1);
            int returnVal = -1;
            string msgText = "";
            var res = SendManagerVerifyCode.Do(type);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
            {
                returnVal = Utils.StrToInt(res.Header.Result.Code, -1);
                msgText = res.Header.Result.Msg;
            }
            if (returnVal == 0) {
                Session["SendVerifyCodeTime"] = DateTime.Now;
            }
            return Json(new { error = returnVal == 0 ? false : true, message = msgText, returnValue = returnVal });
        }
        #endregion

        //判断验证码
        [HttpPost]
        public ActionResult CheckYzm()
        {
            string code = DoRequest.GetFormString("code");
         
            string msg = "系统错误";
            bool error = true;
       
            if (string.IsNullOrEmpty(code))
            {
                return Json(new { error = error, message = "验证码不能为空" });
            }

            int returnVal = -1;
            CheckCodeInfo info = new CheckCodeInfo();
            var res = CheckManagerVerifyCode.Do(code);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
            {
                returnVal = Utils.StrToInt(res.Header.Result.Code, -1);
                msg = res.Header.Result.Msg;
                info = res.Body;
            }

            string url = _config.UrlManager + "/Home/index";

            if (returnVal == 0)
            {
                Cookies.SaveLoginInfo(info.mobile_no, info.last_login_ip, info.last_login_time);
            }
            return Json(new { error = returnVal == 0 ? false : true, message = msg, url = url });
        }
    }
}
