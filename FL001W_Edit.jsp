<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="act" scope="request" class="java.lang.String" />
<jsp:useBean id="frmLoanSubitem" scope="request" class="java.util.HashMap" />

<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.Properties" %>
<%
Properties permission = ( session.getAttribute("FL001W")==null ) ? new Properties() : (Properties)session.getAttribute("FL001W"); 
if(permission == null){
	System.out.println("FL001W_Edit.permission == null");
} else {
	System.out.println("FL001W_Edit.permission.size =" + permission.size());
}	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>專案農貸貸款種類維護作業</title>
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/PopupCal.js"></script>
<script language="javascript" src="js/FL001W.js"></script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>
<body bgColor="#FFFFFF" onload="initEditPage()">
	<form name="form" method="post" action="FL001W.jsp">
		<input type="hidden" name="act" value="<%= act %>" />
		<input type="hidden" name="operation" />
		<input type="hidden" id="loanItemTemp" name="loanItemTemp" value="<%= request.getAttribute("loanItem") %>" />
		<input type="hidden" id="loanItemNameTemp" name="loanItemNameTemp" value="<%= request.getAttribute("loanItemName") %>" />
		<input type="hidden" id="subitemTemp" name="subitemTemp" value="<%= request.getAttribute("subitem") %>" />
		<input type="hidden" id="subitemNameTemp" name="subitemNameTemp" value="<%= request.getAttribute("subitemName") %>" />
		
		
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
				<td width="111" bgcolor="#BDDE9C" height="1">貸款種類</td>
				<td width="423" bgcolor="#EBF4E1" height="1">
					<input type="text" id="loanItem" name="loanItem" value="<%= Utility.getTrimString(frmLoanSubitem.get("loan_item")) %>" />
					<input type="hidden" id="loanItemName" name="loanItemName" />
					<span id="loanItemNameDiv">
						<%= Utility.getTrimString(frmLoanSubitem.get("loan_item_name")) %>
					</span>
				</td>
			</tr>
			<tr class="sbody">
				<td width="111" bgcolor="#BDDE9C" height="1">貸款子目別</td>
				<td width="423" bgcolor="#EBF4E1" height="1">
					<input type="hidden" id="subitem" name="subitem" value="<%= Utility.getTrimString(frmLoanSubitem.get("subitem")) %>" />
					<input type="text" id="subitemName" name="subitemName" />
					<span id="subitemNameDiv">
						<%= Utility.getTrimString(frmLoanSubitem.get("subitem_name")) %>
					</span>
				</td>
			</tr>
			<tr class="sbody">
				<td width="111" bgcolor="#BDDE9C" height="1">實施日期</td>
				<td width="423" bgcolor="#EBF4E1" height="1">
					<input type="hidden" name="startDate" id="startDate" value="<%= Utility.getTrimString(frmLoanSubitem.get("start_date")) %>" />
					<input type="hidden" name="startDateHidden" id="startDateHidden" value="<%= Utility.getTrimString(frmLoanSubitem.get("start_date")) %>" />
					<input type="text" name="begYear" id="begYear" size="3" maxlength="3" value="">年
					<select name="begMonth" id="begMonth">
						<option value></option>
						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option>
						<option value="06">06</option>
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
					</select>月 
					<select name="begDay" id="begDay">
						<option value></option>
						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option>
						<option value="06">06</option>
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
						<option value="13">13</option>
						<option value="14">14</option>
						<option value="15">15</option>
						<option value="16">16</option>
						<option value="17">17</option>
						<option value="18">18</option>
						<option value="19">19</option>
						<option value="20">20</option>
						<option value="21">21</option>
						<option value="22">22</option>
						<option value="23">23</option>
						<option value="24">24</option>
						<option value="25">25</option>
						<option value="26">26</option>
						<option value="27">27</option>
						<option value="28">28</option>
						<option value="29">29</option>
						<option value="30">30</option>
						<option value="31">31</option>
					</select>日
					<button name='button1' onclick="popupCal('form','begYear,begMonth,begDay','BTN_date_1',event); return false;">
						<img align="absmiddle" border='0' name='BTN_date_1' src='images/clander.gif'>
					</button>
				</td>
			</tr>
			<tr class="sbody">
				<td width="111" bgcolor="#BDDE9C" height="1">貸款利率</td>
				<td width="423" bgcolor="#EBF4E1" height="1">
					<input type="text" name="loanRate" value="<%= Utility.getTrimString(frmLoanSubitem.get("loan_rate")) %>" />
					<font color="red">(單位:x.xxxx%)</font>
				</td>
			</tr>
			<tr class="sbody">
				<td width="111" bgcolor="#BDDE9C" height="1">補貼基準</td>
				<td width="423" bgcolor="#EBF4E1" height="1">
					<input type="text" name="baseRate" value="<%= Utility.getTrimString(frmLoanSubitem.get("base_rate")) %>" />
					<font color="red">(單位:x.xxxx%)</font>
				</td>
			</tr>
			<tr class="sbody">
				<td width="111" bgcolor="#BDDE9C" height="1">農業金庫基準利率加一成利率</td>
				<td width="423" bgcolor="#EBF4E1" height="1">
					<input type="text" name="agbaseRate" value="<%= Utility.getTrimString(frmLoanSubitem.get("agbase_rate")) %>" />
					<font color="red">(單位:x.xxxx%)</font>
				</td>
			</tr>
			<tr>
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
					<a style="text-decoration:none" id="delLink" href="javascript:doSubmit(form,'del');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('delBtn','','images/bt_08b.gif',1)">
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
		
		
		<table width="90%" border="0" cellpadding="1" cellspacing="1" class="sbody">
			<tr>
				<td colspan="2">
					<font color='#990000'>
					<img src="images/arrow_1.gif" width="28" height="23" align="absmiddle">
					<font color="#007D7D" size="3">使用說明  : </font></font>
				</td>
			</tr>
			<tr> 
				<td width="3%">&nbsp;</td>
				<td width="78%"> 
					<ul>
						<li>本網頁提供新增功能。</li>
						<li>新增時,可直接於空格內輸入資料，按<font color="#666666">【確定】</font>即將本表上的資料於資料庫中建檔。</li>
						<li>修改時,資料更改完畢後，按<font color="#666666">【修改】</font>即將本表上的資料於資料庫中建檔。</li>
						<li>按<font color="#666666">【取消】</font>即重新輸入資料。</li>
						<li>按<font color="#666666">【回上一頁】</font>則放棄新增回至上個畫面。</li>
					</ul>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>