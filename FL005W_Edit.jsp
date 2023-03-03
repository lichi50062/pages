<%
//105.10.13 create by 2968
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
	String bankType = Utility.getTrimString(dataMap.get("bankType")) ;//農漁會別    
    String tbank = Utility.getTrimString(dataMap.get("tbank")) ;//受檢單位
    String cityType = Utility.getTrimString(dataMap.get("cityType")) ; //縣市別
	System.out.println("Page: FL005W_List.jsp Action:"+act);
    Properties permission = ( session.getAttribute("FL005W")==null ) ? new Properties() : (Properties)session.getAttribute("FL005W");
    
    List DocTypeList = (List)request.getAttribute("DocTypeList");
    List AuditTypeList = (List)request.getAttribute("AuditTypeList");
		  
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
	List AuditIdList = (List)request.getAttribute("AuditIdList");
	if(AuditIdList!=null) {
		// XML Ducument for 核處情形 begin
	    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"AuditIdXML\">");
	    out.println("<datalist>");
	    for(int i=0;i< AuditIdList.size(); i++) {
	    	DataObject bean =(DataObject)AuditIdList.get(i);
	        out.println("<data>");
	        out.println("<audit_type>"+bean.getValue("audit_type")+"</audit_type>");
	        out.println("<audit_id>"+bean.getValue("audit_id")+"</audit_id>");
	        out.println("<audit_case>"+bean.getValue("audit_case")+"</audit_case>");
	        out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	    // XML Ducument for 核處情形 end
    }
	List DefDetailList = (List)request.getAttribute("DefDetailList");
	if(DefDetailList!=null) {
		// XML Ducument for  begin
	    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"DetailXML\">");
	    out.println("<datalist>");
	    for(int i=0;i< DefDetailList.size(); i++) {
	    	DataObject bean =(DataObject)DefDetailList.get(i);
	        out.println("<data>");
	        out.println("<bank_no>"+bean.getValue("bank_no")+"</bank_no>");
	        out.println("<ex_type>"+bean.getValue("ex_type")+"</ex_type>");
	        out.println("<ex_no>"+bean.getValue("ex_no")+"</ex_no>");
	        out.println("<ex_no_list>"+bean.getValue("ex_no_list")+"</ex_no_list>");
	        out.println("<ex_kind>"+bean.getValue("ex_kind")+"</ex_kind>");
	        out.println("<def_seq>"+bean.getValue("def_seq")+"</def_seq>");
	        out.println("<loan_name>"+bean.getValue("loan_name")+"</loan_name>");
	        out.println("<loan_date>"+bean.getValue("loan_date")+"</loan_date>");
	        out.println("<loan_item>"+bean.getValue("loan_item")+"</loan_item>");
	        out.println("<loan_item_name>"+bean.getValue("loan_item_name")+"</loan_item_name>");
	        out.println("<loan_amt>"+bean.getValue("loan_amt")+"</loan_amt>");
	        out.println("<def_type>"+bean.getValue("def_type")+"</def_type>");
	        out.println("<def_case>"+bean.getValue("def_case")+"</def_case>");
	        out.println("<case_name>"+bean.getValue("case_name")+"</case_name>");
	        out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	    // XML Ducument for end
    }
	
    String docY="",docM="",docD="",limitY="",limitM="",limitD="";	
    String doc_Date="",docNo="",bank_No="",bank_Name="",ex_Type="",ex_Type_Name="",ex_No="",ex_No_List="";
    String def_Seq="",doc_Type="",audit_Type="",audit_Id="",limitDate="",non_Loan_Amt="",loan_Year="";
    String change_Loan_Year="",audit_Id_C1="",audit_Id_C2="",fine_Amt="",bank_Rt_DocNo="",ag_Rt_DocNo="";
    List EditInfo = (List)request.getAttribute("EditInfo");
    if(EditInfo != null && EditInfo.size() > 0 ){
		for(int i=0;i<EditInfo.size();i++){
			doc_Date =((DataObject)EditInfo.get(i)).getValue("doc_date")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("doc_date");
			docNo=((DataObject)EditInfo.get(i)).getValue("docno")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("docno");
			bank_No=((DataObject)EditInfo.get(i)).getValue("bank_no")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("bank_no");
			bank_Name=((DataObject)EditInfo.get(i)).getValue("bank_name")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("bank_name");
			ex_Type=((DataObject)EditInfo.get(i)).getValue("ex_type")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("ex_type");
			ex_Type_Name=((DataObject)EditInfo.get(i)).getValue("ex_type_name")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("ex_type_name");
			ex_No=((DataObject)EditInfo.get(i)).getValue("ex_no")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("ex_no");
			ex_No_List=((DataObject)EditInfo.get(i)).getValue("ex_no_list")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("ex_no_list");
			if(!"".equals(def_Seq)){
				def_Seq+=",";
			}
			def_Seq+=((DataObject)EditInfo.get(i)).getValue("def_seq")==null?"":((DataObject)EditInfo.get(i)).getValue("def_seq").toString();
			doc_Type=((DataObject)EditInfo.get(i)).getValue("doc_type")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("doc_type");
			audit_Type=((DataObject)EditInfo.get(i)).getValue("audit_type")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("audit_type");
			audit_Id=((DataObject)EditInfo.get(i)).getValue("audit_id")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("audit_id");
			limitDate=((DataObject)EditInfo.get(i)).getValue("limitdate")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("limitdate");
			non_Loan_Amt=((DataObject)EditInfo.get(i)).getValue("non_loan_amt")==null?"":((DataObject)EditInfo.get(i)).getValue("non_loan_amt").toString();
			loan_Year=((DataObject)EditInfo.get(i)).getValue("loan_year")==null?"":((DataObject)EditInfo.get(i)).getValue("loan_year").toString();
			change_Loan_Year=((DataObject)EditInfo.get(i)).getValue("change_loan_year")==null?"":((DataObject)EditInfo.get(i)).getValue("change_loan_year").toString();
			audit_Id_C1=((DataObject)EditInfo.get(i)).getValue("audit_id_c1")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("audit_id_c1");
			audit_Id_C2=((DataObject)EditInfo.get(i)).getValue("audit_id_c2")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("audit_id_c2");
			fine_Amt=((DataObject)EditInfo.get(i)).getValue("fine_amt")==null?"":((DataObject)EditInfo.get(i)).getValue("fine_amt").toString();
			bank_Rt_DocNo=((DataObject)EditInfo.get(i)).getValue("bank_rt_docno")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("bank_rt_docno");
			ag_Rt_DocNo=((DataObject)EditInfo.get(i)).getValue("ag_rt_docno")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("ag_rt_docno");

			if(!"".equals(doc_Date)){
				docY=String.valueOf(Integer.parseInt(doc_Date)-19110000).substring(0, 3);
				docM=String.valueOf(Integer.parseInt(doc_Date)-19110000).substring(3, 5);
				docD=String.valueOf(Integer.parseInt(doc_Date)-19110000).substring(5, 7);
			}
			if(!"".equals(limitDate)){
				limitY=String.valueOf(Integer.parseInt(limitDate)-19110000).substring(0, 3);
				limitM=String.valueOf(Integer.parseInt(limitDate)-19110000).substring(3, 5);
				limitD=String.valueOf(Integer.parseInt(limitDate)-19110000).substring(5, 7);
			}
		}
	}
    if("".equals(ex_Type))ex_Type="FEB";
	
%>

<HTML>
<HEAD>
<TITLE>專案農貸查核缺失發文維護作業</TITLE>
<script language="javascript" src="js/jquery-3.5.1.min.js"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/PopupCal.js"></script>
<script language="javascript" src="js/FL005W.js"></script>
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
<Form name='form' method=post action='/pages/FL005W.jsp'>
<input type='hidden' name="act" value='<%=act%>'>
<input type='hidden' name="doc_Date" >
<input type='hidden' name="limitDate" >
<input type='hidden' name='detailCnt'><%//個案明細總筆數 %>
<input type='hidden' name='def_Seq'>
<input type='hidden' name='oriDef_Seq' value='<%=def_Seq%>' >
<input type='hidden' name='oriDocNo' value='<%=docNo%>'>
<input type='hidden' name='oriDocType' value='<%=doc_Type%>'>
<input type='hidden' name='bank_Rt_DocNo' value='<%=bank_Rt_DocNo%>'><%//農漁會回文文號 %>
<input type='hidden' name='ag_Rt_DocNo' value='<%=ag_Rt_DocNo%>'><%//金庫來文文號 %>
<table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="40%"><font color='#000000' size=4><b><center>專案農貸查核缺失發文維護作業</center></b></font> </td>
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

<Table border=1 width='80%' align=center  bgcolor="#FFFFF" bordercolor="#76C657">
	<tr class="sbody">
	    <td width="118" bgcolor="#BDDE9C" height="1">發文日期</td>
	    <td bgcolor="#EBF4E1" height="1">
	    <input type='text' name='docY' value="<%=docY%>" size='3' maxlength='3' onblur='CheckYear(this)' >    
	    <font color='#000000'>年
	    <select name=docM>
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
	    <select name=docD>
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
	    		<button name='button1' onclick="popupCal('form','docY,docM,docD','BTN_date_1',event); return false;">
				<img align="absmiddle" border='0' name='BTN_date_1' src='images/clander.gif'>
				</button>
		</td>
	</tr>   
	<tr class="sbody">
	       <td width="118" bgcolor="#BDDE9C" height="1">發文文號</td>
	       <td bgcolor="#EBF4E1" height="1">
	       <input type="text" name="docNo" value='<%=docNo %>' maxlength='10'>
	       &nbsp;&nbsp;<font color='red'>＊</font>
	</tr>
<%if("New".equals(act)){ %>
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
	  <select size="1" name="tbank" id="tbank" onChange="changeEx_No('DetailXML');">
	    <option value="" >請選擇...</option>
	  </select> 
	  &nbsp;&nbsp;<font color='red'>＊</font>
	  </td>
	</tr> 
	<tr class="sbody">
		<td width="118" bgcolor="#BDDE9C" height="1">查核類別</td>
		<td bgcolor="#EBF4E1" height="1">
	  		<input type='radio' name='ex_Type' id='ex_Type' value='FEB'  onClick="changeEx_Type(form,'FEB');">金管會檢查報告&nbsp;
	  		<input type='radio' name='ex_Type' id='ex_Type' value='AGRI' onClick="changeEx_Type(form,'AGRI');">農業金庫查核&nbsp;
	  		<input type='radio' name='ex_Type' id='ex_Type' value='BOAF' onClick="changeEx_Type(form,'BOAF');">農金局訪查&nbsp;
	   	</td>
	</tr>
	<tr class="sbody">
	       <td width="118" bgcolor="#BDDE9C" height="1"><p id="ex_No_Title"></p></td>
	       <td bgcolor="#EBF4E1" height="1">
	       <select size="1" name="ex_No" id="ex_No" onChange="setDetailList('DetailXML');">
		   </select> 
	       &nbsp;&nbsp;<font color='red'>＊</font>
	</tr> 
<%}else{ %>
	<tr class="sbody">
		<td width="118" bgcolor="#BDDE9C" height="1">受檢單位</td>
		<td bgcolor="#EBF4E1" height="1"> 
			<%=bank_No %>&nbsp;<%=bank_Name %> 
			<input type='hidden' name='tbank' value='<%=bank_No%>'>
			<input type='hidden' name='bank_No' value='<%=bank_No%>'>
	  	</td>
	</tr> 
	<tr class="sbody">
		<td width="118" bgcolor="#BDDE9C" height="1">查核類別</td>
		<td bgcolor="#EBF4E1" height="1">
			<%=ex_Type_Name %>
			<input type='hidden' name='ex_Type' value='<%=ex_Type%>'>
	   	</td>
	</tr>
	
	<tr class="sbody" >
		<td width="118" bgcolor="#BDDE9C" height="1">
		<%if("FEB".equals(ex_Type)){ %>檢查報告編號
		<%}else if("BOAF".equals(ex_Type)){ %>訪查日期
		<%}else if("AGRI".equals(ex_Type)){ %>查核季別
	  	<%} %>
		</td>
	    <td bgcolor="#EBF4E1" height="1">
	    	<%=ex_No_List %>
	    	<input type='hidden' name='ex_No' value='<%=ex_No%>'>
	    </td>
	</tr> 
	
<%} %>


<tr class="sbody" >
    <td width="118" bgcolor="#BDDE9C" height="1">發文性質</td>
    <td bgcolor="#EBF4E1" height="1">
    <%for(int i=0;i<DocTypeList.size();i++){ 
    	DataObject b =(DataObject)DocTypeList.get(i);%>
    	<input type='radio' name='doc_Type' value='<%=b.getValue("cmuse_id") %>' onclick="ctrDetail(document.form);" ><%=b.getValue("cmuse_name") %>&nbsp;
    <%} %>
		&nbsp;&nbsp;<font color='red'>＊</font>
    </td>
</tr>
<tr class="sbody" id="showAuditType" style="display:none">
    <td width="118" bgcolor="#BDDE9C" height="1">核處類別</td>
    <td bgcolor="#EBF4E1" height="1">
		<%for(int i=0;i<AuditTypeList.size();i++){ 
	    	DataObject b =(DataObject)AuditTypeList.get(i);%>
	    	<input type='radio' name='audit_Type' value='<%=b.getValue("cmuse_id") %>' onclick="ctrDetail(document.form);setDetailList('DetailXML');crtAuditIdList('AuditIdXML');" ><%=b.getValue("cmuse_name") %>&nbsp;
	    <%} %>
	    <div id="showPointAuditType" style="display:none">
		&nbsp;&nbsp;<font color='red'>＊</font>
		</div>
    </td>
</tr>
<!-- 缺失個案明細 ----------------------->
<tr id='showDetail' style='display:none'><td colspan='7'><table id='tbl' width='100%' border=1 bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody" bgcolor="#BFDFAE" >
	<td width='145' align='left' rowspan='999'>缺失個案明細</td>
	<td width='30'  align='left'>&nbsp;</td>
	<td width='80' align='left'>借款人名稱</td>
	<td width='60' align='left'>貸款日期</td>
	<td width='80' align='left' nowrap="nowrap">貸款種類</td>
	<td width='75' align='left'>貸款金額(元)</td>
	<td width='80' align='left'>缺失情節</td>
</tr>
<tr bgcolor="#EBF4E1" class="sbody">
	<td colspan='7'><font color='#FF0000'>查無符合資料</font></td>
</tr>			
</table></td></tr>
<!-- ----------------------------- -->

<tr class="sbody" id="showAuditId" style="display:none">
    <td width="118" bgcolor="#BDDE9C" height="1">核處情形</td>
    <td bgcolor="#EBF4E1" height="1">
    	<select size="1" name="audit_Id" onChange='ctrShowAudit(form);'>
	  	</select>
	  	<div id="showPointAuditId" style="display:none">
		&nbsp;&nbsp;<font color='red'>＊</font>
		</div>
    </td>
</tr>

<tr class="sbody" id="showAudit1" style="display:none">
    <td width="118" bgcolor="#BDDE9C" height="1">核處內容</td>
    <td bgcolor="#EBF4E1" height="1" >
    	限期函報期限：
    	<input type='text' name='limitY' value="<%=limitY%>" size='3' maxlength='3' onblur='CheckYear(this)' >    
	    <font color='#000000'>年
	    <select name=limitM>
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
	    <select name=limitD>
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
	    		<button name='button2' onclick="popupCal('form','limitY,limitM,limitD','BTN_date_2',event); return false;">
				<img align="absmiddle" border='0' name='BTN_date_2' src='images/clander.gif'>
				</button>
	            
    </td>
</tr>
<tr class="sbody" id="showAudit2" style="display:none">
    <td width="118" bgcolor="#BDDE9C" height="1">核處內容</td>
    <td bgcolor="#EBF4E1" height="1" >
    	<div id="showAudit2_1" style="display:none">不符規定金額</div>
    	<div id="showAudit3_1" style="display:none">應調整貸款金額</div>
    	：<input type="text" name="non_Loan_Amt" value='<%=non_Loan_Amt %>' maxlength='14'>元
    	<div id="showAudit3" style="display:none">
    	<br>原貸款期限：<input type="text" name="loan_Year" value='<%=loan_Year %>'  size='3'>年
    	<br>修正後貸款期限：<input type="text" name="change_Loan_Year" value='<%=change_Loan_Year %>' size='3'>年
    	</div>
    </td>
</tr>
<tr class="sbody" id="showAudit4" style="display:none">
    <td width="118" bgcolor="#BDDE9C" height="1">核處內容</td>
    <td bgcolor="#EBF4E1" height="1" >
    	<input type='hidden' name='audit_Id_C1'>
    	<input type='hidden' name='audit_Id_C2'>
    	<input type='checkbox' name='c1' >糾正<br>
    	<input type='checkbox' name='c2' >罰鍰&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    	罰鍰金額：<input type="text" name="fine_Amt" value='<%=fine_Amt %>' maxlength='14'>元
    </td>
</tr>
</Table>
<table width='80%' border="0" cellpadding="1" cellspacing="1" class="sbody" >
	<tr>
		<td colspan="2" align='center'>
			<table width="20%" border="0" cellpadding="1" cellspacing="1" >
				<tr>
				<%if(act.equals("New")){%>
					<td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Insert');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a></div></td>
					<td width="66"><div align="center"><a href="javascript:AskReset(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image105" width="66" height="25" border="0" id="Image105"></a></div></td>
				<% }else{%>
					<td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Update');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a></div></td>
					<td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Delete');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a></div></td>
				<% }%>
                        
					<td width="93"><div align="center"><a href="javascript:history.back();"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image106','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image106" width="80" height="25" border="0" id="Image106"></a></div></td>                        
				</tr>
 			</table>
		</td>
	</tr>
</table>
</form>
</BODY>
<script language="JavaScript" >
<!--
setSelect(form.docM,"<%=docM%>");
setSelect(form.docD,"<%=docD%>");
if('<%=act%>'=='New' ){
	if('<%=ex_Type%>' !=''){
		setSelect(form.cityType,"<%=cityType%>");
		setSelect(form.bankType,"<%=bankType%>");
		changeCity("CityXML",'') ;
		changeTbank("TBankXML",'');
		setSelect(form.tbank,"<%=bank_No%>");
		if('<%=ex_Type%>'=='FEB') form.ex_Type[0].checked=true;
		if('<%=ex_Type%>'=='AGRI') form.ex_Type[1].checked=true;
		if('<%=ex_Type%>'=='BOAF') form.ex_Type[2].checked=true;
		changeEx_Type(form,'<%=ex_Type%>');
		setSelect(form.ex_No,"<%=ex_No%>");
	}
}
setRadio(form.doc_Type, '<%=doc_Type%>');
setRadio(form.audit_Type, '<%=audit_Type%>');
ctrDetail(document.form);
if('<%=doc_Type%>'=='B'){
	setDetailList('DetailXML')
	crtAuditIdList('AuditIdXML');
	setSelect(form.audit_Id,"<%=audit_Id%>");
	ctrShowAudit(form);
	setSelect(form.limitM,"<%=limitM%>");
	setSelect(form.limitD,"<%=limitD%>");
	form.limitY.value='<%=limitY%>';
	form.loan_Year.value='<%=loan_Year%>';
	form.change_Loan_Year.value='<%=change_Loan_Year%>';
	form.non_Loan_Amt.value='<%=non_Loan_Amt%>';
	if('<%=audit_Id_C1%>'=='1') form.c1.checked=true;
	if('<%=audit_Id_C2%>'=='1') form.c2.checked=true;
	form.fine_Amt.value='<%=fine_Amt%>';
}
-->
</script>

</HTML>
