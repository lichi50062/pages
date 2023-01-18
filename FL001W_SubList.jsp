<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.Utility" %>
<jsp:useBean id="subFrmLoanItems" scope="request" class="java.util.LinkedList" />
<jsp:useBean id="detailList" scope="request" class="java.util.LinkedList" />
<jsp:useBean id="loanItemName" scope="request" class="java.lang.String" />
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
		<input type="hidden" name="loanItem" value="<%= request.getAttribute("loanItem") %>" />
		<input type="hidden" name="loanItemName" value="<%= loanItemName %>" />
		<input type="hidden" name="subitem" value="" />
		<input type="hidden" name="subitemName" value="" />
		<input type="hidden" name="startDate" value="" />
		
		
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
			<tr class="sbody">
				<td width="111" bgcolor="#BDDE9C" height="1">貸款種類名稱</td>
				<td width="423" bgcolor="#EBF4E1" height="1">
					<%= loanItemName %>
					<input type="button" name="insertBtn" value="貸款子目新增" onclick="goInsertPage()" />
				</td>
			</tr>
			
			<tr>
				<td colspan="2">
					<table border="1" width="100%" bgcolor="#FFFFF" bordercolor="#76C657">
						<tr class="sbody" bgcolor="#BFDFAE">
							<td>序號</td>
							<td>貸款子目別</td>
							<td>實施日期</td>
							<td>貸款利率</td>
							<td>補貼基準</td>
							<td>農業金庫基準利率加一成利率</td>
						</tr>
						<%
							for(int i = 0 ; i < subFrmLoanItems.size() ; i++) {
								DataObject bean = (DataObject) subFrmLoanItems.get(i);
								String loanItem = Utility.getTrimString(bean.getValue("loan_item"));
								String subitem = Utility.getTrimString(bean.getValue("subitem"));
								String subitemName =  Utility.getTrimString(bean.getValue("subitem_name"));
								String temp = "javascript:showDetailList('" + loanItem + "','" + subitem + "')";
								String insTemp = "javascript:goInsertRagePage('" + subitem + "','" + subitemName + "')";
						%>
							<tr class="sbody" bgcolor='<%=(i % 2 == 0)?"#EBF4E1":"#FFFFCC"%>'>
								<td>
									<%= subitem %>
								</td>
								<td>
									<a href="<%= temp %>"><%= subitemName %></a>
								</td>
								<td>
									<input type="button" name="insertBtn" value="實施利率新增" onclick="<%= insTemp %>" />
								</td>
								<td>
									&nbsp;
								</td>
								<td>
									&nbsp;
								</td>
								<td>
									&nbsp;
								</td>
							</tr>
							<%
								for(int j = 0 ; j < detailList.size() ; j++) {
									DataObject dbean = (DataObject) detailList.get(j);
									String dLoanItem = Utility.getTrimString(dbean.getValue("loan_item"));
									String dSubitem = Utility.getTrimString(dbean.getValue("subitem"));
									String startDate = Utility.getTrimString(dbean.getValue("start_date"));
									startDate = Utility.getCHTdate(startDate, 0);
									String loanRate = Utility.getTrimString(dbean.getValue("loan_rate"));
									String baseRate = Utility.getTrimString(dbean.getValue("base_rate"));
									String agbaseRate = Utility.getTrimString(dbean.getValue("agbase_rate"));
									
									if(loanItem.equals(dLoanItem) && subitem.equals(dSubitem) ) {
										String dtemp = "javascript:showEditPage('" + dLoanItem + "','" + dSubitem + "','" + startDate + "')";
							%>
								<tr class="sbody" bgcolor="#FFFFCC" name="detail_<%= dSubitem %>" id="detail_<%= dSubitem %>" style="display: none;">
									<td>
										&nbsp;
									</td>
									<td>
										&nbsp;
									</td>
									<td>
										<a href="<%= dtemp %>"><%= startDate %></a>
									</td>
									<td>
										<%= formatRate(loanRate) %>
									</td>
									<td>
										<%= formatRate(baseRate) %>
									</td>
									<td>
										<%= formatRate(agbaseRate) %>
									</td>
								</tr>
							<% 		}
								} 
							%>
						<% } %>
					</table>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>
<%! 
private static String formatRate(String rate) {
	String retRate = "0";
	if(!"".equals(rate)) {
		double d = new Double(rate);
		double tmp = (double) (Math.floor(d * 10000)/10000.0);//保存小數點後四位
		retRate = String.format("%.4f", tmp);
	}
	return retRate;
}
%>