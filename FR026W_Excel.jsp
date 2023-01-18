<%
// FR026W_Excel 在台無住所之外國人新台幣存款表
// 94.11.18 created by lilic0c0 4183
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.FR026W_Excel" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%
    Map dataMap =Utility.saveSearchParameter(request);
	response.setContentType("application/octet-stream");//以上這行設定本網頁為excel格式的網頁
	
	//取得參數 查詢年、月，行庫編號，顯示動作(下載或是檢視)
	String S_Bank_Name = dataMap.get("tbank")==null ? " " :dataMap.get("tbank").toString();
   	String S_YEAR = dataMap.get("S_YEAR")==null ? " " :dataMap.get("S_YEAR").toString();
   	String S_MONTH = dataMap.get("S_MONTH")==null  ? " " :dataMap.get("S_MONTH").toString();
   	String ExcelAction = dataMap.get("ExcelAction")==null  ? " " :dataMap.get("ExcelAction").toString();
   	String bank_type = request.getAttribute("bank_type")==null  ? " " :request.getAttribute("bank_type").toString();
	String Unit = dataMap.get("Unit")==null  ? " " :dataMap.get("Unit").toString();
	String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle"); //108.05.28 add
   	System.out.println("************ExcelAction:"+ExcelAction) ;
   	if(ExcelAction.equals("view")){
   	   //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
   	   //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔
   	   response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.28調整顯示的副檔名
   	}else if(ExcelAction.equals("download")){
   		response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.28調整顯示的副檔名
   	}
%>

<%
	try{
		//生成report
	    String actMsg =FR026W_Excel.createRpt(S_YEAR,S_MONTH,bank_type,S_Bank_Name,Unit);
	    System.out.println("createRpt = "+actMsg);

	    String filename = "";//108.05.28 add
	    if(bank_type.equals("6")) {
	    	filename = "在台無住所之外國人新台幣存款表-農會.xls";//108.05.28 add
	    	//System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+"在台無住所之外國人新台幣存款表-農會.xls");
	    	//fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+"在台無住所之外國人新台幣存款表-農會.xls");
	    }else {
	    	filename = "在台無住所之外國人新台幣存款表-漁會.xls";//108.05.28 add
	    	//System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+"在台無住所之外國人新台幣存款表-漁會.xls");
	    	//fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+"在台無住所之外國人新台幣存款表-漁會.xls");
	    }
	    
		if(!printStyle.equalsIgnoreCase("xls")) {//108.05.28非xls檔須執行轉換	                
		   rptTrans rptTrans = new rptTrans();	  	  			  	
		   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
		   System.out.println("newfilename="+filename);	  			   
		}
		
		System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);//108.05.28 add
		FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);//108.05.28 add
	    ServletOutputStream output = response.getOutputStream();
		
		byte[] line = new byte[8196];
		int getBytes=0;
		
		while( ((getBytes=fin.read(line,0,8196)))!=-1 ){
			output.write(line,0,getBytes);
			output.flush();
	    }
	    
		//關閉檔案
		fin.close();
		output.close();

	}catch(Exception e){
	   System.out.println(e.getMessage());
	}
	
	System.out.println("FR026W_Excel.jsp End...");
%>
