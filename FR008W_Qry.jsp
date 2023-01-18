<%
//94.03.10	增加營運中/裁撤別下拉選單處理 add by egg
// 94.09.05 fix 拿掉檢視報表 by 2295
// 99.05.12 fix 修改部分畫面改為共用 by 2808
// 99.11.09 fix 機構單位排序 by 2808 
//100.05.04 fix 無法顯示漁會機構名稱 by 2295
//100.06.24 fix 機構排列順序,按照直轄市在前.其他縣市在後排序 by 2295
//108.05.08 add 報表格式挑選 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="java.util.List" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>
<%@include file="./include/bank_no_hsien_id.include" %>
<%!
   private static String  report_no = "FR008W" ;
%>
<%     
    
	showCancel_No=true;//顯示營運中/裁撤別
	showBankType=false;//顯示金融機構類別
	showCityType=false;//顯示縣市別
	showUnit=false;//顯示金額單位
	showPageSetting=true;//顯示報表列印格式
	setLandscape=false;//true:橫印
	String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR")) ;		
	String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH")) ;			
	String bankType = Utility.getTrimString(dataMap.get("bankType"));
	String hasMonth = Utility.getTrimString(dataMap.get("hasMonth"));		
    String cancel_no = Utility.getTrimString(dataMap.get("CANCEL_NO")); 
    String bank_type = Utility.getTrimString(dataMap.get("bank_type")) ;
    if(tBankList==null) {
    	//tBankList = Utility.getBankList(request) ;//Utility.getALLTBank(bank_type) ;
    	//tBankList = Utility.getALLTBank(bank_type);//100.05.04
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

function doSubmit(cnd,bank_type){  
	var year = this.document.forms[0].S_YEAR.value == '' ? 0 :eval(this.document.forms[0].S_YEAR.value) ;
	var month  = this.document.forms[0].S_MONTH.value== '' ? 0 :eval (this.document.forms[0].S_MONTH.value) ;
	if(year <=94 && month <= 6) {
    //if(this.document.forms[0].S_YEAR.value <= "94" && this.document.forms[0].S_MONTH.value < "06"){
      alert('94年6月起開始受理申報資料');
      return;
    }
   this.document.forms[0].action = "/pages/FR008W_Excel.jsp?act="+cnd+"&bank_type="+bank_type;	
   this.document.forms[0].target = '_self';
   this.document.forms[0].submit();   
}

//94.03.10 add by egg
//重導FR008W_Qry.jsp頁面以致輸出對應之金融機構資料
function getData(form,item,bank_type){
	if(item == 'cancel_no'){
		//初始BANK_NO值
	   	form.BANK_NO.value="";
	}
	form.action="/pages/FR008W_Qry.jsp?act=getData&bank_type="+bank_type+"&test=nothing";
	form.submit();
}
function changeTbank(xml) {
	var myXML,nodeType,nodeValue, nodeName,nodeCity,nodeYear;
    var oOption; 
    var target = document.getElementById("BANK_NO");
    var type = form.bankType.value;
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
	/*
	var typeName="農漁會";
	if(type=="6"){
		typeName="農會"
	}else if(type=="7"){
		typeName="漁會"
	}
	oOption = document.createElement("OPTION");
	oOption.text="全體"+typeName+"信用部";
	oOption.value="ALL/全體"+typeName+"信用部";
	target.add(oOption);*/
	for(var i=0;i<nodeType.length ;i++)	{
		//無區分縣市別==============
	    //有區分營運中/已裁撤
	    if((nodeYear.item(i).firstChild.nodeValue == m_year) &&
  	       (nodeType.item(i).firstChild.nodeValue == type) )  {//相同年度.農/漁會  
		    if(form.CANCEL_NO.value == 'N'){//營運中				
		         if(BnType.item(i).firstChild.nodeValue != '2'){
		        	 oOption = document.createElement("OPTION");
		        	 oOption.text=nodeName.item(i).firstChild.nodeValue;
			         oOption.value=nodeValue.item(i).firstChild.nodeValue+"/"+nodeName.item(i).firstChild.nodeValue;  
			         target.add(oOption);
		         }		
	        }else{//已裁撤		    
	             if(BnType.item(i).firstChild.nodeValue == '2'){
	            	 oOption = document.createElement("OPTION");
	            	 oOption.text=nodeName.item(i).firstChild.nodeValue;
			         oOption.value=nodeValue.item(i).firstChild.nodeValue+"/"+nodeName.item(i).firstChild.nodeValue;
			         target.add(oOption);
		         }
	        }
		    
	    }
	}
	target[0].selected=true;
}
//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form name='form' method=post action='#'>
<input type='hidden' name="showTbank" value='<%=showBankType %>'>
<input type='hidden' name="showCityType" value='<%=showCityType%>'>
<input type="hidden" name="showCancel_No" value='<%=showCancel_No %>'>
<table width='600' border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
    <td width="50%"><font color='#000000' size=4><center>信用部淨值占風險性資產比率 </center></font></td>
    <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
  </tr>
</table>
<table border=1 width='600' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody" bgcolor="#BDDE9C">
    <td colspan="2" height="1">
      <div align="right">
       <input type='radio' name="excelaction" value='download' checked> 下載報表 
       <a href="javascript:doSubmit('createRpt','<%=bank_type%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a>
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
</table>
<!-- ---------------------------------------------------------------------- -->

</form>
<script language="JavaScript" type="text/JavaScript">

changeTbank("TBankXML") ;



//removeBankOption();

</script>
</body>
</html>
