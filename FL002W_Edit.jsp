<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.Properties" %>
<jsp:useBean id="act" scope="request" class="java.lang.String" />
<%
Properties permission = ( session.getAttribute("FL002W")==null ) ? new Properties() : (Properties)session.getAttribute("FL002W"); 
if(permission == null){
	System.out.println("FL002W_Edit.permission == null");
} else {
	System.out.println("FL002W_Edit.permission.size =" + permission.size());
}	
%>
<jsp:useBean id="defTypes" scope="request" class="java.util.LinkedList" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>專案農貸常見缺失維護作業</title>
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/FL002W.js"></script>
<script>
function initEditPage() {
	var actVal = form.act.value;
	if(actVal == "showInsert") {
		document.getElementById("updateBtn").style.display = "none";
		document.getElementById("delLink").style.display = "none";
	} else {
		document.getElementById("confirmLink").style.display = "none";
	}
	
	
	var defKindVal = "<%= Utility.getTrimString(request.getAttribute("defKind")) %>";
	var defTypeVal = "<%= Utility.getTrimString(request.getAttribute("defType")) %>";
	var defCaseVal = "<%= Utility.getTrimString(request.getAttribute("defCase")) %>";
	var caseNameVal = "<%= Utility.getTrimString(request.getAttribute("caseName")) %>";
	
	var defKindRadios = document.getElementsByName("defKind");
	for(var i = 0 ; i < defKindRadios.length ; i++ ) {
		var defKindRadio = defKindRadios[i];
		if(defKindRadio.value == defKindVal) {
			defKindRadio.checked = true;
		}
	}
	form.defKindHidden.value = defKindVal;
	form.defType.value = defTypeVal;
	form.defTypeHidden.value = defTypeVal;
	form.defCase.value = defCaseVal;
	form.caseName.value = caseNameVal;
}
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>
<body bgColor="#FFFFFF" onload="initEditPage()">
	<form name="form" method="post" action="FL002W.jsp">
		<input type="hidden" name="act" value="<%= act %>" />
		<input type="hidden" name="operation" />
		<input type="hidden" name="defKindHidden" />
		<input type="hidden" name="defTypeHidden" />
		
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
				<td width="20%" bgcolor="#BDDE9C" height="1">缺失類別</td>
				<td width="80%" bgcolor="#EBF4E1" height="1">
					<input type="radio" name="defKind" value="A" />整體性缺失
					<input type="radio" name="defKind" value="C" />個案缺失
				</td>
			</tr>
			<tr class="sbody">
				<td width="20%" bgcolor="#BDDE9C" height="1">缺失態樣</td>
				<td width="80%" bgcolor="#EBF4E1" height="1">
					<select name="defType">
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
				<td width="20%" bgcolor="#BDDE9C" height="1">缺失情節</td>
				<td width="80%" bgcolor="#EBF4E1" height="1">
					<input type="hidden" name="defCase" />
					<input type="text" name="caseName" size="130" maxlength="400" />
				</td>
			</tr>
		</table>
		<jsp:include page="getMaintainUser.jsp?width=90%" flush="true" />
		<table border="0" cellpadding="1" cellspacing="1" align="center">
			<tr>
			<% if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ %>
				<td>
					<div align="center">
						<a id="confirmLink" href="javascript:doSubmit(form,'insert');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('confirmBtn','','images/bt_confirmb.gif',1)">
							<img src="images/bt_confirm.gif" name="confirmBtn" width="66" height="25" border="0" id="confirmBtn">
						</a>
					</div>
				</td>
			<% } %>
			<% if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){ %>
				<td>
					<div align="center">
						<a id="updateLink" href="javascript:doSubmit(form,'update');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('updateBtn','','images/bt_updateb.gif',1)">
							<img src="images/bt_update.gif" name="updateBtn" width="66" height="25" border="0" id="updateBtn">
						</a>
					</div>
				</td>
			<% } %>
			<% if(permission != null && permission.get("D") != null && permission.get("D").equals("Y")){ %>
				<td>
					<div align="center">
						<a id="delLink" href="javascript:doSubmit(form,'delete');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('delBtn','','images/bt_08b.gif',1)">
							<img src="images/bt_08.gif" name="delBtn" width="66" height="25" border="0" id="delBtn">
						</a>
					</div>
				</td>
			<% } %>
			<td>
				<div align="center">
					<a id="cancelLink" href="javascript:doSubmit(form,'cancel');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancelBtn','','images/bt_29b.gif',1)">
						<img src="images/bt_29.gif" name="cancelBtn" width="66" height="25" border="0" id="cancelBtn">
					</a>
				</div>
			</td>
			<td>
				<div align="center">
					<a id="backLink" href="javascript:doSubmit(form,'back');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('backBtn','','images/bt_09b.gif',1)">
						<img src="images/bt_09.gif" name="backBtn" width="66" height="25" border="0" id="backBtn">
					</a>
				</div>
			</td>
			</tr>
		</table>
	</form>
</body>
</html>