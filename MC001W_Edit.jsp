<%
// 97.08.29-09.01 create 違反農金法及其子法而遭罰款 by 2295
// 99.05.26 fix 縣市合併調整&sql injection by 2808
//101.05.07 add 處分方式 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.StringTokenizer" %>
<%
    String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");	
    Properties permission = ( session.getAttribute("MC001W")==null ) ? new Properties() : (Properties)session.getAttribute("MC001W");
    if(permission == null){
       System.out.println("MC001W_Edit.permission == null");
    }else{
       System.out.println("MC001W_Edit.permission.size ="+permission.size());
    }			
    System.out.println("Page: MC001W_Edit.jsp    Action:"+act);

    String tbank="",bank_name="",content="",law_content="",title="",violate_type="",violate_date="";
    String lawSuit_Item="",lawSuit_Date="",lawSuit_Reason="",reply_Doc="",lawSuit_Result="",isSue="";
    List violate_type_list=new ArrayList();
    String bankType = Utility.getTrimString(request.getParameter("bankType" ));    
    String cityType = Utility.getTrimString(request.getParameter("cityType" ));
    String begDate = Utility.getTrimString(request.getParameter("begDate" ));
    String endDate = Utility.getTrimString(request.getParameter("endDate" ));
   
	// 轉換西元年到民國年
	Calendar c = Calendar.getInstance();
	String begY = String.valueOf(c.get(Calendar.YEAR)-1911);
	if(begDate.length() > 6 )
	    begY = String.valueOf(Integer.parseInt(begDate.substring(0,4))-1911);	
	int begM = c.get(Calendar.MONTH)+1;
	if(begDate.length() > 6 )
	    begM = Integer.parseInt(begDate.substring(4,6));	
  	int begD = 1;
  	String lawSuitY=begY; String govY=begY;String replyY=begY; String lawSuit_DecY=begY; 
	int lawSuitM=begM; int govM=begM;int replyM=begM; int lawSuit_DecM=begM;
	int lawSuitD=begD; int govD=begD;int replyD=begD; int lawSuit_DecD=begD;
    	List tBankList = (List)request.getAttribute("TBank");
    	if(tBankList!=null) {
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
    	}
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
    if(act.equals("Edit")) {
        DataObject bean = (DataObject) request.getAttribute("DETAIL");
        if(bean != null) {
            tbank = Utility.getTrimString(bean.getValue("bank_no"));
            bank_name = Utility.getTrimString(bean.getValue("bank_name"));           
            violate_type = Utility.getTrimString(bean.getValue("violate_type"));
            violate_date = Utility.getTrimString(bean.getValue("violate_date_1"));
            content = Utility.getTrimString(bean.getValue("content"));
            law_content = Utility.getTrimString(bean.getValue("law_content"));
            title = Utility.getTrimString(bean.getValue("title"));
            violate_type_list = Utility.getStringTokenizerData(violate_type,":");
            begY = Utility.getTrimString(bean.getValue("begy"));
            if(!"".equals(Utility.getTrimString(bean.getValue("begm")))){
            	begM = Integer.parseInt(String.valueOf(bean.getValue("begm")));
            }
            if(!"".equals(Utility.getTrimString(bean.getValue("begd")))){
            	begD = Integer.parseInt(String.valueOf(bean.getValue("begd")));
            }
            lawSuitY = Utility.getTrimString(bean.getValue("lawsuity"));
            if(!"".equals(Utility.getTrimString(bean.getValue("lawsuitm")))){
            	lawSuitM = Integer.parseInt(String.valueOf(bean.getValue("lawsuitm")));
            }
            if(!"".equals(Utility.getTrimString(bean.getValue("lawsuitd")))){
            	lawSuitD = Integer.parseInt(String.valueOf(bean.getValue("lawsuitd")));
            }
            govY = Utility.getTrimString(bean.getValue("govy"));
            if(!"".equals(Utility.getTrimString(bean.getValue("govm")))){
            	govM = Integer.parseInt(String.valueOf(bean.getValue("govm")));
            }
            if(!"".equals(Utility.getTrimString(bean.getValue("govd")))){
            	govD = Integer.parseInt(String.valueOf(bean.getValue("govd")));
            }
            replyY = Utility.getTrimString(bean.getValue("replyy"));
            if(!"".equals(Utility.getTrimString(bean.getValue("replym")))){
            	replyM = Integer.parseInt(String.valueOf(bean.getValue("replym")));
            }
            if(!"".equals(Utility.getTrimString(bean.getValue("replyd")))){
            	replyD = Integer.parseInt(String.valueOf(bean.getValue("replyd")));
            }
            lawSuit_DecY = Utility.getTrimString(bean.getValue("lawsuit_decy"));
            if(!"".equals(Utility.getTrimString(bean.getValue("lawsuit_decm")))){
            	lawSuit_DecM = Integer.parseInt(String.valueOf(bean.getValue("lawsuit_decm")));
            }
            if(!"".equals(Utility.getTrimString(bean.getValue("lawsuit_decd")))){
            	lawSuit_DecD = Integer.parseInt(String.valueOf(bean.getValue("lawsuit_decd")));
            }
            lawSuit_Item = Utility.getTrimString(bean.getValue("lawsuit_item"));
            lawSuit_Date = Utility.getTrimString(bean.getValue("lawsuit_date"));
            lawSuit_Reason = Utility.getTrimString(bean.getValue("lawsuit_reason"));
            reply_Doc = Utility.getTrimString(bean.getValue("reply_doc"));
            lawSuit_Result = Utility.getTrimString(bean.getValue("lawsuit_result"));
            isSue = Utility.getTrimString(bean.getValue("issue"));
            
        }
    }
    
    
    List paramList = new ArrayList();
	StringBuffer sql = new StringBuffer();
		
	sql.append(" select cmuse_id,cmuse_name from cdshareno where cmuse_div=? and cmuse_id != '7' order by input_order"); 
	paramList.add("038");		
	List violate_type_dbdate = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"");
	sql = new StringBuffer();
	paramList.clear();
	sql.append(" select cmuse_id,cmuse_name from cdshareno where cmuse_div=? order by input_order"); 
	paramList.add("046");		
	List resultList = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"");
    DataObject bean = null;
    String pgName = Utility.getPgName("MC001W");
%>

<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<TITLE>違反農金法及其子法而遭處分增加訴願案件資料</TITLE>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/MC001W.js"></script>
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
<Form name='form' method=post  enctype="multipart/form-data">
<input type='hidden' name="act" value=''>
<input type='hidden' name='preTbank' value='<%=tbank %>'>
<input type='hidden' name="preViolate_Date" value='<%=violate_date %>'>
<input type='hidden' name='reply_doc' value='<%=reply_Doc%>'>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="50%"><font color='#000000' size=4><b><center><%=pgName%></center></b></font> </td>
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
<td width="118" bgcolor="#BDDE9C" height="1">受處分機構</td>
<td width="416" bgcolor="#EBF4E1" height="1"> 
  <select size="1" name="tbank" >
    <option value="" >全部</option>
  </select>  </td>
</tr>

<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">受處分日期</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type='hidden' name="violate_Date" value="">
    <input type='text' name='begY' value="<%=begY%>" size='3' maxlength='3' onblur='CheckYear(this)' onChange="chnageYear()">
    <font color='#000000'>年
    <select id="hide1" name=begM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(begM == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(begM == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>月
    <select id="hide1" name=begD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(begD == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(begD == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>日</font>
	</td>  
</tr>    
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">處分方式</td>
<td width="416" bgcolor="#EBF4E1" height="1">
	<input type='hidden' name='violate_Type' >  
  	<%if(violate_type_dbdate !=null && violate_type_dbdate.size()>0){
	  	for(int i=0;i<violate_type_dbdate.size();i++){
		    bean = (DataObject)violate_type_dbdate.get(i);
		  	%>
		  	<input type="checkbox" name="violate_type" value="<%=bean.getValue("cmuse_id")%>" 
		  	<%
		  	if(violate_type_list !=null && violate_type_list.size()>0){
			  	for(int j=0;j<violate_type_list.size();j++){
			  		if(((String)violate_type_list.get(j)).equals(bean.getValue("cmuse_id"))) out.print(" checked ");
		  		}
			}%>
	  		><%=bean.getValue("cmuse_name")%>    
    	<%}
	}%>
  </td>
</tr>
<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">主旨</td>
  <td width="416" bgcolor="#EBF4E1" height="20">
  <textarea rows="2" cols="50" name='title' maxlength='1000'><%=title%></textarea>   
  </td>
</tr>

<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">說明</td>
  <td width="416" bgcolor="#EBF4E1" height="20">
  <textarea rows="3" cols="50" name='content' maxlength='4000'><%=content%></textarea> 
  </td>
</tr>
<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">法令依據</td>
  <td width="416" bgcolor="#EBF4E1" height="20">
  <textarea rows="2" cols="50" name='law_Content' maxlength='1000'><%=law_content%></textarea> 
  </td>
</tr>


<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">訴願人</td>
  <td width="416" bgcolor="#EBF4E1" height="20">
  <input type='text' name='lawSuit_Item' size='42' maxlength='50' value='<%=lawSuit_Item %>'>
  </td>
</tr>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">訴願日期</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type='hidden' name="lawSuit_Date" value="">
    <input type='text' name='lawSuitY' value="<%=lawSuitY%>" size='3' maxlength='3' onblur='CheckYear(this)' >
    <font color='#000000'>年
    <select id="hide1" name=lawSuitM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(lawSuitM == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(lawSuitM == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>月
    <select id="hide1" name=lawSuitD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(lawSuitD == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(lawSuitD == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>日</font>
	</td>  
</tr> 
<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">訴願案由</td>
  <td width="416" bgcolor="#EBF4E1" height="20">
  <textarea rows="2" cols="50" name='lawSuit_Reason' maxlength='4000'><%=lawSuit_Reason %></textarea>   
  </td>
</tr>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1" ><nobr>移送訴願管轄機關日期</nobr></td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type='hidden' name="gov_Date" value="">
    <input type='text' name='govY' value="<%=govY%>" size='3' maxlength='3' onblur='CheckYear(this)' >
    <font color='#000000'>年
    <select id="hide1" name=govM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(govM == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(govM == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>月
    <select id="hide1" name=govD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(govD == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(govD == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>日</font>
	</td>  
</tr>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">檢卷答辯日期</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type='hidden' name="reply_Date" value="">
    <input type='text' name='replyY' value="<%=replyY%>" size='3' maxlength='3' onblur='CheckYear(this)' >
    <font color='#000000'>年
    <select id="hide1" name=replyM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(replyM == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(replyM == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>月
    <select id="hide1" name=replyD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(replyD == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(replyD == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>日</font>
	</td>  
</tr>
<tr class="sbody">
	<td width="118" bgcolor="#BDDE9C" height="1">訴願答辯書</td>
	<td width="416" bgcolor="#EBF4E1" height="1">
		<input type="file" name="FileType3" value="瀏覽" SIZE=50
		<%if(!"".equals(reply_Doc)){%>
			onClick="if(true){ this.form.FileType3.disabled = true} alert('若是要上傳新檔案,請先刪除原始檔案');"
		<%}%>
		> 
	</td>              
</tr>                            

<%if(act.equals("Edit")){%>
<tr class="sbody">
	<td width="118" bgcolor="#BDDE9C" height="1"><nobr>已上傳的訴願答辯書檔案</nobr></td>
	<td width="416" bgcolor="#EBF4E1" height="1">
	<%if(!"".equals(reply_Doc)){%>
		<%=reply_Doc%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="submit" name="ResetLoad" value="刪除"  onClick="javascript:doSubmit(this.document.forms[0],'Clear','');">&nbsp;&nbsp;&nbsp;
		<input type="submit" name="ResetLoad" value="開啟檔案"  onClick="javascript:doSubmit(this.document.forms[0],'Open','');">                           
	<%} %>
	</td>
</tr>
<%} %>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">訴願決定日期</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type='hidden' name="lawSuit_DecDate" value="" >
    <input type='text' name='lawSuit_DecY' value="<%=lawSuit_DecY%>" size='3' maxlength='3' onblur='CheckYear(this)' >
    <font color='#000000'>年
    <select id="hide1" name=lawSuit_DecM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(lawSuit_DecM == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(lawSuit_DecM == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>月
    <select id="hide1" name=lawSuit_DecD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(lawSuit_DecD == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(lawSuit_DecD == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>日</font>
	</td>  
</tr>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">訴願決定結果</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type='hidden' name='lawSuit_Result' >
    <%bean = null;
    if(resultList!=null && resultList.size()>0){
     for(int i=0;i<resultList.size();i++){ 
    	bean = (DataObject)resultList.get(i); %>
    	<input type='radio' name="lawsuit_result" value="<%=bean.getValue("cmuse_id") %>" <%if((lawSuit_Result).equals(bean.getValue("cmuse_id"))){ %>checked<%} %>><%=bean.getValue("cmuse_name") %>
    <%}} %>
	</td>  
</tr>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">有無提起行政訴訟</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    	<input type='hidden' name='isSue'>
    	<input type='radio' name="issue" value="Y" <%if(!"N".equals(isSue)){ %>checked<%} %>>有
    	<input type='radio' name="issue" value="N" <%if("N".equals(isSue)){ %>checked<%} %>>無
	</td>  
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
				        <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'add','<%=tbank%>');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a></div></td>
				        <% } }else{
				        if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){//Update %>
				        <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'modify','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a></div></td>
				        <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'delete','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a></div></td>
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

<script language="JavaScript" >
<!--
setSelect(form.bankType,"<%=bankType%>");
changeCity("CityXML") ;
changeTbank("TBankXML");
setSelect(form.cityType,"<%=cityType%>");
setSelect(form.tbank,"<%=tbank%>");
<%if(act.equals("New")){%>
setSelect(form.begM,"<%=begM%>");
setSelect(form.begD,"1");
setSelect(form.govM,"<%=govM%>");
setSelect(form.govD,"1");
setSelect(form.replyM,"<%=replyM%>");
setSelect(form.replyD,"1");
setSelect(form.lawSuit_DecM,"<%=lawSuit_DecM%>");
setSelect(form.lawSuit_DecD,"1");
<%}%>

-->
</script>

</HTML>
