<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="EditCateg-boxControl" class="moveBox" style="height:230px;width:520px;">
	<div class="name">
		编辑分类菜单
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postRecommendPageBox(this)">
<input type="hidden" name="posid" value=""/>
<input type="hidden" name="pid" value="" />
<table width="100%" border="0" cellspacing="0" cellpadding="3px">
  <tr>
    <td colspan="4"><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td colspan="2">菜单名称：<input type="text" name="name"  value="" style="height:25px"/></td>    
    <td colspan="2" >url：<input type="text" name="url"  value="" style="height:25px"/></td>   
  </tr>
  <tr>
     <td>序&nbsp;&nbsp;列：<input type="text" name="sort"  value="" style="width: 40px;height:25px;" /></td>
     <td >是否加粗：<input type="checkbox" name="Isb" value="1"/></td>   
     <td >是否加颜色：<input type="checkbox" name="Iscolor" value="1"/></td>
     <td >是否换行：<input type="checkbox" name="IsBr" value="1"/></td>
  </tr>
  <tr name="position">
     <td colspan="4">位&nbsp;&nbsp;置:  左边 <input type="checkbox" name="position1" value="1" onclick="checkedthis(this)"/>&nbsp;
     右边 <input type="checkbox" name="position1" value="2" onclick="checkedthis(this)"/></td>
  </tr>
    <tr>
     <td  colspan="4"><input type="submit" value="确定" style="width:50px;height:40px;background:red;color:White;"/></td>  
  </tr>
</table>
</form>
</div>