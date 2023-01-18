<%//111.06.10 add 新增檢查報告編號 by 2295 %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>


<%
Map dataMap =Utility.saveSearchParameter(request);
String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");				
System.out.println("Page: TC33_EditNew.jsp    Action:"+act);

// 查詢條件值 
	String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
    String ex_content = request.getParameter("ex_content" )== null  ? "" : (String)request.getParameter("ex_content");
    String begDate = request.getParameter("begDate" )== null  ? "" : (String)request.getParameter("begDate");
    String endDate = request.getParameter("endDate" )== null  ? "" : (String)request.getParameter("endDate");
    String bankType = request.getParameter("bankType" )== null    ? "" : (String)request.getParameter("bankType");
    String examine = request.getParameter("examine" )== null  ? "" : (String)request.getParameter("examine");
    String tbank = request.getParameter("tbank" )== null    ? "" : (String)request.getParameter("tbank");
    String cityType = request.getParameter("cityType" )== null    ? "" : (String)request.getParameter("cityType");
    
    
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





    List bankNoList = (List)request.getAttribute("Bank_No");
    List bankTypeList = (List)request.getAttribute("Bank_Type");
    List chTypeList = (List)request.getAttribute("chTypeList");//111.06.09 add
	System.out.println("bankNoList size="+bankNoList.size());
	
	
	//取得權限
	Properties permission = ( session.getAttribute("TC33")==null ) ? new Properties() : (Properties)session.getAttribute("TC33"); 
	if(permission == null){
       System.out.println("TC33_EditNew.permission == null");
    }else{
       System.out.println("TC33_EditNew.permission.size ="+permission.size());
    }
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
<input type='hidden' name="flag" value='1'>
<input type='hidden' name="begDate" value='<%=begDate%>'>


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

<Table border=1 width='100%' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">


<tr class="sbody">
<td width="100" bgcolor="#BDDE9C" height="1">金融機構類別</td>
<td width="450" bgcolor="#EBF4E1" height="1">
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
  &nbsp;&nbsp;&nbsp;
  縣市別:&nbsp;&nbsp;
  <select size="1" name="cityType" id="cityType" onChange="changeTbank('TBankXML',form.begY);changeExamine('BankNoXML','TBankXML',form.begY);" >
    </select>
  </td>
</tr>

<tr class="sbody">
<td width="100" bgcolor="#BDDE9C" height="1">總機構單位</td>
<td width="450" bgcolor="#EBF4E1" height="1">           
  <select size="1" name="tbank" id="tbank" onChange='changeExamine("BankNoXML","TBankXML","begY")'>
    <option value="" >全部</option>
  </select> </td>
</tr>

<tr class="sbody">
<td width="100" bgcolor="#BDDE9C" height="1">受檢單位</td>
<td width="450" bgcolor="#EBF4E1" height="1">
  <select size="1" name="examine">
    <option value="" >全部</option>
  </select> </td>
</tr>

</Table>
<table border="1" width="100%" align="center" height="54" bgcolor="#FFFFF" bordercolor="#76C657">
  <tr class="sbody">
<td width="100" bgcolor="#BDDE9C" height="4">檢查報告編號</td>
<td width="450" bgcolor="#EBF4E1" height="4">
<input type="text" name="reportno" size="20"  value="<%=reportno%>">
</td> 
  </tr>
  <tr class="sbody">
    <td width="100" bgcolor="#BDDE9C" height="1">檢查基準日</td>
    <td width="450" bgcolor="#EBF4E1" height="1">
    <input type="text" name="begY" size="3" maxlength="3" value="<%=begY%>" onChange="chnageYear(form.begY)"> 
      年 
    <select name="begM">  
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
      </td>
  </tr>
  <tr class="sbody">
    <td width="100" bgcolor="#BDDE9C" height="20">檢查性質</td>
    <td width="450" bgcolor="#EBF4E1" height="20">
      <select size="1" name="chType" onChange="">
     
<%   if(chTypeList != null) {
         for(int i=0; i < chTypeList.size(); i++) {
             DataObject bean =(DataObject)chTypeList.get(i);
%>   
     <option value="<%=bean.getValue("cmuse_id")%>"><%=bean.getValue("cmuse_name")%></option>
<%       }
     }
%>
  </select>
    </td>
  </tr>
</table>

</Table>
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="sbody">
  <tr>
    <td colspan='2' align='center'>
    <%if(act.equals("NewReportNo")) {
%>
<%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ %>
  <a href="javascript:doSubmit(form,'InsertNew','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>&nbsp; &nbsp;
  <a href="javascript:clearAll();"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image106','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image106" width="66" height="25" border="0" id="Image106"></a>
  <%}%>  
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
            <li>本網頁提供新增檢查報告功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li> 
		   
        <% } else if(act.equals("Qry")) {%>
            <li>本網頁提供新增檢查報告功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li> 
		    <li>按<font color="#666666">【檢查報告編號】連結</font>則可查看此筆資料。</li>
        <%} else if(act.equals("New")) {%>
            <li>本網頁提供新增檢查報告功能。</li>
		    <li>按<font color="#666666">【確定】</font>即將資料寫入資料庫。</li> 
		    <li>按<font color="#666666">【取消】</font>放棄資料修改。</li>
		<%} else if(act.equals("Edit")) {%>
            <li>本網頁提供新增檢查報告功能。</li>
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
<script language="JavaScript" >
<!--
setSelect(form.bankType,"<%=bankType%>");
changeCity("CityXML",form.begY) ;
changeTbank("TBankXML",form.begY);
setSelect(form.tbank,"<%=tbank%>");
changeExamine("BankNoXML","TBankXML",form.begY) ;
setSelect(form.examine,"<%=examine%>");
setSelect(form.bankType,"<%=bankType%>");
//changeOption('TBankXML',form.tbank, form.bankType, 'TBankXML');

//changeOption('BankNoXML',form.examine, form.tbank, 'TBankXML');

setSelect(form.begM,"<%=begM%>");
setSelect(form.endM,"<%=endM%>");
setSelect(form.begD,"1");
setSelect(form.endD,"31");
setSelect(form.cityType,"<%=cityType%>");
checkCity();
-->
</script>

</HTML>
