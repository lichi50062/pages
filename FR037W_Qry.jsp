<%
// 95.04.24 add 農(漁)會信用部逾期放款統計表(A06) by 2295
// 97.11.06 add 總表(A04) by 2295
// 99.04.27  fix 縣市合併問題 by 2808
// 99.11.10 機構單位排序 fix by 2808
//100.05.04 fix 無法顯示漁會機構名稱/區分全體農/漁會信用部 by 2295	
//100.06.24 fix 機構排列順序,按照直轄市在前.其他縣市在後排序 by 2295
//101.08.20 fix 拿掉檢視報表 by 2295
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Properties" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/bank_no_hsien_id.include" %>
<%
	showCancel_No=true;//顯示營運中/裁撤別
	showBankType=false;//顯示金融機構類別
	showCityType=false;//顯示縣市別
	showUnit=false;//顯示金額單位
	showPageSetting=true;//顯示報表列印格式
	setLandscape=true;//true:橫印
	String report_no = "FR037W";
    Map dataMap =Utility.saveSearchParameter(request);
	String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR")) ;		
	String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH")) ;	    
    
	//add 營運中/已裁撤===================================================================================
	String cancel_no = ( session.getAttribute("CANCEL_NO")==null ) ? "N" : (String)session.getAttribute("CANCEL_NO");				
	//========================================================================================================
	String bank_type = Utility.getTrimString(dataMap.get("bank_type")) ;	
	String bankType = bank_type ;
	String bank_code = (session.getAttribute("tbank_no")==null)?"":(String)session.getAttribute("tbank_no");
	String title=(bank_type.equals("6"))?"農會":"漁會";
	
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");
	if(tBankList==null) {
    	//tBankList =Utility.getBankList(request) ; 
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
<script language="javascript" src="js/FR037W.js"></script>
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
   //alert(this.document.forms[0].BankListSrc.value);
   this.document.forms[0].action = "/pages/FR037W_Excel.jsp?act="+cnd+"&bank_type="+bank_type;	
   this.document.forms[0].target = '_self';
   this.document.forms[0].submit();   
}

function checkflag(){
   if(this.document.forms[0].rptStyle.value == '0'){//總表
      this.document.forms[0].BankListSrc.disabled = true;
   }else if(this.document.forms[0].rptStyle.value == '1'){//明細表
      this.document.forms[0].BankListSrc.disabled = false;
   }
}
function changeTbank(xml) {
	var form = this.document.forms[0];
	var myXML,nodeType,nodeValue, nodeName,nodeCity,nodeYear;
    var oOption;   
    var target = document.getElementById("BankListSrc");
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
	
	var typeName="農漁會";
	if(type=="6"){
		typeName="農會"
	}else if(type=="7"){
		typeName="漁會"
	}
	oOption = document.createElement("OPTION");
	oOption.text="全體"+typeName+"信用部";
	oOption.value="ALL/全體"+typeName+"信用部";
	target.add(oOption);
	
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
	//removeBankOption() ;
	//100.05.04 fix 區分全體農/漁會信用部
	/*if(this.document.forms[0].bank_type.value == '6'){
		$('select[@name=BankListSrc]').prepend("<option value='ALL/全體農會信用部'>全體農會信用部</option>") ;
		$('select[@name=BankListSrc] > option[@value=ALL/全體農會信用部]').attr('selected',true) ;
	}else{
		$('select[@name=BankListSrc]').prepend("<option value='ALL/全體漁會信用部'>全體漁會信用部</option>") ;
		$('select[@name=BankListSrc] > option[@value=ALL/全體漁會信用部]').attr('selected',true) ;            
	}*/
}
/*
function removeBankOption() {
	var year = $('input[@name=S_YEAR]').val()==''? 99 : eval($('input[@name=S_YEAR]').val() ) ;
	syear = '' ;
	if(year > 99) {
		syear = '100' ;
	}else {
		syear = '99' ;
	}
	$('select[@name=BankListSrc] > option').each(function(){
		if($(this).attr('year')!=syear) {
			$(this).remove() ;
		}
	});

}*/
function changeCity(xml, target, source, form) {} //共用畫面會呼叫到的物件
//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#' name='BankListfrm'>
<form method=post action='#'>
<input type='hidden' name="showTbank" value='<%=showBankType %>'>
<input type='hidden' name="showCityType" value='<%=showCityType%>'>
<input type="hidden" name="showCancel_No" value='<%=showCancel_No %>'>
<input type='hidden' name="bank_type" value="<%=bank_type %>"/>
<table width='600' border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
    <td width="50%"><font color='#000000' size=4><center><%=title%>信用部逾期放款統計表</center></font></td>
    <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
  </tr>
</table>
<Table border=1 width='600' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody" bgcolor="#BDDE9C">
    <td colspan="2" height="1">
      <div align="right">
       <!--input type='radio' name="excelaction" value='view' <%if(szExcelAction.equals("view")){out.print("checked");}%> >檢視報表 -->
       <input type='radio' name="excelaction" value='download' <%if(szExcelAction.equals("download")){out.print("checked");}%> >下載報表
       <a href="javascript:doSubmit('createRpt','<%=bank_type%>');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image41','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image41" width="66" height="25" border="0" id="Image41"></a> 
       <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a>
       <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a>
      </div>
    </td>
</tr>
<tr class="sbody">
     <td width="118" bgcolor="#BDDE9C" height="1">報表格式 :</td>
      <td width="416" bgcolor="#EBF4E1" height="1">
            <select size="1" name="rptStyle" onChange="checkflag()">
              <option value ='0' selected>總表</option>
              <option value ='1'>明細表</option>                            
            </select>
	   </td>
</tr>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">查詢日期</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type="text" name="S_YEAR" size="3" maxlength="3" value="<%=YEAR%>"
    	onChange="changeTbank('TBankXML');" >
      年      
    <select id="hide1" name=S_MONTH>        						
     <%
     	for (int j = 1; j <= 12; j++) {
     	if (j < 10){%>        	
     	<option value=0<%=j%> <%if(String.valueOf(Integer.parseInt(MONTH)).equals(String.valueOf(j))) out.print("selected");%>>0<%=j%></option>        		
     	<%}else{%>
     	<option value=<%=j%> <%if(String.valueOf(Integer.parseInt(MONTH)).equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
     	<%}%>
     <%}%>
     </select><font color='#000000'>月</font>
    </td>
</tr>
<%if(showCancel_No){%>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">營運中/裁撤別</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
     <select name='CANCEL_NO' onChange="changeTbank('TBankXML');">
     	<option  value="N" <%if((!cancel_no.equals("")) && cancel_no.equals("N")) out.print("selected");%>>營運中</option>
     	<option  value="Y" <%if((!cancel_no.equals("")) && cancel_no.equals("Y")) out.print("selected");%>>已裁撤</option>
     </select>
    </td>
</tr>
<%}%>
<%if(showBankType){%>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">金融機構類別</td>
<td width="416" bgcolor="#EBF4E1" height="1">  
  <select size="1" name="bankType" onChange="checkCity();resetOption();changeTbank('TBankXML', form.tbank, form.cityType, form)">
  <%if(bankType.equals("6")){//有農會的menu時,才可顯示農會%>
  <option value ='6' <%if((!bankType.equals("")) && bankType.equals("6")) out.print("selected");%>>農會</option>                                                            
  <%}%>
  <%if(bankType.equals("7")){//有漁會的menu時,才可顯示漁會%>
  <option value ='7' <%if((!bankType.equals("")) && bankType.equals("7")) out.print("selected");%>>漁會</option>                              
  <%}%> 
  </select>
</td>
</tr>
<%}else{%>
	<input type='hidden' name="bankType" value='<%=Utility.getTrimString(dataMap.get("bank_type")) %>'>
<%}%>
<%if(showCityType){%>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">縣市別</td>
<td width="416" bgcolor="#EBF4E1" height="1">
  <select size="1" name="cityType" onChange="changeTbank('TBankXML', form.tbank, form.cityType, form)" >
  </select>
  &nbsp;&nbsp;&nbsp;&nbsp;
  </td>
</tr>
<%}%>
<%if(showUnit){%>
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
<%}%>  
<tr class="sbody">
	<td width="118" bgcolor="#BDDE9C" height="1">機構單位 :</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
		<select id='BankListSrc' name='BankListSrc'/>
    </td>
</tr>
<%@include file="./include/DS_Unit2.include" %>
<%@include file="./include/rpt_style.include" %><!--報表格式挑選-->
<table border="1" width="600" align="center" height="54" bgcolor="#FFFFF" bordercolor="#76C657">
  <tr>
  	<td bgcolor="#E9F4E3" colspan="2">
       <div align="center">
  		<table width="574" border="0" cellpadding="1" cellspacing="1">
  		<tr><td width="34"><img src="/pages/images/print_1.gif" width="34" height="34"></td>
            <td width="492"><font color="#CC6600">本報表採用A4紙張橫印</font></td>                              
        </tr>
        </table>
        </div>
    </td>
  </tr>  
</table> 
</Table>

<!-- ======================= -->

</form>
<script language="JavaScript" >
<!--
changeTbank("TBankXML") ;

checkflag() ;

-->
</script>
</body>
</html>
