<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.Utility" %>
<jsp:useBean id="defTypes" scope="request" class="java.util.LinkedList" />
<jsp:useBean id="frmDefItems" scope="request" class="java.util.LinkedList" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>專案農貸常見缺失維護作業</title>
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/FL002W.js"></script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
<script>
function init() {
	var defKindVal = "<%= Utility.getTrimString(request.getAttribute("defKind")) %>";
	var defTypeVal = "<%= Utility.getTrimString(request.getAttribute("defType")) %>";
	var defCaseVal = "<%= Utility.getTrimString(request.getAttribute("defCase")) %>";
	var caseNameVal = "<%= Utility.getTrimString(request.getAttribute("caseName")) %>";
	
	var defKindRadios = document.getElementsByName("defKind");
	for(var i = 0 ; i < defKindRadios.length ; i++ ) {
		var defKindRadio = defKindRadios[i];
		if(defKindVal == defKindRadio.value ) {
			defKindRadio.checked = true;
			break;
		}
	}
	
	document.getElementById("defType").value = defTypeVal;
	document.getElementById("defCase").value = defCaseVal;
	document.getElementById("caseName").value = caseNameVal;
}
</script>
</head>
<body bgColor="#FFFFFF" onload="init()">
	<form name="form" method="post" action="FL002W.jsp">
		<input type="hidden" name="act" value="<%= Utility.getTrimString(request.getAttribute("act")) %>" />
		<input type="hidden" name="operation" />
		
		<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr> 
				<td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
				<td width="50%"><font color='#000000' size=4><b><center>專案農貸常見缺失維護作業 </center></b></font> </td>
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
					<input type="radio" name="defKind" value="A" />整體性缺失
					<input type="radio" name="defKind" value="C" />個案缺失
					<a style="text-decoration: none" id="showInsertLink" href="javascript:doSubmit(form,'showInsert');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('showInsertBtn','','images/B_bt_04b_2.gif',1)">
						<img src="images/B_bt_04.gif" name="showInsertBtn" width="66" height="25" border="0" id="showInsertBtn">
					</a>
					<a style="text-decoration: none" id="queryLink" href="javascript:doSubmit(form,'query');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('queryBtn','','images/bt_queryb.gif',1)">
						<img src="images/bt_query.gif" name="queryBtn" width="66" height="25" border="0" id="queryBtn">
					</a>
				</td>
			</tr>
			<tr class="sbody">
				<td width="111" bgcolor="#BDDE9C" height="1">缺失態樣</td>
				<td width="423" bgcolor="#EBF4E1" height="1">
					<select name="defType" id="defType" >
						<option value="">請選擇...</option>
						<%
							for(int i = 0 ; i < defTypes.size() ; i++) {
								DataObject bean = (DataObject) defTypes.get(i);
								String cmuseId = Utility.getTrimString(bean.getValue("cmuse_id"));
								String cmuseName = Utility.getTrimString(bean.getValue("cmuse_name"));
						%>
							<option value="<%= cmuseId %>"><%= cmuseName %></option>
						<% } %>
					</select>
				</td>
			</tr>
			<tr class="sbody">
				<td width="111" bgcolor="#BDDE9C" height="1">缺失情節</td>
				<td width="423" bgcolor="#EBF4E1" height="1">
					<input type="hidden" name="defCase" id="defCase" />
					<input type="text" name="caseName" id="caseName" size="130" maxlength="400" />
				</td>
			</tr>
		</table>
		<table border="1" width="90%" align="center" height="35" bgcolor="#FFFFF" bordercolor="#76C657">
			<tr>
				<td>
					<table border="1" width="100%" bgcolor="#FFFFF" bordercolor="#76C657">
						<tr class="sbody" bgcolor="#BFDFAE">
							<td nowrap="nowrap">序號</td>
							<td nowrap="nowrap">缺失類別</td>
							<td nowrap="nowrap">缺失態樣</td>
							<td nowrap="nowrap">代號</td>
							<td>缺失情節</td>
						</tr>
				</td>
			</tr>
			<%
				for(int i = 0 ; i < frmDefItems.size() ; i++) {
					DataObject bean = (DataObject) frmDefItems.get(i);
					String defKind = Utility.getTrimString(bean.getValue("def_kind"));
					String defKindname = Utility.getTrimString(bean.getValue("def_kindname"));
					String defType = Utility.getTrimString(bean.getValue("def_type"));
					String cmuseName = Utility.getTrimString(bean.getValue("cmuse_name"));
					String defCase = Utility.getTrimString(bean.getValue("def_case"));
					String defCaseId = Utility.getTrimString(bean.getValue("def_case_id"));
					String caseName = Utility.getTrimString(bean.getValue("case_name"));
					
					String temp = "javascript:goEditPage('" + defKind + "','" + defType + "','" +  defCase + "','" + caseName + "')";
			%>
				<tr class="sbody" bgcolor='<%=(i % 2 == 0)?"#EBF4E1":"#FFFFCC"%>'>
					<td>
						<%= (i + 1) %>
					</td>
					<td>
						<a href="<%= temp %>"><%= defKindname %></a>
					</td>
					<td>
						<%= cmuseName %>
					</td>
					<td>
						<%= defCaseId %>
					</td>
					<td>
						<%= caseName %>
					</td>
				</tr>
			<% } %>
		</table>
	</form>
</body>
</html>