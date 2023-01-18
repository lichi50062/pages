<%
// FR026W_Excel 某年底縣市別之全體農漁會信用部存款金額及存款平均餘額表
// 94.11.18 created by lilic0c0 4183
//108.05.15 add 報表格式挑選 by 2295		
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.RptAN005W" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>

<%
    System.out.println("AN005_Excel.jsp Start...");
    Map dataMap =Utility.saveSearchParameter(request);
	response.setContentType("application/octet-stream");//以上這行設定本網頁為excel格式的網頁
	
	//取得參數 查詢年、月，行庫編號，顯示動作(下載或是檢視)
   	String S_YEAR =  Utility.getTrimString(dataMap.get("S_YEAR")) ;
   	String bankType = Utility.getTrimString(dataMap.get("bankType")) ;
   	String unit = Utility.getTrimString(dataMap.get("unit")) ; 
   	String printStyle = Utility.getTrimString(dataMap.get("printStyle")) ; //108.05.15
   	String filename = "年底縣市別之全體農漁會信用部存款金額及存款平均餘額表.xls";
   	
   	response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.15調整顯示的副檔名   
    //以上這行設定傳送到前端瀏覽器時的檔名為view.xls
    //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔

	try{
		//生成report
	    String actMsg =RptAN005W.createRpt(S_YEAR, bankType, unit);
	    System.out.println("createRpt = "+actMsg);
	    
	    if(!printStyle.equalsIgnoreCase("xls")) {//108.05.15非xls檔須執行轉換	                
	  	     rptTrans rptTrans = new rptTrans();	  			
	  	     filename = rptTrans.transOutputFormat (printStyle,filename,""); 
	  	     System.out.println("newfilename="+filename);	  			   
        };		    								 
	   	
	    
	    FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
		ServletOutputStream output = response.getOutputStream();
		byte[] line = new byte[1024];
		int getBytes=0;
		while( ((getBytes=fin.read(line,0,1024)))!=-1 ){
			output.write(line,0,getBytes);
			output.flush();
	    }
		//關閉檔案
		fin.close();
		output.close();

	}catch(Exception e){
	   System.out.println(e.getMessage());
	}
	
	System.out.println("AN005_Excel.jsp123 End...");
%>
