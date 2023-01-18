<%
//common:
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>

<%-- <%@include file="./include/bank_no_hsien_id.include" %> --%>
<%
boolean showCancel_No=false;//顯示營運中/裁撤別
boolean showBankType=true;//顯示金融機構類別
boolean showCityType=true;//顯示縣市別
boolean showUnit=false;//顯示金額單位
boolean showPageSetting=true;//顯示報表列印格式
boolean setLandscape=true;//true:橫印
	// 查詢條件值 
    Map dataMap =Utility.saveSearchParameter(request);
	String report_no = "FL017W";
	
	List tBankList = (List)request.getAttribute("TBank");
    // XML Ducument for 總機構代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"TBankXML\">");
    out.println("<datalist>");
    for(int i=0;i< tBankList.size(); i++) {
        DataObject bean =(DataObject)tBankList.get(i);
        out.println("<data>");
        out.println("<bankType>"+bean.getValue("bank_type")+"</bankType>");
        out.println("<bankCity>"+bean.getValue("hsien_id")+"</bankCity>");
        out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");
        out.println("<bankName>"+bean.getValue("bank_no")+"  "+bean.getValue("bank_name")+"</bankName>");
        out.println("<m_year>"+bean.getValue("m_year").toString()+"</m_year>") ;
        out.println("</data>");
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 總機構代碼 end 

    List cityList = (List)request.getAttribute("City");
	if(cityList!=null) {
		// XML Ducument for 縣市別 begin
	    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"CityXML\">");
	    out.println("<datalist>");
	    for(int i=0;i< cityList.size(); i++) {
	    	DataObject bean =(DataObject)cityList.get(i);
	        out.println("<data>");
	        out.println("<cityType>"+bean.getValue("hsien_id")+"</cityType>");
	        out.println("<cityName>"+bean.getValue("hsien_name")+"</cityName>");
	        out.println("<cityValue>"+bean.getValue("hsien_id")+"</cityValue>");
	        out.println("<cityYear>"+bean.getValue("m_year").toString()+"</cityYear>");
	        out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	    // XML Ducument for 縣市別 end
    }
 	/* List qLs = (List)request.getAttribute("queryCondition") ;
	if(qLs != null) {
		out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"VQ1_XML\">");
	    out.println("<datalist>");
	    for(int i=0;i< qLs.size(); i++) {
	    	DataObject bean =(DataObject)qLs.get(i);
	    	out.println("<data>");
	    	out.println("<ex_type>"+bean.getValue("ex_type")+"</ex_type>");
	    	out.println("<ex_no>"+bean.getValue("ex_no")+"</ex_no>");
	    	out.println("<ex_no_list>"+bean.getValue("ex_no_list")+"</ex_no_list>");
	    	out.println("<bank_no>"+bean.getValue("bank_no")+"</bank_no>");
	    	out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	} */
	
	List qLs2 = (List)request.getAttribute("queryCondition2") ;
	if(qLs2 != null) {
		out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"VQ2_XML\">");
	    out.println("<datalist>");
	    for(int i=0;i< qLs2.size(); i++) {
	    	DataObject bean =(DataObject)qLs2.get(i);
	    	out.println("<data>");
	    	out.println("<loan_item_name>"+bean.getValue("loan_item_name")+"</loan_item_name>");
	    	out.println("<loan_item>"+bean.getValue("loan_item")+"</loan_item>");
	    	out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	}
	List qLs3 = (List)request.getAttribute("queryCondition3") ;
	if(qLs3 != null) {
		out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"VQ3_XML\">");
	    out.println("<datalist>");
	    for(int i=0;i< qLs3.size(); i++) {
	    	DataObject bean =(DataObject)qLs3.get(i);
	    	out.println("<data>");
	    	out.println("<cmuse_id>"+bean.getValue("cmuse_id")+"</cmuse_id>");
	    	out.println("<cmuse_name>"+bean.getValue("cmuse_name")+"</cmuse_name>");
	    	out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	}
%>

<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/PopupCal.js"></script><!-- 日期檢核 -->

<link href="css/b51.css" rel="stylesheet" type="text/css">

<html>
<head>
<script language="JavaScript" type="text/JavaScript">

function doSubmit(){   
	var f = document.forms[0] ; 
	f.ex_no.value = "" ;
	if(f.stat_tp[0].checked && f.tbank.value=="" ){
		alert("請選擇受檢單位");
		return ;
	} else if(f.stat_tp[0].checked) {
		f.ui_val.value = f.tbank.options[f.tbank.selectedIndex].text ;
		f.query_val.value = f.tbank.value ;
	}
	if(f.stat_tp[1].checked && f.q_sel2.value=="" ){
		alert("請選擇貸款種類");
		return ;
	} else if(f.stat_tp[1].checked) {
		f.ui_val.value = f.q_sel2.options[f.q_sel2.selectedIndex].text ;
		f.query_val.value = f.q_sel2.value ;
	}
	if(f.stat_tp[2].checked && f.q_sel3.value=="" ){
		alert("請選缺失態樣");
		return ;
	} else if(f.stat_tp[2].checked) {
		f.ui_val.value = f.q_sel3.options[f.q_sel3.selectedIndex].text ;
		f.query_val.value = f.q_sel3.value ;
	}
	if(f.stat_tp[3].checked ){
		for(p=0 ; p< f.ex_Type.length ; p++) {
			if(f.ex_Type[p].checked) {
				f.ui_val.value = f.ex_Type[p].nickNm ;
				f.query_val.value  = f.ex_Type[p].value ;
			}
		}
	} 
	 
	f.begDate.value = "" ;
	f.endDate.value = "" ;
	if(f.begY.value!="") {
		if(!mergeCheckedDate("begY;begM;begD","begDate")) {
			f.begY.focus() ;
			return false ;
		}
		if(f.endY.value==""||f.endM.value==""||f.endD.value=="") {
			alert("請輸入繳還日期迄日");
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
	
	this.document.forms[0].action = "/pages/FL017W_Excel.jsp?act=download";	
    this.document.forms[0].target = '_self';
    this.document.forms[0].submit();  
}
//組金融機構畫面
function changeTbank(xml,year) {
	var form = document.forms[0];
	var myXML,nodeValue, nodeName,nodeYear,nodeType,nodeCity;
	//1.取得畫面年分 
	//var begY = year.value=='' ? 0 : eval(year.value) ;
	Myear = '100' ;//預設年分100年
	//if(begY<=99) {
		//Myear = '99' ;
	//}
	//2.讀cityXml
	myXML = document.all(xml).XMLDocument;
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");
	nodeYear = myXML.getElementsByTagName("m_year");
	nodeType = myXML.getElementsByTagName("bankType") ;
	nodeCity = myXML.getElementsByTagName("bankCity") ;
	//3.取得 城市代號
	citycode = form.cityType.value ;
	//4.取得金融機構類別
	bankType = form.bankType.value ;
	//5.移除已搬入的資料
	var target = document.getElementById("tbank");
	target.length = 0;
	
	var oOption = document.createElement("OPTION");
	oOption.text="請選擇...";
	oOption.value="";
	target.add(oOption);
	
	for(var i=0;i<nodeName.length ;i++)	{
		if((citycode==''||nodeCity.item(i).firstChild.nodeValue== citycode) 
				&& nodeYear.item(i).firstChild.nodeValue==Myear
				&& nodeType.item(i).firstChild.nodeValue==bankType) {
			oOption = document.createElement("OPTION");
       	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
	        oOption.value=nodeValue.item(i).firstChild.nodeValue;  
	        target.add(oOption);
		}
	}
}
//組縣市別============
function changeCity(xml,year) {
	var form = document.forms[0];
	var citySeld = form.cityType.value; //已選擇的
	var myXML,nodeValue, nodeName,nodeYear;
	//1.取得畫面年分 
	//var begY = year.value=='' ? 0 : eval(year.value) ;
	Myear = '100' ;//預設年分100年
	//if(begY<=99) {
		//Myear = '99' ;
	//}
	//2.讀cityXml
	myXML = document.all(xml).XMLDocument;
	nodeValue = myXML.getElementsByTagName("cityValue");
	nodeName = myXML.getElementsByTagName("cityName");
	nodeYear = myXML.getElementsByTagName("cityYear");
	//3.移除已搬入的資料
	var target = document.getElementById("cityType");
	target.length = 0;
	
	var oOption = document.createElement("OPTION");
	oOption.text="全部";
	oOption.value="";
	target.add(oOption);
	
	//4.判斷縣市年分組選單
	for(var i=0;i<nodeName.length ;i++)	{
		if(nodeYear.item(i).firstChild.nodeValue==Myear) {
			oOption = document.createElement("OPTION");
       	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
	        oOption.value=nodeValue.item(i).firstChild.nodeValue;  
	        target.add(oOption);
		}
	}
	setSelect(form.cityType,citySeld);
}

<%//貸款種類%>
function chg_query2 (xml) {
	
	var f = document.forms[0];
	var tbankSel = f.tbank.value; //已選擇的
	var myXML,nodeValue, nodeName,nodeType;
	
	//2.讀cityXml
	myXML = document.all(xml).XMLDocument;
	//nodeType = myXML.getElementsByTagName("ex_type");
	nodeValue = myXML.getElementsByTagName("loan_item");
	nodeName = myXML.getElementsByTagName("loan_item_name");
	//nodeKey = myXML.getElementsByTagName("bank_no");
	//3.移除已搬入的資料
	var target = document.getElementById("q_sel2");
	target.length = 0;
	
	var oOption = document.createElement("OPTION");
	oOption.text="請選擇..";
	oOption.value="";
	target.add(oOption);
	
	//4.
	for(var i=0;i<nodeName.length ;i++)	{
		//if(nodeType.item(i).firstChild.nodeValue=="AGRI") {
			//if(tbankSel!='' && nodeKey.item(i).firstChild.nodeValue!=tbankSel) {
			//	continue;
			//}
			oOption = document.createElement("OPTION");
       	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
	        oOption.value=nodeValue.item(i).firstChild.nodeValue;  
	        target.add(oOption);
		//}
	}	
}
function chg_query3 (xml) {
	var f = document.forms[0];
	var tbankSel = f.tbank.value; //已選擇的
	var myXML,nodeValue, nodeName,nodeType;
	//
	myXML = document.all(xml).XMLDocument;
	//nodeType = myXML.getElementsByTagName("ex_type");
	nodeValue = myXML.getElementsByTagName("cmuse_id");
	nodeName = myXML.getElementsByTagName("cmuse_name");
	//nodeKey = myXML.getElementsByTagName("bank_no");
	//移除已搬入的資料
	var target = document.getElementById("q_sel3");
	target.length = 0;
	
	var oOption = document.createElement("OPTION");
	oOption.text="請選擇...";
	oOption.value="";
	target.add(oOption);
	
	//4.
	for(var i=0;i<nodeName.length ;i++)	{
		//if(nodeType.item(i).firstChild.nodeValue=="BOAF") {
			//if(tbankSel!='' && nodeKey.item(i).firstChild.nodeValue!=tbankSel) {
			//	continue;
			//}
			oOption = document.createElement("OPTION");
       	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
	        oOption.value=nodeValue.item(i).firstChild.nodeValue;  
	        target.add(oOption);
		//}
	}	
}
function ctrl_view (v) {
	var c1 = document.getElementById("condition_1") ;
	var c2 = document.getElementById("condition_2") ;
	var c3 = document.getElementById("condition_3") ;
	var c4 = document.getElementById("condition_4") ;
	var c5 = document.getElementById("condition_5") ;
	switch(v) {
	case '1':
		c1.style.display = "";
		c2.style.display = "" ;
		c3.style.display = "none" ;
		c4.style.display = "none" ;
		c5.style.display = "none" ;
		break ;
	case '2':
		c1.style.display = "none";
		c2.style.display = "none" ;
		c3.style.display = "" ;
		c4.style.display = "none" ;
		c5.style.display = "none" ;
		break ;
	case '3':
		c1.style.display = "none";
		c2.style.display = "none" ;
		c3.style.display = "none" ;
		c4.style.display = "" ;
		c5.style.display = "none" ;
		break ;
	case '4' :
		c1.style.display = "none";
		c2.style.display = "none" ;
		c3.style.display = "none" ;
		c4.style.display = "none" ;
		c5.style.display = "" ;
		break ;
	}
	
}
 

function setSelect(S1, bankid) {
    if(S1 == null)
    	return;
    for(i=0;i<S1.length;i++) {
      	if(S1.options[i].value==bankid)    	{
        	S1.options[i].selected=true;
        	break;
    	}
    }
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
<input type='hidden' name="bank_type" value="ALL">
<input type='hidden' name="showTbank" value='false'>
<input type='hidden' name='ex_type_ui'>
<input type='hidden' name='tbank_ui'>
<input type='hidden' name='ex_no'>
<input type='hidden' name='query_val'>
<input type='hidden' name='ui_val'>

<table width='600' border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr>
    <td width="20%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
    <td width="60%"><font color='#000000' size=4><b><center>收回補貼息案件明細表分類統計</center></b></font></td>
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
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">繳還日期</td>
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
    	<button name='button1' onClick="popupCal('form','begY,begM,begD','BTN_date_1',event)">
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
    	<button name='button2' onClick="popupCal('form','endY,endM,endD','BTN_date_2',event)">
			<img align="absmiddle" border='0' name='BTN_date_2' src='images/clander.gif'>
		</button>
</tr>

<tr class="sbody">
<td width="15%" bgcolor="#BDDE9C" height="1">統計分類</td>
<td width='85%'bgcolor="#EBF4E1" height="1">
   <input type='radio' name='stat_tp' value='1' onClick="ctrl_view(this.value)" checked>農漁會別
   <input type='radio' name='stat_tp' value='2' onClick="ctrl_view(this.value)">貸款種類&nbsp;
   <input type='radio' name='stat_tp' value='3' onClick="ctrl_view(this.value)">缺失態樣&nbsp;
   <input type='radio' name='stat_tp' value='4' onClick="ctrl_view(this.value)">查核類別&nbsp;
 
  </td>
</tr>
<tr class="sbody" id='condition_1'>
<td width="15%" bgcolor="#BDDE9C" height="1">農漁會別</td>
<td width='85%'bgcolor="#EBF4E1" height="1">
   <select size="1" name="bankType" onChange="changeTbank('TBankXML','')">
     <option value="6">農會</option>
     <option value="7">漁會</option>
  </select>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  縣市別:&nbsp;&nbsp;
   <select size="1" name="cityType" onChange="changeTbank('TBankXML','')" >
   </select>
  </td>
</tr>

<tr class="sbody" id='condition_2'>
	<td width='15%' bgcolor="#BDDE9C" height="1">受檢單位</td>
	<td width='85%' bgcolor="#EBF4E1" height="1">           
	  <select size="1" name="tbank" onChange="setQuery2()">
	    <option value="" >請選擇</option>
	  </select> 
	</td>
</tr>


<tr class="sbody" id='condition_3'>
	<td width='15%' bgcolor="#BDDE9C" height="1">貸款種類</td>
	<td width='85%' bgcolor="#EBF4E1" height="1">           
	  <select size="1" name="q_sel2" onChange="">
	    <option value="" >請選擇</option>
	  </select> 
	</td>
</tr>

<tr class="sbody" id='condition_4'>
	<td width='15%' bgcolor="#BDDE9C" height="1">缺失態樣</td>
	<td width='85%' bgcolor="#EBF4E1" height="1">           
	  <select size="1" name="q_sel3" onChange="">
	    <option value="" >請選擇</option>
	  </select> 
	</td>
</tr>


<tr class="sbody" id='condition_5'>
	<td width='15%' bgcolor="#BDDE9C" height="1">查核類別</td>
	<td width='85%' bgcolor="#EBF4E1" height="1">
	  <input type='radio' name='ex_Type' value='FEB' checked nickNm='金管會檢查報告'>金管會檢查報告&nbsp;
	  <input type='radio' name='ex_Type' value='AGRI' nickNm='農業金庫查核'>農業金庫查核&nbsp;
	  <input type='radio' name='ex_Type' value='BOAF' nickNm='農金局訪查'>農金局訪查&nbsp;
		      
	 </td>
</tr>
<%@include file="./include/rpt_style.include" %><!--報表格式挑選-->
<%@include file="./include/pageSetting.include" %><!--顯示本報表採用A4紙張直印/橫印 -->
</table>

</form>
</body>
</html>
<script>
changeCity("CityXML",'') ;
changeTbank("TBankXML",'');
chg_query2 ("VQ2_XML") ;
chg_query3 ("VQ3_XML") ;
ctrl_view ('1') ;
</script>