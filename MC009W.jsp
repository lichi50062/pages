<%
//97.11.21 create by 2295
//97.11.28 add 增加日期區間 by 2295
//99.10.13 fix 套用共用Header.include/Tail.include by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.*" %>
<%@ page import="com.tradevan.util.xml.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*,java.io.*" %>
<%@include file="./include/Header.include" %>
<%
	
	//登入者資訊
	String lguser_tbank_no = ( session.getAttribute("tbank_no")==null ) ? "" : (String)session.getAttribute("tbank_no");			
	session.setAttribute("nowtbank_no",null);//94.01.05 fix 沒有Bank_List,把所點選的Bank_no清除======	
	String bank_type = ( session.getAttribute("bank_type")==null ) ? "" : (String)session.getAttribute("bank_type");				
			
	String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR"));	
	String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH"));	
	String S_DAY = Utility.getTrimString(dataMap.get("S_DAY"));	
	String E_YEAR = Utility.getTrimString(dataMap.get("E_YEAR"));	
	String E_MONTH = Utility.getTrimString(dataMap.get("E_MONTH"));	
	String E_DAY = Utility.getTrimString(dataMap.get("E_DAY"));	
	String fileType = Utility.getTrimString(dataMap.get("fileType"));	
	String firstStatus = Utility.getTrimString(dataMap.get("firstStatus"));					
	
    String S_DATE = "";
    String E_DATE = "";
 	
	if(!Utility.CheckPermission(request,"MC009W")){//無權限時,導向到LoginError.jsp
        rd = application.getRequestDispatcher( LoginErrorPgName );        
    }else{            
    	//set next jsp 	    	
    	if(act.equals("Qry") || act.equals("goQry")){                    	        	    
    	    rd = application.getRequestDispatcher( ListPgName +"?act=Qry&firstStatus="+firstStatus);            	        	        	    	    
    	}else if(act.equals("GenerateRpt")){
    		logDir  = new File(Utility.getProperties("logDir"));
   			if(!logDir.exists()){
        		if(!Utility.mkdirs(Utility.getProperties("logDir"))){
    	   			System.out.println("目錄新增失敗");
        		}    
   			}
    	 	//logfile = new File(logDir + System.getProperty("file.separator") + "MC009W."+ logfileformat.format(nowlog));						 
   			//System.out.println("logfile filename="+logDir + System.getProperty("file.separator") +"MC009W."+ logfileformat.format(nowlog));
   			//logos = new FileOutputStream(logfile,true);  		        	   
   			//logbos = new BufferedOutputStream(logos);
   			//logps = new PrintStream(logbos);			    	
    		System.out.println("=============檢查報告資料下載作業開始===========");
    		//logfile = new File(logDir + System.getProperty("file.separator") + "MC009W."+ logfileformat.format(nowlog));						 
  			//System.out.println("logfile filename="+logDir + System.getProperty("file.separator") +"MC009W."+ logfileformat.format(nowlog));
   			//logos = new FileOutputStream(logfile,true);  		        	   
   			//logbos = new BufferedOutputStream(logos);
   			//logps = new PrintStream(logbos);			    
 
   			parseDOM a = new parseDOM();
  			S_DATE = String.valueOf(Integer.parseInt(S_YEAR)+1911)+"-"+S_MONTH+"-"+S_DAY;
  			System.out.println("S_DATE="+S_DATE);
  			E_DATE = String.valueOf(Integer.parseInt(E_YEAR)+1911)+"-"+E_MONTH+"-"+E_DAY;
  			System.out.println("E_DATE="+E_DATE);
  	        if(fileType.equals("exd05")){
	     	   actMsg +=a.parse_exd05(S_DATE,E_DATE); 
	     	}else if(fileType.equals("exd08")){
	     	   actMsg +=a.parse_exd08(S_DATE,E_DATE); 
	     	}
   			
   			System.out.println("actMsg = "+actMsg);   
   			//logcalendar = Calendar.getInstance(); 
   			//nowlog = logcalendar.getTime();
   			//logps.println(logformat.format(nowlog)+actMsg);		    					    
   			//logps.flush();
   			//System.out.println("=============檢查報告資料下載作業結束===========");
   			out.print(actMsg);
         	rd = application.getRequestDispatcher( nextPgName );                       
    	}
    	request.setAttribute("actMsg",actMsg);    
    	request.setAttribute("alertMsg",alertMsg);
    	request.setAttribute("webURL_Y",webURL_Y);
    }        
     
%>

<%@include file="./include/Tail.include" %>

<%!
    private final static String report_no = "MC009W";
    private final static String nextPgName = "/pages/ActMsg.jsp";        
    private final static String ListPgName = "/pages/"+report_no+"_List.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp"; 
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