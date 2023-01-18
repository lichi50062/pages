<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.Utility" %>
<jsp:useBean id="frmLoanItems" scope="request" class="java.util.LinkedList" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>專案農貸貸款種類維護作業</title>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/FL001W.js"></script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>
<body bgColor="#FFFFFF">
	<form name="form" method="post" action="FL001W.jsp">
		<input type="hidden" name="act" value="" />
		<input type="hidden" name="loanItem" value="" />
		<input type="hidden" name="loanItemName" value="" />
		
		<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr> 
				<td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
				<td width="50%"><font color='#000000' size=4><b><center>專案農貸貸款種類維護作業 </center></b></font> </td>
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
			<tr>
				<td>
					<table border="1" width="100%" bgcolor="#FFFFF" bordercolor="#76C657">
						<tr class="sbody" bgcolor="#BFDFAE">
							<td>序號</td>
							<td>貸款種類別</td>
						</tr>
				</td>
			</tr>
			<%
				for(int i = 0 ; i < frmLoanItems.size() ; i++) {
					DataObject bean = (DataObject) frmLoanItems.get(i);
					String loanItem = Utility.getTrimString(bean.getValue("loan_item"));
					String loanItemName =  Utility.getTrimString(bean.getValue("loan_item_name"));
					String temp = "javascript:goSubListPage('" + loanItem + "','" + loanItemName + "')";
			%>
				<tr class="sbody" bgcolor='<%=(i % 2 == 0)?"#EBF4E1":"#FFFFCC"%>'>
					<td>
						<%= loanItem %>
					</td>
					<td>
						<a href="<%= temp %>"><%= loanItemName %></a>
					</td>
				</tr>
			<% } %>
		</table>
	</form>
</body>
</html>