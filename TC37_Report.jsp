<%
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>								          
<%@ page import="com.tradevan.util.report.RptTC37" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>								          
<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁	     
   String act = ( request.getParameter("act")==null ) ? "download" : (String)request.getParameter("act");
   String excelaction = ( request.getParameter("excelaction")==null ) ? "download" : (String)request.getParameter("excelaction");
   //List body =  (List) request.getAttribute("ReportBody");
   String startDate = ( request.getParameter("startDate")==null ) ? "" : (String)request.getParameter("startDate");//108.06.14 add
   String endDate = ( request.getParameter("endDate")==null ) ? "" : (String)request.getParameter("endDate");//108.06.14 add
   String duringDate = ( request.getParameter("duringDate")==null ) ? "" : (String)request.getParameter("duringDate");
   String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle"); //108.05.28 add 
   System.out.println("TC37_Excel.jsp ...Start");
   System.out.println("act="+act);
   //ystem.out.println("body.size = " + body.size());
   System.out.println("excelaction="+excelaction);

   if(excelaction.equals("view")){
      //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.28調整顯示的副檔名
   }else if (excelaction.equals("download")){   
	   response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.28調整顯示的副檔名
   }

%>
<%
	try{
	    
	  String fileName = new RptTC37().createReport( startDate , endDate , duringDate);
	  System.out.println("TC37檔案路徑位置 ="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+fileName);
	  if(!printStyle.equalsIgnoreCase("xls")) {//108.05.28非xls檔須執行轉換	                
		   rptTrans rptTrans = new rptTrans();	  	  			  	
		   fileName = rptTrans.transOutputFormat (printStyle,fileName,""); 
		   System.out.println("newfilename="+fileName);	  			   
		}
		FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+fileName);  		 
		ServletOutputStream out1 = response.getOutputStream();           
		byte[] line = new byte[8196];
		int getBytes=0;
		while( ((getBytes=fin.read(line,0,8196)))!=-1 ){
			System.out.println("getBytes ="+getBytes);		  	  	
			out1.write(line,0,getBytes);
			out1.flush();
	    }		
		fin.close();
		out1.close();            		      
		
	}catch(Exception e){
	   System.out.println(e.getMessage());
	}		       
%>	    		