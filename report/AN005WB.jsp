<%
// 95.11.08
// AN005WB 某年底縣市別之全體農漁會信用部放款金額及放款平均餘額表
// created by ABYSS Brenda
// 99.04.14 fix 修改部分程式以共用方式撰寫 by 2808
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.*" %>
<%@include file="/pages/include/Header.include" %>
<%
	String bank_type = Utility.getTrimString(dataMap.get("bank_type")) ;
	String userId = session.getAttribute("muser_id") == null ? " ":session.getAttribute("muser_id").toString();
	String userName = session.getAttribute("muser_name") == null ? " ":(String) session.getAttribute("muser_name").toString();

	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
		rd = application.getRequestDispatcher( LoginErrorPgName );
	}else if(act.equals("Qry")){
		rd = application.getRequestDispatcher( ListPgName+"?bank_type="+bank_type );
	}else if(act.equals("Excel")){
		//取得使用者所選的查詢條件
		String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR")) ;
		String bankType = dataMap.get("bankType")==null?" " : (String)dataMap.get("bankType") ;
		String unit = Utility.getTrimString(dataMap.get("unit")) ;
		String printStyle = Utility.getTrimString(dataMap.get("printStyle"));//108.05.28 add
		//傳送參數
		request.setAttribute("S_YEAR",S_YEAR);
		request.setAttribute("bankType",bankType);
		request.setAttribute("unit",unit);
		request.setAttribute("printStyle", printStyle);//108.05.28 add
		rd = application.getRequestDispatcher( CreatePgName );
	}
%>
<%@include file="/pages/include/Tail.include" %>
<%!
    private final static String report_no = "AN005WB" ;
	private final static String ListPgName = "/pages/report/"+report_no+"_Qry.jsp";
	private final static String CreatePgName = "/pages/report/"+report_no+"_Excel.jsp";
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";
	private final static String BANK_TYPE = "020";		//金融機構代碼
%>
