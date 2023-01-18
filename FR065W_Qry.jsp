<%
//102.07.03 created by 2968
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@include file="./include/bank_no_hsien_id.include" %>

<%
	// 查詢條件值 
    Map dataMap =Utility.saveSearchParameter(request);
	String report_no = "FR065W";
	showCancel_No=false;//顯示營運中/裁撤別
	showBankType=false;//顯示金融機構類別
    showCityType=false;//顯示縣市別
    showUnit=false;//顯示金額單位
    showPageSetting=true;//顯示本報表採用A4紙張直印/橫印 
	setLandscape=false;//true:橫印
    String cancel_no = "N";
	String act = Utility.getTrimString(dataMap.get("act"));
	String bank_type = Utility.getTrimString(dataMap.get("bank_type"));	
	String bankType = bank_type;//ym_hsien_id_unit.include用
    String title = "N年內及目前月份逾放比家數統計";
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}

function doSubmit(){ 
	if(this.document.forms[0].S_YEAR1.value==""){
		alert("請輸入N年內");
		return;
	}else if(this.document.forms[0].S_YEAR4.value=="" ||
			 this.document.forms[0].S_YEAR3.value=="" ||
			 this.document.forms[0].S_YEAR2.value=="" ||
			 this.document.forms[0].S_YEAR0.value=="" ){
		alert("請輸入逾放比率區間");
		return;
	}else{
		this.document.forms[0].action = "/pages/FR065W_Excel.jsp";	
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
    <td width="60%"><font color='#000000' size=4><b><center><%=title %></center></b></font></td>
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
<%@include file="./include/ym_hsien_id_unit.include" %><!--顯示查詢日期/金融機構類別/縣市別-->

<tr>
<td width="118" bgcolor="#BDDE9C" height="1" class="sbody">農(漁)會別</td>
	<td width="416" bgcolor="#EBF4E1" height="1">
		<select name=bank_type>        						
     	<option value='6'>農會</option>        		
     	<option value='7'>漁會</option>
     	<option value='ALL'>農漁會</option>
     </select>
	</td>
</tr>
<tr>
<td width="118" bgcolor="#BDDE9C" height="1" class="sbody">N年內</td>
<td width="416" bgcolor="#EBF4E1" height="1">
   &nbsp;<input type="text" name="S_YEAR1" size="7" maxlength="3" onkeypress="event.returnValue=IsNum()"></td>
</tr>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1" class="sbody">逾放比率區間</td>
<td width="416" bgcolor="#EBF4E1" height="1">
   <input type="text" name="S_YEAR4" size="7" maxlength="3" onkeypress="event.returnValue=IsNum()" value='2'>% ≦ 
   <input type="text" name="S_YEAR3" size="7" maxlength="3" onkeypress="event.returnValue=IsNum()" value='10'>% ≦ &nbsp;
   <input type="text" name="S_YEAR2" size="7" maxlength="3" onkeypress="event.returnValue=IsNum()" value='15'>% ≦ 
   <input type="text" name="S_YEAR0" size="7" maxlength="3" onkeypress="event.returnValue=IsNum()" value='30'>%</td>
</tr>
<%@include file="./include/rpt_style.include" %><!--報表格式挑選-->
</table>
<table border="1" width="600" align="center" height="54" bgcolor="#FFFFF" bordercolor="#76C657">
  <tr>
  	<td bgcolor="#E9F4E3" colspan="2">
       <div align="center">
  		<table width="555" border="0" cellpadding="1" cellspacing="1">
  		<tr><font color="#CC6600">
  		使用說明：<br>
  		逾放比≦A%<br>
  		A%＜逾放比≦B%<br>
  		B%＜逾放比≦C%<br>
  		C%＜逾放比≦D%<br>
  		逾放比＞D%<br>
  		其中A＜B＜C＜D<br>
  		(預設值 A=2 B=10 C=15 D=30)<br>
  		請輸入 A B C D</font>                              
        </tr>
        </table>
        </div>
    </td>
  </tr> 
<%@include file="./include/pageSetting.include" %><!--顯示本報表採用A4紙張直印/橫印 -->
</table>
</form>
</BODY>
</html>