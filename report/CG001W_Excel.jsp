<%
// 95.11.02 稽核記錄統計管理功能 Create By Allen
//108.05.15 add 報表格式挑選 by 2295		
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.RptCG001WA"%>
<%@ page import="com.tradevan.util.report.RptCG060WA"%>
<%@ page import="com.tradevan.util.report.RptCG001WB"%>
<%@ page import="com.tradevan.util.report.RptCG060WB"%>
<%@ page import="com.tradevan.util.report.RptCG061W"%>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>

<%!
	private HashMap staticBankNameMap = new HashMap();
	public void setBankFieldNameMapValue(){
		staticBankNameMap.put("B01_log","9700002");
		staticBankNameMap.put("B02_log","9700002");
		staticBankNameMap.put("B03_1_log","9700002");
		staticBankNameMap.put("B03_2_log","9700002");
		staticBankNameMap.put("B03_3_log","9700002");
		staticBankNameMap.put("B03_4_log","9700002");
		staticBankNameMap.put("M01_log","9700002");
		staticBankNameMap.put("M02_log","9700002");
		staticBankNameMap.put("M03_log","9700002");
		staticBankNameMap.put("M03_NOTE_log","9700002");
		staticBankNameMap.put("M04_log","9700002");
		staticBankNameMap.put("M05_TOTACC_log","9700002");
		staticBankNameMap.put("M05_log","9700002");
		staticBankNameMap.put("M06_log","9700002");
		staticBankNameMap.put("M07_log","9700002");
		staticBankNameMap.put("M08_log","9700002");
		staticBankNameMap.put("WLX_Notify_log", "8888888");
		staticBankNameMap.put("WTT07_ELM_log", "8888888");
		staticBankNameMap.put("ExHelpItemF_log", "9700002");
	}
%>
<%
	response.setContentType("application/octet-stream");
   	String startYear = request.getAttribute("S_YEAR")==null ? "" :request.getAttribute("S_YEAR").toString();
   	String startMonth = request.getAttribute("S_MONTH")==null ? "" :request.getAttribute("S_MONTH").toString();
   	String endYear = request.getAttribute("E_YEAR")==null ? "" :request.getAttribute("E_YEAR").toString();
   	String endMonth = request.getAttribute("E_MONTH")==null ? "" :request.getAttribute("E_MONTH").toString();
   	String bankType = request.getAttribute("BANK_TYPE")==null?"":(String)request.getAttribute("BANK_TYPE");
   	String reportType = request.getAttribute("REPORT_TYPE")==null?"":(String)request.getAttribute("REPORT_TYPE");
   	String reportGroup = request.getAttribute("reportGroup")==null?"":(String)request.getAttribute("reportGroup");
   	String bankListDst = (String)request.getAttribute("BankListDst");
    String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle");//108.05.15
   	if(bankListDst.equals("")){
   		bankListDst = "A01_LOG,A02_LOG,A03_LOG,A04_LOG,A05_LOG,A06_LOG,A99_LOG"
   					+ ",B01_log,B02_log,B03_1_log,B03_2_log,B03_3_log,B03_4_log,BN04_log,BANK_CMML_log"
   					+ ",ExDisTripF_log,ExHelpItemF_log,ExScheduleF_log,ExReportF_log"
   					+ ",ExSnDocF_log,ExRtDocF_log,ExDefGoodF_log,ExDG_HistoryF_log"
   					+ ",ExWarningF_log,F01_log"
   					+ ",WML01_log,WML02_log,WML03_log,WLX05_M_ATM_log,WLX05_ATM_SETUP_log"
   					+ ",WLX06_M_OUTPUSH_log,WLX07_M_IMPORTANT_log,WLX08_S_GAGE_APPLY_log"
   					+ ",WLX08_S_GAGE_log,WLX09_S_WARNING_log,WLX_APPLY_LOCK_log,WLX_Notify_log"
   					+ ",WTT07,WTT07_ELM_log,WLX_S_RATE_log,WLX01_log,WLX01_M_log,WLX02_log"
   					+ ",WLX02_M_log,WLX04_log,WTT01_log,WZZ07_log"
   					+ ",M01_log,M02_log,M03_log,M03_NOTE_log,M04_log,M05_TOTACC_log,M05_log,M05_NOTE_log"
   					+ ",M06_log,M07_log,M08_log,MUSER_DATA_log";
   	}
   	String[] tableName = bankListDst.split(",");
   	setBankFieldNameMapValue();
   	System.out.println("bankListDst ="+bankListDst);
   	response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.15調整顯示的副檔名   
	try{
	    String actMsg = "";
	    String reportName="";
	    if(reportGroup.equals("OTHER") && tableName.length==1){
	    	reportName = tableName[0];
	    	if(reportName.equals("WTT01")){
	    		reportType="1";
	    	}
	    }
	    System.out.println("reportType="+reportType+":reportName="+reportName);
	    String filename = "";
	    if(reportType.equals("1")){
	    	if(reportName.equals("WTT01")){
	    		System.out.println("test1");
	    		actMsg = RptCG061W.createRpt(startYear, startMonth, endYear, endMonth, bankType);
	    		filename = "使用者帳號數量統計概況表.xls";
	    		System.out.println("test2");
	    	}else if(reportName.equals("WTT06")){
	    		actMsg = RptCG060WA.createRpt(startYear, startMonth, endYear, endMonth, bankType);
	    		filename = "使用者帳號期間未使用總表.xls";
	    	}else{
	    		actMsg = RptCG001WA.createRpt(startYear, startMonth, endYear, endMonth, reportType, bankType, tableName,staticBankNameMap);
	    		filename = "稽核記錄統計總表.xls";
	    	}
	    }else{
	    	if(reportName.equals("WTT06")){
	    		actMsg = RptCG060WB.createRpt(startYear, startMonth, endYear, endMonth, bankType);
	    		filename = "使用者帳號期間未使用明細表.xls";
	    	}else{
	    		actMsg = RptCG001WB.createRpt(startYear, startMonth, endYear, endMonth, reportType, bankType, tableName,staticBankNameMap);
	    		filename = "稽核記錄統計明細表.xls";
	    	}
	    }
	    System.out.println("CG001W_Excel actMsg = "+actMsg);
	    
	   if(!printStyle.equalsIgnoreCase("xls")) {//108.05.15非xls檔須執行轉換	                
	  	   rptTrans rptTrans = new rptTrans();	  			
	  	   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
	  	   System.out.println("newfilename="+filename);	  			   
        };		    								 
	    
	    FileInputStream fin = null;
	    if(reportType.equals("1")){
	    	if(reportName.equals("WTT01")){
	    		fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	    	}else if(reportName.equals("WTT06")){
	    		fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	    	}else{
	    		fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	    	}
	    }else{
	    	if(reportName.equals("WTT06")){
	    		fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	    	}else{
	    		fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	    	}
	    }
		ServletOutputStream output = response.getOutputStream();
		byte[] line = new byte[1024];
		int getBytes=0;
		while( ((getBytes=fin.read(line,0,1024)))!=-1 ){
			output.write(line,0,getBytes);
			output.flush();
	    }
		fin.close();
		output.close();
	}catch(Exception ex){
	   System.out.println("//.... jsp/Report/CG001W_Excel.jsp Have Error...");
	   ex.printStackTrace();
	   System.out.println("//.....................................");
	}
%>