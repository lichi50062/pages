<%
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>								          
<%@ page import="com.tradevan.util.report.RptTC36" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>								          
<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁	     
   String act = (request.getParameter("act")==null ) ? "view" : (String)request.getParameter("act");
   String excelaction = ( request.getParameter("excelaction")==null ) ? "view" : (String)request.getParameter("excelaction");
   String reportno  = ( request.getParameter("reportno")==null ) ? "" : (String)request.getParameter("reportno");
   String BASE_DATE_BEG_Y =( request.getParameter("BASE_DATE_BEG_Y")==null ) ? "" : request.getParameter("BASE_DATE_BEG_Y").toString();
   String userId = session.getAttribute("muser_id") != null ? (String) session.getAttribute("muser_id") : "" ;
   String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle"); //108.05.28 add
   System.out.println("TC36_Excel.jsp ...Start");
   System.out.println("act="+act);
   System.out.println("excelaction="+excelaction);
   System.out.println("reportno="+reportno);
   System.out.println("S_YEAR="+BASE_DATE_BEG_Y);
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
	    System.out.println("TC36_Excel.createRpt="+RptTC36.createRpt(reportno,BASE_DATE_BEG_Y));
	    Utility.insertDataToLog(request, userId, "TC36");
	    String filename = "金融業務檢查缺失改善情形報告表.xls";//108.05.28 add
	    if(!printStyle.equalsIgnoreCase("xls")) {//108.05.28非xls檔須執行轉換	                
    	   rptTrans rptTrans = new rptTrans();	  	  			  	
    	   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
    	   System.out.println("newfilename="+filename);	  			   
    	}
		FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);//108.05.28 fix  		 
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
%>	    		