<%
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="act" scope="request" class="java.lang.String" />
<jsp:useBean id="loanapplyNcacnos" scope="request" class="java.util.LinkedList" />
<jsp:useBean id="applyDates" scope="request" class="java.util.LinkedList" />
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/Common.js"></script>

<%
	String report_no = "TM008W";
	
%>
<script>
var applyDateAry = [];
<%
for(int i = 0 ; i < applyDates.size() ; i++ ) {
	DataObject lbean = (DataObject) applyDates.get(i);
	String accTrType = Utility.getTrimString(lbean.getValue("acc_tr_type"));
	String applyDate = Utility.getTrimString(lbean.getValue("applydate"));
	String chineseDate = Utility.getTrimString(lbean.getValue("chinesedate"));
	
	applyDate = chineseDate.substring(0, 3) + "/" + chineseDate.substring(4, 6) + "/" + chineseDate.substring(7, 9);
	
	String key = accTrType + "_" + applyDate;
%>
	applyDateAry["<%= key %>"] = "<%= applyDate %>";
<% } %>
function changeAccTrType(accTrTypeVal) {
	var applyDateSel = document.getElementById("applyDate");
	applyDateSel.options.length = 0;
	applyDateSel.options.add(new Option("請選擇..." , ""));
	
	for (var key in applyDateAry) {
		if (key === 'length' || !applyDateAry.hasOwnProperty(key)) {
			continue;
		}
		var value = applyDateAry[key];
		if(key.split("_")[0] == accTrTypeVal) {
			var newOption = new Option(value , key);
			applyDateSel.options.add(newOption);
		}
	}
}
function doSubmit(cnd) {
// 	var act = form.act.value;
	form.action="/pages/TM008W.jsp?act=" + cnd;
	form.accTrTypeName.value = form.accTrType.options[form.accTrType.selectedIndex].text;
	if(!checkData(form , cnd)) {
		return;
	}
	form.submit();
	return;
}
function checkData(form , cnd) {
	return true;
}
</script>
<%-- <%@include file="./include/BR_bank_no_hsien_id.include" %> --%>
<!-- <script language="javascript" src="js/Common.js"></script> -->
<!-- <script language="javascript" event="onresize" for="window"></script> -->
<link href="css/b51.css" rel="stylesheet" type="text/css">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>辦理情形統計表</title>
</head>
<body leftmargin="0" topmargin="0">
	<form name="form" method=post action='TM008W.jsp'>
		<input type="hidden" name="act" id="act" value="<%= act %>" />
		<input type="hidden" name="accTrTypeName" id="accTrTypeName" />
		<br>
		<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
						<tr>
							<td width="150">
								<img src="images/banner_bg1.gif" width="200" height="17">
							</td>
							<td width="300">
								<font color='#000000' size="4">
									<center>
										<font color="#336600">
											辦理情形統計表
										</font>
									</center>
								</font>
							</td>
							<td width="150">
								<img src="images/banner_bg1.gif" width="200" height="17">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<img src="images/space_1.gif" width="8" height="8">
				</td>
			</tr>
			<tr>
				<td>
					<table width="600" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#5DA525">
						<tr>
							<td bordercolor="#E9F4E3" bgcolor="#E9F4E3">
								<table width="600" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3">
									<tr>
										<td bgcolor="#B0D595" class="sbody">
											<div align="right">
												<input type='radio' name="excelaction" value='download' checked> 下載報表 
												<% if(Utility.getPermission(request , report_no , "P")) { //Print--有列印權限時 %>
													<a style="text-decoration:none" href="javascript:doSubmit('createRpt');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)">
														<img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41" />
													</a>
												<% } %>
												<a style="text-decoration:none" href="javascript:AskReset(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)">
													<img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51">
												</a>
												<a style="text-decoration:none" href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)">
													<img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61">
												</a>
											</div>
										</td>
									</tr>
									<tr class="sbody">
										<td>
											<img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle">
											<span class="mtext">協助措施名稱 :</span>
											<select name="accTrType" id="accTrType" onchange="changeAccTrType(this.value)">
												<option value="">請選擇...</option>
												<%
													for(int i = 0 ; i < loanapplyNcacnos.size() ; i++) {
														DataObject lbean = (DataObject) loanapplyNcacnos.get(i);
														String accTrType = Utility.getTrimString(lbean.getValue("acc_tr_type"));
														String accTrName = Utility.getTrimString(lbean.getValue("acc_tr_name"));
												%>
													<option value="<%= accTrType %>"><%= accTrName %></option>
												<% } %>
											</select>
										</td>
									</tr>
									<tr class="sbody">
										<td>
											<img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle">
											<span class="mtext">申報基準日 :</span>
											<select name="applyDate" id="applyDate">
												<option value="">請選擇...</option>
											</select>&nbsp;&nbsp;<font color='red'>註:為該所選協助措施名稱的應申報日期</font>
										</td>
									</tr>
									<tr class="sbody">
									  <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">輸出格式 :</span>
										  <input name='printStyle' type='radio' value='xls' checked>Excel
										  <input name='printStyle' type='radio' value='ods' >ODS
										  <input name='printStyle' type='radio' value='pdf' >PDF
									  </td>
									</tr> 
									<tr>
										<td bgcolor="#E9F4E3">
											<div align="left">
												<table width="300" border="0" cellpadding="1" cellspacing="1">
													<tr>
														<td width="34">
															<img src="images/print_1.gif" width="34" height="34">
														</td>
														<td width="539">
															<font color="#CC6600">本報表採用A4紙張直印</font>
														</td>
													</tr>
												</table>
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			
		</table>
	</form>
</body>
</html>