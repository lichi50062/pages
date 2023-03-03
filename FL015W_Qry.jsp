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
	String report_no = "FL015W";
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
<script language="javascript" src="js/PopupCal.js"></script><!-- 日期檢核 -->

<link href="css/b51.css" rel="stylesheet" type="text/css">

<html>
<head>
<script language="JavaScript" type="text/JavaScript">

function doSubmit(){   
	var f = document.forms[0] ; 
	f.begDate.value = "" ;
	f.endDate.value = "" ;
	if(f.begY.value!="") {
		if(!mergeCheckedDate("begY;begM;begD","begDate")) {
			f.begY.focus() ;
			return false ;
		}
		if(f.endY.value==""||f.endM.value==""||f.endD.value=="") {
			alert("請輸入發文日期迄日");
			f.endY.focus() ;
			return false ;
		}
	}
	if(f.endY.value!="") {
		if(!mergeCheckedDate("endY;endM;endD","endDate")) {
			f.endY.focus() ;
			return false ;
		}
	}
	this.document.forms[0].action = "/pages/FL015W_Excel.jsp?act=download";	
    this.document.forms[0].target = '_self';
    this.document.forms[0].submit();  
}
function MM_swapImgRestore() { //v3.0
	  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}

	function MM_preloadImages() { //v3.0
	  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
	    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
	    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
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
</script>

</head>

<body bgColor=#FFFFFF leftmargin="0" topmargin="0">
<form name='form' method=post action='#'>
<input type='hidden' name='begDate'>
<input type='hidden' name='endDate'>
<input type=hidden name="bank_type" value="ALL">
<input type='hidden' name="showTbank" value='false'>

<table width='600' border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr>
    <td width="15%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
    <td width="70%"><font color='#000000' size=4><b><center>政策性農業專案貸款糾正及罰鍰處分一覽表</center></b></font></td>
    <td width="15%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
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
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">發文日期</td>
    <td bgcolor="#EBF4E1" height="1">
    	<input type='text' name='begY' value="" size='3' maxlength='3' onblur='CheckYear(this)' >    
    	<font color='#000000'>年
    		
    	<select id="hide3" name=begM>
    		<option></option>
    	<% for (int j = 1; j <= 12; j++) {
    		if (j < 10){ %>        	
    		<option value=0<%=j%>>0<%=j%></option>        		
    	<%  }else{ %>
    		<option value=<%=j%> ><%=j%></option>
    	<%  } %>
        <%}%>
    	</select>月
    	
    	<select id="hide4" name=begD>
    	<option></option>
    	<% for (int j = 1; j < 32; j++) {
    	   if (j < 10){ %>        	
    	   <option value=0<%=j%> >0<%=j%></option>        		
    	<% } else {%>
    	   <option value=<%=j%> ><%=j%></option>
    	<% }%>
    <%}%>
    	 </select>日</font>
    	<button name='button1' onclick="popupCal('form','begY,begM,begD','BTN_date_1',event); return false;">
			<img align="absmiddle" border='0' name='BTN_date_1' src='images/clander.gif'>
		</button>
                    ～
    	<input type='text' name='endY' value="" size='3' maxlength='3' onblur='CheckYear(this)'>
    	<font color='#000000'>年
    	<select id="hide5" name=endM>
    	<option></option>
	    <%
	    	for (int j = 1; j <= 12; j++) {
	    	if (j < 10){%>        	
	    	<option value=0<%=j%>>0<%=j%></option>        		
	    	<%}else{%>
	    	<option value=<%=j%>><%=j%></option>
	    	<%}%>
	    <%}%>
    	</select>月
    	<select id="hide6" name=endD>
    		<option></option>
	    <%
	    	for (int j = 1; j < 32; j++) {
	    	if (j < 10){%>        	
	    	<option value=0<%=j%>>0<%=j%></option>        		
	    	<%}else{%>
	    	<option value=<%=j%> ><%=j%></option>
	    	<%}%>
	    <%}%>
    	</select>日</font>
    	<button name='button2' onclick="popupCal('form','endY,endM,endD','BTN_date_2',event); return false;">
			<img align="absmiddle" border='0' name='BTN_date_2' src='images/clander.gif'>
		</button>
</tr>
<%@include file="./include/rpt_style.include" %><!--報表格式挑選--> 
<%@include file="./include/pageSetting.include" %><!--顯示本報表採用A4紙張直印/橫印 -->
</table>

</form>
</body>
</html>
