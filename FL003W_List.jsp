<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.Utility" %>
<jsp:useBean id="docTypes" scope="request" class="java.util.LinkedList" />
<jsp:useBean id="frmAuditItems" scope="request" class="java.util.LinkedList" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>專案農貸核處情形維護作業</title>
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/FL003W.js"></script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>
<body bgColor="#FFFFFF">
	<form name="form" method="post" action="FL003W.jsp">
		<input type="hidden" name="act" value="" />
<!-- 		<input type="hidden" name="docType" /> -->
		<input type="hidden" name="auditType" />
		<input type="hidden" name="auditId" />
		<input type="hidden" name="auditCase" />
		
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
				<td width="111" bgcolor="#BDDE9C" height="1">發文性質</td>
				<td width="423" bgcolor="#EBF4E1" height="1">
					<select name="docType">
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
					
					<a style="text-decoration:none" id="queryLink" href="javascript:doSubmit(form,'query');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('queryBtn','','images/bt_queryb.gif',1)">
						<img src="images/bt_query.gif" name="queryBtn" width="66" height="25" border="0" id="queryBtn">
					</a>
					<a style="text-decoration:none" id="showInsertLink" href="javascript:doSubmit(form,'showInsert');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('showInsertBtn','','images/B_bt_04b_2.gif',1)">
						<img src="images/B_bt_04.gif" name="showInsertBtn" width="66" height="25" border="0" id="showInsertBtn">
					</a>
					
				</td>
			</tr>
		</table>
		<table border="1" width="90%" align="center" height="35" bgcolor="#FFFFF" bordercolor="#76C657">
			<tr>
				<td>
					<table border="1" width="100%" bgcolor="#FFFFF" bordercolor="#76C657">
						<tr class="sbody" bgcolor="#BFDFAE">
							<td>序號</td>
							<td>發文性質</td>
							<td>核處類別</td>
							<td>核處情形</td>
						</tr>
				</td>
			</tr>
			<%
				for(int i = 0 ; i < frmAuditItems.size() ; i++) {
					DataObject bean = (DataObject) frmAuditItems.get(i);
					
					String docType = Utility.getTrimString(bean.getValue("doc_type"));
					String docTypeName = Utility.getTrimString(bean.getValue("doc_type_name"));
					String auditType = Utility.getTrimString(bean.getValue("audit_type"));
					String auditTypeName = Utility.getTrimString(bean.getValue("audit_type_name"));
					String auditId = Utility.getTrimString(bean.getValue("audit_id"));
					String aduitCase = Utility.getTrimString(bean.getValue("audit_case"));
					
					String temp = "javascript:goEditPage('" + docType + "','" + auditType + "','" + auditId + "','" + aduitCase +"')";
			%>
				<tr class="sbody" bgcolor='<%=(i % 2 == 0)?"#EBF4E1":"#FFFFCC"%>'>
					<td>
						<%= (i + 1) %>
					</td>
					<td>
						<a href="<%= temp %>"><%= docTypeName %></a>&nbsp;
					</td>
					<td>
						<%= auditTypeName %>&nbsp;
					</td>
					<td>
						<%= aduitCase %>&nbsp;
					</td>
				</tr>
			<% } %>
		</table>
	</form>
</body>
</html>