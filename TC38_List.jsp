<%
//101.07.13 created 檢查追蹤歷程紀錄查詢列印 by 2968
//108.05.28 add 報表格式挑選 by rock.tsai
%>
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
System.out.println("Page: TC38_list.jsp    Action:"+act);
// 查詢條件值 
String sn_docno = request.getParameter("sn_docno" )== null  ? "" : (String)request.getParameter("sn_docno");
String rt_docno = request.getParameter("rt_docno" )== null  ? "" : (String)request.getParameter("rt_docno");
String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
String program_id = request.getParameter("program_id" )== null    ? "" : (String)request.getParameter("program_id");
String begDate = request.getParameter("begDate" )== null  ? "" : (String)request.getParameter("begDate");
String endDate = request.getParameter("endDate" )== null  ? "" : (String)request.getParameter("endDate");
String updType1 = ( request.getParameter("updType1")==null ) ? "" : (String)request.getParameter("updType1");
String updType2 = ( request.getParameter("updType2")==null ) ? "" : (String)request.getParameter("updType2");
String updType3 = ( request.getParameter("updType3")==null ) ? "" : (String)request.getParameter("updType3");
String updType4 = ( request.getParameter("updType4")==null ) ? "" : (String)request.getParameter("updType4");
String updType5 = ( request.getParameter("updType5")==null ) ? "" : (String)request.getParameter("updType5");
	
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
	int begD = 1;
	int endD = 31;
	if(begDate.length() > 6 ){
	    begM = Integer.parseInt(begDate.substring(4,6));
		begD = Integer.parseInt(begDate.substring(6,8));
	}
	if(endDate.length() > 6 ){
	    endM = Integer.parseInt(endDate.substring(4,6));
		endD = Integer.parseInt(endDate.substring(6,8));
	}
	List getPgName = (List)request.getAttribute("getPgName");
	if(getPgName != null && getPgName.size() != 0){
	 	  System.out.println("getPgName.size()="+getPgName.size());
	 	}else{
	 	  System.out.println("getPgName is null");
	 }
	
%>

<HTML>
<HEAD>
<TITLE>檢查追蹤歷程記錄查詢列印</TITLE>
</HEAD>
</HEAD>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/TC38.js"></script>
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
<body bgColor=#FFFFFF>
<Form name='form' method=post action='TC38.jsp'>
<input type='hidden' name="act" value=''>
<input type='hidden' name="begDate" value='<%=begDate%>'>
<input type='hidden' name="endDate" value='<%=endDate%>'>

<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="50%"><font color='#000000' size=4><b><center>檢查追蹤歷程記錄查詢列印 </center></b></font> </td>
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
         </tr>
</table>
<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
<tr>  
    <div align="right">
      <jsp:include page="getLoginUser.jsp" flush="true" />
    </div> 
</tr> 
</table>            


<table border="1" width="90%" align="center" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">功能名稱</td>
<td width="500" bgcolor="#EBF4E1" height="1">
   <select size="1" name="program_id">
   <%   if(getPgName != null) {
         for(int i=0; i < getPgName.size(); i++) {
             DataObject b =(DataObject)getPgName.get(i);
             if(i==getPgName.size()-1){ %> 
     			<option value="<%=b.getValue("program_id")%>" 
     			<%if("TC38".equals(program_id) || "".equals(program_id) ){ %>
     				selected
     			<%} %>	
     				>全部</option>
		<%	 }else{%>
    			<option value="<%=b.getValue("program_id")%>"><%=b.getValue("pg_name")%></option>
			<%}
         }
     }
%>
	
   </SELECT>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <a href="javascript:doSubmit(form,'Qry');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_queryb.gif',1)"><img src="images/bt_query.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>
  <a href="javascript:doSubmit(form,'Report');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_printb.gif',1)"><img src="images/bt_print.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>
  <!-- <a href="javascript:history.back();"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a> -->
  
  </td>
</tr>
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">使用日期</td>
<td width="423" bgcolor="#EBF4E1" height="1">
<input type='hidden' name="excelaction" value='download'>
<input type="text" name="begY" size="3" maxlength="3" value='<%=begY%>'> 
  年 <select name="begM">
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
	<td width="118" bgcolor="#BDDE9C" height="1">操作類別</td>
	<td width="416" bgcolor="#EBF4E1" height="1">
	<%if("".equals(updType1)){ %>
		<Input Type="checkBox" Name="updType1" Value="I">新增
	<%}else{ %>	
		<Input Type="checkBox" Name="updType1" Value="I" checked>新增
	<%} %>
	<%if("".equals(updType2)){ %>
  		<Input Type="checkBox" Name="updType2" Value="U">修改
  	<%}else{ %>	
		<Input Type="checkBox" Name="updType2" Value="U" checked>修改
	<%} %>	
	<%if("".equals(updType3)){ %>
  		<Input Type="checkBox" Name="updType3" Value="D">刪除
  	<%}else{ %>	
		<Input Type="checkBox" Name="updType3" Value="D" checked>刪除
	<%} %>
	<%if("".equals(updType4)){ %>
  		<Input Type="checkBox" Name="updType4" Value="Q">明細
  	<%}else{ %>	
		<Input Type="checkBox" Name="updType4" Value="Q" checked>明細
	<%} %>
	<%if("".equals(updType5)){ %>
  		<Input Type="checkBox" Name="updType5" Value="P">列印 
  	<%}else{ %>	
		<Input Type="checkBox" Name="updType5" Value="P" checked>列印 
	<%} %>
  		
  		
  		
	        
	</td>
</tr>

<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">發文文號</td>
<td width="423" bgcolor="#EBF4E1" height="1">
   <input type="text" name="sn_docno" size="20" value='<%=sn_docno%>'></td>
</tr>
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">回文文號</td>
<td width="423" bgcolor="#EBF4E1" height="1">
   <input type="text" name="rt_docno" size="20" value='<%=rt_docno%>'></td>
</tr>
<tr class="sbody">
<td width="111" bgcolor="#BDDE9C" height="1">檢查報告編號</td>
<td width="423" bgcolor="#EBF4E1" height="1">
   <input type="text" name="reportno" size="20" value='<%=reportno%>'></td>
</tr>
<%@include file="./include/rpt_style.include" %><!--報表格式挑選-->
<%if("Qry".equals(act)){ %>
<tr class="sbody">
<td width="85%" height="1" colspan="2">
  <table border="1" width="100%" bgcolor="#FFFFF" bordercolor="#76C657">
    <tr class="sbody"  bgcolor="#BFDFAE">
      <td >功能名稱</td>
      <td >使用者名稱</td>
      <td >使用日期</td>
      <td >來源IP</td>
      <td >發文文號</td>
      <td >回文文號</td>
      <td >檢查報告編號</td>
      <td >事項序號</td>
      <td >操作類別</td>
    </tr>
    <% List queryList = (List) request.getAttribute("QueryResult");
       if(queryList != null && queryList.size() > 0) {
           System.out.println("Query Result Size= "+queryList.size());
           for(int i=0; i < queryList.size(); i++) {
               DataObject bean = (DataObject) queryList.get(i);
               String use_date = bean.getValue("use_date") != null ? (String)bean.getValue("use_date") : "&nbsp;";
               int use_dateY = Integer.parseInt(use_date.substring(0,4))-1911;
               String use_dateM = use_date.substring(5,7);
               String use_dateD = use_date.substring(8,10);
               use_date = use_dateY+"/"+use_dateM+"/"+use_dateD;
    %>
    <tr class="sbody"  bgcolor='<%=(i % 2 == 0)?"#EBF4E1":"#FFFFCC"%>'>
      <td ><%=bean.getValue("pg_name") != null ? bean.getValue("pg_name") : "&nbsp;" %></td>
      <td ><%=bean.getValue("muser_name") != null ? bean.getValue("muser_name") : "&nbsp;" %>　</td>
      <td ><%=use_date %></td>
      <td ><%=bean.getValue("ip_address") != null ? bean.getValue("ip_address") : "&nbsp;" %></td>
      <td ><%=bean.getValue("sn_docno") != null ? bean.getValue("sn_docno") : "&nbsp;" %></td>
      <td ><%=bean.getValue("rt_docno") != null ? bean.getValue("rt_docno") : "&nbsp;" %></td>
      <td ><%=bean.getValue("reportno") != null ? bean.getValue("reportno") : "&nbsp;" %></td>
      <td ><%=bean.getValue("item_no") != null ? bean.getValue("item_no") : "&nbsp;" %></td>
      <td ><%=bean.getValue("update_type") != null ? bean.getValue("update_type") : "&nbsp;" %></td>
    </tr>
    <%     }
      } else { 
    %>
     <tr class="sbody" bgcolor="#EBF4E1">
        <td colspan='9' align='center'>
        <font color="#FF0000">查不到相符的資料</font>
        </td>
     </tr>
    <%
      }%>
  </table>
</td>
</tr>
<%} %>

</table>
<table width="90%" border="0" cellpadding="1" cellspacing="1" class="sbody">
  <tr> 
    <td colspan="2">
      <font color='#990000'>
        <img src="images/arrow_1.gif" width="28" height="23" align="absmiddle">
        <font color="#007D7D" size="3">使用說明  : </font></font></td>
  </tr>
  <tr> 
    <td width="3%">&nbsp;</td>
    <td width="78%"> 
      <ul>                                                
          <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li> 
		  <li>按<font color="#666666">【列印】</font>則依查詢條件值列印資料。</li> 
      </ul>
    </td>
 </tr>
</table>
</form>
</body>
<script language="javascript" >
<!--
setSelect(form.begM,"<%=begM%>");
setSelect(form.endM,"<%=endM%>");
setSelect(form.begD,"<%=begD%>");
setSelect(form.endD,"<%=endD%>");
setSelect(form.program_id,"<%=program_id%>");
-->
</script>
</HTML>
