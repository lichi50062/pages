<%
// 95.10.24
// AN011W 某年底全體農漁會信用部存款、放款、資產總額、淨值、本期損益及淨值與存款總額比率排名表
// created by ABYSS Brenda
// 99.06.08 fixed by 2808 套用Header.include
//108.05.28 add 報表格式挑選 by rock.tsai
//108.06.12 fix 處理報表無法下載 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="/pages/include/Header.include" %>

<%
	
	String userId = Utility.getTrimString(session.getAttribute("muser_id"));
	String userName = session.getAttribute("muser_name") == null ? " ":(String) session.getAttribute("muser_name").toString();


	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
			rd = application.getRequestDispatcher( LoginErrorPgName );
		}else if(act.equals("Qry")){
			rd = application.getRequestDispatcher( ListPgName );
		}else if(act.equals("Excel")){
			//取得使用者所選的查詢條件
			String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? " " :request.getParameter("S_YEAR").toString();
			String bankType = ( request.getParameter("bankType")==null ) ? " " :request.getParameter("bankType").toString();
			String unit = ( request.getParameter("unit")==null ) ? "" :request.getParameter("unit").toString();
			String printStyle = ( request.getParameter("printStyle")==null ) ? "" :request.getParameter("printStyle").toString(); //108.05.28 add 
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
	private final static String report_no = "AN011W" ;
	private final static String ListPgName = "/pages/report/"+report_no+"_Qry.jsp";
	private final static String CreatePgName = "/pages/report/"+report_no+"_Excel.jsp";
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";

%>
