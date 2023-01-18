﻿<%
//102.01.24 add by 2968
//108.05.10 add 報表格式挑選 by 2295
//108.05.10 add 報表格式挑選 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>

<%
	System.out.println("FR063W_Excel.jsp Program Start...");
	response.setContentType("application/msexcel;charset=UTF-8");
	
	String act = "download" ;
	String report =((String)request.getParameter("report")==null)?"":(String)request.getParameter("report");
	String s_year =((String)request.getParameter("s_year")==null)?"":(String)request.getParameter("s_year");
	String s_month =((String)request.getParameter("s_month")==null)?"":(String)request.getParameter("s_month");
	String bank_no =((String)request.getParameter("bank_no")==null)?"":(String)request.getParameter("bank_no");
	String bank_name =((String)request.getParameter("bank_name")==null)?"":(String)request.getParameter("bank_name");
	String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");
	String Unit =((String)request.getParameter("Unit")==null)?"":(String)request.getParameter("Unit");
	String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle");//108.05.10
	String filename="";
	String actMsg = "";
	if("FR063W".equals(report)){
	    filename = "農漁會信用部聯合貸款案件明細表.xls";
	}else{
		filename = "農漁會信用部聯合貸款案件彙總表.xls";
	}
	if(act.equals("view")){
		response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.10調整顯示的副檔名       
	}else if (act.equals("download")){
		response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.10調整顯示的副檔名       
	}
%>
<%
	try{
	    if("FR063W".equals(report)){
	        actMsg = RtpFR063W_Print.createRpt(s_year,s_month,bank_no,bank_name,Unit);
		}else{
		    actMsg = RptFR064W.createRpt(s_year,s_month,Unit,bank_type,"",null);
		}
	    System.out.println("createRpt="+actMsg);
	    if(!printStyle.equalsIgnoreCase("xls")) {//108.05.10非xls檔須執行轉換	                
	  	   rptTrans rptTrans = new rptTrans();	  			
	  	   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
	  	   System.out.println("newfilename="+filename);	  			   
        };
	    
	    FileInputStream fin = null;
	   	fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	   	System.out.println(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
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
	
	System.out.println("FR063W_Excel.jsp Program End...");
	
%>






