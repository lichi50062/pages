<%
//97.09.09 create 年報申報(MC003W) by 2295
//99.05.27 fix 縣市合併調整&sql injection by 2808
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
     String act = Utility.getTrimString(request.getParameter("act")) ;
    Properties permission = ( session.getAttribute("MC003W")==null ) ? new Properties() : (Properties)session.getAttribute("MC003W");
    if(permission == null){
       System.out.println("MC003W_Edit.permission == null");
    }else{
       System.out.println("MC003W_Edit.permission.size ="+permission.size());
    }			
    System.out.println("Page: MC003W_Edit.jsp    Action:"+act);

    String tbank="",bank_name="",come_date="",come_docno="",sn_date="",sn_docno="",rptyear="",content="";
    String bankType =  Utility.getTrimString(request.getParameter("bankType")) ;   
    String cityType =  Utility.getTrimString(request.getParameter("cityType")) ;
    String Come_begDate =  Utility.getTrimString(request.getParameter("Come_begDate")) ;
    String Come_endDate =  Utility.getTrimString(request.getParameter("Come_endDate")) ;
    String Sn_begDate =  Utility.getTrimString(request.getParameter("Sn_begDate")) ;
    String Sn_endDate =  Utility.getTrimString(request.getParameter("Sn_endDate")) ;
    String RptYear =  Utility.getTrimString(request.getParameter("RptYear")) ;
    // 轉換西元年到民國年
	Calendar c = Calendar.getInstance();
	int come_begY = c.get(Calendar.YEAR)-1911;
	int come_endY = c.get(Calendar.YEAR)-1911;
	int sn_begY = c.get(Calendar.YEAR)-1911;
	int sn_endY = c.get(Calendar.YEAR)-1911;
	
	if(Come_begDate.length() > 6 )
	    come_begY = Integer.parseInt(Come_begDate.substring(0,4))-1911;	
	if(Come_endDate.length() > 6 )
	    come_endY = Integer.parseInt(Come_endDate.substring(0,4))-1911;
    if(Sn_begDate.length() > 6 )
	    sn_begY = Integer.parseInt(Sn_begDate.substring(0,4))-1911;	
	if(Sn_endDate.length() > 6 )
	    sn_endY = Integer.parseInt(Sn_endDate.substring(0,4))-1911;	    
	
	
	int come_begM = c.get(Calendar.MONTH)+1;
	int come_endM = c.get(Calendar.MONTH)+1;
	int sn_begM = c.get(Calendar.MONTH)+1;
	int sn_endM = c.get(Calendar.MONTH)+1;
	
	if(Come_begDate.length() > 6 )
	    come_begM = Integer.parseInt(Come_begDate.substring(4,6));	
	if(Come_endDate.length() > 6 )
	    come_endM = Integer.parseInt(Come_endDate.substring(4,6));
    if(Sn_begDate.length() > 6 )
	    sn_begM = Integer.parseInt(Sn_begDate.substring(4,6));	
	if(Sn_endDate.length() > 6 )
	    sn_endM = Integer.parseInt(Sn_endDate.substring(4,6));	    
	  
	int come_begD = 1;
	int come_endD = 31;
	int sn_begD = 1;
	int sn_endD = 31;
	
	if(Come_begDate.length() > 6 )
	    come_begD = Integer.parseInt(Come_begDate.substring(6,8));	
	if(Come_endDate.length() > 6 )
	    come_endD = Integer.parseInt(Come_endDate.substring(6,8));
	if(Sn_begDate.length() > 6 )
	    sn_begD = Integer.parseInt(Sn_begDate.substring(6,8));	
	if(Sn_endDate.length() > 6 )
	    sn_endD = Integer.parseInt(Sn_endDate.substring(6,8));    
       
    if(act.equals("New")) { 
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
    }else if(act.equals("Edit")) {
        DataObject bean = (DataObject) request.getAttribute("DETAIL");
        if(bean != null) {
            tbank = bean.getValue("bank_no") != null ? (String) bean.getValue("bank_no") : "";
            bank_name = bean.getValue("bank_name") != null ? (String) bean.getValue("bank_name") : "";
            come_date = bean.getValue("come_date_1") != null ? String.valueOf(bean.getValue("come_date_1")) : "";
            come_docno = bean.getValue("come_docno") != null ? (String) bean.getValue("come_docno") : "";
            sn_date = bean.getValue("sn_date_1") != null ? String.valueOf(bean.getValue("sn_date_1")) : "";
            sn_docno = bean.getValue("sn_docno") != null ? (String) bean.getValue("sn_docno") : "";
            rptyear = bean.getValue("rptyear") != null ? String.valueOf(bean.getValue("rptyear")) : "";
            content = bean.getValue("content") != null ? (String) bean.getValue("content") : "";   
            if(come_date.length() > 6 ){
	           come_begY = Integer.parseInt(come_date.substring(0,4))-1911;	
	           come_begM = Integer.parseInt(come_date.substring(5,7));
	           come_begD = Integer.parseInt(come_date.substring(8,10));		
	        }
   			if(sn_date.length() > 6 ){
	    		sn_begY = Integer.parseInt(sn_date.substring(0,4))-1911;
	    		sn_begM = Integer.parseInt(sn_date.substring(5,7));
	    		sn_begD = Integer.parseInt(sn_date.substring(8,10));	
	        }              
        }
    }
%>

<HTML>
<HEAD>
<TITLE>年報申報</TITLE>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/MC003W.js"></script>
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
<Form name='form' method=post action='MC003W.jsp'>
<input type='hidden' name="act" value=''>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="35%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="30%"><font color='#000000' size=4><b><center>年報申報</center></b></font> </td>
           <td width="35%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
         </tr>
</table>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
<tr>  
    <div align="right">
      <jsp:include page="getLoginUser.jsp" flush="true" />
    </div> 
</tr> 
</table> 

<Table border=1 width='100%' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">

<%if(act.equals("New")){%>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">年報年份</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type='text' name='RptYear' value="<%=RptYear%>" size='3' maxlength='3' onblur='CheckYear(this)'>    
    <font color='#000000'>年
</tr> 
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">金融機構類別</td>
<td width="416" bgcolor="#EBF4E1" height="1">
 <select size="1" name="bankType" onChange="changeTbank('TBankXML')">
     <option value="6">農會</option>
     <option value="7">漁會</option>
  </select>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  縣市別:&nbsp;&nbsp;
  <select size="1" name="cityType" onChange="changeTbank('TBankXML')" >
 </select>
  </td>
</tr>

<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">機構名稱</td>
<td width="416" bgcolor="#EBF4E1" height="1">           
  <select size="1" name="tbank" >
    <option value="" >全部</option>
  </select>  </td>
</tr>
<%}else{%>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">年報年份</td>
    <td width="416" bgcolor="#EBF4E1" height="1"><%=rptyear%>年</td>
    <input type='hidden' name='RptYear' value='<%=rptyear%>'>
</tr> 
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">機構名稱</td>
<td width="416" bgcolor="#EBF4E1" height="1"><%=bank_name%>
<input type='hidden' name='tbank' value='<%=tbank%>'>
</td>
</tr>
<%}%>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">來文日期</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type='hidden' name="COME_DATE" value="" >
    <input type='text' name='Come_begY' value="<%=come_begY%>" size='3' maxlength='3' onblur='CheckYear(this)' onChange='chnageYear();'>
    <font color='#000000'>年
    <select id="hide1" name=come_begM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(come_begM == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(come_begM == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>月
    <select id="hide1" name=come_begD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(come_begD == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(come_begD == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>日</font>
	</td>  
</tr> 
<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">來文文號</td>
  <td width="416" bgcolor="#EBF4E1" height="20">
  <input type="text" name="come_docno" size="10" maxlength=10  value="<%=come_docno%>"> 
  </td>
</tr>   

<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">發文日期</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type='hidden' name="SN_DATE" value="">
    <input type='text' name='sn_begY' value="<%=sn_begY%>" size='3' maxlength='3' onblur='CheckYear(this)'>
    <font color='#000000'>年
    <select id="hide1" name=sn_begM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(sn_begM == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(sn_begM == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>月
    <select id="hide1" name=sn_begD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(sn_begD == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(sn_begD == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>日</font>
	</td>  
</tr> 
<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">發文文號</td>
  <td width="416" bgcolor="#EBF4E1" height="20"> 
  <input type="text" name="sn_docno" size="10" maxlength=10 value="<%=sn_docno%>">
  </td>
</tr> 
 
<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">處理情形</td>
  <td width="416" bgcolor="#EBF4E1" height="20">
  <select size="1" name="content" >
    <option value="01" <%if(content.equals("01")) out.print("selected");%>>同意備查</option>
    <option value="02" <%if(content.equals("02")) out.print("selected");%>>修正</option>
  </select> </td>
</tr>
</Table>
<table width="591" border="0" cellpadding="1" cellspacing="1" class="sbody" height="176">
   <tr>
     <td colspan="2" width="583" height="41">
     <div align="center">
       <table width="243" border="0" cellpadding="1" cellspacing="1">
         <tr>
          <%if(act.equals("New")){
          if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){//Add
         %>
		    <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'add');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a></div></td>
		    <% } }else{
		    if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){//Update %>
		    <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'modify');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a></div></td>
		    <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'delete');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a></div></td>
		     <% }}%>
           <td width="66"><div align="center"><a href="javascript:AskReset(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image105" width="66" height="25" border="0" id="Image105"></a></div></td>
           <td width="93"><div align="center"><a href="javascript:history.back();"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image106','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image106" width="80" height="25" border="0" id="Image106"></a></div></td>                        
         </tr>
       </table>
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
		   
        <% } else if(act.equals("Qry")) {%>
            <li>本網頁提供基本資料查詢功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li> 
		    <li>按<font color="#666666">【檢查報告編號】連結</font>則可查看此筆資料。</li>
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
<%if(act.equals("New")){%>
<script language="JavaScript" >
<!--
changeCity("CityXML") ;
changeTbank("TBankXML");
setSelect(form.bankType,"<%=bankType%>");
//changeOption('TBankXML',form.tbank, form.bankType, 'TBankXML');
setSelect(form.tbank,"<%=tbank%>");
setSelect(form.cityType,"<%=cityType%>");
-->
</script>
<%}%>
</HTML>
