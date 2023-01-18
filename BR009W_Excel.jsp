<%
//94.01.03 by 4180
//99.12.30 fix 根據查詢年度.100年以後取得新縣市別.100年以前取得舊縣市別 by 2295
//102.06.26 add 配合個資法,對所產生之EXCEL報表進行壓縮加密 by 2968
//108.05.31 add 報表格式轉換 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.ListArray" %>	
<%@ page import="com.tradevan.util.report.RptBR009W" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>								          
<%@include file="./include/Header.include" %>

<%
   response.setContentType("application/octet-stream;charset=UTF-8");//通知client端要下載檔案類型
   String bank_type = ( session.getAttribute("nowbank_type")==null ) ? "" : (String)session.getAttribute("nowbank_type");	    
   String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR"));
   String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH"));
   String filename=(bank_type.equals("6"))?"農漁會管理人員名冊":"農漁會管理人員名冊";
   String BankList="";
   List BankList_data=null;
   if(session.getAttribute("BankList") != null && !((String)session.getAttribute("BankList")).equals("")){
	  BankList = (String)session.getAttribute("BankList");
	  BankList_data = Utility.getReportData(BankList);
	  System.out.println("BankList_data.size()="+BankList_data.size());
	  System.out.print("農漁會信用部:"+BankList);		   
   }
  
   System.out.println("act="+act);
   System.out.println("bank_type="+bank_type);
   
   String printStyle = "";//輸出格式 108.05.31 add
   //輸出格式 108.05.31 add
   if(session.getAttribute("printStyle") != null && !((String)session.getAttribute("printStyle")).equals("")){
    printStyle = (String)session.getAttribute("printStyle");		  				   
   }
   
  
    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp        
    
    	rd = application.getRequestDispatcher( LoginErrorPgName );        
    }else{            
		//set next jsp 	
		if(act.equals("Qry")){
		   rd = application.getRequestDispatcher( QryPgName + "?bank_type="+bank_type);        
		}else if(act.equals("view")){
    	   //以上這行設定傳送到前端瀏覽器時的檔名為test1.zip
    	   //就是靠這一行，讓前端瀏覽器以為接收到一個zip檔 
    		response.setHeader("Content-disposition","inline; filename=view.zip");
    	}else if (act.equals("download")){   
    		response.setHeader("Content-Disposition","attachment; filename=download.zip");
    	}   
    	if(act.equals("view") || act.equals("download")){
    		try{		    
				actMsg = RptBR009W.createRpt(S_YEAR,S_MONTH,bank_type,BankList_data);
				System.out.println("createRpt="+actMsg);
				System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+report_no+".xls");
				String filename2 = report_no+".xls";//108.05.31 add
				if(!printStyle.equalsIgnoreCase("xls")) {//108.05.31非xls檔須執行轉換	                
					rptTrans rptTrans = new rptTrans();	  			
					filename2 = rptTrans.transOutputFormat (printStyle,filename2,""); 
					System.out.println("newfilename2="+filename2);	  			   
				}
				//壓縮至zip
				boolean encZipSuccess = Utility.createEncZipFile(filename2,filename+".zip",lguser_id); //108.05.31 fix
	            //to download file from HTTP
				FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename+".zip");  		 
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
    	}
    }
    request.setAttribute("actMsg",actMsg);
%>

<%@include file="./include/Tail.include" %>

<%!
    private final static String report_no = "BR009W";
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String QryPgName = "/pages/"+report_no+"_Qry.jsp";              
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
%>