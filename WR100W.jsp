<%
//104.03.06 create 農漁會信用部財營運狀況警訊報表-各別指標明細 by 2968
//108.04.18 add 報表格式轉換 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.RptWR100W" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%@include file="./include/Header.include" %>

<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
   String BANK_NO = Utility.getTrimString(dataMap.get("BANK_NO"));
   String bank_type = ( dataMap.get("bank_type")==null ) ? (String)session.getAttribute("bank_type") : Utility.getTrimString(dataMap.get("bank_type"));			
   String rptBlock = Utility.getTrimString(dataMap.get("rptBlock"));
   String rptType = Utility.getTrimString(dataMap.get("rptType"));			
   String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR"));     
   String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH")); 
   String Unit = Utility.getTrimString(dataMap.get("Unit")); 
   String printStyle = ( request.getParameter("printStyle")==null ) ? "xls" : (String)request.getParameter("printStyle");//108.04.18 add
   
   String filename= "";
   String wr_rpt= "";
   if("1".equals(rptType)){
       filename="農漁會信用部營運狀況警訊報表-各項指標明細.xls";
       wr_rpt= rptBlock;
   }else{
       filename="農漁會信用部營運狀況警訊報表-專案農貸-各項指標明細.xls";
       if("0".equals(rptBlock)){
           wr_rpt= "3";
       }else if("1".equals(rptBlock)){
           wr_rpt= "4";
       }else if("2".equals(rptBlock)){
           wr_rpt= "5";
       }
   }
   
   if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    	rd = application.getRequestDispatcher( LoginErrorPgName );
    }else{
	 	//set next jsp
	 	if(act.equals("Qry")){
	 	   rd = application.getRequestDispatcher( QryPgName + "?bank_type="+bank_type);
	 	   session.setAttribute("nowbank_type",bank_type);//100.06.24
	       //request.setAttribute("TBank",getBankList(request) );//按照直轄市在前.其他縣市在後排序.
	 	}else if(act.equals("view")){
    	   //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
    	   //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔
    		response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.04.01調整顯示的副檔名
    	}else if (act.equals("download")){
    		response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.04.01調整顯示的副檔名
    	}
    	if(act.equals("view") || act.equals("download")){
    		try{
	 			actMsg =RptWR100W.createRpt(S_YEAR,S_MONTH,Unit,rptType,wr_rpt);
	 			System.out.println("createRpt="+actMsg);
	 			System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	 			
	 			
	 			if(!printStyle.equalsIgnoreCase("xls")) {//108.04.18 非xls檔須執行轉換	                
	  			   rptTrans rptTrans = new rptTrans();	  			
	  			   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
	  			   System.out.println("newfilename="+filename);	  			   
        };	 	
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
  	
%>
<%@include file="./include/Tail.include" %>

<%!
    private final static String report_no = "WR100W";
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String QryPgName = "/pages/"+report_no+"_Qry.jsp";
    private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";  
    
%>
