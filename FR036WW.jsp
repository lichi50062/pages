<%
//95/01/03 by 4180
//99.04.13 fix 部分程式改以共用方式撰寫 by 2808
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
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>
<%
	//取得session資料,取得成功時,才繼續往下執行===================================================
	//若muser_id資料時,表示登入成功==============================================================
	//登入者資訊	
					
	//==========================================================================================
	String bank_type = Utility.getTrimString(dataMap.get("bank_type"));			    	
	String firstStatus = Utility.getTrimString(dataMap.get("firstStatus"));			    	
	String report_type = Utility.getTrimString(dataMap.get("report_type"));
	
	if(firstStatus.equals("true")){//若從Menu點選時,先清空session裡的資料
	   session.setAttribute("HSIEN_ID",null);   
	   session.setAttribute("BankList",null);    	
	   session.setAttribute("btnFieldList",null);	
	   session.setAttribute("nowbank_type",null);   
	   session.setAttribute("position_code",null);   
	}
	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
        rd = application.getRequestDispatcher( LoginErrorPgName );        
    }else{            
    	//set next jsp 	
    	//將選取的縣市別,金融機構代碼,報表欄位,排序的報表欄位寫到session=======================================   
    	String bankList = Utility.getTrimString(dataMap.get("BankList"));
    	String btnFieldList = Utility.getTrimString(dataMap.get("btnFieldList")) ;
    	String hsien_id = Utility.getTrimString(dataMap.get("HSIEN_ID")) ;
    	if(!"".equals(bankList)){
    	   session.setAttribute("BankList",bankList);    
    	   String BankList_data = "BankList="+(String)session.getAttribute("BankList");	
    	}   
    	if(!"".equals(btnFieldList)){
    	   session.setAttribute("btnFieldList",btnFieldList);	
    	}
    	
        if(!"".equals(hsien_id)){
           session.setAttribute("HSIEN_ID",hsien_id);   
        }
       
        if(!"".equals(bank_type)){
           session.setAttribute("nowbank_type",bank_type);   
        }
        //=================================================================================================
               
        if(act.equals("Qry")){//金融機構
            System.out.println("btnFieldList="+(String)request.getParameter("btnFieldList"));            
            rd = application.getRequestDispatcher( BankListPgName );                 
        }else if(act.equals("createRpt")){//產生Excel報表
            String excelAction = (String)request.getParameter("excelaction");           
            if(report_type.equals("1")){       //信用部統一貸款資料單月報表
            	rd = application.getRequestDispatcher( RptCreatePgName1 +"?act="+excelAction	);         
            }else if(report_type.equals("2")){ //信用部統一貸款資料指定單月新增戶數金額比較報表
                rd = application.getRequestDispatcher( RptCreatePgName2 +"?act="+excelAction	);         
        	}else if(report_type.equals("3")){ //信用部統一農貸資料某二指定期間新增戶數金額比較報表
            	rd = application.getRequestDispatcher( RptCreatePgName3 +"?act="+excelAction	);         
        	}
        }
        
    	request.setAttribute("actMsg",actMsg);    
    	request.setAttribute("alertMsg",alertMsg);
        request.setAttribute("webURL_Y",webURL_Y);
    	request.setAttribute("webURL_N",webURL_N);   
    }        
     
%>
<%@include file="./include/Tail.include" %>
<%!
    private final static String report_no = "FR036WW" ;
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String BankListPgName = "/pages/"+report_no+"_Qry.jsp";          
    private final static String RptCreatePgName1 = "/pages/FR036W_Excel.jsp";  
    private final static String RptCreatePgName2 = "/pages/FR036WA_Excel.jsp";  
    private final static String RptCreatePgName3 = "/pages/FR036WB_Excel.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    
   %>