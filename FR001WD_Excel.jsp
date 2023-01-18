<%
//101.08 created by 2968
// 108.05.27 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>	
<%@ page import="com.tradevan.util.report.RptFR001WD" %>								          
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%@include file="./include/Header.include" %>
<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁	
   act = ( request.getParameter("act")==null ) ? "view" : (String)request.getParameter("act");
   String Unit =( request.getParameter("Unit")==null ) ? "" : (String)request.getParameter("Unit");
   String bank_type =( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");
   String S_YEAR =( request.getParameter("S_YEAR")==null ) ? "" : (String)request.getParameter("S_YEAR");
   String S_MONTH =( request.getParameter("S_MONTH")==null ) ? "" : (String)request.getParameter("S_MONTH");
   String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle"); //108.05.27 add 
   System.out.println(report_no+", "+act+", "+bank_type+", "+S_YEAR+", "+S_MONTH);
   //String filename=S_YEAR+S_MONTH+"農漁會信用部營運概況.xls";
   String filename="農漁會信用部營運概況.xls";  
  
   if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
   	  rd = application.getRequestDispatcher( LoginErrorPgName );        
   }else{            
	 	//set next jsp 	
	 	if("Qry".equals(act)){
	 	   rd = application.getRequestDispatcher( QryPgName + "?bank_type="+bank_type);        
	 	}else if("view".equals(act)){
   	       //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
   	       //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
	 		response.setHeader("Content-disposition","inline; filename=view."+printStyle); // 108.05.27調整顯示的副檔名   
        }else if ("download".equals(act)){   
        	response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);// 108.05.27調整顯示的副檔名
        }
        if("view".equals(act) || "download".equals(act)){
   		 	try{	
	         	actMsg = RptFR001WD.createRpt(S_YEAR,S_MONTH,Unit,bank_type);
	         	System.out.println("createRpt="+actMsg);
	         	System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	         	
    			if(!printStyle.equalsIgnoreCase("xls")) {//108.05.27非xls檔須執行轉換	                
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
    private final static String report_no = "FR001WD";
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String QryPgName = "/pages/"+report_no+"_Qry.jsp";        
    private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";   
%>