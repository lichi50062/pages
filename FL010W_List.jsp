<%
//105.11.04 create by 2968
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>


<%
	Map dataMap =Utility.saveSearchParameter(request);
	String act = Utility.getTrimString(dataMap.get("act")) ;
	System.out.println("Page: FL010W_List.jsp Action:"+act);
    // 查詢條件值 
    String bankType = Utility.getTrimString(dataMap.get("bankType")) ;//農漁會別    
    String tbank = Utility.getTrimString(dataMap.get("tbank")) ;//受檢單位
    String cityType = Utility.getTrimString(dataMap.get("cityType")) ; //縣市別
    String ex_Type = Utility.getTrimString(dataMap.get("ex_Type")) ;//查核類別
    String begDate = Utility.getTrimString(dataMap.get("begDate")) ;//訪查日期-起始
    String endDate = Utility.getTrimString(dataMap.get("endDate")) ;//訪查日期-結束
    String ex_No = Utility.getTrimString(dataMap.get("ex_No")) ;//檢查報告編號
    String begSeason = Utility.getTrimString(dataMap.get("begSeason")) ;//查核季別-起始
    String endSeason = Utility.getTrimString(dataMap.get("endSeason")) ;//查核季別-結束
    String docBegDate = Utility.getTrimString(dataMap.get("docBegDate")) ;//發文日期-起始
    String docEndDate = Utility.getTrimString(dataMap.get("docEndDate")) ;//發文日期-結束
    String docNo = Utility.getTrimString(dataMap.get("docNo")) ; 
    List rs = (List)request.getAttribute("QueryResult");
    Properties permission = ( session.getAttribute("FL010W")==null ) ? new Properties() : (Properties)session.getAttribute("FL010W");
    String begY="",begM="",begD="",endY="",endM="",endD="";	
    String begSeasonY="",begSeasonS="",endSeasonY="",endSeasonS="";
    String docBegY="",docBegM="",docBegD="",docEndY="",docEndM="",docEndD="";
    if(!"".equals(begDate)){
    	begY=begDate.substring(0, 3);
    	begM=begDate.substring(3, 5);
    	begD=begDate.substring(5, 7);
    	endY=endDate.substring(0, 3);
    	endM=endDate.substring(3, 5);
    	endD=endDate.substring(5, 7);
    }
    if(!"".equals(begSeason)){
    	begSeasonY=begSeason.substring(0, 3);
    	begSeasonS=begSeason.substring(3, 5);
    	endSeasonY=endSeason.substring(0, 3);
    	endSeasonS=endSeason.substring(3, 5);
    }
    if(!"".equals(docBegDate)){
    	docBegY=docBegDate.substring(0, 3);
    	docBegM=docBegDate.substring(3, 5);
    	docBegD=docBegDate.substring(5, 7);
    	docEndY=docEndDate.substring(0, 3);
    	docEndM=docEndDate.substring(3, 5);
    	docEndD=docEndDate.substring(5, 7);
    }
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
<TITLE>溢繳補貼息退還維護作業</TITLE>
<script language="javascript" src="js/jquery-3.5.1.min.js"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/PopupCal.js"></script>
<script language="javascript" src="js/FL010W.js"></script>
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
<Form name='form' method=post action='/pages/FL010W.jsp'>
<input type='hidden' name="act" value=''>
<input type='hidden' name="begDate" >
<input type='hidden' name="endDate" >
<input type='hidden' name="begSeason" >
<input type='hidden' name="endSeason" >
<input type='hidden' name="docBegDate" >
<input type='hidden' name="docEndDate" >
<table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="40%"><font color='#000000' size=4><b><center>溢繳補貼息退還維護作業</center></b></font> </td>
           <td width="25%"><img src="images/banner_bg1.gif" width="113%" height="17"></td>
         </tr>
</table>
<table width="80%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
<tr>  
    <div align="right">
      <jsp:include page="getLoginUser.jsp" flush="true" />
    </div> 
</tr> 
</table> 

<Table border=1 width='80%' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">查核類別</td>
<td bgcolor="#EBF4E1" height="1">
  <input type='radio' name='ex_Type' value='FEB'  onClick="ctrEx_No(form);">金管會檢查報告&nbsp;
  <input type='radio' name='ex_Type' value='AGRI' onClick="ctrEx_No(form);">農業金庫查核&nbsp;
  <input type='radio' name='ex_Type' value='BOAF' onClick="ctrEx_No(form);">農金局訪查&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;
   <font color='red'>＊必要查詢條件</font>
  &nbsp;&nbsp;&nbsp;&nbsp;     
  <a href="javascript:doSubmit(form,'List');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_queryb.gif',1)"><img src="images/bt_query.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>&nbsp;
  <a href="javascript:doSubmit(form,'New');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/B_bt_04b_2.gif',1)"><img src="images/B_bt_04.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>&nbsp;&nbsp;&nbsp;      
  </td>
</tr>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">農漁會別</td>
<td bgcolor="#EBF4E1" height="1">
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
<td width="118" bgcolor="#BDDE9C" height="1">受檢單位</td>
<td bgcolor="#EBF4E1" height="1">           
  <select size="1" name="tbank" >
    <option value="" >全部</option>
  </select> </td>
</tr>
<tr class="sbody" id="showFEB" style="display:none">
       <td width="118" bgcolor="#BDDE9C" height="1">檢查報告編號</td>
       <td bgcolor="#EBF4E1" height="1">
       <input type="text" name="ex_No" value='<%=ex_No %>' size="49" maxlength='10'>
    </tr> 
<tr class="sbody" id="showBOAF" style="display:none">
    <td width="118" bgcolor="#BDDE9C" height="1">訪查日期</td>
    <td bgcolor="#EBF4E1" height="1">
    <input type='text' name='begY' value="<%=begY%>" size='3' maxlength='3' onblur='CheckYear(this)' >    
    <font color='#000000'>年
    <select id="hide3" name=begM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> ><%=j%></option>
    	<%}%>
    <%}%>
    </select>月
    <select id="hide4" name=begD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> >0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> ><%=j%></option>
    	<%}%>
    <%}%>
    </select>日</font>
    		<button name='button1' onclick="popupCal('form','begY,begM,begD','BTN_date_1',event); return false;">
			<img align="absmiddle" border='0' name='BTN_date_1' src='images/clander.gif'>
			</button>
             ～
    <input type='text' name='endY' value="<%=endY%>" size='3' maxlength='3' onblur='CheckYear(this)'>
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
    		<button name='button2' onclick="popupCal('form','endY,endM,endD','BTN_date_2',event); return false;">
			<img align="absmiddle" border='0' name='BTN_date_2' src='images/clander.gif'>
			</button>
</tr>        
<tr class="sbody" id="showAGRI" style="display:none">
    <td width="118" bgcolor="#BDDE9C" height="1">查核季別</td>
    <td bgcolor="#EBF4E1" height="1">
    <input type='text' name='begSeasonY' value="<%=begSeasonY%>" size='3' maxlength='3' onblur='CheckYear(this)' >    
    <font color='#000000'>年
    <select id="hide3" name='begSeasonS'>
    <option></option>
    <%
    	for (int j = 1; j <= 4; j++) {%>        	
    	<option value=0<%=j%>>0<%=j%></option>        		
    <%}%>
    </select>季
             ～
    <input type='text' name='endSeasonY' value="<%=endSeasonY%>" size='3' maxlength='3' onblur='CheckYear(this)'>
    <font color='#000000'>年
    <select id="hide5" name='endSeasonS'>
    <option></option>
    <%
    	for (int j = 1; j <= 4; j++) {%>
    	<option value=0<%=j%>>0<%=j%></option>        		
    <%}%>
    </select>季
</tr>
<tr class="sbody" >
    <td width="118" bgcolor="#BDDE9C" height="1">發文日期</td>
    <td bgcolor="#EBF4E1" height="1">
    <input type='text' name='docBegY' value="<%=docBegY%>" size='3' maxlength='3' onblur='CheckYear(this)' >    
    <font color='#000000'>年
    <select name=docBegM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> ><%=j%></option>
    	<%}%>
    <%}%>
    </select>月
    <select name=docBegD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> >0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> ><%=j%></option>
    	<%}%>
    <%}%>
    </select>日</font>
    		<button name='button3' onclick="popupCal('form','docBegY,docBegM,docBegD','BTN_date_3',event); return false;">
			<img align="absmiddle" border='0' name='BTN_date_3' src='images/clander.gif'>
			</button>
             ～
    <input type='text' name='docEndY' value="<%=docEndY%>" size='3' maxlength='3' onblur='CheckYear(this)'>
    <font color='#000000'>年
    <select name=docEndM>
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
    <select name=docEndD>
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
    		<button name='button4' onclick="popupCal('form','docEndY,docEndM,docEndD','BTN_date_4',event); return false;">>
			<img align="absmiddle" border='0' name='BTN_date_4' src='images/clander.gif'>
			</button>
</tr>
<tr class="sbody" >
       <td width="118" bgcolor="#BDDE9C" height="1">發文文號</td>
       <td bgcolor="#EBF4E1" height="1">
       <input type="text" name="docNo" value='<%=docNo %>' size="49" maxlength='10'>
</tr>  
</Table>

<% if(!"".equals(ex_Type)) {%>
	<Table border="1" width="80%" align='center' bgcolor="#FFFFF" bordercolor="#76C657">
    <tr class="sbody" bgcolor="#BFDFAE">
    	<td width="15%" >機構代號</td>
    	<td width="25%" >機構名稱</td>
      	<td width="15%" ><%if("FEB".equals(ex_Type)){%>檢查報告編號<%}else if("AGRI".equals(ex_Type)){%>查核季別<%}else{%>訪查日期<%} %></td>
        <td width="15%" >發文日期</td>        
      	<td width="15%" >發文文號</td>
      	<td width="15%" >退還金額(元)</td>
    </tr>
    <%
    if(rs != null && rs.size() > 0) {
      System.out.println("Query Result Data Size= "+rs.size());
      for(int i=0; i<rs.size(); i++) {
        DataObject bean =(DataObject)rs.get(i);
    %>      
    <tr class="sbody" bgcolor='<%=(i % 2 == 0)?"#EBF4E1":"#FFFFCC"%>'>
      <td><%=bean.getValue("bank_no") != null ? bean.getValue("bank_no") : "&nbsp;"%></td>
      <td><%=bean.getValue("bank_name") != null ? bean.getValue("bank_name") : "&nbsp;"%></td>
      <td><%=bean.getValue("ex_no_list") != null ? bean.getValue("ex_no_list") : "&nbsp;"%></td>
      <td><%=bean.getValue("doc_date") != null ? (String)bean.getValue("doc_date") : "&nbsp;"%></td>
      <td>
	      <a href=FL010W.jsp?act=Edit&bank_No=<%=bean.getValue("bank_no")%>&ex_Type=<%=bean.getValue("ex_type")%>&ex_No=<%=bean.getValue("ex_no")%>&docNo=<%=bean.getValue("docno")%>>
	      	<%=bean.getValue("docno") != null ? bean.getValue("docno") : "&nbsp;"%>
	      </a>&nbsp;</td>
      <td><%=bean.getValue("refund_amt") != null ? Utility.setCommaFormat(bean.getValue("refund_amt").toString()) : "&nbsp;"%></td>
    </tr>
    <%        
      }
    }else{%>            
    <tr bgcolor="#EBF4E1" class="sbody">
       <td width="100%" colspan='9' align='center'><font color="#FF0000">查無符合資料</font></td>
    </tr>
  <%}%>        
  </Table>
<%}%>

</form>
</BODY>
<script language="JavaScript" >
<!--
if('<%=ex_Type%>' !=''){
	if('<%=ex_Type%>'=='FEB') form.ex_Type[0].checked=true;
	if('<%=ex_Type%>'=='AGRI') form.ex_Type[1].checked=true;
	if('<%=ex_Type%>'=='BOAF') form.ex_Type[2].checked=true;
	ctrEx_No(form);
	setSelect(form.begM,"<%=begM%>");
	setSelect(form.endM,"<%=endM%>");
	setSelect(form.begD,"<%=begD%>");
	setSelect(form.endD,"<%=endD%>");
	setSelect(form.cityType,"<%=cityType%>");
	setSelect(form.begSeasonS,"<%=begSeasonS%>");
	setSelect(form.endSeasonS,"<%=endSeasonS%>");
}
if("<%=tbank%>"!='')setSelect(form.bankType,"<%=bankType%>");
changeCity("CityXML",'') ;
changeTbank("TBankXML",'');
//changeOption('TBankXML',form.tbank, form.bankType, 'TBankXML');
setSelect(form.tbank,"<%=tbank%>");
setSelect(form.docBegM,"<%=docBegM%>");
setSelect(form.docEndM,"<%=docEndM%>");
setSelect(form.docBegD,"<%=docBegD%>");
setSelect(form.docEndD,"<%=docEndD%>");
-->
</script>

</HTML>
