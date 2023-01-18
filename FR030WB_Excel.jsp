<%
/*
  *   created on 95.1.6  by lilic0c0 4183  
  *   99.04.09 修正畫面部分程式為共用元件 by 2808
  *   108.05.28 add 報表格式挑選 by rock.tsai
  */ 
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.FR030WB_Excel" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>

<%
	System.out.println("FR030WB_Excel.jsp Program Start...");
    Map dataMap =Utility.saveSearchParameter(request);
	response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
	
	String act = dataMap.get("act")==null?"view" : (String)dataMap.get("act") ;
	String bank_type = Utility.getTrimString(dataMap.get("bank_type"));
	String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR")); 
	String Unit = dataMap.get("Unit")==null?"1" : (String)dataMap.get("Unit");
	String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH"));
	String printStyle = Utility.getTrimString(dataMap.get("printStyle")); //108.05.28 add
	
	String filename = bank_type.equals("6") ? "台灣區農會信用部支票存款戶數與餘額總表.xls" : "台灣區漁會信用部支票存款戶數與餘額總表.xls";//108.05.28 fix

	if("view".equals(act)){
		//以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
		//就是靠這一行，讓前端瀏覽器以為接收到一個excel檔
		response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.28調整顯示的副檔名
	}else if ("download".equals(act)){
		response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.28調整顯示的副檔名
	}
%>
<%
	try{
	    String actMsg = FR030WB_Excel.createRpt(S_YEAR,S_MONTH,Unit,bank_type);
	    System.out.println("createRpt="+actMsg);

	    if(!printStyle.equalsIgnoreCase("xls")) {//108.05.28非xls檔須執行轉換	                
	    	   rptTrans rptTrans = new rptTrans();	  	  			  	
	    	   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
	    	   System.out.println("newfilename="+filename);	  			   
    	}
	    
    	System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);//108.05.28 fix
    	FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);//108.05.28 fix
		
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
	
	System.out.println("FR030WB_Excel.jsp Program End...");
%>






