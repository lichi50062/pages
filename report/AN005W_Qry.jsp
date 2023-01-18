<%
// 95.10.16 某年底縣市別之全體農漁會信用部存款金額及存款平均餘額表
// 99.04.14 fix 修改部分程式以共用方式撰寫 by 2808
//108.05.15 add 報表格式挑選 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.*" %>
<%@include file="/pages/include/bank_no_hsien_id.include" %>
<%
	//查詢條件值 
	Map dataMap =Utility.saveSearchParameter(request);
	String report_no = "AN005W";
	showBankType=false;//顯示金融機構類別
	showCityType=false;//顯示縣市別
	showPageSetting=true;//顯示本報表採用A4紙張直印/橫印 
	setLandscape=true;//true:橫印
	showUnit=true;//顯示金額單位
	//
	String act = Utility.getTrimString(dataMap.get("act"));	
    String bankType = Utility.getTrimString(dataMap.get("bankType"));	
    String tbank = Utility.getTrimString(dataMap.get("tbank"));	
    String cityType = Utility.getTrimString(dataMap.get("cityType"));	
  	String cancel_no = "" ;
  	YEAR  = Utility.getYear() ;
%>
<script language="javascript" src="../js/Common.js"></script>
<script language="javascript" src="../js/AN000W.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<script language="javascript" src="js/HsienIDUtil.js"></script><!-- 根據查詢年月.挑選縣市別/總機構單位-->
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
<!--
function doSubmit(){      
	if (!confirm("本項報表會執行 3-5 秒，是否確定執行？")){return;}

	this.document.forms[0].action = "/pages/report/AN005W.jsp?act=Excel";
	this.document.forms[0].submit();   
}
//-->
</script>
<link href="/pages/css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form name='form' method=post action='#'>
<input type='hidden' name="rtf_bank_type" value=''>
<input type="hidden" name="wordaction" value='download' >
<input type='hidden' name="showTbank" value='<%=showBankType %>'>
<input type='hidden' name="showCityType" value='<%=showCityType%>'>
<table width='600' border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="25%"><img src="/pages/images/banner_bg1.gif" width="100%" height="17"></td>
    <td width="50%"><font color='#000000' size=4><nobr>某年底縣市別之全體農漁會信用部存款金額及存款平均餘額表</nobr></font></td>
    <td width="25%"><img src="/pages/images/banner_bg1.gif" width="100%" height="17"></td>
  </tr>
</table>
<Table border=1 width='600' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
		<tr class="sbody" bgcolor="#BDDE9C">
		    <td colspan="2" height="1">
		      <div align="right">
		       <input type='radio' name="excelaction" value='download' checked> 下載報表
		       <%if(Utility.getPermission(request,report_no,"P")){//Print %> 
		       <a href="javascript:doSubmit()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','../images/bt_execb.gif',1)"><img src="../images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a>
			   <%} %>
		       <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','../images/bt_cancelb.gif',0)"><img src="../images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a>
		       <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','../images/bt_reporthelpb.gif',1)"><img src="../images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a>
		      </div>
		    </td> 
		</tr>
		<tr class="sbody">
			<td width="118" bgcolor="#BDDE9C" height="1">查詢年度</td>
			<td width="416" bgcolor="#EBF4E1" height="1">
				<input type='text' name='S_YEAR' value="<%=YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)'>
        		<font color='#000000'>年</font>     
			</td>
		</tr>
		<tr class="sbody">
			<td width="118" bgcolor="#BDDE9C" height="1">農(漁)會別</td>
			<td width="416" bgcolor="#EBF4E1" height="1">
				<select size="1" name="bankType">
					<option value="6" selected >農會</option>
					<option value="7">漁會</option>
					<option value="">農漁會</option>
  				</select>
			</td>
		</tr>
		<tr class="sbody">
			<td width="118" bgcolor="#BDDE9C" height="1">金額單位</td>
			<td width="416" bgcolor="#EBF4E1" height="1">
				<select size="1" name="unit">
					<option value ="元;1">元</option>
					<option value ="仟元;1000" selected >仟元</option>
					<option value ="萬元;10000">萬元</option>
					<option value ="百萬元;1000000">百萬元</option>
					<option value ="仟萬元;10000000">仟萬元</option>
					<option value ="億元;100000000">億元</option>
				</select>
			</td>
		</tr>
		
		<tr class="sbody">
			<td width="118" bgcolor="#BDDE9C" height="1">輸出格式</td>
			<td width="416" bgcolor="#EBF4E1" height="1">
				 <input name='printStyle' type='radio' value='xls' checked>Excel
  				 <input name='printStyle' type='radio' value='ods' >ODS
  				 <input name='printStyle' type='radio' value='pdf' >PDF
			</td>
		</tr>
		
        <tr>
  			<td bgcolor="#E9F4E3" colspan="2">
            	<font color="red" size="2">資料來源：各農漁會信用部每年度12月底之申報財務資料</font>
      		</td>
  		</tr>
		<tr>
			<td bgcolor="#E9F4E3" colspan="2" align="center">
				<table width="555" border="0" cellpadding="1" cellspacing="1">
					<tr>
						<td width="34"><img src="../images/print_1.gif" width="34" height="34"></td>
						<td width="222"><font color="#CC6600">本報表採用A4紙張橫印</font></td>
					</tr>
				</table>
			</td>
		</tr>
</Table>
  


</form>
</body>
</html>
