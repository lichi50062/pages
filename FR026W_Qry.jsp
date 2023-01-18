<%
// FR026W_Excel 在台無住所之外國人新台幣存款表
// 94.11.18 created by lilic0c0 4183
// 99.04.09 因應縣市合併調整程式&抽取部分程式為共用部分 by 2808
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %> 
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.*" %>
<%@include file="./include/bank_no_hsien_id.include" %>
<%

	System.out.println("FR026W_Qry.jsp Program Start...");
	//查詢條件值 
	Map dataMap =Utility.saveSearchParameter(request);
	String report_no = "FR026W";
	showBankType=true;//顯示金融機構類別
	showCityType=true;//顯示縣市別
	showUnit=false ;//顯示金額單位 PS :金額單位顯示於最下方,所以另外include
	showPageSetting=true;//顯示本報表採用A4紙張直印/橫印 
	setLandscape=false;//true:橫印
    showCancel_No=false;//顯示營運中/裁撤別
	// 取得參數
    String tbank = dataMap.get("tbank")== null ? "" : dataMap.get("tbank").toString();
    String bankType = Utility.getTrimString(dataMap.get("bank_type"));
    String cancel_no = Utility.getTrimString(dataMap.get("cancel_no"));
%>

<HTML>
<HEAD>
<TITLE>在台無住所之外國新台幣存款表</TITLE>
<script language="javascript" src="js/FR026W.js"></script>
<script language="javascript" src="js/HsienIDUtil.js"></script><!-- 根據查詢年月.挑選縣市別/總機構單位-->
<link href="css/b51.css" rel="stylesheet" type="text/css">
</HTML>

<body>
<Form name='form' method=post action='#'>
<input type="hidden" name="bank_type" value="<%= bankType %>" >
<input type='hidden' name="showTbank" value='true'>
<input type='hidden' name="showCityType" value='<%=showCityType%>'>
<input type="hidden" name="showCancel_No" value="<%=showCancel_No %>"/> 
<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td width="150"><img src="images/banner_bg1.gif" width="150" height="17"></td>
        <td width="300"><font color='#000000' size=4>在台無住所之外國新台幣存款表</font></td>
        <td width="150"><img src="images/banner_bg1.gif" width="150" height="17"></td>
    </tr>
</table>

<table border=1 width='600' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
	<tr class="sbody" bgcolor="#BDDE9C">
    	<td colspan="2" height="1"><div align="right">
      		<input type='radio' name="ExcelAction" value = "download" checked > 下載報表
      		<a href="javascript:doSubmit('Creatrpt',this.document.forms[0])" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a>
      		<a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a>
      		<a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a>
      	</div></td>
	</tr>
	<%@include file="./include/ym_hsien_id_unit.include" %><!--顯示查詢日期/金融機構類別/縣市別-->
	<tr class="sbody">
		<td width="118" bgcolor="#BDDE9C" height="1">總機構單位</td>
		<td width="416" bgcolor="#EBF4E1" height="1">
		  <select size="1" name="tbank"> 
		  </select> </td>
	</tr>
	<%@include file="./include/DS_Unit2.include" %>
	<%@include file="./include/rpt_style.include" %><!--報表格式挑選-->
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
</table>
</form>
</body>
<script language="JavaScript" >
<!--

setSelect(form.bankType,"<%=bankType%>");
form.S_YEAR.value = '<%=Utility.getCHTYYMMDD("yy")%>';
changeCity('CityXML', form.cityType, form.S_YEAR, form);
changeTbank('TBankXML', form.tbank, form.cityType, form);

-->
</script>
</HTML>
<% System.out.println("FR026W_Qry.jsp Program End...");%>	
