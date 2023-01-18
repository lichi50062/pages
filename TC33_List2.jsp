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
System.out.println("Page: TC33_list2.jsp    Action:"+act);

String reportno = "";
String bank_no = "";
String ch_type = "";
String base_date = "";

DataObject ob = (DataObject) request.getAttribute("HEAD");
if(ob != null) {
    reportno = (String) ob.getValue("reportno");
    bank_no = (String) ob.getValue("bank_no") + "    " + (String) ob.getValue("bank_name");
    ch_type = (String) ob.getValue("ch_type");
    base_date = (String) ob.getValue("base_date");
}


%>

<HTML>
<HEAD>
<TITLE>缺失改善情形登錄及查詢</TITLE>
<script language="javascript" src="js/TC33.js"></script>
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
<Form name='form' method=post action='TC33.jsp'>
<input type='hidden' name="act" value=''>
<input type='hidden' name="reportno_seq" value=''>
<input type='hidden' name="item_no" value=''>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="50%"><font color='#000000' size=4><b><center>缺失改善情形登錄及查詢 </center></b></font> </td>
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

<Table border=1 width="100%" align=center height="90" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="4">檢查報告編號</td>
<td width="70%" bgcolor="#EBF4E1" height="4" colspan="3">
  <input type='text' name='reportno' value='<%=reportno%>' readonly >&nbsp;&nbsp;&nbsp;&nbsp;   
   &nbsp;&nbsp;&nbsp;<a href="javascript:doSubmit(form,'New','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_04b.gif',1)"><img src="images/bt_04.gif" name="Image101"  border="0" id="Image101"></a>
&nbsp;&nbsp;&nbsp;<a href="javascript:doSubmit(form,'List','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_05b.gif',1)"><img src="images/bt_05.gif" name="Image102"  border="0" id="Image102"></a>
   
</td> 
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="4">受檢單位</td>
<td width="70%" bgcolor="#EBF4E1" height="4" colspan="3">
  <input type='text' name='bank_no' size='50' value='<%=bank_no%>' readonly> 
</td> 
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">檢查性質</td>
<td width="10%" bgcolor="#EBF4E1" height="1">
  <input type='text' name='ch_type' size='15' value='<%=ch_type%>' readonly>  
  </td>
<td width="20%" bgcolor="#BDDE9C" height="1">檢查基準日期   
  </td>
<td width="40%" bgcolor="#EBF4E1" height="1">
  <input type='text' name='base_date' value='<%=base_date%>' readonly>   
  </td>
</tr>
<tr class="sbody">
<td width="100%" bgcolor="#EBF4E1" colspan="4">
  <div align="center">
    <center>
    <table border="1" width="100%" bgcolor="#FFFFF" bordercolor="#76C657">
      <tr class="sbody" bgcolor="#BFDFAE">
        <td width="6%" height="14" valign="middle" align="center">序號</td>
        <td width="50%" height="14" valign="middle" align="center">檢查缺失摘要</td>
        <td width="15%" height="14" valign="middle" align="center">檢查處理意見</td>
        <td width="23%" height="14" valign="middle" align="center">函覆改善情形摘要</td>
        <td width="6%" height="14" valign="middle" align="center">審核結果</td>
      </tr>
<% List bodyList = (List) request.getAttribute("BODY");
   System.out.println("bodyList.size = "+bodyList.size());
   if(bodyList != null && bodyList.size() > 0) {
       
       for(int i=0; i<bodyList.size(); i++) {
           DataObject bean = (DataObject) bodyList.get(i);
%>    
      <tr class="sbody" bgcolor='<%=(i % 2 == 0)?"#EBF4E1":"#FFFFCC"%>'>
        <td  height="1" align="center"><a href="javascript:doSubmit(form,'Edit','<%=bean.getValue("item_no")%>','<%=bean.getValue("reportno_seq")%>')"><%=bean.getValue("item_no") != null ? bean.getValue("item_no") : "目前空白"%></a></td>
        <td  height="1" valign='top' >&nbsp;<%=bean.getValue("ex_content") != null ? bean.getValue("ex_content") : ""%></td>
        <td  height="1" valign='top' >&nbsp;<%=bean.getValue("commentt") != null ? bean.getValue("commentt") : ""%></td>
        <td  height="1" valign='top' >&nbsp;<%=bean.getValue("digest") != null ? bean.getValue("digest") : ""%></td>
        <td  height="1" align="center">&nbsp;<%=bean.getValue("cmuse_name") != null ? bean.getValue("cmuse_name") : ""%></td>
      </tr>
<%    }
   } else { %> 
     <tr class="sbody" bgcolor="#EBF4E1">
       <td align="center" colspan="5"><font color="#FF0000">目前沒有資料</font></td>
     </tr>   
<% }%>
    </table>
    </center>
  </div>
</td>
</tr>
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
            <li>本網頁提供基本資料查詢功能。</li>
            <li>按<font color="#666666">【新增檢查意見】</font>則依新增資料。</li> 
		    <li>按<font color="#666666">【回查詢頁面】</font>則回查詢頁面。</li> 
		    <li>按<font color="#666666">【序號】連結</font>則可修改或查看此筆資料。</li>
       
      </ul>
    </td>
 </tr>
</table>

</form>
</BODY>
</HTML>
