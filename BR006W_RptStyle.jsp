<%
//94.01.24 create by 2295
//94.01.31 add 權限 by 2295
//99.12.27 add 範本格式套用共用include by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>

<%
	Map dataMap =Utility.saveSearchParameter(request);
	String report_no = "BR006W";	
	String act = Utility.getTrimString(dataMap.get("act"));				
	String szExcelAction = (session.getAttribute("excelaction")==null)?"view":(String)session.getAttribute("excelaction");
	//System.out.println("BR002W_RptStyle.szExcelAction="+szExcelAction);
	String bank_type = (session.getAttribute("nowbank_type")==null)?"":(String)session.getAttribute("nowbank_type");
%>



<script language="javascript" src="js/Common.js"></script>
<!--script language="javascript" src="js/BR006W.js"></script-->
<!--script language="javascript" src="js/BRUtil.js"></script-->
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/movesels.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#' name='RptStylefrm'>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="#FFFFFF">
	<table width="750" border="0" align="center" cellpadding="1" cellspacing="1">        
        <tr> 
          <td><table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="225"><img src="images/banner_bg1.gif" width="225" height="17"></td>
                <td width="300"><font color='#000000' size=4> 
                  <center>
                    <font color="#336600"><%=((bank_type.equals("6"))?"農會":"漁會")+Utility.getPgName(report_no)%></font>
                  </center>
                  </font> </td>
                <td width="225"><img src="images/banner_bg1.gif" width="225" height="17"></td>
              </tr>
            </table></td>
        </tr>
        <%@include file="./include/BR_RptStyle.include" %><!-- 報表格式(範本檔) -->  
      </table>
    </td>
  </tr>
</table>

<INPUT type="hidden" name=SortList><!--//btnSortList儲存已勾選的報表排序欄位名稱-->
<INPUT type="hidden" name=btnFieldList value='<%if(session.getAttribute("btnFieldList") != null) out.print((String)session.getAttribute("btnFieldList"));%>'><!--//btnFieldList儲存已勾選的報表欄位名稱-->
<INPUT type="hidden" name=BankList value='<%if(session.getAttribute("BankList") != null) out.print((String)session.getAttribute("BankList"));%>'><!--//BankList儲存已勾選的金融機構-->
</form>

</body>
</html>
