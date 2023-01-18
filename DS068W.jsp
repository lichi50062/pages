<%
//105.11.09 create 查核案件數彈性報表 by 2295
//108.05.03 add 報表格式轉換 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.reportUtil" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>

<%
	String last_act = Utility.getTrimString(dataMap.get("last_act"));//95.12.08	
	String bank_type = Utility.getTrimString(dataMap.get("bank_type"));    
    String firstStatus = Utility.getTrimString(dataMap.get("firstStatus"));
    String template = Utility.getTrimString(dataMap.get("template"));
    String template_list = Utility.getTrimString(dataMap.get("template_list"));
    String menu = Utility.getTrimString(dataMap.get("menu"));//顯示BOAF menu用		    		
	if(bank_type.equals("")){
	   bank_type = (session.getAttribute("nowbank_type")==null)?"":(String)session.getAttribute("nowbank_type");
	}   
	String nowBank_List = "";//95.12.07 add
	String lastBank_List = "";//95.12.07 add
	System.out.println(report_no+".act="+act);
	System.out.println(report_no+".bank_type="+bank_type);
	if(firstStatus.equals("true")){//若從Menu點選時,先清空session裡的資料
	   session.setAttribute("CANCEL_NO",null);   
	   session.setAttribute("HSIEN_ID",null);   
	   session.setAttribute("BankList",null);    	
	   session.setAttribute("btnFieldList",null);	
	   session.setAttribute("SortList",null);   	   
	   session.setAttribute("SortBy",null);   
	   session.setAttribute("excelaction",null);   
	   session.setAttribute("nowbank_type",null);   
	   session.setAttribute("S_YEAR",null);   
	   session.setAttribute("S_MONTH",null);   
	   session.setAttribute("S_DAY",null);  
	   session.setAttribute("begDate",null);  
	   session.setAttribute("E_YEAR",null);   
	   session.setAttribute("E_MONTH",null);
	   session.setAttribute("E_DAY",null);   
	   session.setAttribute("endDate",null);    
	   session.setAttribute("Unit",null);   
	   session.setAttribute("rptKind",null);
	   session.setAttribute("printStyle",null); //108.05.03 add  	   
	   System.out.println("clear all session");
	}
	
    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp//95.11.03 fix 使用Utility.CheckPermission檢核權限 by 2295
        rd = application.getRequestDispatcher( LoginErrorPgName );        
    }else{            
    	//set next jsp 	
    	//將選取的縣市別,金融機構代碼,報表欄位,排序的報表欄位寫到session=======================================    
    	if(last_act.equals("ReadRpt")){//95.12.08 add讀取完報表格式檔時,回到BankList不做此判斷(金融機構代號若本來選全部->各信用部 or 各信用部->全部,清空已選報表欄位/排序欄位)
    	   if(request.getParameter("BankList")	!= null && !((String)request.getParameter("BankList")).equals("")){
    	      session.setAttribute("BankList",(String)request.getParameter("BankList"));    	
    	   }    	   
    	}else{//不為讀取格式檔時
    	   //95.12.07 add 取得前一次所選取的金融機構代碼=====================================================================
    	   if(session.getAttribute("BankList") != null){        	   
              lastBank_List = (String)session.getAttribute("BankList");
           }           
    	   if(!Utility.getTrimString(dataMap.get("BankList")).equals("")){    	   
    	      nowBank_List = Utility.getTrimString(dataMap.get("BankList"));//95.12.06 add 取得目前所選取的金融機構代碼    	   
    	      session.setAttribute("BankList",Utility.getTrimString(dataMap.get("BankList")));    	    	   
    	   }else{
    	      session.setAttribute("BankList",null);//95.12.07 add 目前無所選取的金融機構代碼時,則session先清成null
    	   }  
    	}   
    	if(!Utility.getTrimString(dataMap.get("btnFieldList")).equals("")){
    	   session.setAttribute("btnFieldList",Utility.getTrimString(dataMap.get("btnFieldList")));	
    	}
    	if(!Utility.getTrimString(dataMap.get("rptKind")).equals("")){
            session.setAttribute("rptKind",(String)request.getParameter("rptKind"));   
        }
    	
    	
    	if(!Utility.getTrimString(dataMap.get("SortList")).equals("")){
    	   System.out.println(report_no+".SortList="+Utility.getTrimString(dataMap.get("SortList")));
           session.setAttribute("SortList",Utility.getTrimString(dataMap.get("SortList")));   
        }
        if(!last_act.equals("ReadRpt")){//95.12.08 add不為讀取完報表格式檔,判斷是否清除已選報表欄位/排序欄位
            //95.12.07 add 金融機構代號若本來選全部->各信用部 or 各信用部->全部,清空已選報表欄位/排序欄位============================================
            System.out.println("nowBank_List="+nowBank_List);
            System.out.println("lastBank_List="+lastBank_List);
            if((nowBank_List.indexOf("ALL") != -1 && lastBank_List.indexOf("ALL") == -1 )//目前所選的Bank_List,有選全部;上次選的Bank_List.沒選全部    	   
            || (nowBank_List.indexOf("ALL") == -1 && lastBank_List.indexOf("ALL") != -1 ))//目前所選的Bank_List,沒選全部;上次選的Bank_List.有選全部    	   
    	    {        
    	       session.setAttribute("btnFieldList",null);//清除已勾選的勾選的報表欄位)
               session.setAttribute("SortList",null);//清除已勾選的欲sort的報表欄位                 
    	    }
    	}
    	//=======================================================================================================================================
        //營運中/已裁撤=============================================================
        if(!Utility.getTrimString(dataMap.get("CANCEL_NO")).equals("")){
           session.setAttribute("CANCEL_NO",(String)request.getParameter("CANCEL_NO"));   
        }
        //=======================================================================================
        if(!Utility.getTrimString(dataMap.get("HSIEN_ID")).equals("")){
           session.setAttribute("HSIEN_ID",(String)request.getParameter("HSIEN_ID"));   
        }
        if(!Utility.getTrimString(dataMap.get("SortBy")).equals("")){
           session.setAttribute("SortBy",(String)request.getParameter("SortBy"));   
        }
        if(!Utility.getTrimString(dataMap.get("excelaction")).equals("")){
           session.setAttribute("excelaction",(String)request.getParameter("excelaction"));   
        }     
           
        if(!Utility.getTrimString(dataMap.get("bank_type")).equals("")){
           //95.09.06 此次所選的bank_type與上次不同清除已勾選的勾選的報表欄位/sort報表欄位
           if(session.getAttribute("nowbank_type") != null && !((String)session.getAttribute("nowbank_type")).equals(bank_type)){                           
              session.setAttribute("btnFieldList",null);//清除已勾選的勾選的報表欄位)
              session.setAttribute("SortList",null);//清除已勾選的欲sort的報表欄位
           }                 
           session.setAttribute("nowbank_type",Utility.getTrimString(dataMap.get("bank_type")));   
        }else{//request無所選bank_type
           if(session.getAttribute("nowbank_type") != null){    
              bank_type = (String)session.getAttribute("nowbank_type");
           }
        }
        //95.11.10 add 儲存DS_bank_type. menu的機構類別===================================================================
        if(!Utility.getTrimString(dataMap.get("DS_bank_type")).equals("")){           
           session.setAttribute("DS_bank_type",Utility.getTrimString(dataMap.get("DS_bank_type")));
           session.setAttribute("nowbank_type",Utility.getTrimString(dataMap.get("DS_bank_type")));//100.05.04
        }
        if(firstStatus.equals("true") && (!Utility.getTrimString(dataMap.get("bank_type")).equals(""))){           
           session.setAttribute("DS_bank_type",Utility.getTrimString(dataMap.get("bank_type"))); 
        }
        //===============================================================================================================
        
        //年-begin
        if(!Utility.getTrimString(dataMap.get("S_YEAR")).equals("")){
           session.setAttribute("S_YEAR",(String)request.getParameter("S_YEAR"));
        }
        //年-end
        if(!Utility.getTrimString(dataMap.get("E_YEAR")).equals("")){
           session.setAttribute("E_YEAR",(String)request.getParameter("E_YEAR"));   
        }
       
        //月-begin
        if(!Utility.getTrimString(dataMap.get("S_MONTH")).equals("")){
           session.setAttribute("S_MONTH",(String)request.getParameter("S_MONTH"));   
        }
        //月-end
        if(!Utility.getTrimString(dataMap.get("E_MONTH")).equals("")){
           session.setAttribute("E_MONTH",(String)request.getParameter("E_MONTH"));   
        }
        
        //日-begin
        if(!Utility.getTrimString(dataMap.get("S_DAY")).equals("")){
           session.setAttribute("S_DAY",(String)request.getParameter("S_DAY"));   
        }
        //日-end
        if(!Utility.getTrimString(dataMap.get("E_DAY")).equals("")){
           session.setAttribute("E_DAY",(String)request.getParameter("E_DAY"));   
        }
        
        //查核期間-begin
        if(!Utility.getTrimString(dataMap.get("begDate")).equals("")){
           session.setAttribute("begDate",(String)request.getParameter("begDate"));   
        }
        //查核期間-end
        if(!Utility.getTrimString(dataMap.get("endDate")).equals("")){
           session.setAttribute("endDate",(String)request.getParameter("endDate"));   
        }
        //輸出格式 108.05.03 add
        if(!Utility.getTrimString(dataMap.get("printStyle")).equals("")){
           session.setAttribute("printStyle",(String)request.getParameter("printStyle"));   
        }            
        //=================================================================================================
        if(act.equals("RptColumn")){//報表欄位              			
        	rd = application.getRequestDispatcher( RptColumnPgName );        
        }else if(act.equals("BankList")){//金融機構
            System.out.println("btnFieldList="+Utility.getTrimString(dataMap.get("btnFieldList")));            
            rd = application.getRequestDispatcher( BankListPgName );        
        }else if(act.equals("createRpt")){//產生Excel報表
            String excelAction = (String)session.getAttribute("excelaction");
            rd = application.getRequestDispatcher( RptCreatePgName +"?act="+excelAction);         
        }
        
    	request.setAttribute("actMsg",actMsg);    
    	request.setAttribute("alertMsg",alertMsg);
    	request.setAttribute("webURL_Y",webURL_Y);
    	request.setAttribute("webURL_N",webURL_N);   
    }            
%>

<%@include file="./include/Tail.include" %>

<%!
    private final static String report_no = "DS068W";
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String BankListPgName = "/pages/"+report_no+"_BankList.jsp";    
    private final static String RptColumnPgName = "/pages/"+report_no+"_RptColumn.jsp";  
    private final static String RptOrderPgName = "/pages/"+report_no+"_RptOrder.jsp";  
    private final static String RptStylePgName = "/pages/"+report_no+"_RptStyle.jsp";  
    private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";  
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";    
%>    