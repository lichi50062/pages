﻿<%
// 95.06.14 create by 2295
// 98.06.16 add 檢查局格式 by 2295
// 99.04.09 add 套用saveSearchParameter取得參數 by 2295
//108.05.07 add 報表格式挑選 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.RptFR001WW" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%@include file="./include/Header.include" %>

<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
   String bank_type = Utility.getTrimString(dataMap.get("bank_type"));        
   String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR"));     
   String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH"));     
   String Unit = Utility.getTrimString(dataMap.get("Unit"));  
   String showEng = Utility.getTrimString(dataMap.get("showEng"));	 
   String rptStyle = "1";
   String printStyle = Utility.getTrimString(dataMap.get("printStyle")); //108.05.07 add 
    
   String filename="農漁會信用部經營概況統計表.xls";
   System.out.print("FR001WW.S_YEAR="+S_YEAR);
   System.out.print(":act="+act);
   System.out.println(":bank_type="+bank_type+":showEng="+showEng);
  
   
    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    	rd = application.getRequestDispatcher( LoginErrorPgName );
    }else{
	 	//set next jsp
	 	if(act.equals("Qry")){
	 	   rd = application.getRequestDispatcher( QryPgName + "?bank_type="+bank_type);
	 	}else if(act.equals("view")){
    	   //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
    	   //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔
    		response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.06調整顯示的副檔名       
    	}else if (act.equals("download")){
    		response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.06調整顯示的副檔名       
    	}
    	if(act.equals("view") || act.equals("download")){
    		try{
	 			actMsg =RptFR001WW.createRpt(S_YEAR,S_MONTH,Unit,bank_type,rptStyle,"",null,showEng);
	 			System.out.println("createRpt="+actMsg);
	 			System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	 			
	 			if(!printStyle.equalsIgnoreCase("xls")) {//108.05.07非xls檔須執行轉換	                
	  			   rptTrans rptTrans = new rptTrans();	  			
	  			   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
	  			   System.out.println("newfilename="+filename);	  			   
                };	
	 			
	 			FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	 			ServletOutputStream out1 = response.getOutputStream();
	 			byte[] line = new byte[8196];
	 			int getBytes=0;
	 			while( ((getBytes=fin.read(line,0,8196)))!=-1 ){
	 				out1.write(line,0,getBytes);
	 				out1.flush();
	 			}
    
	 			fin.close();
	 			out1.close();
    
	 		}catch(Exception e){
	 			System.out.println(e.getMessage());
	 		}
    	}
    }
   	request.setAttribute("actMsg",actMsg);		
%>
<%@include file="./include/Tail.include" %>

<%!
    private final static String report_no = "FR001WW";
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String QryPgName = "/pages/"+report_no+"_Qry.jsp";
    private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";    
%>
