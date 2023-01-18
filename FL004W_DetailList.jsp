<%
//105.10.06 create by 2968
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

	System.out.println("Page: FL004W_DetailList.jsp Action:"+act);
	// 查詢條件值
	String bankType = Utility.getTrimString(request.getAttribute("bankType")) ;
	String bank_no = Utility.getTrimString(request.getAttribute("bank_no")) ;
	String bank_name = Utility.getTrimString(request.getAttribute("bank_name")) ;        
	String ex_type = Utility.getTrimString(request.getAttribute("ex_type")) ;
	String ex_no = Utility.getTrimString(request.getAttribute("ex_no")) ;
	String ex_no_list = Utility.getTrimString(request.getAttribute("ex_no_list")) ;
     
    List DetailResult_C = (List)request.getAttribute("DetailResult_C");//個案查核
    List DetailResult_AR = (List)request.getAttribute("DetailResult_AR");//整體性
    
    Properties permission = ( session.getAttribute("FL004W")==null ) ? new Properties() : (Properties)session.getAttribute("FL004W");


   
%>

<HTML>
<HEAD>
<TITLE>專案農貸查核情形維護作業</TITLE>
<script language="javascript" src="js/Common.js"></script>
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
<input type='hidden' name="act" value=''>
<input type='hidden' name="bankType" value='<%=bankType%>'>
<input type='hidden' name="bank_no" value='<%=bank_no%>'>
<input type='hidden' name="ex_type" value='<%=ex_type%>'>
<input type='hidden' name="ex_no" value='<%=ex_no%>'>
<input type='hidden' name="bank_Name" value='<%=bank_name%>'>
<input type='hidden' name="ex_no_list" value='<%=ex_no_list%>'>
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
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1"><%if("FEB".equals(ex_type)){%>檢查報告編號<%}else if("AGRI".equals(ex_type)){%>查核季別<%}else{%>訪查日期<%} %></td>
<td bgcolor="#EBF4E1" height="1">
   <%=ex_no_list %>
  &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <input type='button' value=' <%if("FEB".equals(ex_type)){ %>缺失內容新增<%}else{ %>查核內容新增<%} %> ' onClick="doSubmit(form,'New1');">&nbsp;&nbsp;
  <a href="javascript:doSubmit(form,'RtnList');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_05b.gif',1)"><img src="images/bt_05.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>&nbsp;&nbsp;&nbsp;&nbsp;      
  </td>
</tr>

<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">受檢單位</td>
<td bgcolor="#EBF4E1" height="1">           
	<%=bank_no %>&nbsp;<%=bank_name %>
</tr>

</Table>

	<Table border="1" width="80%" align=center bgcolor="#FFFFF" bordercolor="#76C657">
	<tr class="sbody" bgcolor="#BFDFAE">
      <td colspan='6' align='center'>整體性查核</td>
    </tr>
    <tr class="sbody" bgcolor="#BFDFAE">
      <td width="10%" height="14">序號</td>
      <td width="30%" height="14">缺失情節</td>          
      <td width="60%" height="14" colspan='4'>查核結果</td>
    </tr>
    <%
    if(DetailResult_AR != null && DetailResult_AR.size() > 0) {
		System.out.println("Query DetailResult_AR Size= "+DetailResult_AR.size());
		int cnt = 0; 
      	for(int i=0; i<DetailResult_AR.size(); i++){
			DataObject bean =(DataObject)DetailResult_AR.get(i);
			cnt++;
    %>      
	    <tr class="sbody" bgcolor='#FFFFCC'>
	    	<td width="10%" height="1"><%if(cnt<10){out.print("0"+cnt);}else{out.print(cnt);}%></td>
	      	<td width="30%" height="1"><a href=FL004W.jsp?act=Edit&bank_No=<%=bean.getValue("bank_no")%>&ex_No=<%=bean.getValue("ex_no")%>&def_Seq=<%=bean.getValue("def_seq")%>&ex_Kind=<%=bean.getValue("ex_kind")%>>
								      <%=bean.getValue("case_name") != null ? bean.getValue("case_name") : "&nbsp;"%></a>&nbsp;</td>
	      	<td width="60%" height="1" colspan='4'><%=bean.getValue("ex_result") != null ? bean.getValue("ex_result") : "&nbsp;"%></td>
	    </tr>
    <%        
      	}
    }else{%>            
	    <tr bgcolor="#EBF4E1" class="sbody">
			<td width="100%" colspan='6' align='center'><font color="#FF0000">查無符合資料</font></td>
	    </tr>
  <%}%> 
	<tr class="sbody" bgcolor="#BFDFAE">
      <td colspan='6' align='center'>個案查核</td>
    </tr>
    <tr class="sbody" bgcolor="#BFDFAE">
      <td width="10%" height="14">序號</td>
      <td width="30%" height="14">借款人名稱</td>          
      <td width="10%" height="14">貸款日期</td>
      <td width="30%" height="14">貸款種類</td>
      <td width="10%" height="14">貸款金額(元)</td>
      <td width="10%" height="14">查核結果</td>
    </tr>
    <%
    if(DetailResult_C != null && DetailResult_C.size() > 0) {
		System.out.println("Query DetailResult_C Size= "+DetailResult_C.size());
		int cnt = 0;
		String lName = "",lDate = "",lItem = "",lAmt = "",lResult = "";
      	for(int i=0; i<DetailResult_C.size(); i++){
			DataObject bean =(DataObject)DetailResult_C.get(i);
			String def_seq = bean.getValue("def_seq") != null ? bean.getValue("def_seq").toString() : "&nbsp;";
			String loan_name = bean.getValue("loan_name") != null ? bean.getValue("loan_name").toString() : "&nbsp;";
			String loan_date = bean.getValue("loan_date") != null ? bean.getValue("loan_date").toString() : "&nbsp;";
			String loan_item_name = bean.getValue("loan_item_name") != null ? bean.getValue("loan_item_name").toString() : "&nbsp;";
			String loan_amt = bean.getValue("loan_amt") != null ? bean.getValue("loan_amt").toString() : "&nbsp;";
			String ex_result = bean.getValue("ex_result") != null ? bean.getValue("ex_result").toString() : "&nbsp;";
			String case_name = bean.getValue("case_name") != null ? bean.getValue("case_name").toString() : "&nbsp;";
			if(!(loan_name.equals(lName) &&loan_date.equals(lDate) && loan_item_name.equals(lItem) && loan_amt.equals(lAmt) && ex_result.equals(lResult))){
				cnt++; %>  
			    <tr class="sbody" bgcolor='#FFFFCC'>
			    	  <td width="10%" height="14"><%if(cnt<10){out.print("0"+cnt);}else{out.print(cnt);}%></td>
				      <td width="20%" height="14"><a href="#" onClick="showCase('showCase<%=cnt%>');"><%=loan_name%></a></td>          
				      <td width="10%" height="14"><%=Utility.getCHTdate(loan_date,0)%></td>
				      <td width="30%" height="14"><%=loan_item_name%></td>
				      <td width="10%" height="14"><%=Utility.setCommaFormat(loan_amt)%></td>
				      <td width="10%" height="14"><%=ex_result%></td>
			    </tr>
			    <tr class="sbody" bgcolor="#FFFFCC" id="showCase<%=cnt%>" name="showCase<%=cnt%>" style="display:none">
			      <td width="10%" height="14">&nbsp;</td>
			      <td width="30%" height="14">&nbsp;</td>          
			      <td width="60%" height="14" colspan='4' bgcolor="#BFDFAE" >缺失情節</td>
			    </tr>
	    	<%} %> 
		    <tr class="sbody" bgcolor='#FFFFCC' id="showCase<%=cnt%>" name="showCase<%=cnt%>" style="display:none">
		    	<td width="10%" height="14">&nbsp;</td>
			    <td width="30%" height="14">&nbsp;</td>
		    	<td width="60%" height="14" colspan='4'><a href=FL004W.jsp?act=Edit&def_Seq=<%=bean.getValue("def_seq")%>&bank_No=<%=bean.getValue("bank_no")%>&ex_No=<%=bean.getValue("ex_no")%>&ex_Kind=<%=bean.getValue("ex_kind")%>>
								      <%=case_name%></a></td>
		    </tr>
    <%  	lName = loan_name;lDate=loan_date;lItem = loan_item_name;lAmt = loan_amt;lResult = ex_result;
      	}
    }else{%>            
	    <tr bgcolor="#EBF4E1" class="sbody">
			<td width="100%" colspan='6' align='center'><font color="#FF0000">查無符合資料</font></td>
	    </tr>
  <%}%> 
         
  </Table>
</form>
</BODY>
<script language="JavaScript" >


</script>

</HTML>
