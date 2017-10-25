<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords" content="管理端登录验证,九洲网上药店" />
<meta name="description" content="管理端登录验证,九洲网上药店" />
<script type="text/javascript" src="/javascript/jquery-1.8.3.js"></script>
<!-- <script type="text/javascript" src="/javascript/AtaiJs-1.1.js" charset="utf-8"></script> -->
<script src="/javascript/v1.2/AtaiJs-1.2.js" type="text/javascript"></script>
<!-- <script type="text/javascript" src="/javascript/v1.2/jscode2.js" charset="utf-8"></script> -->
<script type="text/javascript" src="/javascript/user.js" charset="utf-8"></script>
<link href="/style/v1.2/base2.css" type="text/css" rel="stylesheet"/>
<link href="/style/v1.2/user.css" type="text/css" rel="stylesheet"/>
<link href="<%=config.UrlManager %>/favicon.ico" type="image/x-icon" rel="shortcut icon" />
<!--[if lte IE 6]>
<script type="text/javascript" src="<%=config.UrlHome %>javascript/iepng.js"></script>
<script>DD_belatedPNG.fix('div,ul,li,dl,dt,dd,span,p,input,h1,h2,h3,h4,h5,h6,a,em,b,img,strong');</script>
<![endif]-->
<title>管理端登录验证-九洲网上药店</title>
<style type="text/css">
    .btn_code, .btn_vcode{padding: 2px; display:inline; color: white;line-height: 24px;  width:100px; border-radius: 3px; cursor:pointer;}
    .btn_code{background-color: rgb(145,29,40);}
    .btn_vcode{background-color: #1D4F73;}
    .waiting{background-color: gray; cursor:default; }
    .trCode, .hdn{display:none;}
</style>
</head>
<body>
<%Html.RenderPartial("User/UserPageTopControl"); %>
<form action="" method="post" onsubmit="return checkYzm(this,<%=(int)ViewData["usertype"] %>)">
<input type="hidden" id="login-returnUrl" name="returnUrl" value="<%=DoRequest.GetQueryString("returnurl").Trim()%>"/>
<input type="hidden" id="postaddress" name="postaddress" value=""/>
<div class="tab-register-form">
	<h1>管理端登录验证</h1>
<table>
<thead>
<tr>
<th style="width:20%">&nbsp;</th>
<th >&nbsp;</th>
<th style="width:40%">&nbsp;</th>
</tr>
</thead>
<tbody>

  <tr id="trCode">
    <td class="td-lable">手机验证码：</td>
    <td class="td-input"><input id="verifyCode" name="verifyCode" value="" class="input" style="width:140px;float:left;" placeholder="请输入您收到的验证码" title="请输入您收到的验证码" onfocus="tips('')"/>&nbsp;<input type="button" id="btnCode" class="btn_code" value="获取验证码" onclick="getCode(1)"/> <input type="button" id="btnCodev" class="btn_vcode" value="获取验证码" onclick="getCode(2)"/></td>
    <td><div class="tips-text" id="tips-message" style="color:#F00"></div></td>
  </tr>
  
  <tr>
    <td>&nbsp;</td>
    <td class="td-input"><input type="submit" value="登录" class="submit"/></td>
    <td>&nbsp;</td>
  </tr>
  </tbody>
</table>
</div>
</form>
<br/><br/><br/><br/><br/><br/>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>