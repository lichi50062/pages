<%
/* 台灣區農會信用部支票存款戶數與餘額彙計表
 * fixed on 94.12.17 by lilic0c0 4183  
 * 94.11/28 by 4180
 * 99.04.12 fix 物件方式取得reqest參數 by 2808
 * 108.05.28 add 報表格式挑選 by rock.tsai
 */
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.FR030W_Excel" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>

<%
	System.out.println("FR030W_Excel.jsp Program Start...");
    Map dataMap = Utility.saveSearchParameter(request);
	response.setHeader("Content-Disposition","attachment; filename=download.xls");
	response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
	
	String bank_type = Utility.getTrimString(dataMap.get("bank_type"));
   	
   	String act = Utility.getTrimString(dataMap.get("act"));
   	String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR"));
   	String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH"));
    String Unit = Utility.getTrimString(dataMap.get("Unit")); 
   	String excelAction = ( request.getParameter("excelaction")==null ) ?  "" : (String)request.getParameter("excelaction");
   	String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle"); //108.05.28 add 
	
	
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
	    String actMsg = FR030W_Excel.createRpt(S_YEAR,S_MONTH,bank_type,Unit);
	    System.out.println("createRpt="+actMsg);
	    FileInputStream fin = null;
	    String filename = bank_type.equals("6") ? "台灣區農會信用部支票存款戶數與餘額彙計表.xls" : "台灣區漁會信用部支票存款戶數與餘額彙計表.xls";//108.05.28 add
	    if(!printStyle.equalsIgnoreCase("xls")) {//108.05.28非xls檔須執行轉換	                
    	   rptTrans rptTrans = new rptTrans();	  	  			  	
    	   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
    	   System.out.println("newfilename="+filename);	  			   
    	}

    	System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);//108.05.28 fix
   		fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);//108.05.28 fix

	    ServletOutputStream out1 = response.getOutputStream();
	    byte[] line = new byte[8196];
	    int getBytes=0;
	
	    while( ((getBytes=fin.read(line,0,8196)))!=-1 ){
	       out1.write(line,0,getBytes);
	       out1.flush();
	    }
		
		//關閉檔案
	    fin.close();
	    out1.close();
	    
	}catch(Exception e){
	   System.out.println(e.getMessage());
	}
	
	System.out.println("FR030W_Excel.jsp Program End...");
%>






