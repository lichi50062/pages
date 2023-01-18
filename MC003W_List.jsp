<%
//97.09.09 create 年報(MC003W) by 2295
//99.05.27 fix 縣市合併調整&sql injection by 2808
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
	System.out.println("Page: MC003W_List.jsp    Action:"+act);

    // 查詢條件值 
    
    String bankType = Utility.getTrimString(dataMap.get("act")) ;
    String tbank = Utility.getTrimString(dataMap.get("tbank")) ;
    String cityType =Utility.getTrimString(dataMap.get("cityType")) ;  
    String Come_begDate =Utility.getTrimString(dataMap.get("Come_begDate")) ;;
    String Come_endDate = Utility.getTrimString(dataMap.get("Come_endDate")) ;
    String Sn_begDate = Utility.getTrimString(dataMap.get("Sn_begDate")) ;
    String Sn_endDate = Utility.getTrimString(dataMap.get("Sn_endDate")) ;
    String content = Utility.getTrimString(dataMap.get("content")) ;
    String Come_docno = Utility.getTrimString(dataMap.get("Come_docno")) ;
    String Sn_docno =Utility.getTrimString(dataMap.get("Sn_docno")) ;
    String RptYear = Utility.getTrimString(dataMap.get("RptYear")) ;
    
    Properties permission = ( session.getAttribute("MC003W")==null ) ? new Properties() : (Properties)session.getAttribute("MC003W");
    if (permission == null) {
        System.out.println("MC003W_List.permission == null");
    }else {
        System.out.println("MC003W_List.permission.size ="+permission.size());
        System.out.println(permission.get("A"));
    }
	// 轉換西元年到民國年
	Calendar c = Calendar.getInstance();
	int Come_begY = c.get(Calendar.YEAR)-1911;
	int Come_endY = c.get(Calendar.YEAR)-1911;
	int Sn_begY = c.get(Calendar.YEAR)-1911;
	int Sn_endY = c.get(Calendar.YEAR)-1911;
	
	if(Come_begDate.length() > 6 )
	    Come_begY = Integer.parseInt(Come_begDate.substring(0,4))-1911;	
	if(Come_endDate.length() > 6 )
	    Come_endY = Integer.parseInt(Come_endDate.substring(0,4))-1911;
    if(Sn_begDate.length() > 6 )
	    Sn_begY = Integer.parseInt(Sn_begDate.substring(0,4))-1911;	
	if(Sn_endDate.length() > 6 )
	    Sn_endY = Integer.parseInt(Sn_endDate.substring(0,4))-1911;	    
	
	
	int Come_begM = 1;
	int Come_endM = c.get(Calendar.MONTH)+1;
	int Sn_begM = 1;
	int Sn_endM = c.get(Calendar.MONTH)+1;
	
	if(Come_begDate.length() > 6 )
	    Come_begM = Integer.parseInt(Come_begDate.substring(4,6));	
	if(Come_endDate.length() > 6 )
	    Come_endM = Integer.parseInt(Come_endDate.substring(4,6));
    if(Sn_begDate.length() > 6 )
	    Sn_begM = Integer.parseInt(Sn_begDate.substring(4,6));	
	if(Sn_endDate.length() > 6 )
	    Sn_endM = Integer.parseInt(Sn_endDate.substring(4,6));	    
	  
	int Come_begD = 1;
	int Come_endD = 31;
	int Sn_begD = 1;
	int Sn_endD = 31;
	
	if(Come_begDate.length() > 6 )
	    Come_begD = Integer.parseInt(Come_begDate.substring(6,8));	
	if(Come_endDate.length() > 6 )
	    Come_endD = Integer.parseInt(Come_endDate.substring(6,8));
	if(Sn_begDate.length() > 6 )
	    Sn_begD = Integer.parseInt(Sn_begDate.substring(6,8));	
	if(Sn_endDate.length() > 6 )
	    Sn_endD = Integer.parseInt(Sn_endDate.substring(6,8));    
       
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
<input type='hidden' name="Come_begDate" value='<%=Come_begDate%>'>
<input type='hidden' name="Come_endDate" value='<%=Come_endDate%>'>
<input type='hidden' name="Sn_begDate" value='<%=Sn_begDate%>'>
<input type='hidden' name="Sn_endDate" value='<%=Sn_endDate%>'>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="35%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="30%"><font color='#000000' size=4><b><center>年報查詢 </center></b></font> </td>
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
     <option value="">全部</option>
     <option value="6">農會</option>
     <option value="7">漁會</option>
  </select>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  縣市別:&nbsp;&nbsp;
  <select size="1" name="cityType" onChange="changeTbank('TBankXML')" >
  </select>
  &nbsp;&nbsp;&nbsp;&nbsp;     
  <a href="javascript:doSubmit(form,'Qry');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_queryb.gif',1)"><img src="images/bt_query.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>&nbsp;&nbsp;&nbsp;&nbsp;      
  <%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){//Add %>  
  <a href="/pages/MC003W.jsp?act=New" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_addb.gif',1)">
     <img src="images/bt_add.gif" name="Image102" width="66" height="25" border="0" id="Image101"></a>
  <%}%>
  </td>
</tr>

<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">機構名稱</td>
<td width="416" bgcolor="#EBF4E1" height="1">           
  <select size="1" name="tbank" >
    <option value="" >全部</option>
  </select> </td>
</tr>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">來文日期</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type='text' name='Come_begY' value="<%=Come_begY%>" size='3' maxlength='3' onblur='CheckYear(this)' onChange="chnageYear()">    
    <font color='#000000'>年
    <select id="hide1" name=Come_begM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(Come_begM == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(Come_begM == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>月
    <select id="hide1" name=Come_begD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(Come_begD == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(Come_begD == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>日</font>
    <font color="#FF0000">至</font>  
    <input type='text' name='Come_endY' value="<%=Come_endY%>" size='3' maxlength='3' onblur='CheckYear(this)'>
    <font color='#000000'>年
    <select id="hide1" name=Come_endM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(Come_endM == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(Come_endM == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>月
    <select id="hide1" name=Come_endD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(Come_endD == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(Come_endD == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>日</font>
</tr>    

    
<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">來文文號</td>
  <td width="416" bgcolor="#EBF4E1" height="20">
  <input type="text" name="Come_docno" size="10" value="<%=Come_docno%>">  
  </td>
</tr>

<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">發文日期</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type='text' name='Sn_begY' value="<%=Sn_begY%>" size='3' maxlength='3' onblur='CheckYear(this)'>    
    <font color='#000000'>年
    <select id="hide1" name=Sn_begM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(Sn_begM == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(Sn_begM == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>月
    <select id="hide1" name=Sn_begD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(Sn_begD == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(Sn_begD == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>日</font>
    <font color="#FF0000">至</font>  
    <input type='text' name='Sn_endY' value="<%=Sn_endY%>" size='3' maxlength='3' onblur='CheckYear(this)'>
    <font color='#000000'>年
    <select id="hide1" name=Sn_endM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(Sn_endM == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(Sn_endM == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>月
    <select id="hide1" name=Sn_endD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(Sn_endD == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(Sn_endD == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>日</font>
</tr>  

<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">發文文號</td>
  <td width="416" bgcolor="#EBF4E1" height="20">
  <input type="text" name="Sn_docno" size="10" value="<%=Sn_docno%>">  
  </td>
</tr>
<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">處理情形</td>
  <td width="416" bgcolor="#EBF4E1" height="20">
  <select size="1" name="content" >
    <option value="ALL">全部</option>
    <option value="01">同意備查</option>
    <option value="02">修正</option>
  </select> </td>
</tr>

</Table>

<% if(act.equals("Qry")) {%>


<Table border="1" width="100%"  bgcolor="#FFFFF" bordercolor="#76C657">
      <tr class="sbody" bgcolor="#BFDFAE">
        <td width="5%" height="14">年份</td>
        <td width="35%" height="14">機構名稱</td>
        <td width="10%" height="14">來文日期</td>          
        <td width="15%" height="14">來文文號</td>
        <td width="10%" height="14">發文日期</td>          
        <td width="15%" height="14">發文文號</td>
        <td width="10%" height="14">處理情形</td>         
      </tr>
      
      <%
      
      List rs = (List)request.getAttribute("QueryResult");
      System.out.println("rs.size()="+rs.size());     
      int rowidx = 0;
      if(rs != null && rs.size() > 0) {
          System.out.println("Query Result Data Size= "+rs.size());
          DataObject bean = null;          
          for(int i=0; i<rs.size(); i++) {
              bean =(DataObject)rs.get(i);             
                  rowidx++;                
      %>      
                  <tr class="sbody" bgcolor='<%=(rowidx % 2 == 0)?"#EBF4E1":"#FFFFCC"%>'>
                    <td width="5%" height="1"><%=bean.getValue("rptyear") != null ? bean.getValue("rptyear") : ""%></td>
                    <td width="35%" height="1"><a href=MC003W.jsp?act=Edit&bank_no=<%=bean.getValue("bank_no")%>&rptyear=<%=bean.getValue("rptyear")%>><%=bean.getValue("bank_name")%></a>&nbsp;</td>
                    <td width="10%" height="1"><%=bean.getValue("come_date") != null ? bean.getValue("come_date") : ""%></td>
                    <td width="15%" height="1"><%=bean.getValue("come_docno") != null ? bean.getValue("come_docno") : ""%></td>
                    <td width="10%" height="1"><%=bean.getValue("sn_date") != null ? bean.getValue("sn_date") : ""%></td>
                    <td width="15%" height="1"><%=bean.getValue("sn_docno") != null ? bean.getValue("sn_docno") : ""%></td>
                    <td width="10%" height="1"><%=bean.getValue("content") != null ? bean.getValue("content") : ""%></td>
                  </tr>         
      <% }//end of for bean_sub      
      }else {%>   
     <tr bgcolor="#EBF4E1" class="sbody">
        <td width="100%" colspan='7' align='center'><font color="#FF0000">查無符合資料</font></td>
      </tr>
<%    }
}   %>      
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
		   
        <% } else if(act.equals("Qry")) {%>
            <li>本網頁提供基本資料查詢功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li> 
		    <li>按<font color="#666666">【機構名稱】連結</font>則可查看此筆資料。</li>
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
<script language="JavaScript" >
<!--
setSelect(form.bankType,"<%=bankType%>");
//changeOption('TBankXML',form.tbank, form.bankType, 'TBankXML');
changeCity("CityXML") ;
changeTbank("TBankXML");
setSelect(form.tbank,"<%=tbank%>");
setSelect(form.Come_begM,"<%=Come_begM%>");
setSelect(form.Come_endM,"<%=Come_endM%>");
setSelect(form.Come_begD,"<%=Come_begD%>");
setSelect(form.Come_endD,"<%=Come_endD%>");
setSelect(form.Sn_begM,"<%=Sn_begM%>");
setSelect(form.Sn_endM,"<%=Sn_endM%>");
setSelect(form.Sn_begD,"<%=Sn_begD%>");
setSelect(form.Sn_endD,"<%=Sn_endD%>");
setSelect(form.cityType,"<%=cityType%>");
-->
</script>

</HTML>
