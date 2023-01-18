<%
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>								          
<%@ page import="com.tradevan.util.report.RptFR032W" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>							          
<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁	     
   String act = ( request.getParameter("act")==null ) ? "view" : (String)request.getParameter("act");			  
   String s_year  = ( request.getParameter("S_YEAR")==null ) ? "" : (String)request.getParameter("S_YEAR");
   String s_month = ( request.getParameter("S_MONTH")==null ) ? "" : (String)request.getParameter("S_MONTH");
   String e_year  = ( request.getParameter("E_YEAR")==null ) ? "" : (String)request.getParameter("E_YEAR");
   String e_month = ( request.getParameter("E_MONTH")==null ) ? "" : (String)request.getParameter("E_MONTH");
   String datestate = ( request.getParameter("datestate")==null ) ? "0" : (String)request.getParameter("datestate");
   String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle"); //108.05.28 add 
   System.out.println("act="+act);
   System.out.println("s_year="+s_year);
   System.out.println("s_month="+s_month);
   System.out.println("e_year="+e_year);
   System.out.println("e_month="+e_month);
   if(act.equals("view")){
      //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.28調整顯示的副檔名
   }else if (act.equals("download")){   
	   response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.28調整顯示的副檔名
   }
   
%>
<%
	try{	
	    System.out.println("createRpt="+RptFR032W.createRpt(s_year,s_month,e_year,e_month,datestate));
	    String filename = "農業信用保證基金業務統計(二).xls";//108.05.28 add
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