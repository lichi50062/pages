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
System.out.println("Page: TC32_list.jsp    Action:"+act);

// 查詢條件值 
String sn_docno = request.getParameter("sn_docno" )== null  ? "" : (String)request.getParameter("sn_docno");
String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
String receive_docno = request.getParameter("receive_docno" )== null  ? "" : (String)request.getParameter("receive_docno");
String rt_docno = request.getParameter("rt_docno" )== null  ? "" : (String)request.getParameter("rt_docno");
String begDate = request.getParameter("begDate" )== null  ? "" : (String)request.getParameter("begDate");
String endDate = request.getParameter("endDate" )== null  ? "" : (String)request.getParameter("endDate");

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
%>

<HTML>
<HEAD>
<TITLE></TITLE>
<TITLE>回文記錄維護</TITLE>
</HEAD>
<script language="javascript" src="js/TC32.js"></script>
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
<Form name='form' method=post action='TC32.jsp'>
<input type='hidden' name="act" value=''>
<input type='hidden' name="flag" value='1'>
<input type='hidden' name="begDate" value='<%=begDate%>'>
<input type='hidden' name="endDate" value='<%=endDate%>'>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="50%"><font color='#000000' size=4><b><center>回文記錄維護查詢 </center></b></font> </td>
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

<Table border=1 width="100%" align=center height="35"  bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">檢查報告編號</td>
<td width="423" bgcolor="#EBF4E1" height="1">
<input type="text" name="reportno" size="20" value='<%=reportno%>' >&nbsp;&nbsp;&nbsp;&nbsp;
<a href="javascript:doSubmit(form,'Qry','','','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_queryb.gif',1)"><img src="images/bt_query.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>
<a href="javascript:doSubmit(form,'New','','','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_addb.gif',1)"><img src="images/bt_add.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>
<!-- <a href="javascript:history.back();"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a> -->
  </td>
</tr>
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">上次發文文號</td>
<td width="423" bgcolor="#EBF4E1" height="1">
<input type="text" name="sn_docno" size="20" value="<%=sn_docno%>">
  </td>
</tr>
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">回文文號</td>
<td width="423" bgcolor="#EBF4E1" height="1">
 <input type="text" name="rt_docno" size="20" value="<%=rt_docno%>"></td>
</tr>
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">回文日期</td>
<td width="423" bgcolor="#EBF4E1" height="1">
<input type="text" name="begY" size="3" maxlength="3" value="<%=begY%>""> 
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
  </select>日<font color="#FF0000">至</font>
  <input type="text" name="endY" size="3" maxlength="3" value="<%=endY%>"> 
  年 
  <select name="endM">      
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
<td width="111" bgcolor="#BDDE9C" height="1">農金局收文文號</td>
<td width="423" bgcolor="#EBF4E1" height="1">
 <input type="text" name="receive_docno" size="20" value="<%=receive_docno%>"></td>

</tr>


<% 
if(act.equals("Qry")) {
%>
<tr class="sbody">
<td width="100%" height="1" colspan="2">
  <table border="1" width="100%" bgcolor="#FFFFF" bordercolor="#76C657">
    <tr class="sbody" bgcolor="#BFDFAE" >
      <td width="20%" align='center'>回文文號</td>
      <td width="20%" align='center'>上次發文文號</td>
      <td width="15%" align='center'>檢查報告編號</td>
      <td width="30%" align='center'>金融機構</td>   
      <td width="15%" align='center'>回文日期</td>
    </tr>
<%
    List resultList = (List) request.getAttribute("QueryResult");
    if(resultList != null && resultList.size() > 0 ) {
        for(int i=0; i<resultList.size(); i++) {
            DataObject bean = (DataObject) resultList.get(i);
%>
    <tr class="sbody" bgcolor='<%=(i % 2 == 0)?"#EBF4E1":"#FFFFCC"%>'>
      <td width="20%" align='center'><a href="javascript:doSubmit(form,'Edit','<%=bean.getValue("rt_docno")%>','<%=bean.getValue("sn_docno")%>','<%=bean.getValue("reportno")%>')"><%=bean.getValue("rt_docno")%></a></td>
      <td width="20%" align='center'><%=bean.getValue("sn_docno") != null ? bean.getValue("sn_docno") : "&nbsp;"%></td>
      <td width="15%" align='center'><%=bean.getValue("reportno") != null ? bean.getValue("reportno") : "&nbsp;"%></td>
      <td width="30%" align='center'><%=bean.getValue("bank_name") != null ? bean.getValue("bank_name") : "&nbsp;"%></td>
      <td width="15%" align='center'><%=bean.getValue("rt_date") != null ? bean.getValue("rt_date") : "&nbsp;"%></td>
    </tr>
<%      }
    } else {
%>
   <tr class="sbody" bgcolor="EBF4E1">
      <td width="27%" colspan='5' align='center'><font color="#FF0000">查不到符合的資料</font></td>
   </tr>

<%  } %>
  </table>
</td>
</tr>
<% } %>
</Table>
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="sbody">
  <tr>
    <td colspan='2' align='center'>
    
    </td>
  </tr>
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
		    <li>按<font color="#666666">【回文文號】連結</font>則可修改或查看此筆資料。</li>
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
<script language="javascript" >
<!--

setSelect(form.begM,"<%=begM%>");
setSelect(form.endM,"<%=endM%>");
setSelect(form.begD,"1");
setSelect(form.endD,"31");

-->
</script>

</BODY></HTML>
