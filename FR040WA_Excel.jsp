﻿<%
//94.12.04 存放款統計表(FR040WW)--明細表 by 4180
//99.03.26 add 套用saveSearchParameter取得參數 by 2295
//         add 根據查詢年度.100年以後取得新縣市別.100年以前取得舊縣市別 by 2295
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.RptFR040WA" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>

<%
   Map dataMap =Utility.saveSearchParameter(request);
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
   String act = Utility.getTrimString(dataMap.get("act"));
   String bank_type = Utility.getTrimString(dataMap.get("bank_type"));
   String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR"));
   String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH"));
   String Unit = Utility.getTrimString(dataMap.get("Unit"));
   String rptStyle = Utility.getTrimString(dataMap.get("rptStyle"));
   String printStyle = Utility.getTrimString(dataMap.get("printStyle")); //108.05.28 add
   String filename="";
   
   filename =((bank_type.equals("6"))?"農會":"漁會")+((rptStyle.equals("0"))?"存放款彙總表.xls":"存放款彙明細表.xls");
  
   RequestDispatcher rd = null;
   boolean doProcess = false;
   String actMsg = "";
   //取得session資料,取得成功時,才繼續往下執行===================================================   
   if(session.getAttribute("muser_id") == null){//session timeout
      System.out.println(report_no+" login timeout");
	  rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );
	  try{
         rd.forward(request,response);
      }catch(Exception e){
         System.out.println("forward Error:"+e+e.getMessage());
      }
   }else{
      doProcess = true;
   }
   if(doProcess){//若muser_id資料時,表示登入成功====================================================================
   		if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp   
        	rd = application.getRequestDispatcher( LoginErrorPgName );
    	}else{
	    	//set next jsp
	    	if(act.equals("Qry")){
	    	   rd = application.getRequestDispatcher( QryPgName + "?bank_type="+bank_type);
	    	}else if(act.equals("view")){
      		   //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      		   //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔
      			response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.28調整顯示的副檔名
   			}else if (act.equals("download")){
   				response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.28調整顯示的副檔名
   			}
   			if(act.equals("view") || act.equals("download")){
   				try{
	    			actMsg =RptFR040WA.createRpt(S_YEAR,S_MONTH,Unit,bank_type,rptStyle);
	    			System.out.println("createRpt="+actMsg);
	    			if(!printStyle.equalsIgnoreCase("xls")) {//108.05.28非xls檔須執行轉換	                
    				   rptTrans rptTrans = new rptTrans();	  	  			  	
    				   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
    				   System.out.println("newfilename="+filename);	  			   
    				}
	    			System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
					FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
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
		try {
        	//forward to next present jsp
        	rd.forward(request, response);
    	} catch (NullPointerException npe) {
    	}
    }//end of doProcess
%>

<%!
    private final static String report_no = "FR040WW";
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String QryPgName = "/pages/"+report_no+"_Qry.jsp";
    private final static String RptCreatePgName = "/pages/FR040WA_Excel.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";    
%>