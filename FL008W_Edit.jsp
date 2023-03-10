<%
//105.10.31 create by 2968
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
    //String tbank = Utility.getTrimString(dataMap.get("tbank")) ;//受檢單位
    String cityType = Utility.getTrimString(dataMap.get("cityType")) ; //縣市別
	System.out.println("Page: FL008W_List.jsp Action:"+act);
    Properties permission = ( session.getAttribute("FL008W")==null ) ? new Properties() : (Properties)session.getAttribute("FL008W");
    
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
	
	List DetailList = (List)request.getAttribute("DetailList");
	if(DetailList!=null && DetailList.size()>0) {
		// XML Ducument for  begin
	    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"DetailXML\">");
	    out.println("<datalist>");
	    for(int i=0;i< DetailList.size(); i++) {
	    	DataObject bean =(DataObject)DetailList.get(i);
	        out.println("<data>");
	        out.println("<bank_no>"+bean.getValue("bank_no")+"</bank_no>");
	        out.println("<ex_type>"+bean.getValue("ex_type")+"</ex_type>");
	        out.println("<ex_no>"+bean.getValue("ex_no")+"</ex_no>");
	        out.println("<ex_no_list>"+bean.getValue("ex_no_list")+"</ex_no_list>");
	        out.println("<def_seq>"+bean.getValue("def_seq").toString()+"</def_seq>");
	        //out.println("<doc_date>"+bean.getValue("doc_date")+"</doc_date>");
	        //out.println("<docno>"+bean.getValue("docno")+"</docno>");
	        out.println("<loan_name>"+bean.getValue("loan_name")+"</loan_name>");
	        out.println("<loan_date>"+bean.getValue("loan_date")+"</loan_date>");
	        //out.println("<loan_item>"+bean.getValue("loan_item")+"</loan_item>");
	        out.println("<loan_item_name>"+bean.getValue("loan_item_name")+"</loan_item_name>");
	        out.println("<loan_amt>"+Utility.setCommaFormat(bean.getValue("loan_amt").toString())+"</loan_amt>");
	        //out.println("<def_type>"+bean.getValue("def_type")+"</def_type>");
	        //out.println("<def_case>"+bean.getValue("def_case")+"</def_case>");
	        out.println("<case_name>"+bean.getValue("case_name")+"</case_name>");
	        out.println("<pay_amt>"+bean.getValue("pay_amt").toString()+"</pay_amt>");
	        String str = (String)bean.getValue("non_loan_status");
	        str = str.replace("<", "&lt;");
	        str = str.replace(">", "&gt;");
	        out.println("<non_loan_status>"+str+"</non_loan_status>");
	        out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	    // XML Ducument for end
    }
	String chkSeqs = "",chks="";
	String docNo="";
	String ex_Type = "FEB",ex_No = "",bank_No = "";
    String docY="",docM="",docD="",payY="",payM="",payD="";	
    String ex_Type_Name="",bank_Name="",ex_No_List="";
    String doc_Date="" ,corr_DocNo="",checkv="",def_Seq="";
    String loan_Name="",loan_Date="",loan_Item="",loan_Item_Name="",loan_Amt="";
    String lName="";String lDate="";String lItem="";String lAmt="";
    List EditInfo = (List)request.getAttribute("EditInfo");
    if(EditInfo != null && EditInfo.size() > 0 ){//會撈出所有相關案件
		for(int i=0;i<EditInfo.size();i++){
			DataObject b = (DataObject)EditInfo.get(i);
			//若該docNo有勾選，則checkv=V,否則為null(ps.設null是為了跟detailList的選項一致)
			if((Utility.getTrimString(dataMap.get("docNo"))).equals((String)b.getValue("docno"))){
				ex_Type=b.getValue("ex_type")==null?"":(String)b.getValue("ex_type");
				ex_Type_Name=b.getValue("ex_type_name")==null?"":(String)b.getValue("ex_type_name");
				bankType=b.getValue("bank_type")==null?"":(String)b.getValue("bank_type");
				bank_No=b.getValue("bank_no")==null?"":(String)b.getValue("bank_no");
				bank_Name=b.getValue("bank_name")==null?"":(String)b.getValue("bank_name");
				ex_No=b.getValue("ex_no")==null?"":(String)b.getValue("ex_no");
				ex_No_List=b.getValue("ex_no_list")==null?"":(String)b.getValue("ex_no_list");
				doc_Date =b.getValue("doc_date")==null?"":(String)b.getValue("doc_date");
				docNo=b.getValue("docno")==null?"":(String)b.getValue("docno");
				corr_DocNo=b.getValue("corr_docno")==null?"":(String)b.getValue("corr_docno"); 
				
				if(!"".equals(doc_Date)){
					docY=String.valueOf(Integer.parseInt(doc_Date)-19110000).substring(0, 3);
					docM=String.valueOf(Integer.parseInt(doc_Date)-19110000).substring(3, 5);
					docD=String.valueOf(Integer.parseInt(doc_Date)-19110000).substring(5, 7);
				}
				if("".equals(checkv)){
					checkv =b.getValue("checkv")==null?"":(String)b.getValue("checkv");
				}
			}
			
			
			loan_Name = (String)b.getValue("loan_name");
			loan_Date = (String)b.getValue("loan_date");
			loan_Item_Name = (String)b.getValue("loan_item_name");
			loan_Amt = b.getValue("loan_amt").toString();
			if(!(lName.equals(loan_Name) && lDate.equals(loan_Date) && lItem.equals(loan_Item_Name) && lAmt.equals(loan_Amt))
					&& i>0){
					if(!"".equals(chks))chks+=",";
					chks += ((checkv=="")?"null":checkv);
					if(i<EditInfo.size()-1)checkv = "";
			}
			lName=loan_Name;lDate=loan_Date;lItem=loan_Item_Name;lAmt=loan_Amt;
		}
		if(!"".equals(lName)){//最後一筆
			if(!"".equals(chks))chks+=",";
			chks += ((checkv=="")?"null":checkv);
			checkv = "";
		}
	}
	
%>

<HTML>
<HEAD>
<TITLE>收回補貼息案件發文至農業金庫維護作業</TITLE>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/PopupCal.js"></script>
<script language="javascript" src="js/FL008W.js"></script>
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
<Form name='form' method=post action='/pages/FL008W.jsp'>
<input type='hidden' name="act" value='<%=act%>'>
<input type='hidden' name="doc_Date" >
<input type='hidden' name='detailCnt'><%//個案明細總筆數 %>
<input type='hidden' name='def_Seq' value='<%=chkSeqs%>'>
<input type='hidden' name='oriDocNo' value='<%=docNo%>'>
<input type='hidden' name='corr_DocNo' value='<%=corr_DocNo%>'>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="40%"><font color='#000000' size=4><b><center>收回補貼息案件發文至農業金庫維護作業</center></b></font> </td>
           <td width="25%"><img src="images/banner_bg1.gif" width="113%" height="17"></td>
         </tr>
</table>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
<tr>  
    <div align="right">
      <jsp:include page="getLoginUser.jsp" flush="true" />
    </div> 
</tr> 
</table> 

<Table border=1 width='100%' align=center bgcolor="#FFFFF" bordercolor="#76C657">
	<tr class="sbody">
	    <td width="13%" bgcolor="#BDDE9C" height="1">發文日期</td>
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
	    		<button name='button1' onClick="popupCal('form','docY,docM,docD','BTN_date_1',event)">
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
	  <select size="1" name="tbank" id="tbank" onChange="changeExNo('DetailXML');">
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




<!-- 補貼息計算有疑義個案明細 ----------------------->
<tr ><td colspan='11'>
<table id='tbl' width='100%' border=1  bordercolor="#76C657">
<tr class="sbody" bgcolor="#BFDFAE" >
	<td width='10%' align='left' rowspan='999'>補貼息計算有疑義個案明細</td>
	<td width='5%' align='left'>&nbsp;</td>
	<td width='11%' align='left'>借款人名稱</td>
	<td width='8%' align='left'>貸款日期</td>
	<td width='10%' align='left'>貸款種類</td>
	<td width='10%' align='left'>貸款金額</td>
	<td width='20%' align='left'>缺失情節</td>
	<td width='14%' align='left'>不符規定情形</td>
	<td width='12%' align='left'>繳還補貼息金額(元)</td>
</tr>
<tr bgcolor="#EBF4E1" class="sbody">
	<td colspan='11'>
		<font color='#FF0000'>查無符合資料</font>
	</td>
</tr>			
</table></td></tr>
<!-- ----------------------------- -->
</Table>
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="sbody" >
	<tr>
		<td colspan="2" >
			<table border="0" cellpadding="1" cellspacing="1" align="center">
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
	}
}

if('<%=act%>'!='New'){
	setDetailList('DetailXML');
	var cks = "<%=chks%>";
	var v = cks.split(",");
	if(form.detailCnt.value>1){
		for (var i in v) {
		    var seq = document.getElementsByName("chkb");
		    if(v[i] == 'V'){
				seq[i].checked=true;
			}
		}
	}else if(form.detailCnt.value==1){
	    var seq = document.getElementById("chkb");
	    if("<%=chks%>" == 'V'){
			seq.checked=true;
		}
	}
}

	
		

-->
</script>

</HTML>
