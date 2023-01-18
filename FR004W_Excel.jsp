<%
// 94.11.18 add 金額單位 by 2295	
// 99.04.27 fix 修改以dataMap方式存取 by 2808
//108.05.08 add 報表格式挑選 by 2295		
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>								          
<%@ page import="com.tradevan.util.report.FR004W_Excel" %>	
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>		
<%@ page import="com.tradevan.util.transfer.rptTrans" %>						          
<%
   Map dataMap =Utility.saveSearchParameter(request);
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁	     
   String act = Utility.getTrimString(dataMap.get("act"));			  
   
   String BANK_DATA = Utility.getTrimString(dataMap.get("BANK_NO"));			  
   String BANK_NO = BANK_DATA.substring(0,BANK_DATA.indexOf("/"));
   String BANK_NAME = BANK_DATA.substring(BANK_DATA.indexOf("/")+1,BANK_DATA.length());
   String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR"));
   String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH")); 
   String Unit = dataMap.get("Unit")==null? "1" : (String)dataMap.get("Unit");			  
   String hasMonth = Utility.getTrimString(dataMap.get("hasMonth"));
   String printStyle = Utility.getTrimString(dataMap.get("printStyle")); //108.05.08 add 
   String fileName = "農業信用部損益表.xls";
   System.out.println("S_YEAR="+S_YEAR);
   System.out.println("S_MONTH="+S_MONTH);   
   System.out.println("BANK_NO="+BANK_NO);
   System.out.println("BANK_NAME="+BANK_NAME);
   System.out.println("Unit="+Unit);
   System.out.println("hasMonth="+hasMonth);
   String excelAction = Utility.getTrimString(dataMap.get("excelaction")); 			    	
   if(excelAction.equals("view")){
      //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.08調整顯示的副檔名         
   }else if (excelAction.equals("download")){   
      response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.08調整顯示的副檔名         
   }
   
%>
<%
	try{	
	    String actMsg = FR004W_Excel.createRpt(S_YEAR,S_MONTH,BANK_NO,BANK_NAME,Unit,hasMonth);
	    System.out.println("createRpt="+actMsg);
	    System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+fileName);
	    
	    if(!printStyle.equalsIgnoreCase("xls")) {//108.05.08非xls檔須執行轉換	                
	  	   rptTrans rptTrans = new rptTrans();	  			
	  	   fileName = rptTrans.transOutputFormat (printStyle,fileName,""); 
	  	   System.out.println("newfilename="+fileName);	  			   
        };	
	    
		FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+fileName);  		 
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