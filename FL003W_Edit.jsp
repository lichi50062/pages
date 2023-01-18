<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.Properties" %>
<jsp:useBean id="act" scope="request" class="java.lang.String" />
<jsp:useBean id="docTypes" scope="request" class="java.util.LinkedList" />
<jsp:useBean id="auditTypes" scope="request" class="java.util.LinkedList" />
<%
Properties permission = ( session.getAttribute("FL003W")==null ) ? new Properties() : (Properties)session.getAttribute("FL003W"); 
if(permission == null){
	System.out.println("FL003W_Edit.permission == null");
} else {
	System.out.println("FL003W_Edit.permission.size =" + permission.size());
}	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>專案農貸核處情形維護作業</title>
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/FL003W.js"></script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
<script>
function initEditPage() {
	var actVal = form.act.value;
	var docTypeVal = "<%= Utility.getTrimString(request.getAttribute("docType")) %>";
	var auditTypeVal = "<%= Utility.getTrimString(request.getAttribute("auditType")) %>";
	var auditIdVal = "<%= Utility.getTrimString(request.getAttribute("auditId")) %>";
	var auditCaseVal = "<%= Utility.getTrimString(request.getAttribute("auditCase")) %>";
	
	if(docTypeVal == "B") {
		document.getElementById("auditType").disabled = false;
		document.getElementById("auditCase").disabled = false;
	} else {
		document.getElementById("auditType").disabled = true;
		document.getElementById("auditCase").disabled = true;
	}
	
	if(actVal == "showInsert") {
		document.getElementById("updateBtn").style.display = "none";
		document.getElementById("delLink").style.display = "none";
	} else if(actVal == "showEditPage") {
		form.auditIdHidden.value = auditIdVal;
		form.auditTypeHidden.value = auditTypeVal;
		document.getElementById("confirmLink").style.display = "none";
	} else {
		document.getElementById("confirmLink").style.display = "none";
	}
	
	form.docType.value = docTypeVal;
	form.auditType.value = auditTypeVal;
	form.auditId.value = auditIdVal;
	form.auditCase.value = auditCaseVal;
}
</script>
</head>
<body bgColor="#FFFFFF" onload="initEditPage()" >
	<form name="form" method="post" action="FL003W.jsp">
		<input type="hidden" name="act" value="<%= act %>" />
		<input type="hidden" name="auditId" />
		<input type="hidden" name="auditIdHidden" />
		<input type="hidden" name="auditTypeHidden" />
		
		<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr> 
				<td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
				<td width="50%"><font color='#000000' size=4><b><center>專案農貸核處情形維護作業 </center></b></font> </td>
				<td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
			</tr>
		</table>
		<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
			<tr>
				<div align="right">
					<jsp:include page="getLoginUser.jsp" flush="true" />
				</div> 
			</tr> 
		</table>
		<table border="1" width="90%" align="center" height="35" bgcolor="#FFFFF" bordercolor="#76C657">
			<tr class="sbody">
				<td width="111" bgcolor="#BDDE9C" height="1">缺失類別</td>
				<td width="423" bgcolor="#EBF4E1" height="1">
					<select name="docType" id="docType" onchange="checkDocType(this.value)" >
						<option value="">請選擇...</option>
						<%
							for(int i = 0 ; i < docTypes.size() ; i++) {
								DataObject bean = (DataObject) docTypes.get(i);
								String cmuseId = Utility.getTrimString(bean.getValue("cmuse_id"));
								String cmuseName = Utility.getTrimString(bean.getValue("cmuse_name"));
						%>
							<option value="<%= cmuseId %>"><%= cmuseName %></option>
						<% } %>
					</select>
				</td>
			</tr>
			<tr class="sbody">
				<td width="111" bgcolor="#BDDE9C" height="1">核處類別</td>
				<td width="423" bgcolor="#EBF4E1" height="1">
					<select name="auditType" id="auditType" disabled="disabled" >
						<option value="">請選擇...</option>
						<%
							for(int i = 0 ; i < auditTypes.size() ; i++) {
								DataObject bean = (DataObject) auditTypes.get(i);
								String cmuseId = Utility.getTrimString(bean.getValue("cmuse_id"));
								String cmuseName = Utility.getTrimString(bean.getValue("cmuse_name"));
						%>
							<option value="<%= cmuseId %>"><%= cmuseName %></option>
						<% } %>
					</select>
				</td>
			</tr>
			<tr class="sbody">
				<td width="111" bgcolor="#BDDE9C" height="1">核處情形</td>
				<td width="423" bgcolor="#EBF4E1" height="1">
					<textarea name="auditCase" id="auditCase" rows="4" cols="100" disabled="disabled">
						
					</textarea>
				</td>
			</tr>
		</table>
		<jsp:include page="getMaintainUser.jsp?width=90%" flush="true" />
		<table width="90%" align="center">
			<tr class="sbody">
				<td height="1" align="center">
					<% if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ %>
						<a style="text-decoration:none" id="confirmLink" href="javascript:doSubmit(form,'insert');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('confirmBtn','','images/bt_confirmb.gif',1)">
							<img src="images/bt_confirm.gif" name="confirmBtn" width="66" height="25" border="0" id="confirmBtn">
						</a>
					<% } %>
					<% if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){ %>
						<a style="text-decoration:none" id="updateLink" href="javascript:doSubmit(form,'update');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('updateBtn','','images/bt_updateb.gif',1)">
							<img src="images/bt_update.gif" name="updateBtn" width="66" height="25" border="0" id="updateBtn">
						</a>
					<% } %>
					<% if(permission != null && permission.get("D") != null && permission.get("D").equals("Y")){ %>
						<a style="text-decoration:none" id="delLink" href="javascript:doSubmit(form,'delete');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('delBtn','','images/bt_08b.gif',1)">
							<img src="images/bt_08.gif" name="delBtn" width="66" height="25" border="0" id="delBtn">
						</a>
					<% } %>
					<a style="text-decoration:none" id="cancelLink" href="javascript:doSubmit(form,'cancel');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancelBtn','','images/bt_29b.gif',1)">
						<img src="images/bt_29.gif" name="cancelBtn" width="66" height="25" border="0" id="cancelBtn">
					</a>
					<a style="text-decoration:none" id="backLink" href="javascript:doSubmit(form,'back');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('backBtn','','images/bt_09b.gif',1)">
						<img src="images/bt_09.gif" name="backBtn" width="66" height="25" border="0" id="backBtn">
					</a>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>