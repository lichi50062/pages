<%
// 95.10.30
// CG001W 稽核記錄統計管理功能 - 統計報表列印
// created by ABYSS Brenda
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>

<%
	RequestDispatcher rd = null;
	boolean doProcess = false;
	String actMsg = "";
	String alertMsg = "";
	String act = request.getParameter("act") == null ? " ":request.getParameter("act");
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
			rd = application.getRequestDispatcher( ListPgName );
		}else if(act.equals("Excel")){
			//取得使用者所選的查詢條件
			String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? " " :request.getParameter("S_YEAR").toString();
			String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? " " :request.getParameter("S_MONTH").toString();
			String E_YEAR = ( request.getParameter("E_YEAR")==null ) ? " " :request.getParameter("E_YEAR").toString();
			String E_MONTH = ( request.getParameter("E_MONTH")==null ) ? " " :request.getParameter("E_MONTH").toString();
			String BANK_TYPE = ( request.getParameter("BANK_TYPE")==null ) ? " " :request.getParameter("BANK_TYPE").toString();
			String REPORT_TYPE = ( request.getParameter("REPORT_TYPE")==null ) ? " " :request.getParameter("REPORT_TYPE").toString();
			String reportGroup =  ( request.getParameter("reportGroup")==null ) ? " " :request.getParameter("reportGroup").toString();
			String BankListDst = request.getParameter("BankListDst");
			//傳送參數
			request.setAttribute("S_YEAR",S_YEAR);
			request.setAttribute("S_MONTH",S_MONTH);
			request.setAttribute("E_YEAR",E_YEAR);
			request.setAttribute("E_MONTH",E_MONTH);
			request.setAttribute("BANK_TYPE",BANK_TYPE);
			request.setAttribute("REPORT_TYPE",REPORT_TYPE);
			request.setAttribute("BankListDst",BankListDst);
			request.setAttribute("reportGroup",reportGroup);
			rd = application.getRequestDispatcher( CreatePgName );
		}
	}
	
	try{//進行導向
		rd.forward(request, response);
	}
	catch(Exception npe){
		System.out.println("///// CG001W.jsp have Error!!");
        System.out.println("Exception = "+npe.getMessage());
        System.out.println("..........");
	}
%>

<%!

	private final static String ListPgName = "/pages/report/CG001W_Qry.jsp";
	private final static String CreatePgName = "/pages/report/CG001W_Excel.jsp";
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";

	//檢核權限=============================================================
    private boolean CheckPermission(HttpServletRequest request){
    	
    	boolean CheckOK=false;
    	HttpSession session = request.getSession();
        Properties permission = ( session.getAttribute("CG001W")==null ) ? new Properties() : (Properties)session.getAttribute("CG001W");
        
        if(permission == null){
        	System.out.println("CG001W_Qry.permission == null");
        }else{
        	System.out.println("CG001W_Qry.permission.size ="+permission.size());
        }
        
        //只要有Query的權限,就可以進入畫面
        if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){
        	CheckOK = true;
        }
                
        return CheckOK;
    }
%>
