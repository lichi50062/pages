<%
// 95.10.30
// CG002W 稽核記錄統計管理功能 - 清檔備份
// created by ABYSS Brenda
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility_report" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="com.tradevan.util.report.RptCG002W" %>
<%!

	private final static String ListPgName = "/pages/report/CG002W_Qry.jsp";
	private final static String CreatePgName = "/pages/report/CG002W_Excel.jsp";
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";
	private final static String BANK_TYPE = "020";

	//檢核權限=============================================================
    private boolean CheckPermission(HttpServletRequest request){
    	
    	boolean CheckOK=false;
    	HttpSession session = request.getSession();
        Properties permission = ( session.getAttribute("CG002W")==null ) ? new Properties() : (Properties)session.getAttribute("CG002W");
        
        if(permission == null){
        	System.out.println("CG002W_Qry.permission == null");
        }else{
        	System.out.println("CG002W_Qry.permission.size ="+permission.size());
        }
        
        //只要有Query的權限,就可以進入畫面
        if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){
        	CheckOK = true;
        }
                
        return CheckOK;
    }
%>
<%
	RequestDispatcher rd = null;
	boolean doProcess = false;
	String actMsg = "";
	String alertMsg = "";
	String act = request.getParameter("act") == null ? " ":request.getParameter("act");
    String bank_type = request.getParameter("bank_type") == null ? "":request.getParameter("bank_type");
	String userId = session.getAttribute("muser_id") == null ? " ":session.getAttribute("muser_id").toString();
	String userName = session.getAttribute("muser_name") == null ? " ":(String) session.getAttribute("muser_name").toString();
    //取得session資料,取得成功時,才繼續往下執行===================================================
	if(userId.equals("") ){//session timeout
        System.out.println("Login timeout");
		rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );
	}else{
		doProcess = true;
	}

	if(doProcess){//資料取得成功 
		if(!CheckPermission(request)){//無權限時,導向到LoginError.jsp
			rd = application.getRequestDispatcher( LoginErrorPgName );
		}else if(act.equals("Qry")){
			rd = application.getRequestDispatcher(ListPgName);
		}else if(act.equals("Log")){
			String S_YEAR = request.getParameter("S_YEAR");
			String E_YEAR = request.getParameter("E_YEAR");
			String S_MONTH = request.getParameter("S_MONTH");
			String E_MONTH = request.getParameter("E_MONTH");
			request.setAttribute("S_YEAR",S_YEAR);
			request.setAttribute("E_YEAR",E_YEAR);
			request.setAttribute("S_MONTH",S_MONTH);
			request.setAttribute("E_MONTH",E_MONTH);
			String isBakDB = new RptCG002W().goBakDB(S_YEAR,E_YEAR,S_MONTH,E_MONTH);
			rd = application.getRequestDispatcher(ListPgName +"?isBakDB="+isBakDB);
		}
	}
	try{//進行導向
		rd.forward(request, response);
	}
	catch(Exception npe){
        System.out.println("Exception = "+npe.getMessage());
	}
%>
