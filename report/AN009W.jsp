<%
// 95.10.23
// AN009W 某年底各縣市農漁會信用部逾期放款、比率及存放款及比率彙總表
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
	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
		rd = application.getRequestDispatcher( LoginErrorPgName );
	}else if(act.equals("Qry")){
		rd = application.getRequestDispatcher( ListPgName );
	}else if(act.equals("Excel")){
		//取得使用者所選的查詢條件
		String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR")) ;
		String bankType = Utility.getTrimString(dataMap.get("bankType")) ; 
		String unit =  Utility.getTrimString(dataMap.get("unit")) ;  
		String printStyle =  Utility.getTrimString(dataMap.get("printStyle"));
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
    private final static String report_no = "AN009W" ;
	private final static String ListPgName = "/pages/report/"+report_no+"_Qry.jsp";
	private final static String CreatePgName = "/pages/report/"+report_no+"_Excel.jsp";
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";

	
%>
