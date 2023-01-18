<%
//108.05.27 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>								          
<%@ page import="com.tradevan.util.report.FR007W_Excel" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>						          
<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁	     
   String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");			  
   System.out.println("act="+act);
   
   String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? "" : (String)request.getParameter("S_YEAR");
   String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? "" : (String)request.getParameter("S_MONTH");
   String E_YEAR = ( request.getParameter("E_YEAR")==null ) ? "" : (String)request.getParameter("E_YEAR");
   String E_MONTH = ( request.getParameter("E_MONTH")==null ) ? "" : (String)request.getParameter("E_MONTH");
   String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");
   String datestate = ( request.getParameter("datestate")==null ) ? "" : (String)request.getParameter("datestate");
   String Unit = ( request.getParameter("Unit")==null ) ? "" : (String)request.getParameter("Unit");
   String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle"); //108.05.27 add
   
   System.out.println("S_YEAR="+S_YEAR);
   System.out.println("S_MONTH="+S_MONTH);
   System.out.println("E_YEAR="+E_YEAR);
   System.out.println("E_MONTH="+E_MONTH);
   System.out.println("bank_type="+bank_type);
   System.out.println("datestate="+datestate);
   System.out.println("Unit="+Unit); 

   String excelAction = ( request.getParameter("excelaction")==null ) ? "" : (String)request.getParameter("excelaction");			    	
   if(excelAction.equals("view")){
      //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.27調整顯示的副檔名
   }else if (excelAction.equals("download")){   
	   response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.27調整顯示的副檔名
   }
   
%>
<%
	try{	
	    String actMsg = FR007W_Excel.createRpt(S_YEAR,S_MONTH,E_YEAR,E_MONTH,bank_type,datestate,Unit);
	    System.out.println("createRpt="+actMsg);
	    String filename = "農(漁)會資產品質分析彙總表.xls";//108.05.27 add
		if(!printStyle.equalsIgnoreCase("xls")) {//108.05.27非xls檔須執行轉換	                
		   rptTrans rptTrans = new rptTrans();	  	  			  	
		   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
		   System.out.println("newfilename="+filename);	  			   
		}
		System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);//108.05.27 fix
		FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);//108.05.27 fix	 
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