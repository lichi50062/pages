﻿<%
// 97.06.18 create 應予評估資產彙總表
// 99.05.12 fix 縣市合併問題 by 2808
// 99.11.10 機構單位排序 & js錯誤fix by 2808	
//100.02.12 fix 只顯示下載報表 by 2295
//100.06.24 fix 機構排列順序,按照直轄市在前.其他縣市在後排序 by 2295
//108.05.09 add 報表格式挑選 by 2295
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
<%@ page import="java.util.*" %>
<%@include file="./include/bank_no_hsien_id.include" %>
<%
	String report_no = "FR047W" ;
	showCancel_No=false;//顯示營運中/裁撤別
	showBankType=false;//顯示金融機構類別
	showCityType=false;//顯示縣市別
	showUnit=false;//顯示金額單位
	showPageSetting=true;//顯示報表列印格式
	setLandscape=false;//true:橫印
	Map dataMap =Utility.saveSearchParameter(request);
	
    
	if(MONTH.equals("1")){//若本月為1月份是..則是申報上個年度的12月份
       YEAR = String.valueOf(Integer.parseInt(YEAR) - 1);
       MONTH = "12";
    }
   	String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");			    	
 	String title=(bank_type.equals("6"))?"農會":"漁會";
 	String bankType = bank_type ;    
    String cancel_no  = "" ;
    if(tBankList==null) {
        System.out.println("tBankList==null");
        session.setAttribute("nowbank_type",bank_type);//100.06.24
    	tBankList = Utility.getBankList(request) ;//100.06.24按照直轄市在前.其他縣市在後排序.    	
    	 // XML Ducument for 總機構代碼 begin
	    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"TBankXML\">");
	    out.println("<datalist>");
	    for(int i=0;i< tBankList.size(); i++) {
	        bean =(DataObject)tBankList.get(i);
	        out.println("<data>");
	        out.println("<bankType>"+bean.getValue("bank_type")+"</bankType>");
	        out.println("<BnType>"+bean.getValue("bn_type")+"</BnType>");
	        out.println("<bankYear>"+bean.getValue("m_year").toString()+"</bankYear>");
	        out.println("<bankCity>"+bean.getValue("hsien_id")+"</bankCity>");
	        out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");
	        out.println("<bankName>"+bean.getValue("bank_no")+"  "+bean.getValue("bank_name")+"</bankName>");
	        out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	    // XML Ducument for 總機構代碼 en
    }
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
	  var d = document ;
	  var i,x,a=d.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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
function doSubmit(form){ 
   var tmp_year,tmp_month;
   tmp_year = parseInt(form.S_YEAR.value);
   tmp_month = parseInt(form.S_MONTH.value);
   if( tmp_year * 100 + tmp_month < 9406){
      alert('94年6月起開始受理申報資料');
      return;
   } 
    	 
   if(confirm("本項報表會報行10-15秒，是否確定執行？")){
   		form.action = "/pages/FR047W_Excel.jsp";	
   		form.target = '_self';
   		form.submit();   
   }
   
}
function changeTbank(xml) {
	var myXML,nodeType,nodeValue, nodeName,nodeCity,nodeYear;
    var oOption;    
    var target = document.getElementById("BANK_NO");
    var type = '<%=bankType%>';
   	var m_year = form.S_YEAR.value;
   	target.length = 0;
    if(m_year >= 100){
       m_year = 100;
    }else{
       m_year = 99;
    }
   	
    myXML = document.all(xml).XMLDocument;
    nodeType = myXML.getElementsByTagName("bankType");//bank_type農/漁會
    nodeCity = myXML.getElementsByTagName("bankCity");//hsien_id縣市別
	nodeValue = myXML.getElementsByTagName("bankValue");//bank_no機構代號
	nodeName = myXML.getElementsByTagName("bankName");//bank_no+bank_name
	nodeYear = myXML.getElementsByTagName("bankYear");//m_year所屬年度
	BnType = myXML.getElementsByTagName("BnType");//bn_type營運中/已裁撤
	for(var i=0;i<nodeType.length ;i++)	{
		if(nodeYear.item(i).firstChild.nodeValue == m_year){
			 oOption = document.createElement("OPTION");
	    	 oOption.text=nodeName.item(i).firstChild.nodeValue;
	         oOption.value=nodeValue.item(i).firstChild.nodeValue;
	         target.add(oOption);
		}
	}
	target[0].selected=true;
}


function changeCity(xml, target, source, form) {} //共用畫面會呼叫到的物件
//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form name='form' method=post action='#'>
<input type='hidden' name="showTbank" value='<%=showBankType %>'>
<input type='hidden' name="showCityType" value='<%=showCityType%>'>
<input type="hidden" name="showCancel_No" value='<%=showCancel_No %>'>
<input type=hidden name="bank_type" value=<%=bank_type%>>
<table width='600' border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
    <td width="50%"><font color='#000000' size=4><center><%=title%>信用部應予評估資產彙總表</center></font></td>
    <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
  </tr>
</table>
<Table border=1 width='600' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody" bgcolor="#BDDE9C">
    <td colspan="2" height="1">
      <div align="right">
       <!--input type='radio' name="act" value='view' checked>檢視報表-->
       <input type='radio' name="act" value='download' checked> 下載報表
        <%if(Utility.getPermission(request,report_no,"P")){//Print %>  
        <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',0)"  onClick="doSubmit( this.document.forms[0])"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a>                  	        	                                   		     			        
        <%}%>
       
        <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a>
        <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a>
      </div>
    </td>
</tr>
<%//105.4.6 控制點不同，無法共用  ym_hsien_id_unit.include  by 2968%>
<%@include file="./include/ym_hsien_id_unit2.include" %><!--顯示查詢日期/金融機構類別/縣市別-->
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
</Table>

<!-- ================================================= -->

</form>
<script language="JavaScript" type="text/JavaScript">

changeTbank("TBankXML") ;


//removeBankOption();

</script>
</body>
</html>
