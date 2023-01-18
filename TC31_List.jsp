<%// 99.06.01 fix 縣市合併 by 2808 %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>

<%
String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");				
System.out.println("Page: TC31_list.jsp    Action:"+act);
// 查詢條件值 
String sn_docno = request.getParameter("sn_docno" )== null  ? "" : (String)request.getParameter("sn_docno");
String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
String sn_date = request.getParameter("sn_date" )== null  ? "" : (String)request.getParameter("sn_date");
String doctype = request.getParameter("doctype" )== null  ? "" : (String)request.getParameter("doctype");
String bankType = request.getParameter("bankType" )== null    ? "" : (String)request.getParameter("bankType");
String tbank_no = request.getParameter("tbank" )== null    ? "" : (String)request.getParameter("tbank");
String examine = request.getParameter("examine" )== null  ? "" : (String)request.getParameter("examine");
String limitdate = request.getParameter("limitdate" )== null  ? "" : (String)request.getParameter("limitdate");
String begDate = request.getParameter("begDate" )== null  ? "" : (String)request.getParameter("begDate");
String endDate = request.getParameter("endDate" )== null  ? "" : (String)request.getParameter("endDate");
String cityType = request.getParameter("cityType" )== null    ? "" : (String)request.getParameter("cityType");

System.out.println("sn_docno ="+sn_docno);	
System.out.println("reportno ="+reportno);
System.out.println("sn_date ="+sn_date);
System.out.println("doctype ="+doctype);	
System.out.println("bankType ="+bankType);
System.out.println("examine ="+examine);
System.out.println("limitdate ="+limitdate);
System.out.println("begDate ="+begDate);
System.out.println("endDate ="+endDate);
	
// 轉換西元年到民國年
	Calendar c = Calendar.getInstance();
	int begY = c.get(Calendar.YEAR)-1911;
	int endY = c.get(Calendar.YEAR)-1911;
	if(begDate.length() > 6 )
	    begY = Integer.parseInt(begDate.substring(0,4))-1911;
	if(endDate.length() > 6 )
	    endY = Integer.parseInt(endDate.substring(0,4))-1911;
	    
	int begM = c.get(Calendar.MONTH)+1;
	int endM = c.get(Calendar.MONTH)+1;
	if(begDate.length() > 6 )
	    begM = Integer.parseInt(begDate.substring(4,6));	
	if(endDate.length() > 6 )
	    endM = Integer.parseInt(endDate.substring(4,6));
	
	String limitY = "";
	int limitM = 0;
	int limitD = 0;
	
	if(limitdate.length() > 6) {
	    limitY = String.valueOf(Integer.parseInt(begDate.substring(0,4))-1911);
	    limitM = Integer.parseInt(limitdate.substring(4,6));
	    limitD = Integer.parseInt(limitdate.substring(6,8));
	}
	
	List bankNoList = (List)request.getAttribute("Bank_No");
    List chTypeList = (List)request.getAttribute("Ch_Type");
    List bankTypeList = (List)request.getAttribute("Bank_Type");
	System.out.println("bankNoList size="+bankNoList.size());
    HashMap bankNoMap = new HashMap();
    // XML Ducument for 受檢代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"BankNoXML\">");
    out.println("<datalist>");
    for(int i=0;i< bankNoList.size(); i++) {
        DataObject bean =(DataObject)bankNoList.get(i);
        out.println("<data>");
        out.println("<bankType>"+bean.getValue("tbank_no")+"</bankType>");
        out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");
        out.println("<bankName>"+bean.getValue("bank_no")+"  "+bean.getValue("bank_name")+"</bankName>");
        out.println("</data>");
        bankNoMap.put(bean.getValue("bank_no"),bean.getValue("bank_name"));
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 受檢代碼 end 
    
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
%>

<HTML>
<HEAD>
<TITLE>發文記錄維護</TITLE>
</HEAD>
<script language="javascript" src="js/TC31.js"></script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
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
//-->
</script>
<BODY bgColor=#FFFFFF>
<Form name='form' method=post action='TC31.jsp'>
<input type='hidden' name="act" value=''>
<input type='hidden' name="reportno" value=''>
<input type='hidden' name="flag" value='1'>
<input type='hidden' name="limitdate" value='<%=limitdate%>'>
<input type='hidden' name="begDate" value='<%=begDate%>'>
<input type='hidden' name="endDate" value='<%=endDate%>'>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="50%"><font color='#000000' size=4><b><center>發文記錄維護查詢 </center></b></font> </td>
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
         </tr>
</table>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
<tr>  
    <div align="right">
      <jsp:include page="getLoginUser.jsp" flush="true" />
    </div> 
</tr> 
</table>            


<Table border=1 width='100%' align=center height="35" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">金融機構類別</td>
<td width="500" bgcolor="#EBF4E1" height="1">
   <select size="1" name="bankType" onChange="checkCity();resetOption();changeTbank('TBankXML',form.begY);">
     
<%   if(bankTypeList != null) {
         for(int i=0; i < bankTypeList.size(); i++) {
             DataObject bean =(DataObject)bankTypeList.get(i);
%>   
     <option value="<%=bean.getValue("cmuse_id")%>"><%=bean.getValue("cmuse_name")%></option>
<%       }
     }
%>
  </select>
  &nbsp;&nbsp;&nbsp;&nbsp;
  縣市別:&nbsp;&nbsp;
  <select size="1" name="cityType" onChange="changeTbank('TBankXML',form.begY);changeExamine('BankNoXML','TBankXML',form.begY);" >
    </select>
  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <a href="javascript:doSubmit(form,'Qry','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_queryb.gif',1)"><img src="images/bt_query.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>
  <a href="javascript:doSubmit(form,'New','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_addb.gif',1)"><img src="images/bt_add.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>
  <!-- <a href="javascript:history.back();"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a> -->
  
  </td>
</tr>

<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">總機構單位</td>
<td width="416" bgcolor="#EBF4E1" height="1">           
  <select size="1" name="tbank" onChange='changeExamine("BankNoXML","TBankXML",form.begY)'>
    <option value="" >全部</option>
  </select>
   </td>
</tr>

<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">受檢單位</td>
<td width="416" bgcolor="#EBF4E1" height="1">
  <select size="1" name="examine">
    <option value="" >全部</option>
  </select> </td>
</tr>
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">發文文號</td>
<td width="423" bgcolor="#EBF4E1" height="1">
   <input type="text" name="sn_docno" size="20" value='<%=sn_docno%>'></td>
</tr>
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">發文日期</td>
<td width="423" bgcolor="#EBF4E1" height="1">
<input type="text" name="begY" size="3" maxlength="3" value='<%=begY%>' onChange="chnageYear(form.begY)"> 
  年 <select name="begM">     
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
  </select>月 
  <select name="begD">     
    <option value></option>
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
    <option value="13">13</option>
    <option value="14">14</option>
    <option value="15">15</option>
    <option value="16">16</option>
    <option value="17">17</option>
    <option value="18">18</option>
    <option value="19">19</option>
    <option value="20">20</option>
    <option value="21">21</option>
    <option value="22">22</option>
    <option value="23">23</option>
    <option value="24">24</option>
    <option value="25">25</option>
    <option value="26">26</option>
    <option value="27">27</option>
    <option value="28">28</option>
    <option value="29">29</option>
    <option value="30">30</option>
    <option value="31">31</option>
  </select>日
  <font color="#FF0000">至</font>
  <input type="text" name="endY" size="3" maxlength="3" value='<%=endY%>'> 
  年 
  <select name="endM">     
    <option value></option>
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
  </select>月 
  <select name="endD">     
    <option value></option>
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
    <option value="13">13</option>
    <option value="14">14</option>
    <option value="15">15</option>
    <option value="16">16</option>
    <option value="17">17</option>
    <option value="18">18</option>
    <option value="19">19</option>
    <option value="20">20</option>
    <option value="21">21</option>
    <option value="22">22</option>
    <option value="23">23</option>
    <option value="24">24</option>
    <option value="25">25</option>
    <option value="26">26</option>
    <option value="27">27</option>
    <option value="28">28</option>
    <option value="29">29</option>
    <option value="30">30</option>
    <option value="31">31</option>
  </select></td>
</tr>
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">公文類別</td>
<td width="423" bgcolor="#EBF4E1" height="1">
<select size="1" name="doctype">
    <option value="">全部</option>
    <% List docTypeList = (List) request.getAttribute("DOCTYPE");
       if(docTypeList != null) {
           for(int i=0 ; i < docTypeList.size(); i++) {
               DataObject bean = (DataObject) docTypeList.get(i);
    %>
    <option value="<%=bean.getValue("cmuse_id")%>"><%=bean.getValue("cmuse_name")%></option>
    <%     }
       }%>
  </select></td>
</tr>
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">限期函報日</td>
<td width="423" bgcolor="#EBF4E1" height="1">
<input type="text" name="limitY" size="3" maxlength="3" value="<%=limitY%>"> 
  年 
  <select name="limitM">    
    <option value="" ></option>
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
  </select>月 
  <select name="limitD">    
    <option value="" ></option>
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
    <option value="13">13</option>
    <option value="14">14</option>
    <option value="15">15</option>
    <option value="16">16</option>
    <option value="17">17</option>
    <option value="18">18</option>
    <option value="19">19</option>
    <option value="20">20</option>
    <option value="21">21</option>
    <option value="22">22</option>
    <option value="23">23</option>
    <option value="24">24</option>
    <option value="25">25</option>
    <option value="26">26</option>
    <option value="27">27</option>
    <option value="28">28</option>
    <option value="29">29</option>
    <option value="30">30</option>
    <option value="31">31</option>
  </select>日</td>
</tr>
<%
if(act.equals("Qry")) {
%>
<tr class="sbody">
<td width="100%" height="1" colspan="2">
  <table border="1" width="100%" bgcolor="#FFFFF" bordercolor="#76C657">
    <tr class="sbody"  bgcolor="#BFDFAE">
      <td width="18%">發文文號</td>
      <td width="21%">檢查報告編號</td>
      <td width="27%">金融機構</td>    
      <td width="14%">發文日期</td>
      <td width="18%">公文類別</td>
    </tr>
    <% List queryList = (List) request.getAttribute("QueryResult");
       if(queryList != null && queryList.size() > 0) {
           System.out.println("Query Result Size= "+queryList.size());
           for(int i=0; i < queryList.size(); i++) {
               DataObject bean = (DataObject) queryList.get(i);
    %>
    <tr class="sbody"  bgcolor='<%=(i % 2 == 0)?"#EBF4E1":"#FFFFCC"%>'>
      <td width="18%"><a href="javascript:doSubmit(form,'Edit','<%=bean.getValue("sn_docno")%>','<%=bean.getValue("reportno")%>')"><%=bean.getValue("sn_docno")%></a> </td>
      <td width="21%"><%=bean.getValue("reportno") != null ? bean.getValue("reportno") : "&nbsp;" %></td>
      <td width="27%"><%=bean.getValue("bank_name") != null ? bean.getValue("bank_name") : "&nbsp;" %>　</td>
      <td width="14%"><%=bean.getValue("sn_date") != null ? bean.getValue("sn_date") : "&nbsp;" %></td>
      <td width="18%"><%=bean.getValue("cmuse_name") != null ? bean.getValue("cmuse_name") : "&nbsp;" %></td>
    </tr>
    <%     }
      } else { 
    %>
     <tr class="sbody" bgcolor="#EBF4E1">
        <td colspan='5' align='center'>
        <font color="#FF0000">查不到相符的資料</font>
        </td>
     </tr>
    <%
      }%>
  </table>
</td>
</tr>
<% } %>
</Table>
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="sbody">
  <tr> 
    <td colspan="2">
      <font color='#990000'>
        <img src="images/arrow_1.gif" width="28" height="23" align="absmiddle">
        <font color="#007D7D" size="3">使用說明  : </font></font></td>
  </tr>
  <tr> 
    <td width="3%">&nbsp;</td>
    <td width="97%"> 
      <ul>                                                
        <%if(act.equals("List")) {%>
            <li>本網頁提供基本資料查詢功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li> 
		    <li>按<font color="#666666">【新增】</font>則新增一筆資料。</li> 
        <% } else if(act.equals("Qry")) {%>
            <li>本網頁提供基本資料查詢功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li> 
		    <li>按<font color="#666666">【新增】</font>則新增一筆資料。</li> 
		    <li>按<font color="#666666">【發文文號】連結</font>則可修改或查看此筆資料。</li>
        <%} else if(act.equals("New")) {%>
            <li>本網頁提供基本資料維護功能。</li>
		    <li>按<font color="#666666">【確定】</font>即將資料寫入資料庫。</li> 
		    <li>按<font color="#666666">【取消】</font>放棄資料修改。</li>
		<%} else if(act.equals("Edit")) {%>
            <li>本網頁提供基本資料維護功能。</li>
            <li>按<font color="#666666">【修改】</font>即將修改資料寫入資料庫。</li> 
		    <li>按<font color="#666666">【刪除】</font>刪除這一筆資料。</li>
        <% } %> 
        <li>按<font color="#666666">【回上一頁】則回至上個畫面</font>。</li>
      </ul>
    </td>
 </tr>
</table>
</form>
</BODY>
<script language="javascript" >
<!--
changeCity("CityXML",form.begY) ;
changeTbank("TBankXML",form.begY);
changeExamine("BankNoXML","TBankXML",form.begY) ;
setSelect(form.bankType,"<%=bankType%>");
//changeOption('TBankXML',form.tbank, form.bankType, 'TBankXML');
setSelect(form.tbank,"<%=tbank_no%>");
//changeOption('BankNoXML',form.examine, form.tbank, 'TBankXML');
setSelect(form.examine,"<%=examine%>");
setSelect(form.begM,"<%=begM%>");
setSelect(form.endM,"<%=endM%>");
setSelect(form.begD,"1");
setSelect(form.endD,"31");
setSelect(form.limitM,"<%=limitM%>");
setSelect(form.limitD,"<%=limitD%>");
setSelect(form.cityType,"<%=cityType%>");
checkCity();


-->
</script>
</HTML>
