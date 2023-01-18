<%
//105.11.09 add by 2968
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="java.util.List" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%
	boolean setLandscape=true;//true:橫印
	
	String report_no = "TM009W";
    Map dataMap =Utility.saveSearchParameter(request);
	//String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR")) ;		
	//String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH")) ;	
	String Unit = Utility.getTrimString(dataMap.get("Unit")) ;
	if("".equals(Unit))Unit="1000";
	String bankType = Utility.getTrimString(dataMap.get("bank_type")); 
	String title="協助措施案件明細表";
	
	List AllAccTr = (List)request.getAttribute("AllAccTr");
	List AllDates = (List)request.getAttribute("AllDates");
	if(AllDates!=null) {
		// XML Ducument for 申報基準日  begin
	    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"DatesXML\">");
	    out.println("<datalist>");
	    for(int i=0;i< AllDates.size(); i++) {
	    	DataObject bean =(DataObject)AllDates.get(i);
	        out.println("<data>");
	        out.println("<acc_tr_type>"+bean.getValue("acc_tr_type")+"</acc_tr_type>");
	        out.println("<applydate>"+bean.getValue("applydate")+"</applydate>");
	        out.println("<applydate_show>"+Utility.getCHTdate(bean.getValue("applydate").toString(), 0)+"</applydate_show>");
	        out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	    // XML Ducument for 申報基準日  end
    }
	
%>
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
	function changeDate(xml) {
		var form = document.forms[0];
		var myXML,nodeValue, nodeName,nodeYear,nodeType,nodeCity;
		//讀Xml
		myXML = document.all(xml).XMLDocument;
		nodeValue = myXML.getElementsByTagName("applydate");
		nodeName = myXML.getElementsByTagName("applydate_show");
		nodeType = myXML.getElementsByTagName("acc_tr_type") ;
		
		var acc_tr_type = form.acc_Tr_Type.value ;
		//移除已搬入的資料
		var target = document.getElementById("applyDate");
		target.length = 0;
		
		var oOption = document.createElement("OPTION");
		//oOption.text="全部";
		//oOption.value="";
		//target.add(oOption);
		
		for(var i=0;i<nodeName.length ;i++)	{
			if(nodeType.item(i).firstChild.nodeValue==acc_tr_type) {
				oOption = document.createElement("OPTION");
	       	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
		        oOption.value=nodeValue.item(i).firstChild.nodeValue;  
		        target.add(oOption);
			}
		}
	}
function doSubmit(cnd){
	this.document.forms[0].action = "/pages/TM009W_Excel.jsp?act=download";	
	this.document.forms[0].target = '_self';
	this.document.forms[0].submit(); 
}
function onload(){
	changeDate('DatesXML');
}
//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0" onLoad = 'onload()'>
<form name='form' method=post action='#'>
<input type='hidden' name="bank_type" value='<%=bankType %>'>
<table width='600' border="0" align="center" cellpadding="0" cellspacing="0" height="65" >
  <tr>
    <td width="20%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
    <td width="60%"><font color='#000000' size=4><b><center><%=title %></center></b></font></td>
    <td width="20%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
  </tr>
</table>
<table border=1 width='600' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
	<tr class="sbody" bgcolor="#BDDE9C">
	    <td colspan="2" height="1">
	      <div align="right">
	       <input type='radio' name="excelaction" value='download' checked> 下載報表
	       <a href="javascript:doSubmit()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a>
	       <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a>
	       <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a>
	      </div>
	    </td>
	</tr>
	<tr class="sbody">
	    <td width="118" bgcolor="#BDDE9C" height="1">協助措施名稱</td>
	    <td width="416" bgcolor="#EBF4E1" height="1">
	     <select name='acc_Tr_Type' onChange="changeDate('DatesXML')" >
	     <%if(AllAccTr!=null && AllAccTr.size()>0){
				for(int i=0; i<AllAccTr.size(); i++){ 
					out.print("<option value='"+(String)((DataObject)AllAccTr.get(i)).getValue("acc_tr_type")+"'>"+(String)((DataObject)AllAccTr.get(i)).getValue("acc_tr_name")+"</option>");
				}
		 }%>
	     </select>
	    </td>
	</tr>
	<tr class="sbody">
	<td width="118" bgcolor="#BDDE9C" height="1">申報基準日</td>
	<td width="416" bgcolor="#EBF4E1" height="1">  
	  <select size="1" name="applyDate" >
	    <option value="" ></option>
	  </select> 
	  &nbsp;&nbsp;<font color='red'>註:為該所選協助措施名稱的應申報日期</font>
	  </td>
	</tr> 
	<tr class="sbody">
	    <td width="118" bgcolor="#BDDE9C" height="1">報表分類</td>
	    <td width="416" bgcolor="#EBF4E1" height="1">
	    	<input type='radio' name='acc_Div' value='01' checked>舊貸展延需求 &nbsp;&nbsp;
	    	<input type='radio' name='acc_Div' value='02'>新貸需求
	    </td>
	</tr>
	<%@include file="./include/DS_Unit2.include" %>
	<%@include file="./include/rpt_style.include" %><!--報表格式挑選-->
</table>
<table border="1" width="600" align="center" height="54" bgcolor="#FFFFF" bordercolor="#76C657">
  <tr>
  	<td bgcolor="#E9F4E3" colspan="2">
       <div align="center">
  		<table width="555" border="0" cellpadding="1" cellspacing="1">
  		<tr><td width="34"><img src="/pages/images/print_1.gif" width="34" height="34"></td>
            <td width="222"><font color="#CC6600">本報表採用A4紙張<%=(setLandscape==true?"橫":"直")%>印</font></td>                              
        </tr>
        </table>
        </div>
    </td>
  </tr>  
</table>
<!-- ======================================================== -->

</form>

</body>
<script language="JavaScript" type="text/JavaScript">


</script>
</html>
