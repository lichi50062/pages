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
	String report_no = "FL016W";
	
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
 	List qLs = (List)request.getAttribute("queryCondition") ;
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
	}
%>

<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/jquery-3.5.1.min.js"></script>
<link href="css/b51.css" rel="stylesheet" type="text/css">

<html>
<head>
<script language="JavaScript" type="text/JavaScript">

function doSubmit(){   
	var f = document.forms[0] ; 
	var ckFlg = true ;
	f.ex_no.value = "" ;
	if(f.tbank.value=="") {
		alert("請選擇受檢單位");
		ckFlg = false; 
		return ;
	} else {
		f.tbank_ui.value= f.tbank.options[f.tbank.selectedIndex].text;
	}
	if(f.ex_Type[0].checked && f.q_sel1.value=="") {
		alert("請選擇檢查報告編號!");
		ckFlg = false;
		return false ;
	} else if(f.ex_Type[0].checked){
		f.ex_no.value = f.q_sel1.value ;
		f.ui_value.value = f.q_sel1.options[f.q_sel1.selectedIndex].text;
	}
	
	if(f.ex_Type[1].checked && f.q_sel2.value=="") {
		alert("請選擇查核季別!");
		ckFlg = false;
		return false ;
	} else if(f.ex_Type[1].checked){
		f.ex_no.value = f.q_sel2.value ;
		f.ui_value.value = f.q_sel2.options[f.q_sel2.selectedIndex].text;
	}
	if(f.ex_Type[2].checked && f.q_sel3.value=="") {
		alert("請選擇訪查日期!");
		ckFlg = false;
		return false ;
	} else if(f.ex_Type[2].checked){
		f.ex_no.value = f.q_sel3.value ;
		f.ui_value.value = f.q_sel3.options[f.q_sel3.selectedIndex].text;
	}
	if(ckFlg) {
		this.document.forms[0].action = "/pages/FL016W_Excel.jsp?act=download";	
    	this.document.forms[0].target = '_self';
    	this.document.forms[0].submit();
	}
}
//組金融機構畫面
function changeTbank(xml,year) {
	var form = document.form;
	//var myXML,nodeValue, nodeName,nodeYear,nodeType,nodeCity;
	//1.取得畫面年分
	var Myear = '100' ;//預設年分100年
	//3.取得 城市代號
	var citycode = form.cityType.value ;
	//4.取得金融機構類別
	var bankType = form.bankType.value ;

	var xmlDoc = $.parseXML($("xml[id=TBankXML]").html()) ;
	document.form.tbank.length = 0;
	var data = $(xmlDoc).find("data") ;
	var oOption = document.createElement("OPTION");
	oOption.text="全部";
	oOption.value="";
	document.form.tbank.add(oOption);

	$(data).each(function (i) {
		if((citycode==''|| $(this).find("bankcity").text()== citycode)
				&& $(this).find("m_year").text()==Myear
				&& $(this).find("banktype").text()==bankType) {
			oOption = document.createElement("OPTION");
			oOption.text= $(this).find("bankname").text();
			oOption.value=$(this).find("bankvalue").text();
			document.form.tbank.add(oOption);
		}
	})
	;
	chg_query1 ("VQ1_XML") ;
	chg_query2 ("VQ1_XML") ;
	chg_query3 ("VQ1_XML") 
}
//組縣市別============
function changeCity(xml,year) {
	var citySeld = document.form.cityType.value; //已選擇的
	Myear = '100' ;//預設年分100年

	var xmlDoc = $.parseXML($("xml[id=CityXML]").html()) ;
	document.form.cityType.length = 0;
	var data = $(xmlDoc).find("data") ;
	var oOption = document.createElement("OPTION");
	oOption.text="全部";
	oOption.value="";
	document.form.cityType.add(oOption);


	$(data).each(function (i) {
		if ($(this).find("cityyear").text() == Myear) {
			oOption = document.createElement("OPTION");
			oOption.text = $(this).find("cityname").text();
			oOption.value = $(this).find("cityvalue").text();
			document.form.cityType.add(oOption);
		}
	});
	setSelect(form.cityType,citySeld);
}
<%//檢查報告%>
function chg_query1 (xml) {
	
	var f = document.form;
	var tbankSel = f.tbank.value; //已選擇的
	//1.取得畫面年分
	Myear = '100' ;//預設年分100年

	//2.讀cityXml
	var xmlDoc = $.parseXML($("xml[id=VQ1_XML]").html()) ;
	var data = $(xmlDoc).find("data") ;

	//3.移除已搬入的資料
	var oOption = document.createElement("OPTION");
	document.form.q_sel1.length = 0;
	oOption.text="請選擇...";
	oOption.value="";
	document.form.q_sel1.add(oOption);

	//4.
	$(data).each(function (i) {
		if($(this).find("ex_type").text()=="FEB") {
			if($(this).find("bank_no").text()!=tbankSel) {
				return;
			}
			oOption = document.createElement("OPTION");
			oOption.text= $(this).find("ex_no_list").text();
			oOption.value=$(this).find("ex_no").text();
			document.form.q_sel1.add(oOption);
		}
	});
}
<%//查核季別%>
function chg_query2 (xml) {

	var f = document.form;
	var tbankSel = f.tbank.value; //已選擇的
	//1.取得畫面年分
	Myear = '100' ;//預設年分100年

	//2.讀cityXml
	var xmlDoc = $.parseXML($("xml[id=VQ1_XML]").html()) ;
	var data = $(xmlDoc).find("data") ;

	//3.移除已搬入的資料
	var oOption = document.createElement("OPTION");
	document.form.q_sel2.length = 0;
	oOption.text="請選擇...";
	oOption.value="";
	document.form.q_sel2.add(oOption);

	//4.
	$(data).each(function (i) {
		if($(this).find("ex_type").text()=="AGRI") {
			if($(this).find("bank_no").text()!=tbankSel) {
				return;
			}
			oOption = document.createElement("OPTION");
			oOption.text= $(this).find("ex_no_list").text();
			oOption.value=$(this).find("ex_no").text();
			document.form.q_sel2.add(oOption);
		}
	});
}
function chg_query3 (xml) {

	var f = document.form;
	var tbankSel = f.tbank.value; //已選擇的
	//1.取得畫面年分
	Myear = '100' ;//預設年分100年

	//2.讀cityXml
	var xmlDoc = $.parseXML($("xml[id=VQ1_XML]").html()) ;
	var data = $(xmlDoc).find("data") ;

	//3.移除已搬入的資料
	var oOption = document.createElement("OPTION");
	document.form.q_sel3.length = 0;
	oOption.text="請選擇...";
	oOption.value="";
	document.form.q_sel3.add(oOption);

	//4.
	$(data).each(function (i) {
		if($(this).find("ex_type").text()=="BOAF") {
			if($(this).find("bank_no").text()!=tbankSel) {
				return;
			}
			oOption = document.createElement("OPTION");
			oOption.text= $(this).find("ex_no_list").text();
			oOption.value=$(this).find("ex_no").text();
			document.form.q_sel3.add(oOption);
		}
	});
}
function ctrEx_No(v) {
	var q1 = document.getElementById("vq1") ;
	var q2 = document.getElementById("vq2") ;
	var q3 = document.getElementById("vq3") ;
	switch(v) {
	case 'FEB':
		q1.style.display = "";
		q2.style.display = "none" ;
		q3.style.display = "none" ;
		break ;
	case 'AGRI':
		q1.style.display = "none";
		q2.style.display = "" ;
		q3.style.display = "none" ;
		break ;
	case 'BOAF':
		q1.style.display = "none";
		q2.style.display = "none" ;
		q3.style.display = "" ;
		break ;
	}
	setQuery2();
}
function setQuery2() {
	var f = document.form ;
	var ex_type_obj = f.ex_Type ;
	console.log('type' + ex_type_obj[0].value);
	var ex_type ;
	//get ex_type ;
	for(i=0 ; i< ex_type_obj.length ; i++) {
		if(ex_type_obj[i].checked) {
			ex_type = ex_type_obj[i].value ;
		}
	}
	switch(ex_type) {
	case 'FEB':
		chg_query1('VQ1_XML') ;
		break ;
	case 'AGRI':
		//chg_query1('VQ2_XML') ;
		chg_query2('VQ1_XML') ;
		break ;
	case 'BOAF':
		//chg_query1('VQ3_XML') ;
		chg_query3('VQ1_XML') ;
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
<input type='hidden' name='ui_value'>
<input type='hidden' name='tbank_ui'>
<input type='hidden' name='ex_no'>
<table width='600' border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr>
    <td width="20%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
    <td width="60%"><font color='#000000' size=4><b><center>個別農漁會對其政策性農業專案貸款檢查缺失改善處理情形</center></b></font></td>
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

<tr class="sbody">
	<td width='15%' bgcolor="#BDDE9C" height="1">受檢單位</td>
	<td width='85%' bgcolor="#EBF4E1" height="1">           
	  <select size="1" name="tbank" onChange="setQuery2()">
	    <option value="" >全部</option>
	  </select> 
	</td>
</tr>
<tr class="sbody">
	<td width='15%' bgcolor="#BDDE9C" height="1">查核類別</td>
	<td width='85%' bgcolor="#EBF4E1" height="1">
	  <input type='radio' name='ex_Type' value='FEB'  onclick="ctrEx_No(this.value);" checked>金管會檢查報告&nbsp;
	  <input type='radio' name='ex_Type' value='AGRI' onclick="ctrEx_No(this.value);">農業金庫查核&nbsp;
	  <input type='radio' name='ex_Type' value='BOAF' onclick="ctrEx_No(this.value);">農金局訪查&nbsp;
		      
	 </td>
</tr>
<tr id='vq1' class="sbody">
	<td width='15%' bgcolor="#BDDE9C" height="1">檢查報告編號</td>
	<td width='85%' bgcolor="#EBF4E1" height="1">           
	  <select size="1" name="q_sel1" >
	    <option value="" >請選擇...</option>
	  </select> 
	</td>
</tr>
<tr id='vq2' class="sbody">
	<td width='15%' bgcolor="#BDDE9C" height="1">查核季別</td>
	<td width='85%' bgcolor="#EBF4E1" height="1">           
	  <select size="1" name="q_sel2" >
	    <option value="" >請選擇...</option>
	  </select> 
	</td>
</tr>
<tr id='vq3' class="sbody">
	<td width='15%' bgcolor="#BDDE9C" height="1">訪查日期</td>
	<td width='85%' bgcolor="#EBF4E1" height="1">           
	  <select size="1" name="q_sel3" >
	    <option value="" >請選擇...</option>
	  </select> 
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
chg_query1 ("VQ1_XML") ;
chg_query2 ("VQ1_XML") ;
chg_query3 ("VQ1_XML") ;
ctrEx_No("FEB") ;
</script>