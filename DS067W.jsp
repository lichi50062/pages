<%
//105.11.15 create 協助措施彈性報表 by 2968
//108.05.03 add 報表格式轉換 by 2295
//111.04.12 調整列印報表後,再次列印時,都無資料 by 2295
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
	   session.setAttribute("ACC_TR_TYPE",null);
	   session.setAttribute("Unit",null);
	   session.setAttribute("APPLYDATE",null);   
	   session.setAttribute("ACC_DIV",null);  
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
              //session.setAttribute("btnFieldList",null);//清除已勾選的勾選的報表欄位)//111.04.12 fix
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
        
        if(!Utility.getTrimString(dataMap.get("ACC_TR_TYPE")).equals("")){
           session.setAttribute("ACC_TR_TYPE",(String)request.getParameter("ACC_TR_TYPE"));
        }
        if(!Utility.getTrimString(dataMap.get("Unit")).equals("")){
            session.setAttribute("Unit",(String)request.getParameter("Unit"));   
        }
        if(!Utility.getTrimString(dataMap.get("HSIEN_ID")).equals("")){
            session.setAttribute("HSIEN_ID",(String)request.getParameter("HSIEN_ID"));   
        }
        if(!Utility.getTrimString(dataMap.get("APPLYDATE")).equals("")){
           session.setAttribute("APPLYDATE",(String)request.getParameter("APPLYDATE"));   
        }
        if(!Utility.getTrimString(dataMap.get("ACC_DIV")).equals("")){
           session.setAttribute("ACC_DIV",(String)request.getParameter("ACC_DIV"));   
        }
        //輸出格式 108.05.03 add
        if(!Utility.getTrimString(dataMap.get("printStyle")).equals("")){
           session.setAttribute("printStyle",(String)request.getParameter("printStyle"));   
        }        
        //=================================================================================================
        if(act.equals("RptColumn")){//報表欄位    
        	System.out.println("BankList="+Utility.getTrimString(dataMap.get("BankList"))); 
        	request.setAttribute("AllAccTr", getAllAccTr());
        	request.setAttribute("AllAccList", getAllAccList());
        	request.setAttribute("AllApplyDates", getAllApplyDates());
        	rd = application.getRequestDispatcher( RptColumnPgName );        
        }else if(act.equals("BankList")){//金融機構
            System.out.println("btnFieldList="+Utility.getTrimString(dataMap.get("btnFieldList")));   
            request.setAttribute("AllAccTr", getAllAccTr());
            request.setAttribute("AllLoanBank", getAllLoanBank());
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
    private final static String report_no = "DS067W";
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String BankListPgName = "/pages/"+report_no+"_BankList.jsp";    
    private final static String RptColumnPgName = "/pages/"+report_no+"_RptColumn.jsp";  
    private final static String RptOrderPgName = "/pages/"+report_no+"_RptOrder.jsp";  
    private final static String RptStylePgName = "/pages/"+report_no+"_RptStyle.jsp";  
    private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";  
    private final static String LoginErrorPgName = "/pages/LoginError.jsp"; 
    
    //協助措施名稱
    private List getAllAccTr(){
		//查詢條件
	    List dbData =null;
		StringBuffer sqlCmd = new StringBuffer();
		List paramList = new ArrayList();	
		sqlCmd.append("select acc_tr_type,acc_tr_name ");
		sqlCmd.append("  from loanapply_ncacno ");
		sqlCmd.append(" group by acc_tr_type,acc_tr_name ");
		sqlCmd.append(" order by acc_tr_type ");
		dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"acc_tr_type,acc_tr_name");
	
		return dbData;
	}
    //貸款經辦機構.可選擇項目
    private List getAllLoanBank(){
		//查詢條件
	    List dbData =null;
		StringBuffer sqlCmd = new StringBuffer();
		List paramList = new ArrayList();

		sqlCmd.append(" select acc_tr_type,");//--金融協助措施報表代碼
		sqlCmd.append(" bank_type,");//--貸款經辦機構別 6:農會 7:漁會 A:銀行
		sqlCmd.append(" hsien_id,");//--縣市別
		sqlCmd.append(" loanapply_bn01.bank_code,");//--機構代號	
		sqlCmd.append(" bank_name ");//--機構名稱
		sqlCmd.append(" from loanapply_bn01 ");
		sqlCmd.append(" left join (select  * from bn01 where m_year=100)bn01 on loanapply_bn01.bank_code=bn01.bank_no ");
		sqlCmd.append(" left join (select * from wlx01 where m_year=100)wlx01 on loanapply_bn01.bank_code=wlx01.bank_no ");
		dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
	
		return dbData;
	}
    //申報基準日
    private List getAllApplyDates(){
		//查詢條件
	    List dbData =null;
		StringBuffer sqlCmd = new StringBuffer();
		List paramList = new ArrayList();	
		sqlCmd.append("select acc_tr_type,to_char(applydate,'YYYY/MM/DD') applydate ");
		sqlCmd.append("  from loanapply_period ");
		sqlCmd.append(" group by acc_tr_type,applydate ");
		sqlCmd.append(" order by acc_tr_type,applydate ");
		dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"acc_tr_type,applydate");
	
		return dbData;
	}
    //可挑選的貸款種類
    private List getAllAccList(){
		//查詢條件
	    List dbData =null;
		StringBuffer sqlCmd = new StringBuffer();
		List paramList = new ArrayList();	
		sqlCmd.append("select acc_tr_type,acc_div,acc_code,acc_name ");
		sqlCmd.append("  from loanapply_ncacno ");
		sqlCmd.append(" order by acc_tr_type,acc_div,acc_name ");
		dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"acc_tr_type,acc_div,acc_code,acc_name");
	
		return dbData;
	}
    
%> 
  