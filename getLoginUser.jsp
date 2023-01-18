<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%
	String lguser_name = (session.getAttribute("muser_name") == null)?"":Utility.maskChar((String)session.getAttribute("muser_name"),2,((String)session.getAttribute("muser_name")).length()-2,"＊"); 
	//登入者的tbank_no
	String tbank_no = (session.getAttribute("tbank_no") == null)?"":(String)session.getAttribute("tbank_no"); 
	//所點選的nowtbank_no
	//若有點選的tbank_no,則顯示所點選的tbank_no
	tbank_no = ( session.getAttribute("nowtbank_no")==null ) ? tbank_no : (String)session.getAttribute("nowtbank_no");		
	String bank_name = "";
	String sqlCmd = "select bank_name from BA01 where bank_no=?";
	List paramList = new ArrayList();
	paramList.add(tbank_no);
	List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");
	if(dbData != null && dbData.size() != 0){
	   bank_name = (String)((DataObject)dbData.get(0)).getValue("bank_name");
	} 	
	String width=(request.getParameter("width") == null)?"100%":(String)request.getParameter("width");
	System.out.println("wifth="+width);
%>
 <td><table width=<%=width%> border=1 align='center' cellpadding="1" cellspacing="1" bgcolor="#FFFFF" bordercolor="#76C657">
     <tr bgcolor="#BFDFAE" class="sbody"> 
     <td width='20%'><font face=細明體 color=#000000>機構名稱</font></td>
     <td width='30%'><font face=細明體 color=#000000><%=bank_name%></font></td>
     <td width='20%'><font face=細明體 color=#000000>作業人員</font></td>
     <td width='30%'><font face=細明體 color=#000000><%=lguser_name%></font></td>
     </tr>
     </table>
 </td>