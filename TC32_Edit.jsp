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
System.out.println("Page: TC32_Edit.jsp    Action:"+act);

String sn_docno = request.getParameter("sn_docno" )== null  ? "" : (String)request.getParameter("sn_docno");
String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
String rt_date = request.getParameter("rt_date" )== null  ? "" : (String)request.getParameter("rt_date");
String rt_docno = request.getParameter("rt_docno" )== null  ? "" : (String)request.getParameter("rt_docno");
String rt_dateY = request.getParameter("rt_dateY" )== null  ? "" : (String)request.getParameter("rt_dateY");
String rt_dateM = request.getParameter("rt_dateM" )== null  ? "" : (String)request.getParameter("rt_dateM");
String rt_dateD = request.getParameter("rt_dateD" )== null  ? "" : (String)request.getParameter("rt_dateD");
String sn_date = request.getParameter("sn_date" )== null  ? "" : (String)request.getParameter("sn_date");
String receive_docno = request.getParameter("receive_docno" )== null  ? "" : (String)request.getParameter("receive_docno");
String message =request.getAttribute("actMsg" )== null  ? "" : (String)request.getAttribute("actMsg");
System.out.println("message = "+message);
DataObject ob = (DataObject)request.getAttribute("reportOB");
if(ob != null) {
    reportno = ob.getValue("reportno") != null ? (String)ob.getValue("reportno") : "";
    sn_date = ob.getValue("sn_date") != null ? (String)ob.getValue("sn_date") : "";
    
}

if(act.equals("New")) {
    Calendar c = Calendar.getInstance();
    rt_dateY = String.valueOf(c.get(Calendar.YEAR)-1911);
    // rt_dateM = String.valueOf(c.get(Calendar.MONTH)+1);
    // rt_dateD = String.valueOf(c.get(Calendar.DATE));
}
else if(act.equals("Edit")) {
    List detailList = (List) request.getAttribute("DETAIL");
    if(detailList != null && detailList.size() > 0) {
            DataObject bean = (DataObject)detailList.get(0);
            if(sn_docno.equals("")) {
              sn_docno = bean.getValue("sn_docno") != null ? (String)bean.getValue("sn_docno") : "";
            }
            receive_docno = bean.getValue("receive_docno") != null ? (String)bean.getValue("receive_docno") : "";
            rt_docno = bean.getValue("rt_docno") != null ? (String)bean.getValue("rt_docno") : "";
            rt_dateY = bean.getValue("rt_datey") != null ? (String)bean.getValue("rt_datey") : "";
            rt_dateM = bean.getValue("rt_datem") != null ? (String)bean.getValue("rt_datem") : "";
            rt_dateD = bean.getValue("rt_dated") != null ? (String)bean.getValue("rt_dated") : "";
            
            
            if(!rt_dateY.equals("") && !rt_dateM.equals("") && !rt_dateD.equals("")) {
                rt_dateY =  String.valueOf(Integer.parseInt(rt_dateY)-1911);
                rt_dateM =  String.valueOf(Integer.parseInt(rt_dateM));
                rt_dateD =  String.valueOf(Integer.parseInt(rt_dateD));
            }
            
    }

}

//取得權限
	Properties permission = ( session.getAttribute("TC32")==null ) ? new Properties() : (Properties)session.getAttribute("TC32"); 
	if(permission == null){
       System.out.println("TC32_Edit.permission == null");
    }else{
       System.out.println("TC32_Edit.permission.size ="+permission.size());
  }

%>

<HTML>
<HEAD>
<TITLE>回文記錄維護</TITLE>
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

function message() {
<% if(!message.equals("")) {%>
   alert("<%=message%>");
<%
   
 }
%>
return ;
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
<input type='hidden' name="rt_date" value=''>
<input type='hidden' name="sn_date" value='<%=sn_date%>'>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="50%"><font color='#000000' size=4><b><center>回文記錄建檔維護管理 </center></b></font> </td>
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

<Table border=1 width="100%" align=center height="42" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">檢查報告編號</td>
<td width="423" bgcolor="#EBF4E1" height="1">
  <input type='hidden' name='reportno' value='<%=reportno%>' readonly >
  <%=reportno%>&nbsp;

</td>
</tr>
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">上次發文文號</td>
<td width="423" bgcolor="#EBF4E1" height="1">
  <input type="text" name="sn_docno" size="30" maxlength="30" value='<%=sn_docno%>'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <a href="javascript:doSubmit(form,'<%=act%>','<%=act.equals("Edit") ? rt_docno : ""%>', form.sn_docno.value );"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image112','','images/bt_03b.gif',1)"><img src="images/bt_03.gif" name="Image112"  border="0" id="Image112"></a>
   </td>
</tr>
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">回文日期</td>
<td width="423" bgcolor="#EBF4E1" height="1">
<input type="text" name="rt_dateY" size="3" maxlength="3" value="<%=rt_dateY%>"> 
  年 
  <select name="rt_dateM">  
    <option value=""></option>   
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
  <select name="rt_dateD">
    <option value=""></option>   
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
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">回文文號</td>
<td width="423" bgcolor="#EBF4E1" height="1">
<%if(act.equals("New")) {%>
<input type="text" name="rt_docno" size="30" maxlength="30" value="<%=rt_docno%>">
<%} else {%>
<input type="hidden" name="rt_docno" size="20" value="<%=rt_docno%>">
<%=rt_docno%>&nbsp;
<%}%>
</td>
</tr>
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">農金局收文文號</td>
<td width="423" bgcolor="#EBF4E1" height="1">
 <input type="text" name="receive_docno" size="20" value="<%=receive_docno%>"></td>
</tr>

</Table>
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="sbody">
  <tr>
    <td colspan='2' align='center'>
      <% if( (act.equals("New") )  ) {%>
<%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ %>
<a href="javascript:doSubmit(form,'Insert','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>
<a href="javascript:clearAll();"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a>
 <a href="javascript:location.replace('TC32.jsp?act=List');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_05b.gif',1)"><img src="images/bt_05.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a>
<%}%>  
<% } else if(act.equals("Edit") ) {%>
<%if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){ %>
<a href="javascript:doSubmit(form,'Update','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>
<%}%>
<%if(permission != null && permission.get("D") != null && permission.get("D").equals("Y")){ %>
<a href="javascript:doSubmit(form,'Delete','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a>
  <% } %>
<a href="javascript:location.replace('TC32.jsp?act=List');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a>
<%}%>
    
    
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
        <%} else if(act.equals("New") ) {%>
            <li>本網頁提供基本資料維護功能。</li>
		    <li>按<font color="#666666">【確定】</font>即將資料寫入資料庫。</li> 
		    <li>按<font color="#666666">【取消】</font>放棄資料修改。</li>
		<%} else if(act.equals("Edit")  ) {%>
            <li>本網頁提供基本資料維護功能。</li>
            <li>按<font color="#666666">【修改】</font>即將修改資料寫入資料庫。</li> 
		    <li>按<font color="#666666">【刪除】</font>刪除這一筆資料。</li>
        <% } %> 
         <li>按<font color="#666666">【回查詢頁】</font>則回至查詢畫面。</li>
      </ul>
    </td>
 </tr>
</table>
</form>
</BODY>
<script language="javascript" >
<!--

message();
setSelect(form.rt_dateM,"<%=rt_dateM%>");
setSelect(form.rt_dateD,"<%=rt_dateD%>");


-->
</script>
</HTML>
