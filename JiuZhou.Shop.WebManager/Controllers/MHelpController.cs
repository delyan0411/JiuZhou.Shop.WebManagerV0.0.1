using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using JiuZhou.ControllerBase;
using JiuZhou.MySql;
using JiuZhou.HttpTools;
using JiuZhou.Common;

namespace JiuZhou.Shop.WebManager.Controllers
{
    [HandleError]
    public class MHelpController : ForeSysBaseController
    {
        #region List
        public ActionResult List()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,104,228,229,"))
                {
                    currResBody = item;
                    break;
                }
            }
            HasPermission(currResBody.res_id);

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            int pagesize = DoRequest.GetQueryInt("size", 100);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int classid = DoRequest.GetQueryInt("classid", -1);

            string q = DoRequest.GetQueryString("q");
            string sKey = q;

            #region 文章列表
            int dataCount = 0;
            int pageCount = 0;
            List<ShortHelpInfo> _table = new List<ShortHelpInfo>();
            var res = QueryHelpList.Do(pagesize, pageindex
                 , classid
                 , sKey, ref dataCount, ref pageCount);
            if (res != null && res.Body != null && res.Body.help_list != null)
                _table = res.Body.help_list;
            ViewData["infoList"] = _table;//文章列表

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/marticle/list?");
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&classid=" + classid);

            currPageUrl.Append("&q=" + DoRequest.UrlEncode(q));
            currPageUrl.Append("&page=" + pageindex);
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;

            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            #endregion

            return View();
        }
        #endregion

        #region Editor
        public ActionResult Editor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,104,228,229,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            return View();
        }
        #endregion

        #region Categ
        public ActionResult Categ()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,104,228,230,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            return View();
        }
        #endregion

        #region GetHelpTypeInfo
        [HttpPost]
        public ActionResult GetHelpTypeInfo()
        {
            int parentId = DoRequest.GetFormInt("parentId");
            int itemId = DoRequest.GetFormInt("itemId");
            List<HelpTypeInfo> tList = new List<HelpTypeInfo>();
            var res = GetHelpType.Do(0, 2, -1);
            if (res != null && res.Body != null && res.Body.help_type_list != null) {
                tList = res.Body.help_type_list;
            }

            HelpTypeInfo pInfo = new HelpTypeInfo();
            HelpTypeInfo tInfo = new HelpTypeInfo();
            List<HelpTypeInfo> temList = tList.FindAll(
                    delegate(HelpTypeInfo item)
                    {
                        return item.help_type_id == parentId;
                    });
            if (temList.Count > 0) pInfo = temList[0];
            //子分类
            temList = tList.FindAll(
                    delegate(HelpTypeInfo item)
                    {
                        return item.help_type_id == itemId;
                    });
            if (temList.Count > 0) tInfo = temList[0];
            #region 设置排序
            if (tInfo.help_type_id < 1)
            {
                temList = tList.FindAll(
                    delegate(HelpTypeInfo item)
                    {
                        return item.parent_id == parentId;
                    });
                int sort = 0;
                foreach (HelpTypeInfo em in temList)
                {
                    if (em.sort_no > sort) sort = em.sort_no;
                }
                sort++;
                tInfo.sort_no = sort;
            }
            #endregion
            
            #region 分类名路径
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            if (pInfo.type_path == null)
                pInfo.type_path = "";
            string[] arr = pInfo.type_path.Split(',');
           
            sb.Append("根");
            foreach (string s in arr)
            {
                if (string.IsNullOrEmpty(s))
                    continue;
                int val = Utils.StrToInt(s.Trim());
                List<HelpTypeInfo> list = tList.FindAll(
                    delegate(HelpTypeInfo item)
                    {
                        return item.help_type_id == val;
                    });
                if (list.Count > 0)
                {
                    sb.Append(" >> " + list[0].type_name);
                }
            }
            #endregion
            return Json(new { parent = pInfo, type = tInfo, parentName = sb.ToString() }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region PostCategData 保存分类信息
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostCategData()
        {
            int parentId = DoRequest.GetFormInt("parentId");
            int itemId = DoRequest.GetFormInt("itemId");
            string name = DoRequest.GetFormString("name").Trim();
            int sort = DoRequest.GetFormInt("sort", 0);

            #region Checking
            if (name.Length < 1)
            {
                return Json(new { error = true, message = "【名称】不能为空" });
            }
            if (name.Length > 50)
            {
                return Json(new { error = true, message = "【名称】不能多于50个字符" });
            }
            #endregion

            List<HelpTypeInfo> tList = new List<HelpTypeInfo>();
            var resart = GetHelpType.Do(0, 2, -1);
            if (resart != null && resart.Body != null && resart.Body.help_type_list != null)
            {
                tList = resart.Body.help_type_list;
            }

            HelpTypeInfo tInfo = tList.Find(delegate(HelpTypeInfo em)
            {
                return em.help_type_id == itemId;
            });
            if (tInfo == null)
                tInfo = new HelpTypeInfo();
            tInfo.help_type_id = itemId;
            tInfo.parent_id = parentId;
            tInfo.type_name = name;
            tInfo.sort_no = sort;

            int returnValue = -1;
            var res = OpHelpType.Do(tInfo);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ResetCategStatus 修改分类状态
        [HttpPost]
        public ActionResult ResetCategStatus()
        {
            int id = DoRequest.GetFormInt("id");
            int status = DoRequest.GetFormInt("status");

            int returnValue = -1;
            var res = ModifyHelpTypeState.Do(id, status);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion
        
        #region DeleteCategList 删除分类
        [HttpPost]
        public ActionResult DeleteCategList()
        {
            int id = DoRequest.GetFormInt("id");

            int returnValue = -1;
            var res = DeleteHelpType.Do(id);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion 

        #region PostHelpData 保存帮助信息
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostHelpData()
        {
            int id = DoRequest.GetFormInt("id");
            int classId = DoRequest.GetFormInt("ClassID");
            HelpInfo help = new HelpInfo();
            var resarticle = GetHelpInfo.Do(classId);
            if (resarticle != null && resarticle.Body != null)
                help = resarticle.Body;
            List<HelpTypeInfo> categs = new List<HelpTypeInfo>(); ;//分类信息
            var restype = GetHelpType.Do(0, 2, -1);
            if (restype != null && restype.Body != null && restype.Body.help_type_list != null)
                categs = restype.Body.help_type_list;
            HelpTypeInfo categ = categs.Find(delegate(HelpTypeInfo em)
            {
                return em.help_type_id == classId;
            });

            if (categ.help_type_id < 1)
            {
                return Json(new { error = true, input = "message", message = "请选择分类" });
            }
            #region 获取参数
            help.help_title = DoRequest.GetFormString("title").Trim();
            help.click_count = DoRequest.GetFormInt("clickcount");
            help.help_summary = DoRequest.GetFormString("summary").Trim();
            help.help_content = DoRequest.GetFormString("content", false).Trim();
            help.key_word = DoRequest.GetFormString("keyword").Trim();
            help.author_name = DoRequest.GetFormString("author").Trim();
            #endregion

            help.help_type_id = categ.help_type_id;

            #region Checking
            if (help.help_type_id < 1)
            {
                return Json(new { error = true, input = "message", message = "请选择分类" });
            }
            if (help.help_title.Length < 1)
            {
                return Json(new { error = true, input = "message", message = "请填写标题" });
            }
            if (help.help_title.Length > 200)
            {
                return Json(new { error = true, input = "message", message = "标题不能大于200个字符" });
            }
            if (help.click_count < 0)
            {
                return Json(new { error = true, input = "message", message = "点击数不能小于0！" });
            }
            if (help.help_summary.Length > 1000)
            {
                return Json(new { error = true, input = "message", message = "摘要1000个字符" });
            }
            #endregion

            int returnValue = -1;
            var res = OpHelp.Do(help);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            #region 判断是否操作成功
            string msgText = "";
            switch (returnValue)
            {
                case 0:
                    msgText = "操作成功";
                    break;
                case -1:   
                default:
                    msgText = "操作失败";
                    break;
            }
            #endregion

            return Json(new { error = returnValue == 0 ? false : true, message = msgText});
        }
        #endregion

        #region ResetHelpSort 更改排序
        [HttpPost]
        public ActionResult ResetHelpSort()
        {
            int id = DoRequest.GetFormInt("id");
            int sort = DoRequest.GetFormInt("sort");

            int returnValue = -1;
            var res = ModifyHelpSort.Do(id,sort);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ResetHelpState 修改帮助状态
        [HttpPost]
        public ActionResult ResetHelpState()
        {
            int id = DoRequest.GetFormInt("id");
            int status = DoRequest.GetFormInt("state");

            int returnValue = -1;
            var res = ModifyHelpState.Do(id, status);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region RemoveHelpList 删除帮助信息
        [HttpPost]
        public ActionResult RemoveHelpList()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();
            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }

            int returnValue = -1;
            var res = DeleteHelp.Do(idString);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion
    }
}
