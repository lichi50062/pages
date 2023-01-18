<%//111.06.10 add 新增檢查報告編號 by 2295 %>
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

String reportno = "";
String reportno_seq = "";
String item_no = "";
String ex_content = "";
String commentt = "";
String fault_id = "";
String faultda_id = "";
String audit_oppinion = "";
String act_id = "";
String audit_result = "";
String digest = "";
String rt_docno = "";
String rt_date = "";
String rt_dateY = "";
String rt_dateM = "";
String rt_dateD = "";
String disable = "";
String frt_docno = "";
String frt_date = "";
String frt_dateY = "";
String frt_dateM = "";
String frt_dateD = "";


String actMsg = request.getAttribute("actMsg") != null ? (String) request.getAttribute("actMsg") : "";

DataObject rtbean = (DataObject) request.getAttribute("RTDATA");
if(rtbean != null) {
	frt_docno = rtbean.getValue("rt_docno") != null ? (String) rtbean.getValue("rt_docno") : "";
    frt_dateY = rtbean.getValue("rt_datey") != null ? (String) rtbean.getValue("rt_datey") : "";
    frt_dateM = rtbean.getValue("rt_datem") != null ? (String) rtbean.getValue("rt_datem") : "";
    frt_dateD = rtbean.getValue("rt_dated") != null ? (String) rtbean.getValue("rt_dated") : "";
    frt_date = rtbean.getValue("rt_date") != null ? (String) rtbean.getValue("rt_date") : "";
}


if(act.equals("New")) {
    disable = "disabled";
    reportno = request.getAttribute("reportno") != null ? (String) request.getAttribute("reportno") : "";
    item_no = request.getAttribute("item_no") != null ? (String) request.getAttribute("item_no") : "";
    ex_content = request.getAttribute("ex_content") != null ? (String) request.getAttribute("ex_content") : "";
    commentt = request.getAttribute("commentt") != null ? (String) request.getAttribute("commentt") : "";

}else if(act.equals("Edit")) {
    DataObject bean = (DataObject) request.getAttribute("DETAIL");
    if(bean != null) {
        reportno = bean.getValue("reportno") != null ? (String) bean.getValue("reportno") : "";
        reportno_seq = bean.getValue("reportno_seq") != null ? String.valueOf(bean.getValue("reportno_seq")) : "";
        item_no = bean.getValue("item_no") != null ? (String) bean.getValue("item_no") : "";
        ex_content = bean.getValue("ex_content") != null ? (String) bean.getValue("ex_content") : "";
        commentt = bean.getValue("commentt") != null ? (String) bean.getValue("commentt") : "";
        fault_id = bean.getValue("fault_id") != null ? (String) bean.getValue("fault_id") : "";
        faultda_id = bean.getValue("faultda_id") != null ? (String) bean.getValue("faultda_id") : "";
        audit_oppinion = bean.getValue("audit_oppinion") != null ? (String) bean.getValue("audit_oppinion") : "";
        act_id = bean.getValue("act_id") != null ? (String) bean.getValue("act_id") : "";
        audit_result = bean.getValue("audit_result") != null ? (String) bean.getValue("audit_result") : "";
        digest = bean.getValue("digest") != null ? (String) bean.getValue("digest") : "";
        rt_docno = bean.getValue("rt_docno") != null ? (String) bean.getValue("rt_docno") : "";
        rt_dateY = bean.getValue("rt_datey") != null ? (String) bean.getValue("rt_datey") : "";
        rt_dateM = bean.getValue("rt_datem") != null ? (String) bean.getValue("rt_datem") : "";
        rt_dateD = bean.getValue("rt_dated") != null ? (String) bean.getValue("rt_dated") : "";
        rt_date = bean.getValue("rt_date") != null ? (String) bean.getValue("rt_date") : "";
        
        if(!rt_dateY.equals("") && !rt_dateM.equals("") && !rt_dateD.equals("")) {
                rt_dateY =  String.valueOf(Integer.parseInt(rt_dateY)-1911);
                rt_dateM =  String.valueOf(Integer.parseInt(rt_dateM));
                rt_dateD =  String.valueOf(Integer.parseInt(rt_dateD));
        }
       
    }
}
//取得權限
	Properties permission = ( session.getAttribute("TC33")==null ) ? new Properties() : (Properties)session.getAttribute("TC33"); 
	if(permission == null){
       System.out.println("TC33_Edit.permission == null");
    }else{
       System.out.println("TC33_Edit.permission.size ="+permission.size());
  }
  
    List faultList = (List) request.getAttribute("exFault");
	System.out.println("faultList size="+faultList.size());
    // XML Ducument for 受檢代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"FaultXML\">");
    out.println("<datalist>");
    for(int i=0;i< faultList.size(); i++) {
        DataObject bean =(DataObject)faultList.get(i);
        out.println("<data>");
        out.println("<faultType>"+bean.getValue("fault_type")+"</faultType>");
        out.println("<faultID>"+bean.getValue("fault_id")+"</faultID>");
        out.println("<faultName>"+bean.getValue("fault_id")+"  "+bean.getValue("fault_name")+"</faultName>");
        out.println("</data>");
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 受檢代碼 end 

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
<BODY bgColor=#FFFFFF >
<Form name='form' method=post action='TC33.jsp'>
<input type='hidden' name="act" value=''>
<input type='hidden' name='reportno_seq' value='<%=reportno_seq%>'>
<input type='hidden' name="rt_date" value='<%=rt_date%>'>
<input type='hidden' name='srt_date' value='<%=rt_date%>'>
<input type='hidden' name='msg' value='<%=actMsg%>'>
<input type='hidden' name='changeSec1' value=''>
<input type='hidden' name='changeSec2' value=''>
<input type='hidden' name='frt_docno' value='<%=frt_docno%>'>
<input type='hidden' name='frt_dateY' value='<%=frt_dateY%>'>
<input type='hidden' name='frt_dateM' value='<%=frt_dateM%>'>
<input type='hidden' name='frt_dateD' value='<%=frt_dateD%>'>
<input type='hidden' name='frt_date' value='<%=frt_date%>'>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="50%"><font color='#000000' size=4><b><center>缺失改善情形建檔維護管理 </center></b></font> </td>
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

<Table border=1 width='100%' align=center height="260" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody">
<td width="20%" bgcolor="#BDDE9C" height="1">檢查報告編號</td>
<td width="80%" bgcolor="#EBF4E1" height="1">
  <input type='text' name='reportno' value='<%=reportno%>' readonly >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  

 </td>  
</tr>
<tr class="sbody">
<td width="20%" bgcolor="#BDDE9C" height="1">缺失事項序號</td>
<td width="80%" bgcolor="#EBF4E1" height="1">
<input type='hidden' name='sitem_no' value='<%=item_no%>'>
<input type="text" name="item_no" size="20" value='<%=item_no%>'></td>
</tr>
<tr class="sbody">
<td width="20%" bgcolor="#BDDE9C" height="1">檢查缺失摘要</td>
<td width="80%" bgcolor="#EBF4E1" height="1">
    <input type='hidden' name='sex_content' value='<%=ex_content%>'>
    <textarea rows="7" name="ex_content" cols="50"><%=ex_content%></textarea></td>
</tr>
<tr class="sbody">
<td width="20%" bgcolor="#BDDE9C" height="1">檢查處理意見</td>
<td width="80%" bgcolor="#EBF4E1" height="1">
   <input type='hidden' name='scommentt' value='<%=commentt%>'>
   <textarea rows="3" name="commentt" cols="50"><%=commentt%></textarea></td>
</tr>
<tr class="sbody">
<td width="20%" bgcolor="#BDDE9C" height="1">檢查意見代號</td>
<td width="80%" bgcolor="#EBF4E1" height="1">
  <input type='hidden' name='sfault_id' value='<%=fault_id%>'>
  <select size="1" name="faultda_id"  onChange="changeFault(form.faultda_id,form.fault_id)">
    <option value="">請選擇...</option>
    <% List faultdaList = (List) request.getAttribute("exFaultda");
   if(faultdaList != null ) {
       for(int i=0; i<faultdaList.size(); i++) {
           DataObject bean = (DataObject) faultdaList.get(i);
%>   
    <option value="<%=bean.getValue("faultda_id")%>"><%=bean.getValue("faultda_name")%></option>
<%     }
   }%>   
  </select> 
  <select size="1" name="fault_id">
    <option value="">請選擇...</option>
  </select> 
  
 </td>
</tr>
<tr class="sbody">
<td width="20%" bgcolor="#BDDE9C" height="1">農金局處理意見</td>
<td width="80%" bgcolor="#EBF4E1" height="1">
  <input type='hidden' name='saudit_oppinion' value='<%=audit_oppinion%>'>
  <textarea rows="3" name="audit_oppinion" cols="50" ><%=audit_oppinion%></textarea></td>
</tr>
<tr class="sbody">
<td width="20%" bgcolor="#BDDE9C" height="1">農金局處理代號</td>
<td width="80%" bgcolor="#EBF4E1" height="1">
<input type='hidden' name='sact_id' value='<%=act_id%>'>
<select size="1" name="act_id">
    <option value="">請選擇...</option>
    <% List actNoList = (List) request.getAttribute("actNo");
   if(actNoList != null ) {
       for(int i=0; i<actNoList.size(); i++) {
           DataObject bean = (DataObject) actNoList.get(i);
%>   
    <option value="<%=bean.getValue("act_id")%>"><%=bean.getValue("act_id")%>    <%=bean.getValue("act_name")%></option>
<%     }
   }%>   
    
  </select> </td>

</tr>
<tr class="sbody">
<td width="20%" bgcolor="#BDDE9C" height="1">函覆改善情形摘要 </td>
<td width="80%" bgcolor="#EBF4E1" height="1">
   <input type='hidden' name='sdigest' value='<%=digest%>'>
   <textarea rows="3" name="digest" cols="50" <%=disable%> ><%=digest%></textarea></td>
</tr>
<tr class="sbody">
<td width="20%" bgcolor="#BDDE9C" height="1">受檢單位來文文號</td>
<td width="80%" bgcolor="#EBF4E1" height="1">
  <input type='hidden' name='srt_docno' value='<%=rt_docno%>'>
  <input type="text" name="rt_docno" size="20" value='<%=rt_docno%>' <%=disable%>  maxlength="50" >
  <input type="button" name="bu1" value="抄錄最近一筆異動的(受檢單位來文文號及日期)" onClick="getRtData(form)">
  </td>
</tr>
<tr class="sbody">
<td width="20%" bgcolor="#BDDE9C" height="4">受檢單位來文日期</td>
<td width="80%" bgcolor="#EBF4E1" height="4">
  
  <input type="text" name="rt_dateY" size="3" maxlength="3" value='<%=rt_dateY%>' <%=disable%> > 
  年 <select name="rt_dateM" <%=disable%> >                 
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
  <select name="rt_dateD" <%=disable%> >                 
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
<td width="20%" bgcolor="#BDDE9C" height="1">審核結果</td>
<td width="80%" bgcolor="#EBF4E1" height="1">
  <input type='hidden' name='saudit_result' value='<%=audit_result%>' >
  <select size="1" name="audit_result" <%=disable%> >
    <option value="">請選擇...</option>
<% List auditList = (List) request.getAttribute("auditList");
   if(auditList != null ) {
       for(int i=0; i<auditList.size(); i++) {
           DataObject bean = (DataObject) auditList.get(i);
%>   
    <option value="<%=bean.getValue("cmuse_id")%>"><%=bean.getValue("cmuse_name")%></option>
<%     }
   }%>     
  </select>
</td>
</tr>
</Table>

<table width="100%" border="0" cellpadding="1" cellspacing="1" class="sbody">
  <tr>
    <td colspan='2' align='center'>
    <%if(act.equals("New")) {
%>
<%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ %>
  <a href="javascript:doSubmit(form,'Insert','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>&nbsp; &nbsp;
  <a href="javascript:clearAll();"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image106','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image106" width="66" height="25" border="0" id="Image106"></a>
  <%}%>
  <a href="javascript:doSubmit(form,'Qry2','<%=reportno%>');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a>   
<%} else if(act.equals("Edit")) {
%>
  <%if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){ %>
  <a href="javascript:doSubmit(form,'Update','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>&nbsp; &nbsp;
  <%}%>
  <%if(permission != null && permission.get("D") != null && permission.get("D").equals("Y")){ %>
  <a href="javascript:doSubmit(form,'Delete','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a>
  <%}%>  
  <a href="javascript:doSubmit(form,'Qry2','<%=reportno%>');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a> 
  <%} %>
<a href="TC33.jsp?act=List"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image106','','images/bt_05b.gif',1)"><img src="images/bt_05.gif" name="Image106" width="80" height="25" border="0" id="Image106"></a> 

    
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
		    <li>按<font color="#666666">【派差通知單編號連結】</font>則可修改或查看此筆資料。</li>
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
        <li>按<font color="#666666">【抄錄最近一筆異動的(受檢單位來文文號及日期)】鍵方可正常執行抄錄本畫面檢查報告編號的(受檢單位來文文號及日期)資料</font>。</li>
      </ul>
    </td>
 </tr>
</table>

</form>
</BODY>
<script language="javascript">
<!--
message(form);
setSelect(form.faultda_id, '<%=faultda_id%>');
changeFault(form.faultda_id, form.fault_id);
setSelect(form.fault_id,'<%=fault_id%>');
setSelect(form.act_id,'<%=act_id%>');
setSelect(form.rt_dateM,'<%=rt_dateM%>');
setSelect(form.rt_dateD,'<%=rt_dateD%>');
setSelect(form.audit_result,'<%=audit_result%>');
-->
</script>
</HTML>
