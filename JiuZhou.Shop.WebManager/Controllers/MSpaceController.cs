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
    public class MSpaceController : ForeSysBaseController
    {
        #region 图片列表
        public ActionResult ImgList()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,105,139,140,"))
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


            int size = 60;
            int page = DoRequest.GetQueryInt("page", 1);
            int classid = DoRequest.GetQueryInt("classid", 3);

        
            int dataCount = 0;
            int pageCount = 0;

            DateTime sDate = DoRequest.GetQueryDate("st", DateTime.Now.AddYears(-3));
            DateTime eDate = DoRequest.GetQueryDate("et", DateTime.Now);


            string q = DoRequest.GetQueryString("q");
            //bool isImage = true;
            List<SysFiles> infoList = new List<SysFiles>();
            var res = QuerySysFile.Do(size, page, classid, 1
                , sDate.ToString()
                , eDate.ToString("yyyy-MM-dd 23:59:59")
                , q
                , ref dataCount, ref pageCount);
            if (res != null && res.Body != null && res.Body.file_list != null)
            {
                infoList = res.Body.file_list;
            }
            ViewData["infoList"] = infoList; 

            #region 分页链接
            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mspace/imgList");
            currPageUrl.Append("?classid=" + classid);
            currPageUrl.Append("&st=" + sDate);
            currPageUrl.Append("&et=" + eDate);
            currPageUrl.Append("&page=" + page);
            currPageUrl.Append("&q=" + DoRequest.UrlEncode(q));
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = size;
            ViewData["pageindex"] = page;
            ViewData["dataCount"] = dataCount;

            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, size, page, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, size, page, currPageUrl.ToString());
            #endregion

            return View();
        }
        #endregion

        #region 图片回收站列表
        public ActionResult ImgRecycleList()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,105,139,143,"))
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


            int size = 60;
            int page = DoRequest.GetQueryInt("page", 1);
            int classid = DoRequest.GetQueryInt("classid", 3);


            int dataCount = 0;
            int pageCount = 0;

            DateTime sDate = DoRequest.GetQueryDate("st", DateTime.Now.AddYears(-3));
            DateTime eDate = DoRequest.GetQueryDate("et", DateTime.Now);


            string q = DoRequest.GetQueryString("q");
            //bool isImage = true;
            List<SysFiles> infoList = new List<SysFiles>();
            var res = QuerySysFile.Do(size, page, classid, 0
                , sDate.ToString()
                , eDate.ToString()
                , q
                , ref dataCount, ref pageCount);
            if (res != null && res.Body != null && res.Body.file_list != null)
                infoList = res.Body.file_list;

            ViewData["infoList"] = infoList;

            #region 分页链接
            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mspace/imgrecycleList");
            currPageUrl.Append("?classid=" + classid);
            currPageUrl.Append("&st=" + sDate);
            currPageUrl.Append("&et=" + eDate);
            currPageUrl.Append("&page=" + page);
            currPageUrl.Append("&q=" + DoRequest.UrlEncode(q));
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = size;
            ViewData["pageindex"] = page;
            ViewData["dataCount"] = dataCount;

            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, size, page, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, size, page, currPageUrl.ToString());
            #endregion

            return View();
        }
        #endregion

        #region 文件列表
        public ActionResult FileList()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,105,139,141,"))
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


            int size = 60;
            int page = DoRequest.GetQueryInt("page", 1);
            int classid = DoRequest.GetQueryInt("classid", 8);


            int dataCount = 0;
            int pageCount = 0;

            DateTime sDate = DoRequest.GetQueryDate("st", DateTime.Now.AddYears(-3));
            DateTime eDate = DoRequest.GetQueryDate("et", DateTime.Now);


            string q = DoRequest.GetQueryString("q");
            //bool isImage = true;
            List<SysFiles> infoList = new List<SysFiles>();
            var res = QuerySysFile.Do(size, page, classid, 1
                , sDate.ToString()
                , eDate.ToString("yyyy-MM-dd 23:59:59")
                , q
                , ref dataCount, ref pageCount);
            if (res != null && res.Body != null && res.Body.file_list != null)
                infoList = res.Body.file_list;

            ViewData["infoList"] = infoList;

            #region 分页链接
            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mspace/fileList");
            currPageUrl.Append("?classid=" + classid);
            currPageUrl.Append("&st=" + sDate);
            currPageUrl.Append("&et=" + eDate);
            currPageUrl.Append("&page=" + page);
            currPageUrl.Append("&q=" + DoRequest.UrlEncode(q));
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = size;
            ViewData["pageindex"] = page;
            ViewData["dataCount"] = dataCount;

            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, size, page, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, size, page, currPageUrl.ToString());
            #endregion

            return View();
        }
        #endregion

        #region Categ 文件分类
        public ActionResult Categ()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,105,139,142,"))
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

        #region 图片上传
        public ActionResult UploadImage()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,105,139,140,"))
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

        #region ResetSysFileStatus 修改状态
        [HttpPost]
        public ActionResult ResetSysFileStatus()
        {
            int id = DoRequest.GetFormInt("id");
            int status = DoRequest.GetFormInt("status");

            int returnValue = -1;
            var res = ModifySysFileTypeState.Do(id, status);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region GetClass 获取分类信息
        //[HttpPost]
        public ActionResult GetClass()
        {

            string parentCode = DoRequest.Request("parentCode");
            string code = DoRequest.Request("Code");

            List<PicTypeList> sysFClassList = new List<PicTypeList>();
            var restype = GetSysFileType.Do(-1);
            if (restype != null && restype.Body != null && restype.Body.type_list != null)
                sysFClassList = restype.Body.type_list;

            PicTypeList pInfo = sysFClassList.FindLast(delegate(PicTypeList item) { return item.type_code.Equals(parentCode); });
            PicTypeList tInfo = sysFClassList.FindLast(delegate(PicTypeList item) { return item.type_code.Equals(code); });
            if (pInfo == null) pInfo = new PicTypeList();
            if (tInfo == null) tInfo = new PicTypeList();
            if (tInfo.sp_type_id < 1)
            {
                List<PicTypeList> temList = sysFClassList.FindAll(delegate(PicTypeList item) { return item.parent_code == parentCode; });
                tInfo.sort_no = 1;
                foreach (PicTypeList node in temList)
                {
                    if (tInfo.sort_no <= node.sort_no)
                        tInfo.sort_no += 1;
                }
            }

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            string[] arr = pInfo.type_path.Split(',');
            sb.Append("根");
            foreach (string s in arr)
            {
                if (string.IsNullOrEmpty(s))
                    continue;
                //int val = Utils.StrToInt(s.Trim());
                List<PicTypeList> list = sysFClassList.FindAll(
                    delegate(PicTypeList item)
                    {
                        return item.type_code.Equals(s);
                    });
                if (list.Count > 0)
                    sb.Append(" >> " + list[0].sp_type_name);
            }
            return Json(new { parent = pInfo, type = tInfo, parentName = sb.ToString() }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region PostSysFileCategData 修改分类
        [HttpPost]
        public ActionResult PostSysFileCategData()
        {
            string parentCode = DoRequest.GetFormString("parentCode");
            string code = DoRequest.GetFormString("code");
            int typeId = DoRequest.GetFormInt("typeId");
            string name = DoRequest.GetFormString("name").Trim();
            int sort = DoRequest.GetFormInt("sort");
            int issys = DoRequest.GetFormInt("isSys");
            #region 验证
            if (string.IsNullOrEmpty(name))
            {
                return Json(new { error = true, message = "名称不能为空" });
            }
            if (string.IsNullOrEmpty(code))
            {
                return Json(new { error = true, message = "编码不能为空" });
            }
            if (Utils.IsLong(code))
            {
                return Json(new { error = true, message = "编码不能是纯数字" });
            }
            if (!Utils.IsMatch(code, @"^[0-9a-zA-Z\-]{1,100}$"))
            {
                return Json(new { error = true, message = "编码只能是数字、字母或中划线(-)" });
            }
            #endregion
            List<PicTypeList> sysFClassList = new List<PicTypeList>();
            var restype = GetSysFileType.Do(-1);
            if (restype != null && restype.Body != null && restype.Body.type_list != null)
                sysFClassList = restype.Body.type_list;

            PicTypeList pNode = sysFClassList.FindLast(delegate(PicTypeList item) { return item.type_code.Equals(parentCode); });
            PicTypeList cNode = sysFClassList.FindLast(delegate(PicTypeList item) { return item.sp_type_id == typeId; });
            if (pNode == null) pNode = new PicTypeList();
            if (cNode == null) cNode = new PicTypeList();
            #region 初始化参数
            cNode.parent_code = pNode.type_code;
            cNode.type_code = code;
            cNode.sp_type_name = name;
            cNode.sort_no = sort;
            cNode.is_sys = issys;
            #endregion

            int returnValue = -1;
            if (cNode.sp_type_id < 1)
            {
                //新增
                cNode.sp_type_state = 0;
            }
             
            var res = OpSysFileType.Do(cNode);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if(returnValue == 0)
                return Json(new { error = false, message = "操作成功！" });
            return Json(new { error = true, message = "操作失败！" });
        }
        #endregion

        #region ResetFileStatus 修改状态
        [HttpPost]
        public ActionResult ResetFileStatus()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();
            int visible = DoRequest.GetFormInt("visible");

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }

            int returnValue = -1;
            var res = ModifySysFileState.Do(idString,visible);
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
