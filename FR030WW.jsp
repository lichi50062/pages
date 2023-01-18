<%
//95/01/03 by 4180
//99.04.12 fix 搬移部分程式至共用 by 2808
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.BufferedOutputStream" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.PrintStream" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>

<%
	String bank_type = ( session.getAttribute("bank_type")==null ) ? "" : (String)session.getAttribute("bank_type");
	String firstStatus = Utility.getTrimString(dataMap.get("firstStatus"));  			    	
	String report_type = Utility.getTrimString(dataMap.get("report_type")); 			    	
	String bankList = Utility.getTrimString(dataMap.get("BankList"));
	String btnFieldList = Utility.getTrimString(dataMap.get("btnFieldList"));
	String cityType = Utility.getTrimString(dataMap.get("cityType"));
	if("true".equals(firstStatus)){//若從Menu點選時,先清空session裡的資料
	   session.setAttribute("cityType",null);   
	   session.setAttribute("BankList",null);    	
	   session.setAttribute("btnFieldList",null);	
	   session.setAttribute("nowbank_type",null);   
	   session.setAttribute("position_code",null);   
	}
	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
        rd = application.getRequestDispatcher( LoginErrorPgName );        
    }else{          
    	request.setAttribute("TBank", Utility.getALLTBank(bank_type));
    	request.setAttribute("City",  Utility.getCity());
    	//set next jsp 	
    	//將選取的縣市別,金融機構代碼,報表欄位,排序的報表欄位寫到session=======================================    
    	if(!"".equals(bankList)){
    	   session.setAttribute("BankList",bankList);    
    	   String BankList_data = "BankList="+(String)session.getAttribute("BankList");	
    	}   
    	if(!"".equals(btnFieldList)){
    	   session.setAttribute("btnFieldList",btnFieldList);	
    	}
    	
        if(!"".equals(cityType)){
           session.setAttribute("cityType",cityType);   
        }
       
        if(!"".equals(bank_type)){
           session.setAttribute("nowbank_type",bank_type);   
        }
        //=================================================================================================
               
        if(act.equals("Qry")){//金融機構
            System.out.println("btnFieldList="+btnFieldList);            
            rd = application.getRequestDispatcher( BankListPgName );                 
        }else if(act.equals("createRpt")){//產生Excel報表
            String excelAction = (String)request.getParameter("excelaction");           
            if(report_type.equals("1")){ //信用部支票存款戶數與餘額統計表
            	rd = application.getRequestDispatcher( RptCreatePgName1 +"?act="+excelAction+"&bank_type="+bank_type);         
        	}
        	if(report_type.equals("2")){ //信用部支票存款戶數與餘額明細表
                rd = application.getRequestDispatcher( RptCreatePgName2 +"?act="+excelAction+"&bank_type="+bank_type);        
            }
        	if(report_type.equals("3")){ //信用部支票存款戶數與餘額總表
           	   rd = application.getRequestDispatcher( RptCreatePgName3 +"?act="+excelAction+"&bank_type="+bank_type);        
        	}
        }
        
    	request.setAttribute("actMsg",actMsg);    
    	request.setAttribute("alertMsg",alertMsg);
    	//request.setAttribute("webURL_Y",webURL_Y);
    	//request.setAttribute("webURL_N",webURL_N);   
    }        
     
%>
<%@include file="./include/Tail.include" %>
<%!
    private final static String report_no = "FR030WW";
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String BankListPgName = "/pages/"+report_no+"_Qry.jsp";          
    private final static String RptCreatePgName1 = "/pages/FR030W_Excel.jsp";  
    private final static String RptCreatePgName2 = "/pages/FR030WA_Excel.jsp";  
    private final static String RptCreatePgName3 = "/pages/FR030WB_Excel.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    
   %>