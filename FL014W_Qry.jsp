<%
//common:
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>  
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/bank_no_hsien_id.include" %>
<%
	// 查詢條件值 
    Map dataMap =Utility.saveSearchParameter(request);
	String report_no = "FL014W";
	setLandscape = true ;
	/* showCancel_No=false;//顯示營運中/裁撤別
	showBankType=false;//顯示金融機構類別
    showCityType=false;//顯示縣市別
    showUnit=true;//顯示金額單位
    showPageSetting=true;//顯示本報表採用A4紙張直印/橫印 
	setLandscape=true;//true:橫印
    String cancel_no = "N"; */
	
    
 	
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/HsienIDUtil.js"></script><!-- 根據查詢年月.挑選縣市別/總機構單位-->
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">

function doSubmit(){   
	this.document.forms[0].action = "/pages/FL014W_Excel.jsp?act=download";	
    this.document.forms[0].target = '_self';
    this.document.forms[0].submit();  
}

</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#'>
<input type=hidden name="bank_type" value="ALL">
<input type='hidden' name="showTbank" value='false'>

<table width='600' border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr>
    <td width="20%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
    <td width="60%"><font color='#000000' size=4><b><center>政策性農業專案貸款尚未繳交罰鍰明細表</center></b></font></td>
    <td width="20%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
  </tr>
</table>
<table border="1" width="600" align="center" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody" bgcolor="#BDDE9C">
    <td colspan="2" height="1">
      <div align="right">
       <input type='radio' name="act" value='download' checked>下載報表  
       <%if(Utility.getPermission(request,report_no,"P")){//Print %> 
       <a href="javascript:doSubmit('createRpt')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a>
       <%}%>
       <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a>
       <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a>
      </div>
    </td>
</tr>
<%@include file="./include/rpt_style.include" %><!--報表格式挑選-->
<%@include file="./include/pageSetting.include" %><!--顯示本報表採用A4紙張直印/橫印 -->
</table>

</form>
</body>
</html>
