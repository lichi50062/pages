<%
//105.10.07 create by 2968
//106.08.02 fix 調整貸款日期,100年以前會讀取錯誤 by 2295
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
    
	System.out.println("Page: FL004W_List.jsp Action:"+act);
    Properties permission = ( session.getAttribute("FL004W")==null ) ? new Properties() : (Properties)session.getAttribute("FL004W");
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
    
	List LoanItemList = (List)request.getAttribute("LoanItemList");
	List DefCaseList = (List)request.getAttribute("DefCaseList");
	if(DefCaseList!=null) {
		// XML Ducument for 缺失情節  begin
	    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"CaseXML\">");
	    out.println("<datalist>");
	    for(int i=0;i< DefCaseList.size(); i++) {
	    	DataObject bean =(DataObject)DefCaseList.get(i);
	        out.println("<data>");
	        out.println("<kind>"+bean.getValue("def_kind")+"</kind>");
	        out.println("<kindName>"+bean.getValue("def_kindname")+"</kindName>");
	        out.println("<type>"+bean.getValue("def_type")+"</type>");
	        out.println("<typeName>"+bean.getValue("cmuse_name").toString()+"</typeName>");
	        out.println("<case>"+bean.getValue("def_case")+"</case>");
	        out.println("<caseName>"+bean.getValue("case_name").toString()+"</caseName>");
	        out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	    // XML Ducument for 缺失情節 end
    }
	
    String begY="",begM="",begD="",loanY="",loanM="",loanD="";	
    String begSeasonY="",begSeasonS="";
    String ex_Type = request.getAttribute("ex_Type") ==null?"":(String)request.getAttribute("ex_Type");
    String ex_No = request.getAttribute("ex_No") ==null?"":(String)request.getAttribute("ex_No") ;
    String bank_No = request.getAttribute("bank_No") ==null?"":(String)request.getAttribute("bank_No") ;
    String def_Seq = request.getAttribute("def_Seq") ==null?"":(String)request.getAttribute("def_Seq") ;
    String bank_Name = request.getAttribute("bank_Name") ==null?"":(String)request.getAttribute("bank_Name") ;
    String ex_No_List = request.getAttribute("ex_No_List") ==null?"":(String)request.getAttribute("ex_No_List") ;
    String ex_Type_Name="",ex_Kind="";
    String loan_Name="",loan_Date="",loan_Item="",loan_Amt="",ex_Result="",def_Type="",def_Case="",memo="",tmp_loan_Date="";
    List EditInfo = (List)request.getAttribute("EditInfo");
    if(EditInfo != null && EditInfo.size() > 0 ){
		for(int i=0;i<EditInfo.size();i++){
			ex_Type=(String)((DataObject)EditInfo.get(i)).getValue("ex_type");
			ex_Type_Name=(String)((DataObject)EditInfo.get(i)).getValue("ex_type_name");
			ex_No=(String)((DataObject)EditInfo.get(i)).getValue("ex_no");
			ex_No_List=(String)((DataObject)EditInfo.get(i)).getValue("ex_no_list");
			bank_No=(String)((DataObject)EditInfo.get(i)).getValue("bank_no");
			bank_Name=(String)((DataObject)EditInfo.get(i)).getValue("bank_name");
			def_Seq=(String)((DataObject)EditInfo.get(i)).getValue("def_seq");
			ex_Kind= ((DataObject)EditInfo.get(i)).getValue("ex_kind")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("ex_kind");
		    loan_Name=((DataObject)EditInfo.get(i)).getValue("loan_name")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("loan_name");
		    loan_Date=((DataObject)EditInfo.get(i)).getValue("loan_date")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("loan_date");
		    loan_Item=((DataObject)EditInfo.get(i)).getValue("loan_item")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("loan_item");
		    loan_Amt=((DataObject)EditInfo.get(i)).getValue("loan_amt")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("loan_amt");
		    ex_Result=((DataObject)EditInfo.get(i)).getValue("ex_result")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("ex_result");
		    def_Type=((DataObject)EditInfo.get(i)).getValue("def_type")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("def_type");
		    def_Case=((DataObject)EditInfo.get(i)).getValue("def_case")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("def_case");
		    memo=((DataObject)EditInfo.get(i)).getValue("memo")==null?"":(String)((DataObject)EditInfo.get(i)).getValue("memo");
		    System.out.println("loan_Date="+loan_Date);
		    
			if(!"".equals(loan_Date)){//106.08.02調整貸款日期,100年以前會讀取錯誤
				if(String.valueOf(Integer.parseInt(loan_Date)-19110000).length() != 7){
				   tmp_loan_Date = "0"+String.valueOf(Integer.parseInt(loan_Date)-19110000);
				   //System.out.println("tmp_loan_Date1="+tmp_loan_Date);	
				}else{
				   tmp_loan_Date = String.valueOf(Integer.parseInt(loan_Date)-19110000);
				   //System.out.println("tmp_loan_Date2="+tmp_loan_Date);	
				}	
				
				loanY=tmp_loan_Date.substring(0, 3);
				loanM=tmp_loan_Date.substring(3, 5);
				loanD=tmp_loan_Date.substring(5, 7);
			}
		}
	}
    if(!"".equals(bank_No)){
    	
    }
    if("".equals(ex_Type))ex_Type="FEB";
	if(!"".equals(ex_No) && "AGRI".equals(ex_Type)){
		begSeasonY=ex_No.substring(0, ex_No.length()-2);
		begSeasonS=ex_No.substring(ex_No.length()-2, ex_No.length());
	}else if(!"".equals(ex_No) && "BOAF".equals(ex_Type)){
		begY=String.valueOf(Integer.parseInt(ex_No)-19110000).substring(0, 3);
		begM=String.valueOf(Integer.parseInt(ex_No)-19110000).substring(3, 5);
		begD=String.valueOf(Integer.parseInt(ex_No)-19110000).substring(5, 7);
	}
%>

<HTML>
<HEAD>
<TITLE>專案農貸查核情形維護作業</TITLE>
<script language="javascript" src="js/jquery-3.5.1.min.js"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/PopupCal.js"></script>
<script language="javascript" src="js/FL004W.js"></script>
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
<Form name='form' method=post action='/pages/FL004W.jsp'>
<input type='hidden' name="act" value='<%=act%>'>
<input type='hidden' name="begDate" >
<input type='hidden' name="begSeason" >
<input type='hidden' name="loanDate" >
<input type='hidden' name="def_Seq" value='<%=def_Seq%>'> 
<input type='hidden' name='insEx_No' value='<%=ex_No%>'>
<table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="35%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="30%"><font color='#000000' size=4><b><center>專案農貸查核情形維護作業</center></b></font> </td>
           <td width="35%"><img src="images/banner_bg1.gif" width="113%" height="17"></td>
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

<%if("New".equals(act)){ %>
	<tr class="sbody">
		<td width="118" bgcolor="#BDDE9C" height="1">查核類別</td>
		<td bgcolor="#EBF4E1" height="1">
	  		<input type='radio' name='ex_Type' id='ex_Type' value='FEB'  onClick="changeEx_Type(form,'FEB');">金管會檢查報告&nbsp;
	  		<input type='radio' name='ex_Type' id='ex_Type' value='AGRI' onClick="changeEx_Type(form,'AGRI');">農業金庫查核&nbsp;
	  		<input type='radio' name='ex_Type' id='ex_Type' value='BOAF' onClick="changeEx_Type(form,'BOAF');">農金局訪查&nbsp;
	   	</td>
	</tr>
	<tr class="sbody" id="showFEB" style="display:none">
	       <td width="118" bgcolor="#BDDE9C" height="1">檢查報告編號</td>
	       <td bgcolor="#EBF4E1" height="1">
	       <input type="text" name="ex_No" value='<%=ex_No %>' maxlength='10'>
	       &nbsp;&nbsp;<font color='red'>＊</font>
	</tr> 
	<tr class="sbody" id="showBOAF" style="display:none">
	    <td width="118" bgcolor="#BDDE9C" height="1">訪查日期</td>
	    <td bgcolor="#EBF4E1" height="1">
	    <input type='text' name='begY' value="<%=begY%>" size='3' maxlength='3' onblur='CheckYear(this)' >    
	    <font color='#000000'>年
	    <select name=begM>
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
	    <select name=begD>
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
	            &nbsp;&nbsp;<font color='red'>＊</font>
		</td>
	</tr>        
	<tr class="sbody" id="showAGRI" style="display:none">
	    <td width="118" bgcolor="#BDDE9C" height="1">查核季別</td>
	    <td bgcolor="#EBF4E1" height="1">
	    <input type='text' name='begSeasonY' value="<%=begSeasonY%>" size='3' maxlength='3' onblur='CheckYear(this)' >    
	    	年
	    <select name='begSeasonS'>
	    <option></option>
	    <%
	    	for (int j = 1; j <= 4; j++) {%>        	
	    	<option value=0<%=j%>>0<%=j%></option>        		
	    <%}%>
	    </select>季
	            &nbsp;&nbsp;<font color='red'>＊</font>
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
	  </select> 
	  &nbsp;&nbsp;<font color='red'>＊</font>
	  </td>
	</tr> 
<%}else{ %>
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
	    	<input type='hidden' name='ex_No_List' value='<%=ex_No_List%>'>
	    </td>
	</tr> 
	<tr class="sbody">
		<td width="118" bgcolor="#BDDE9C" height="1">受檢單位</td>
		<td bgcolor="#EBF4E1" height="1"> 
			<%=bank_No %>&nbsp;<%=bank_Name %> 
			<input type='hidden' name='tbank' value='<%=bank_No%>'>
			<input type='hidden' name='bank_No' value='<%=bank_No%>'>
			<input type='hidden' name='bank_Name' value='<%=bank_Name%>'>
	  	</td>
	</tr>
<%} %>


<tr class="sbody" >
    <td width="118" bgcolor="#BDDE9C" height="1">抽查範圍</td>
    <td bgcolor="#EBF4E1" height="1">
		<input type='radio' name='ex_Kind' value='C' onclick="ctrEx_Kind('C');changeDefType();" checked>個案&nbsp;
		<input type='radio' name='ex_Kind' value='A' onclick="ctrEx_Kind('A');changeDefType();">內部稽核及自行查核&nbsp;
		<div id="showEx_KindR" style="display:none">
			<input type='radio' name='ex_Kind' value='R' onclick="ctrEx_Kind('R');changeDefType();">定期性報表作業&nbsp;
		</div>
		&nbsp;&nbsp;<font color='red'>＊</font>
    </td>
</tr>
<tr class="sbody" id="showLoan1" style="display:none">
    <td width="118" bgcolor="#BDDE9C" height="1">借款人名稱</td>
    <td bgcolor="#EBF4E1" height="1">
		<input type='text' name='loan_Name' value='<%=loan_Name %>' size='50' maxlength='100'>
    </td>
</tr>
<tr class="sbody" id="showLoan2" style="display:none">
    <td width="118" bgcolor="#BDDE9C" height="1">貸款日期</td>
    <td bgcolor="#EBF4E1" height="1">
    <input type='text' name='loanY' value="<%=loanY%>" size='3' maxlength='3' onblur='CheckYear(this)'>
	    <font color='#000000'>年
	    <select name=loanM>
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
	    <select name=loanD>
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
	    		<button name='button3' onclick="popupCal('form','loanY,loanM,loanD','BTN_date_3',event); return false;">
				<img align="absmiddle" border='0' name='BTN_date_3' src='images/clander.gif'>
				</button>
    </td>
</tr>
<tr class="sbody" id="showLoan3" style="display:none">
    <td width="118" bgcolor="#BDDE9C" height="1">貸款種類</td>
    <td bgcolor="#EBF4E1" height="1">
    	<select size="1" name="loan_Item" >
	     	<option value="">請選擇</option>
	     <%for(int i=0;i<LoanItemList.size();i++){ 
			DataObject b =(DataObject)LoanItemList.get(i);%>
	     	<option value="<%=b.getValue("loan_item")%>"><%=b.getValue("loan_item_name")%></option>
	     <%} %>
	  	</select>
    </td>
</tr>
<tr class="sbody" id="showLoan4" style="display:none">
    <td width="118" bgcolor="#BDDE9C" height="1">貸款金額(元)</td>
    <td bgcolor="#EBF4E1" height="1" >
    <input type='text' name='loan_Amt' value='<%=loan_Amt %>' maxlength='14' >
    </td>
</tr>
<tr class="sbody" id="showEx_Result" style="display:none">
    <td width="118" bgcolor="#BDDE9C" height="1">查核結果</td>
    <td bgcolor="#EBF4E1" height="1">
    <input type='radio' name='ex_Result' value='0' onClick="ctrDefType('0');" >尚無不妥
    <input type='radio' name='ex_Result' value='1' onClick="ctrDefType('1');" checked>核有缺失
    </td>
</tr>
<tr class="sbody" id="showDefType" style="display:none">
    <td width="118" bgcolor="#BDDE9C" height="1">缺失內容</td>
    <td bgcolor="#EBF4E1" height="1">
      <select style=" width: 150px;" name="def_Type" id="def_Type" onchange="changeDefCase();">
	  </select>
	  &nbsp;&nbsp;&nbsp;
	  <select style=" width: 300px;" name="def_Case" id="def_Case">
	  </select>
    </td>
</tr>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">備註</td>
    <td bgcolor="#EBF4E1" height="1">
    <textarea name='memo' cols="85" rows="3" maxlength='200'><%=memo %></textarea>
    </td>
</tr>
</Table>
<table border=0 align=center width="835">
	<tr align=center>
		<td ><div align="center">
		<%if("New".equals(act)){ %> 
			<div id="showAddBtn1" style="display:none">
	    		<input type='button' value=' 查核內容新增 ' onClick="doSubmit(form,'Insert');">
	    	</div>
	    	<div id="showAddBtn2" style="display:none">
	    		<input type='button' value=' 缺失內容新增 ' onClick="doSubmit(form,'Insert');">
	    	</div>
	    	<input type='button' value=' 同一個案缺失內容新增 ' onClick="doSubmit(form,'Insert');">
	    	<input type='button' value=' 回上一頁 ' onClick="doSubmit(form,'DetailList');">
	    <%}else{ %>
	    	<input type='button' value=' 修改 ' onClick="doSubmit(form,'Update');">
	    	<input type='button' value=' 刪除 ' onClick="doSubmit(form,'Delete');">
	    	<input type='button' value=' 回上一頁 ' onClick="doSubmit(form,'DetailList');">
	    	<%if("FEB".equals(ex_Type)){ %>
	    	<input type='button' value=' 同一個案缺失內容新增 ' onClick="doSubmit(form,'Insert');">
	    	<%} %>
	    <%} %>
	    </div></td> 
	</tr>
</Table>


</form>
</BODY>
<script language="JavaScript" >
<!--
if('<%=act%>'=='New' ){
	if('<%=ex_Type%>' !=''){
		if('<%=ex_Type%>'=='FEB') form.ex_Type[0].checked=true;
		if('<%=ex_Type%>'=='AGRI') form.ex_Type[1].checked=true;
		if('<%=ex_Type%>'=='BOAF') form.ex_Type[2].checked=true;
		changeEx_Type(form,'<%=ex_Type%>');
		setSelect(form.begM,"<%=begM%>");
		setSelect(form.begD,"<%=begD%>");
		setSelect(form.cityType,"<%=cityType%>");
		setSelect(form.begSeasonS,"<%=begSeasonS%>");
		setSelect(form.bankType,"<%=bankType%>");
		changeCity() ;
		changeTbank();
		setSelect(form.tbank,"<%=bank_No%>");
	}
}else{
	ctrEx_Type(form,'<%=ex_Type%>');
}

if('<%=ex_Kind%>'=='A'){
	form.ex_Kind[1].checked=true;
	ctrEx_Kind('A');
}else if('<%=ex_Kind%>'=='R'){
	form.ex_Kind[2].checked=true;
	ctrEx_Kind('R');
}else{
	form.ex_Kind[0].checked=true;
	ctrEx_Kind('C');
}
setSelect(form.loanM,"<%=loanM%>");
setSelect(form.loanD,"<%=loanD%>");
setSelect(form.loan_Item,"<%=loan_Item%>");
if('<%=ex_Result%>'=='0'){
	form.ex_Result[0].checked=true;
}else{
	form.ex_Result[1].checked=true;
}
ctrDefType('<%=ex_Result%>');
changeDefType();
setSelect(document.def_Type,"<%=def_Type%>");
changeDefCase();
setSelect(document.def_Case,"<%=def_Case%>");

-->
</script>

</HTML>
