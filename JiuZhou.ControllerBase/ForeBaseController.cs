using System;
using System.IO;
using System.Text;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.Configuration;
using System.Collections.Generic;

using JiuZhou.Common;
using JiuZhou.Model;
using JiuZhou.XmlSource;

namespace JiuZhou.ControllerBase
{
    /// <summary>
    /// »ùÀà
    /// </summary>
    public class ForeBaseController : Controller
    {
        public ConfigInfo _config = ConnStringConfig.GetConfig;


        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            base.OnActionExecuting(filterContext);//base.OnResultExecuted
        }

        protected override void OnException(ExceptionContext filterContext)
        {
            base.OnException(filterContext);//base.OnResultExecuted


        }
    }
}

