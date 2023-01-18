﻿<%
//108.04.12 create 全體農漁會信用部各身分別放款金額一覽表 by 2295
//108.05.16 add 報表格式挑選 by 2295
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
	String report_no = "FR082W";
	showCancel_No=false;//顯示營運中/裁撤別
	showBankType=false;//顯示金融機構類別
    showCityType=false;//顯示縣市別
    showUnit=true;//顯示金額單位
    showPageSetting=true;//顯示本報表採用A4紙張直印/橫印 
	setLandscape=false;//true:橫印
    String cancel_no = "N";
	String act = Utility.getTrimString(dataMap.get("act"));	
    String bank_type = Utility.getTrimString(dataMap.get("bank_type"));	  
    String bankType = bank_type;//ym_hsien_id_unit.include用    
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/HsienIDUtil.js"></script><!-- 根據查詢年月.挑選縣市別/總機構單位-->
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
<!--
function doSubmit(){ 
   var tmp_year,tmp_month;
   tmp_year = parseInt(this.document.forms[0].S_YEAR.value);
   tmp_month = parseInt(this.document.forms[0].S_MONTH.value);
   if( tmp_year * 100 + tmp_month < 9406){
      alert('94年6月起開始受理申報資料');
      return;
   } 
   if(confirm("本項報表會報行10-15秒，是否確定執行？")){
      this.document.forms[0].action = "/pages/FR082W_Excel.jsp";	
      this.document.forms[0].target = '_self';
      this.document.forms[0].submit();   
   }
}

//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#'>
<input type=hidden name="bank_type" value=<%=bank_type%>>
<input type='hidden' name="showTbank" value='false'>
<input type='hidden' name="showCityType" value='<%=showCityType%>'>
<input type='hidden' name="showCancel_No" value='<%=showCancel_No%>'>

<table width='600' border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr>
    <td width="15%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
    <td width="70%"><font color='#000000' size=4><b><center>全體農漁會信用部各身分別放款金額一覽表</center></b></font></td>
    <td width="15%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
  </tr>
</table>
<Table border=1 width='600' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
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
<%@include file="./include/ym_hsien_id_unit.include" %><!--顯示查詢日期/金融機構類別/縣市別-->
<%@include file="./include/rpt_style.include" %><!--報表格式挑選-->
<tr>
<table border="1" width="600" align="center" height="54" bgcolor="#FFFFF" bordercolor="#76C657">
  <tr>
  	<td bgcolor="#E9F4E3" colspan="2">
       <div align="center">
  		<table width="574" border="0" cellpadding="1" cellspacing="1">
  		<tr><td width="34"><img src="/pages/images/print_1.gif" width="34" height="34"></td>
            <td width="492"><font color="#CC6600">本報表採用A4紙張直印</font></td>                              
        </tr>
        </table>
        </div>
    </td>
  </tr>  
</table>
</Table>

</form>
</BODY>
</html>
