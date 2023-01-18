<%
//109.09.08 add 排程農委會OpenData報表上傳 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.*" %>
<%@ page import="com.tradevan.util.ftp.CoaFtp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<%
	Map dataMap =Utility.saveSearchParameter(request);
	logDir  = new File(Utility.getProperties("logDir"));
    if(!logDir.exists()){
        if(!Utility.mkdirs(Utility.getProperties("logDir"))){
    	   System.out.println("目錄新增失敗");
        }    
    }	
    System.out.println("=============執行農委會OpenData檔案上傳開始===========");
    logfile = new File(logDir + System.getProperty("file.separator") + "WMAutoSendCOARpt."+ logfileformat.format(nowlog));						 
  	System.out.println("logfile filename="+logDir + System.getProperty("file.separator") +"WMAutoSendCOARpt."+ logfileformat.format(nowlog));
   	logos = new FileOutputStream(logfile,true);  		        	   
   	logbos = new BufferedOutputStream(logos);
   	logps = new PrintStream(logbos);			    
 
   	String errMsg ="";
   	CoaFtp a = new CoaFtp();
   	errMsg += a.upload(logps);
   	System.out.println("errMsg = "+errMsg);   
   	logcalendar = Calendar.getInstance(); 
   	nowlog = logcalendar.getTime();
   	logps.println(logformat.format(nowlog)+errMsg);		    					    
   	logps.flush();
   	System.out.println("=============執行農委會OpenData檔案上傳結束===========");
   	out.print(errMsg);    	
    	 
%>
<%!
   
   	private File logfile;
	private FileOutputStream logos=null;    	
	private BufferedOutputStream logbos = null;
	private PrintStream logps = null;
	private Date nowlog = new Date();
	private SimpleDateFormat logformat = new SimpleDateFormat("yyyy/MM/dd  HH:mm:ss  ");	     
	private SimpleDateFormat logfileformat = new SimpleDateFormat("yyyyMMddHHmmss");
	private Calendar logcalendar;
	private File logDir = null;
%>    