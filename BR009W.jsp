<%
//95.01.03 by 4180
//99.12.30 add 查詢日期 by 2295
//102.06.27 add 操作歷程寫入log by2968
//108.05.31 add 報表格式轉換 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@include file="./include/Header.include" %>

<%		    	
	String bank_type = Utility.getTrimString(dataMap.get("bank_type"));    
    String firstStatus = Utility.getTrimString(dataMap.get("firstStatus"));	
    
	if(firstStatus.equals("true")){//若從Menu點選時,先清空session裡的資料
	   session.setAttribute("S_YEAR",null);//99.12.30 add
	   session.setAttribute("S_MONTH",null);//99.12.30 add
	   session.setAttribute("HSIEN_ID",null);   
	   session.setAttribute("BankList",null);    	
	   session.setAttribute("btnFieldList",null);	
	   session.setAttribute("nowbank_type",null);   
	   session.setAttribute("position_code",null);
	   session.setAttribute("printStyle",null); //108.05.31 add
	}
     if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp//95.11.03 fix 使用Utility.CheckPermission檢核權限 by 2295
        rd = application.getRequestDispatcher( LoginErrorPgName );        
    }else{            
    	//set next jsp 	
    	//將選取的縣市別,金融機構代碼,報表欄位,排序的報表欄位寫到session=======================================    
    	if(!Utility.getTrimString(dataMap.get("BankList")).equals("")){
    	   session.setAttribute("BankList",(String)request.getParameter("BankList"));    
    	   String BankList_data = "BankList="+(String)session.getAttribute("BankList");	
    	}   
    	if(!Utility.getTrimString(dataMap.get("btnFieldList")).equals("")){
    	   session.setAttribute("btnFieldList",(String)request.getParameter("btnFieldList"));	
    	}
    	//99.12.30 add 查詢日期====================================================================
        if(!Utility.getTrimString(dataMap.get("S_YEAR")).equals("")){
           session.setAttribute("S_YEAR",(String)request.getParameter("S_YEAR"));   
        }
        if(!Utility.getTrimString(dataMap.get("S_MONTH")).equals("")){
           session.setAttribute("S_MONTH",(String)request.getParameter("S_MONTH"));   
        }    
        //========================================================================================
        if(!Utility.getTrimString(dataMap.get("HSIEN_ID")).equals("")){
           session.setAttribute("HSIEN_ID",(String)request.getParameter("HSIEN_ID"));   
        }
       
        if(!Utility.getTrimString(dataMap.get("bank_type")).equals("")){
           session.setAttribute("nowbank_type",(String)request.getParameter("bank_type"));   
        }
        
        //輸出格式 108.05.31 add
        if(!Utility.getTrimString(dataMap.get("printStyle")).equals("")){
          session.setAttribute("printStyle",(String)request.getParameter("printStyle"));   
        }
        //=================================================================================================
               
        if(act.equals("Qry")){//金融機構
            System.out.println("btnFieldList="+(String)request.getParameter("btnFieldList"));            
            rd = application.getRequestDispatcher( BankListPgName );                 
        }else if(act.equals("createRpt")){//產生Excel報表
            String excelAction = (String)request.getParameter("excelaction");
            this.InsertWlXOPERATE_LOG(request,lguser_id,report_no,"P");
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
    private final static String report_no = "BR009W";
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String BankListPgName = "/pages/"+report_no+"_Qry.jsp";          
    private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    
    public String InsertWlXOPERATE_LOG(HttpServletRequest request,String lguser_id,String program_id,String update_type) throws Exception{    	
		StringBuffer sqlCmd = new StringBuffer();
		List paramList = new ArrayList() ;
		String errMsg="";
	    try {
	        sqlCmd.append(" INSERT INTO WlXOPERATE_LOG(muser_id,use_Date,program_id,ip_address,update_type)");
	        sqlCmd.append("                     VALUES(?,sysdate,?,?,?) ");
	        paramList.add(lguser_id);
	        paramList.add(program_id);
	        paramList.add(request.getRemoteAddr());//ipAddress
	        paramList.add(update_type);//操作類別 I-新增，U-異動，D-刪除，Q-明細，P-列印
	        if(this.updDbUsesPreparedStatement(sqlCmd.toString(),paramList)){
				errMsg = errMsg + "相關資料寫入資料庫成功";					
			}else{
			    errMsg = errMsg + "相關資料寫入log失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
			}
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入log失敗";						
		}	

		return errMsg;
	}
    private boolean updDbUsesPreparedStatement(String sql ,List paramList) throws Exception{
		List updateDBList = new ArrayList();//0:sql 1:data
	    List updateDBSqlList = new ArrayList();//欲執行updatedb的sql list
		List updateDBDataList = new ArrayList();//儲存參數的List
		
		updateDBDataList.add(paramList);
		updateDBSqlList.add(sql);
		updateDBSqlList.add(updateDBDataList);
		updateDBList.add(updateDBSqlList);
		return DBManager.updateDB_ps(updateDBList) ;
	}
%>