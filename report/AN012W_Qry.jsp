<%
// 95.10.31
// AN012W 某年底個別農漁會信用部業務經營概況
// created by ABYSS Brenda
// 99.06.08 fixed 縣市合併調整 by 2808
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%
	String title = "某年底個別農漁會信用部業務經營概況";
	Calendar rightNow = Calendar.getInstance();
   	Calendar now = Calendar.getInstance();
   	String YEAR  = String.valueOf((now.get(Calendar.YEAR)-1911)-1); //回覆值為西元年故需-1911取得民國年;
   	
 	//取得權限
	Properties permission = ( session.getAttribute("AN012W")==null ) ? new Properties() : (Properties)session.getAttribute("AN012W"); 
	if(permission == null){
       System.out.println("AN012W_Qry.permission == null");
    }else{
       System.out.println("AN012W_Qry.permission.size ="+permission.size());               
    }
	List cityList = (List)request.getAttribute("CityList");
	if(cityList!=null) {
		// XML Ducument for 縣市別 begin
	    out.println("<xml version=\"1.0\" encoding=\"big5\" ID=\"CityXML\">");
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
%>
<script language="javascript" src="../js/Common.js"></script>
<script language="javascript" src="../js/AN000W.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<link href="/pages/css/b51.css" rel="stylesheet" type="text/css">
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
<!--
function doSubmit(){ 
	if(document.form.bankType.value == ""){
		alert("請選擇農(漁)會別");
		document.form.bankType.focus();
		return;
	}
	
	if(document.form.cityType.value == ""){
		alert("請選擇縣市別");
		document.form.cityType.focus();
		return;
	}
	
	if (!confirm("本項報表會執行 20-30 秒，是否確定執行？")){return;}
	this.document.forms[0].action = "/pages/report/AN012W.jsp?act=Excel";
	this.document.forms[0].submit();   
}
//組縣市別============
function changeCity(xml) {
	var citySeld = form.cityType.value; //已選擇的
	var myXML,nodeValue, nodeName,nodeYear;
	//1.取得畫面年分 
	var begY = form.S_YEAR.value=='' ? 0 : eval(form.S_YEAR.value) ;
	Myear = '100' ;//預設年分100年
	if(begY<=99) {
		Myear = '99' ;
	}
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
//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form name='form' method=post action='#'>
<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="#FFFFFF">
	<table width="800" border="0" align="center" cellpadding="1" cellspacing="1">        
        <tr> 
          <td><table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="100"><img src="../images/banner_bg1.gif" width="100" height="17"></td>
                <td width="*"><font color='#000000' size=4> 
                  <center>
                    <font color="#336600"><%=title%></font>
                  </center>
                  </font> </td>
                <td width="100"><img src="../images/banner_bg1.gif" width="100" height="17"></td>
              </tr>
            </table></td>
        </tr>
    </table>
    <Table border=1 width='600' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
		<tr class="sbody" bgcolor="#BDDE9C">
    		<td colspan="2" height="1">
      			<div align="right">
                  	  <input type='radio' name="excelaction" value='download' checked> 下載報表
                  	  <a href="javascript:doSubmit()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','../images/bt_execb.gif',1)"><img src="../images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a>
                      <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','../images/bt_cancelb.gif',0)"><img src="../images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a>
                      <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','../images/bt_reporthelpb.gif',1)"><img src="../images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a>
   				</div>
    		</td>
		</tr>
		<tr class="sbody">
			<td width="118" bgcolor="#BDDE9C" height="1">查詢年度</td>
			<td width="416" bgcolor="#EBF4E1" height="1">
				<input type='text' name='S_YEAR' value="<%=YEAR%>" size='3' maxlength='3' onblur='CheckYear(this);changeCity("CityXML")'>
        		<font color='#000000'>年</font>     
			</td>
		</tr>
		<tr class="sbody">
			<td width="118" bgcolor="#BDDE9C" height="1">農(漁)會別</td>
			<td width="416" bgcolor="#EBF4E1" height="1">
				<select size="1" name="bankType">
					<option value="">請選擇</option>
					<option value="6">農會</option>
					<option value="7">漁會</option>
  				</select>
  				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  縣市別:&nbsp;&nbsp;
				 <select size="1" name="cityType"  >
  				 </select>
  				
			</td>
		</tr>
		<tr class="sbody">
			<td width="118" bgcolor="#BDDE9C" height="1">金額單位</td>
			<td width="416" bgcolor="#EBF4E1" height="1">
				<select size="1" name="unit">
					<option value ="元;1">元</option>
					<option value ="仟元;1000" selected >仟元</option>
					<option value ="萬元;10000">萬元</option>
					<option value ="百萬元;1000000">百萬元</option>
					<option value ="仟萬元;10000000">仟萬元</option>
					<option value ="億元;100000000">億元</option>
				</select>
			</td>
		</tr>
		<%@include file="../include/rpt_style.include" %><!--報表格式挑選--> 
		<tr>
  			<td bgcolor="#E9F4E3" colspan="2">
            	<font color="red" size="2">資料來源：各農漁會信用部每年度12月底之申報財務資料</font>
      		</td>
  		</tr>
        <tr>
  			<td bgcolor="#E9F4E3" colspan="2">
            	<div align="center">
	  				<table width="555" border="0" cellpadding="1" cellspacing="1">
	  					<tr>
							<td width="34"><img src="../images/print_1.gif" width="34" height="34"></td>
							<td width="222"><font color="#CC6600">本報表採用A4紙張橫印</font></td>
	                    </tr>
					</table>
            	</div>
      		</td>
  		</tr>
      </table>
    </td>
  </tr>
</table>
</form>
</body>
<script language="JavaScript" >
<!--
changeCity("CityXML") ;
-->
</script>
</html>
