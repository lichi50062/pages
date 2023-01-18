<%
//create N年內及目前月份經營概況趨勢統計分析 by 2968
//108.05.27 add 報表格式挑選 by rock.tsai
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
	String report_no = "FR001WN";
	showCancel_No=false;//顯示營運中/裁撤別
	showBankType=false;//顯示金融機構類別
    showCityType=false;//顯示縣市別
    showUnit=false;//顯示金額單位
    showPageSetting=true;//顯示本報表採用A4紙張直印/橫印 
	setLandscape=true;//true:橫印
    String cancel_no = "N";
	
    String bank_type = Utility.getTrimString(dataMap.get("bank_type"));	  
    String showEng = Utility.getTrimString(dataMap.get("showEng"));	 
    String bankType = bank_type;//ym_hsien_id_unit.include用
    String title = "N年內及目前月份經營概況趨勢統計分析";  
	//取得登入者資訊=================================================================================================
	String muser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");		
    String muser_bank_type = ( session.getAttribute("bank_type")==null ) ? "" : (String)session.getAttribute("bank_type");			
    String DS_bank_type = (session.getAttribute("DS_bank_type")==null)?"6":(String)session.getAttribute("DS_bank_type");	
    System.out.println("**************** ds_bank_type="+session.getAttribute("DS_bank_type"));
    //============================================================================================================== 	
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
   	if(this.document.forms[0].S_YEAR0.value==''){
		alert('請輸入N年內');
	    return;
	}
   	tmp_year = parseInt(this.document.forms[0].S_YEAR.value);
   	tmp_month = parseInt(this.document.forms[0].S_MONTH.value);
   	tmp_year0 = parseInt(this.document.forms[0].S_YEAR0.value);
   	if( tmp_year >=100 && tmp_year-tmp_year0<=99){
		alert('不可跨年度查詢');
      	return;
   	} 
   if(confirm("本項報表會報行10-15秒，是否確定執行？")){
      this.document.forms[0].action = "/pages/FR001WN_Excel.jsp";	
      this.document.forms[0].target = '_self';
      this.document.forms[0].submit();   
   }
}
//所有欄位只能輸入數字
function IsNum(){ 
       return ((event.keyCode >= 48) && (event.keyCode <= 57)); 
}
//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#'>
<input type='hidden' name="showTbank" value='false'>
<input type='hidden' name="showCityType" value='<%=showCityType%>'>
<input type='hidden' name="showCancel_No" value='<%=showCancel_No%>'>

<table width='600' border="0" align="center" cellpadding="0" cellspacing="0">
<tr> 
	<td>&nbsp;</td>
</tr>
<tr>
	<td width="20%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
	<td width="60%"><font color='#000000' size=4><b><center><%=title%></center></b></font></td>
	<td width="20%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
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
<tr class="sbody">
	<td width="118" bgcolor="#BDDE9C" height="1">N年內</td>
	<td width="416" bgcolor="#EBF4E1" height="1">
		<input type='text' name='S_YEAR0' size="7" maxlength="3" onkeypress="event.returnValue=IsNum()">
	</td>
</tr> 
<tr class="sbody">
	<td width="118" bgcolor="#BDDE9C" height="1">農(漁)會別</td>
	<td width="416" bgcolor="#EBF4E1" height="1">
	    <select size="1" name="bank_type">                            
	    <%if(DS_bank_type.equals("6") || muser_id.equals("A111111111") ){//95.11.10 有農會的menu時,才可顯示農會%>
	    	<option value ='6' <%if((!bank_type.equals("")) && bank_type.equals("6")) out.print("selected");%>>農會</option>                                                            
	    <%}%>
	    <%if(DS_bank_type.equals("7") || muser_id.equals("A111111111") ){//95.11.10 有漁會的menu時,才可顯示漁會%>
	        <option value ='7' <%if((!bank_type.equals("")) && bank_type.equals("7")) out.print("selected");%>>漁會</option>                              
	    <%}%>
	    <%if(!bank_type.equals("") && (muser_bank_type.equals("2") || muser_id.equals("A111111111"))){
	        //95.11.10 登入者為A111111111 or 農金局時,才可顯示農漁會%>                              
	        <option value ='ALL' <%if((!bank_type.equals("")) && bank_type.equals("ALL")) out.print("selected");%>>農漁會</option>                              
	    <%}%>
	    </select>
	</td>
</tr>
<tr class="sbody">
	<td width="118" bgcolor="#BDDE9C" height="1">金額單位</td>
	<td width="416" bgcolor="#EBF4E1" height="1">
		<select size="1" name="Unit">
			<option value ='1' <%if((!Unit.equals("")) && Unit.equals("1")) out.print("selected");%>>元</option>
			<option value ='1000' <%if((!Unit.equals("")) && Unit.equals("1000")) out.print("selected");%>>千元</option>
			<option value ='10000' <%if((!Unit.equals("")) && Unit.equals("10000")) out.print("selected");%>>萬元</option>
			<option value ='1000000' <%if((!Unit.equals("")) && Unit.equals("1000000")) out.print("selected");%>>百萬元</option>
			<option value ='10000000' <%if((!Unit.equals("")) && Unit.equals("10000000")) out.print("selected");%>>千萬元</option>
			<option value ='100000000' <%if((!Unit.equals("")) && Unit.equals("100000000")) out.print("selected");%>>億元</option>
		</select>
	</td>
</tr>
<%@include file="./include/rpt_style.include" %><!--報表格式挑選-->                     
</Table>
<table border="1" width="600" align="center" height="54" bgcolor="#FFFFF" bordercolor="#76C657">
<tr>
	<td bgcolor="#E9F4E3" colspan="2">
		<div align="center">
			<table width="555" border="0" cellpadding="1" cellspacing="1">
				<tr><td width="550"><font color="#CC6600">使用說明:<br>
					因100年度縣市合併,只能查詢99年度(含)以前資料或100年度(含)以後資料,不可跨年度查詢</font></td>
				</tr>
			</table>
		</div>
	</td>
</tr> 
<tr>
	<td bgcolor="#E9F4E3" colspan="2">
		<div align="center">
			<table width="555" border="0" cellpadding="1" cellspacing="1">
				<tr><td width="34"><img src="images/print_1.gif" width="34" height="34"></td>
					<td width="222"><font color="#CC6600">本報表採用A3紙張<%=(setLandscape==true?"橫":"直")%>印</font></td>                              
				</tr>
			</table>
		</div>
	</td>
</tr>  
</table>
</form>
</BODY>
</html>
