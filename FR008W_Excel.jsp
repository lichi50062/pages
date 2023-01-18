<%
// 95.08.21 add 金額單位 by 2295
// 99.04.28 fix request改以dataMap存取 by 2808
//108.05.08 add 報表格式挑選 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.FR008W_Excel" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>

<%
   Map dataMap =Utility.saveSearchParameter(request);
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
   String act = Utility.getTrimString(dataMap.get("act")) ;
   String bank_type = Utility.getTrimString(dataMap.get("bank_type")) ;
   String BANK_DATA = Utility.getTrimString(dataMap.get("BANK_NO")) ;
   String BANK_NO = BANK_DATA.substring(0,BANK_DATA.indexOf("/"));
   String BANK_NAME = BANK_DATA.substring(BANK_DATA.indexOf("/")+1,BANK_DATA.length());
   String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR")) ; 
   String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH")) ;
   String Unit = dataMap.get("Unit")==null?"1" : (String)dataMap.get("Unit") ;	
   String printStyle = Utility.getTrimString(dataMap.get("printStyle"));//108.05.08 add    		  
   String excelAction =  Utility.getTrimString(dataMap.get("excelaction")) ; 
   String filename="信用部淨值占風險性資產比率.xls";
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
	    String actMsg = FR008W_Excel.createRpt(S_YEAR,S_MONTH,BANK_NO,BANK_NAME,bank_type,Unit);
	    System.out.println("createRpt="+actMsg);
	    System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	    
	    if(!printStyle.equalsIgnoreCase("xls")) {//108.05.08非xls檔須執行轉換	                
	  	   rptTrans rptTrans = new rptTrans();	  			
	  	   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
	  	   System.out.println("newfilename="+filename);	  			   
        };	
	    
		FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
		ServletOutputStream out1 = response.getOutputStream();
		byte[] line = new byte[8192];
		int getBytes=0;
		while( ((getBytes=fin.read(line,0,8192)))!=-1 ){
			out1.write(line,0,getBytes);
			out1.flush();
	    }

		fin.close();
		out1.close();

	}catch(Exception e){
	   System.out.println(e.getMessage());
	}
%>