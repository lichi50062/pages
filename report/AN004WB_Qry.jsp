<%
///**95.11.09
//多個年度農漁會信用部放款結構及變動表
//Create By Allen
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.tradevan.util.Utility_report"%>
<%@ page import="java.math.BigDecimal"%>
<%
	Calendar rightNow = Calendar.getInstance();
   	String YEAR1  = String.valueOf((rightNow.get(Calendar.YEAR)-1911)-5);//==2006/12/19關貿提出需求變更
   	String YEAR2  = String.valueOf((rightNow.get(Calendar.YEAR)-1911)-1); //==2006/12/19關貿提出需求變更
   	
   	String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");			    	
 	//取得權限
	Properties permission = ( session.getAttribute("AN004WB")==null ) ? new Properties() : (Properties)session.getAttribute("AN004WB"); 
	if(permission == null){
       System.out.println("AN004WB_Qry.permission == null");
    }else{
       System.out.println("AN004WB_Qry.permission.size ="+permission.size());               
    }
%>
<script language="javascript" src="../js/Common.js"></script>
<script language="javascript" src="../js/AN000W.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<link href="/pages/css/b51.css" rel="stylesheet" type="text/css">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=big5">
		<script language="JavaScript" type="text/JavaScript">
<!--
			function doSubmit(){    
				if (!confirm("本項報表會執行 5-10 秒，是否確定執行？")){return;}  
			   this.document.queryForm.action = "/pages/report/AN004WB.jsp?act=Excel";
			   this.document.queryForm.submit();   
			}
//-->
		</script>
	</head>
	<body leftmargin="0" topmargin="0">
		<form name='queryForm' method=post action='#'>
			<input type=hidden name="bank_type" value=<%=bank_type%>>
			<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr> 
					<td>&nbsp;</td>
				</tr>
				<tr> 
					<td bgcolor="#FFFFFF">
						<table width="800" border="0" align="center" cellpadding="1" cellspacing="1">        
							<tr> 
								<td>
									<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
										<tr> 
											<td width="100"><img src="../images/banner_bg1.gif" width="100" height="17"></td>
											<td width="*"><font color='#000000' size=4> 
												<center>
													<font color="#336600">多個年度農漁會信用部放款結構及變動表</font>
												</center>
											</font></td>
											<td width="100"><img src="../images/banner_bg1.gif" width="100" height="17"></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<table border=1 width='600' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
							<tr class="sbody" bgcolor="#BDDE9C">
								<td colspan="2" height="1" align="right">
									<input type='radio' name="excelaction" value='download' checked> 下載報表
									<a href="javascript:doSubmit()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','../images/bt_execb.gif',1)"><img src="../images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a>
									<a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','../images/bt_cancelb.gif',0)"><img src="../images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a>
									<a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','../images/bt_reporthelpb.gif',1)"><img src="../images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a>
								</td>
							</tr>
							<tr class="sbody">
								<td width="118" bgcolor="#BDDE9C" height="1">查詢年度</td>
								<td width="416" bgcolor="#EBF4E1" height="1">
									<input type='text' name='S_YEAR1' value="<%=YEAR1%>" size='3' maxlength='3' onblur='CheckYear(this)'>
									<font color='#000000'>年</font>~
									<input type='text' name='S_YEAR2' value="<%=YEAR2%>" size='3' maxlength='3' onblur='CheckYear(this)'>
									<font color='#000000'>年</font>
								</td>
							</tr>
							<tr class="sbody">
								<td width="118" bgcolor="#BDDE9C" height="1">農(漁)會別</td>
								<td width="416" bgcolor="#EBF4E1" height="1">
									<select size="1" name="bankType">
										<option value="6" selected >農會</option>
										<option value="7">漁會</option>
										<option value="ALL">農漁會</option>
									</select>
								</td>
							</tr>
							<tr class="sbody">
								<td width="118" bgcolor="#BDDE9C" height="1">金額單位</td>
								<td width="416" bgcolor="#EBF4E1" height="1">
									<select size="1" name="priceUtil">
										<option value ="1">元</option>
										<option value ="1000" selected >仟元</option>
										<option value ="10000">萬元</option>
										<option value ="1000000">百萬元</option>
										<option value ="10000000">仟萬元</option>
										<option value ="100000000">億元</option>
									</select>
								</td>
							</tr>
							<%@include file="../include/rpt_style.include" %><!--報表格式挑選-->
							<tr>
								<td bgcolor="#E9F4E3" colspan="2"><font color="red" size="2">資料來源：各農漁會信用部每年度12月底之申報財務資料</font></td>
							</tr>
							<tr>
								<td bgcolor="#E9F4E3" colspan="2" align="center">
									<table width="555" border="0" cellpadding="1" cellspacing="1">
										<tr>
											<td width="34"><img src="../images/print_1.gif" width="34" height="34"></td>
											<td width="222"><font color="#CC6600">本報表採用A4紙張直印</font></td>
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
<script language="JavaScript" >
<!--
//changeCity('TBankXML', form.tbank, form.cityType, form);
-->
</script>
</html>
