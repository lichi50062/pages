<%
//106.12.04 add 下載金融機構代號轉換清單 by 2295
//108.05.14 add 報表格式挑選 by 2295		
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.RptAS003W1" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>

<%@include file="./include/Header.include" %>

<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁

    String filename="金融機構代號轉換清單.xls";
    String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle");//108.05.14		  
    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    	rd = application.getRequestDispatcher( LoginErrorPgName );
    }else{
	 	//set next jsp
	 	if(act.equals("Qry")){
	 	   rd = application.getRequestDispatcher( QryPgName );
	 	}else if(act.equals("view")){
    	   //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
    	   //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔
    		response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.14調整顯示的副檔名       
    	}
    	if(act.equals("view") || act.equals("download")){
    		response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.14調整顯示的副檔名       ;
    		try{
	 			System.out.println("=========call RptAS003W1") ;
    			actMsg =RptAS003W1.createRpt();
	 			
	 			if(!printStyle.equalsIgnoreCase("xls")) {//108.05.14非xls檔須執行轉換	                
	               rptTrans rptTrans = new rptTrans();	  			
	               filename = rptTrans.transOutputFormat (printStyle,filename,""); 
	               System.out.println("newfilename="+filename);	  			   
                };	       
	 	
	 			//System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+actMsg);
	 			FileInputStream fin = new FileInputStream(
	 					Utility.getProperties("reportDir")
	 					+System.getProperty("file.separator") + filename
	 					);
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
    private final static String report_no = "AS003W";
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String QryPgName = "/pages/"+report_no+"_Qry.jsp";
    private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";
    private final static String RptCreatePgName1 = "/pages/"+report_no+"_Excel1.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";    
    
    
%>
