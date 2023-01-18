<%
// 95.10.30 稽核記錄統計管理功能 - 統計報表列印 created by ABYSS Brenda
//108.05.16 fix 金融機代碼/縣市別/總機構單位查無資料問題 by 2295
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

<%
	RequestDispatcher rd = null;
	boolean doProcess = false;
	String actMsg = "";
	String alertMsg = "";
	String act = request.getParameter("act") == null ? " ":request.getParameter("act");
	String userId = session.getAttribute("muser_id") == null ? " ":session.getAttribute("muser_id").toString();
	String userName = session.getAttribute("muser_name") == null ? " ":(String) session.getAttribute("muser_name").toString();
	String reportGroup = request.getParameter("reportGroup")==null?"A":request.getParameter("reportGroup");

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
			//取得使用者所選的查詢條件
			String Q_YEAR = ( request.getParameter("Q_YEAR")==null ) ? " " :request.getParameter("Q_YEAR").toString();
			String bankType = ( request.getParameter("bankType")==null ) ? " " :request.getParameter("bankType").toString();

			//傳送參數
			request.setAttribute("Q_YEAR",Q_YEAR);
			request.setAttribute("bankType",bankType);
			request.setAttribute("reportGroup",reportGroup);
			rd = application.getRequestDispatcher( ListPgName );
		}else if(act.equals("Excel")){
			String qYear = ( request.getParameter("Q_YEAR")==null ) ? " " :request.getParameter("Q_YEAR").toString();
			String qMonth = ( request.getParameter("Q_MONTH")==null ) ? " " :request.getParameter("Q_MONTH").toString();
			String bankType = ( request.getParameter("bankType")==null ) ? " " :request.getParameter("bankType").toString();
			String cityType = ( request.getParameter("cityType")==null ) ? " " :request.getParameter("cityType").toString();
			String tbank = ( request.getParameter("tbank")==null ) ? " " :request.getParameter("tbank").toString();
			String tbName = ( request.getParameter("tbName")==null ) ? " " :request.getParameter("tbName").toString();
			
			request.setAttribute("qYear",qYear);
			request.setAttribute("qMonth",qMonth);
			request.setAttribute("bankType",bankType);
			request.setAttribute("cityType",cityType);
			request.setAttribute("tbank",tbank);
			request.setAttribute("tbName",tbName);
			request.setAttribute("reportGroup",reportGroup);
			rd = application.getRequestDispatcher( CreatePgName );
		}
	}
	
	try{//進行導向
		rd.forward(request, response);
	}
	catch(Exception npe){
		System.out.println("///// CG003W.jsp have Error!!");
        System.out.println("Exception = "+npe.getMessage());
        System.out.println("..........");
	}
%>

<%!
	private final static String ListPgName = "/pages/report/CG003W_Qry.jsp";
	private final static String CreatePgName = "/pages/report/CG003W_Excel.jsp";
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";
	
	private final static String BANK_TYPE = "001"; //金融機構代碼	

	//檢核權限=============================================================
    private boolean CheckPermission(HttpServletRequest request){
    	
    	boolean CheckOK=false;
    	HttpSession session = request.getSession();
        Properties permission = ( session.getAttribute("CG003W")==null ) ? new Properties() : (Properties)session.getAttribute("CG003W");
        
        if(permission == null){
        	System.out.println("CG003W_Qry.permission == null");
        }else{
        	System.out.println("CG003W_Qry.permission.size ="+permission.size());
        }
        
        //只要有Query的權限,就可以進入畫面
        if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){
        	CheckOK = true;
        	request.setAttribute("Bank_Type", getCDShareNOWith(BANK_TYPE));
        	request.setAttribute("TBank", getTatolBankType(BANK_TYPE));
        	request.setAttribute("City", getCity());
        }
                
        return CheckOK;
    }
    
    //取得CDShareNO, 欄位cmuse_div為id的所有內容
	private List getCDShareNOWith(String id){
		    List paramList = new ArrayList() ;
    		//查詢條件    
    		String sqlCmd = "SELECT CMUSE_ID,CMUSE_NAME FROM CDSHARENO "
    						+ "WHERE CMUSE_DIV = ? AND CMUSE_ID != 'Z' "
    						+ "ORDER BY CMUSE_ID";
    		paramList.add(id) ;				
            List dbData =  DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");  
                
            return dbData;
    }
    
    //取得所有總機構資料
    private List getTatolBankType(String id){
    	    List paramList = new ArrayList() ;
    		//查詢條件    
    		String sqlCmd = "SELECT HSIEN_id, BN01.BANK_NO , BANK_NAME, BANK_TYPE "
    						+ " FROM  (select * from bn01 where m_year=100)BN01, (select * from wlx01 where m_year=100)WLX01  WHERE BN01.BANK_NO = WLX01.BANK_NO(+) "
    						+ " AND bank_type in ( select cmuse_id from cdshareno where cmuse_div = ? )"
    						+ " order by BANK_NO ";  
    		paramList.add(id) ;							
            List dbData =  DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");     
            return dbData;
    }
    
    //取得所有縣市
    private List getCity(){
    		//查詢條件    
    		String sqlCmd = " SELECT HSIEN_id, HSIEN_name from cd01 order by input_order, hsien_id ";  
            List dbData =  DBManager.QueryDB_SQLParam(sqlCmd,null,"");        
            return dbData;
    }
%>
