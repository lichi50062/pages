<%
// 95.10.24
// AN004W 多個年度農漁會信用部存款結構及變動表
// created by ABYSS Allen
// 99.06.04 fixed by 2808 套用Header.include
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility_report" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="/pages/include/Header.include" %>
<%!
	private final static String report_no ="AN004W" ;
	private final static String ListPgName = "/pages/report/"+report_no+"_Qry.jsp";
	private final static String CreatePgName = "/pages/report/"+report_no+"_Excel.jsp";
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";
	private final static String BANK_TYPE = "020";

%>
<%
	
    String bank_type = Utility.getTrimString(dataMap.get("bank_type")) ;
	String userId = Utility.getTrimString(session.getAttribute("muser_id"));
	String userName = Utility.getTrimString(session.getAttribute("muser_name"));
	String bankType=request.getParameter("bankType")==null?"ALL":request.getParameter("bankType");//農(漁)會別
	String priceUtil=request.getParameter("priceUtil")==null?"1000":request.getParameter("priceUtil");//金額單位
    


	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
			rd = application.getRequestDispatcher( LoginErrorPgName );
		}else if(act.equals("Qry")){
			List bankTypeList = Utility_report.getTatolBankType();
			List cityList = Utility_report.getCity();
			request.setAttribute("TBank",bankTypeList);
			request.setAttribute("CityList", cityList);
			rd = application.getRequestDispatcher( ListPgName+"?bank_type="+bank_type );
		}else if(act.equals("Excel")){
			String S_YEAR1 = request.getParameter("S_YEAR1");
			String S_YEAR2 = request.getParameter("S_YEAR2");
			request.setAttribute("S_YEAR1",S_YEAR1);
			request.setAttribute("S_YEAR2",S_YEAR2);
			request.setAttribute("bankType", bankType);
			request.setAttribute("priceUtil", priceUtil);
			String printStyle = request.getParameter("printStyle");//108.05.28 add
			request.setAttribute("printStyle", printStyle);//108.05.28 add
			rd = application.getRequestDispatcher(CreatePgName);
		}
	
%>
<%@include file="/pages/include/Tail.include" %>