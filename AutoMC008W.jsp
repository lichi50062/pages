<%
//97.10.13 add 排程發佈檢查局財務報表 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.*" %>
<%@ page import="com.tradevan.util.ftp.MyFTPClient" %>

<%@ page import="java.lang.Integer" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="java.util.*,java.io.*" %>
<%
   System.out.println("=============執行檢查局財務報表發佈開始===========");      
   String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? "" : (String)request.getParameter("S_YEAR");		
   String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? "" : (String)request.getParameter("S_MONTH");		
   String lguser_id = ( request.getParameter("lguser_id")==null ) ? "" : (String)request.getParameter("lguser_id");		
   String lguser_name = ( request.getParameter("lguser_name")==null ) ? "" : (String)request.getParameter("lguser_name");		  
   
   RequestDispatcher rd = null;
   //申報上個月份的報表
   Calendar now = Calendar.getInstance();
   String YEAR  = String.valueOf(now.get(Calendar.YEAR)-1911); //回覆值為西元年故需-1911取得民國年;
   String MONTH = String.valueOf(now.get(Calendar.MONTH)+1);   //月份以0開始故加1取得實際月份;
   if(MONTH.equals("1")){//若本月為1月份是..則是申報上個年度的12月份
      YEAR = String.valueOf(Integer.parseInt(YEAR) - 1);
      MONTH = "12";	
   }else{    
      MONTH = String.valueOf(Integer.parseInt(MONTH) - 1);//申報上個月份的
   }
   
   if(!S_YEAR.equals("") && !S_MONTH.equals("")){
      YEAR = S_YEAR;
      MONTH = S_MONTH;
   }
   logDir  = new File(Utility.getProperties("logDir"));
   if(!logDir.exists()){
        if(!Utility.mkdirs(Utility.getProperties("logDir"))){
    	   System.out.println("目錄新增失敗");
        }    
   }
   logfile = new File(logDir + System.getProperty("file.separator") + "MC008W."+ logfileformat.format(nowlog));						 
   System.out.println("logfile filename="+logDir + System.getProperty("file.separator") +"MC008W."+ logfileformat.format(nowlog));
   logos = new FileOutputStream(logfile,true);  		        	   
   logbos = new BufferedOutputStream(logos);
   logps = new PrintStream(logbos);			    
 
   String errMsg = "";
   RptGenerateALL a = new RptGenerateALL();
   errMsg += a.createRpt(YEAR,MONTH,logps);
   System.out.println("errMsg = "+errMsg);   
   logcalendar = Calendar.getInstance(); 
   nowlog = logcalendar.getTime();
   logps.println(logformat.format(nowlog)+errMsg);		    					    
   logps.flush();
   System.out.println("=============執行檢查局財務報表發佈結束===========");
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