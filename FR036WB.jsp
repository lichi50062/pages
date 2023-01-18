<%
//95/01/03 by 4180
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.BufferedOutputStream" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.PrintStream" %>
<%@ page import="java.io.*" %>

<%
	RequestDispatcher rd = null;
	String actMsg = "";	
	String alertMsg = "";	
	String webURL_Y = "";	
	String webURL_N = "";		
	boolean doProcess = false;	
	
	//取得session資料,取得成功時,才繼續往下執行===================================================
	if(session.getAttribute("muser_id") == null){//session timeout		
      System.out.println("FR031WA login timeout");   
	   rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );         	   
	   try{
          rd.forward(request,response);
       }catch(Exception e){
          System.out.println("forward Error:"+e+e.getMessage());
       }
    }else{
      doProcess = true;
    }    
	if(doProcess){//若muser_id資料時,表示登入成功====================================================================	
	
	//登入者資訊	
	String lguser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");		
	String lguser_name = ( session.getAttribute("muser_name")==null ) ? "" : (String)session.getAttribute("muser_name");		
	String lguser_type = ( session.getAttribute("muser_type")==null ) ? "" : (String)session.getAttribute("muser_type");						
	//======================================================================================================================
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");			    	
	String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");			    	
	String firstStatus = ( request.getParameter("firstStatus")==null ) ? "" : (String)request.getParameter("firstStatus");			    	
	System.out.println("act="+act);
	System.out.println("bank_type="+bank_type);
	
	if(firstStatus.equals("true")){//若從Menu點選時,先清空session裡的資料
	   session.setAttribute("HSIEN_ID",null);   
	   session.setAttribute("BankList",null);    	
	   session.setAttribute("btnFieldList",null);	
	   session.setAttribute("nowbank_type",null);   
	   session.setAttribute("position_code",null);   
	}
    if(!CheckPermission(request)){//無權限時,導向到LoginError.jsp
        rd = application.getRequestDispatcher( LoginErrorPgName );        
    }else{            
    	//set next jsp 	
    	//將選取的縣市別,金融機構代碼,報表欄位,排序的報表欄位寫到session=======================================    
    	if(request.getParameter("BankList")	!= null && !((String)request.getParameter("BankList")).equals("")){
    	   session.setAttribute("BankList",(String)request.getParameter("BankList"));    
    	   String BankList_data = "BankList="+(String)session.getAttribute("BankList");	
    	}   
    	if(request.getParameter("btnFieldList")	!= null && !((String)request.getParameter("btnFieldList")).equals("")){
    	   session.setAttribute("btnFieldList",(String)request.getParameter("btnFieldList"));	
    	}
    	
        if(request.getParameter("HSIEN_ID")	!= null && !((String)request.getParameter("HSIEN_ID")).equals("")){
           session.setAttribute("HSIEN_ID",(String)request.getParameter("HSIEN_ID"));   
        }
       
        if(request.getParameter("bank_type") != null && !((String)request.getParameter("bank_type")).equals("")){
           session.setAttribute("nowbank_type",(String)request.getParameter("bank_type"));   
        }
        //=================================================================================================
               
        if(act.equals("Qry")){//金融機構
            System.out.println("btnFieldList="+(String)request.getParameter("btnFieldList"));            
            rd = application.getRequestDispatcher( BankListPgName );                 
        }else if(act.equals("createRpt")){//產生Excel報表
            String excelAction = (String)request.getParameter("excelaction");
            rd = application.getRequestDispatcher( RptCreatePgName +"?act="+excelAction);         
        }
        
    	request.setAttribute("actMsg",actMsg);    
    	request.setAttribute("alertMsg",alertMsg);
    	request.setAttribute("webURL_Y",webURL_Y);
    	request.setAttribute("webURL_N",webURL_N);   
    }        
     
%>

<%
	try {
        //forward to next present jsp
        rd.forward(request, response);
    } catch (NullPointerException npe) {
    }
    }//end of doProcess
%>


<%!
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String BankListPgName = "/pages/FR036WB_Qry.jsp";          
    private final static String RptCreatePgName = "/pages/FR036WB_Excel.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    private boolean CheckPermission(HttpServletRequest request){//檢核權限    	    
    		
    	    boolean CheckOK=false;
    	    HttpSession session = request.getSession();            
            Properties permission = ( session.getAttribute("FR036WB")==null ) ? new Properties() : (Properties)session.getAttribute("FR036WB");				                
            if(permission == null){
              System.out.println("FR036WB.permission == null");
            }else{
               System.out.println("FR036WB.permission.size ="+permission.size());
               
            }
            //只要有Query的權限,就可以進入畫面
        	if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){            
        	   CheckOK = true;//Query
        	}
        	System.out.println("CheckOk="+CheckOK);        	
        	return CheckOK;
    }   
   %>