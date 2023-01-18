<%
//95.04.24 add 農(漁)會信用部逾期放款統計表 by 2295
//97.11.06 add 總表(A04) by 2295
//99.04.28 fix request改用dataMap存取 by 2808
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.*" %>								          
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.BufferedOutputStream" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.PrintStream" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>

<%
    Map dataMap =Utility.saveSearchParameter(request);
	response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁       
	
	String act = Utility.getTrimString(dataMap.get("act"));			    	
	String bank_type = Utility.getTrimString(dataMap.get("bank_type"));			    	
	String BANK_DATA = Utility.getTrimString(dataMap.get("BankListSrc"));			  
    String BANK_NO = "";    
    String BANK_NAME = "";
    String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR")); 
    String S_MONTH =Utility.getTrimString(dataMap.get("S_MONTH")); 
    String Unit = dataMap.get("Unit")==null? "1" : (String)dataMap.get("Unit") ;
    String printStyle = Utility.getTrimString(dataMap.get("printStyle")); //108.05.28 add
    String rptStyle = Utility.getTrimString(dataMap.get("rptStyle"));//總表.明細表			  
    String filename="農漁會信用部逾期放款統計表";
    if("0".equals(rptStyle)) {
    	filename = "農漁會信用部逾期放款統計表_總表" ;
    }
    
    
   
    String excelAction = ( request.getParameter("excelaction")==null ) ? "" : (String)request.getParameter("excelaction");			    	
    
    

    if(excelAction.equals("view")){
      //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.28調整顯示的副檔名
    }else if (excelAction.equals("download")){   
    	response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.28調整顯示的副檔名
    }
    
    try{	
	    String actMsg = "";
	    if(rptStyle.equals("0")){//總表//97.11.06 add  
	    	System.out.println("=====總表===============") ;
	       actMsg = RptFR053W.createRpt(S_YEAR,S_MONTH,bank_type,Unit);	    
	    }else{//明細表
	       BANK_NO =   BANK_DATA.substring(0,BANK_DATA.indexOf("/"));
	       BANK_NAME = BANK_DATA.substring(BANK_DATA.indexOf("/")+1,BANK_DATA.length());
	       System.out.println("=====明細表===============") ;
	       actMsg = RptFR037W.createRpt(S_YEAR,S_MONTH,BANK_NO,bank_type,BANK_NAME,Unit);	    
	    }
	    System.out.println("createRpt="+actMsg);
	    //System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename+".xls");
	    filename = filename +".xls"; //108.05.28 add
	    if(!printStyle.equalsIgnoreCase("xls")) {//108.05.28非xls檔須執行轉換	                
		   rptTrans rptTrans = new rptTrans();	  	  			  	
		   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
		   System.out.println("newfilename="+filename);	  			   
		}
		FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename); //108.05.28 fix	 
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
    