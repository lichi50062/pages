<%
//94.11.16 designed by lilic0c0 4183
//96.11.29 fix 總表-新增金融卡本月交易次數/金融卡本月交易金額(元)/本年累計交易次數/本年累計交易金額(元) by 2295
//96.11.30 add 農漁會信用部金融卡發卡及ATM裝設情形資料_明細表 by 2295
//101.07.26 fix 增加是否顯示機構中英文名稱 by 2968
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.FR025W_Excel" %>
<%@ page import="com.tradevan.util.report.RptFR025WB" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%
   	System.out.println("FR025W_Excel.jsp Start...");
	response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁

	String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");
	String showEng = ( request.getParameter("showEng")==null ) ? "" : (String)request.getParameter("showEng");
   	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");
   	String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? "" : (String)request.getParameter("S_YEAR");
   	String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? "" : (String)request.getParameter("S_MONTH");
    String Unit = ( request.getParameter("Unit")==null ) ? "" : (String)request.getParameter("Unit");
    String rptStyle = ( request.getParameter("rptStyle")==null ) ? "" : (String)request.getParameter("rptStyle");
   	String excelAction = ( request.getParameter("excelaction")==null ) ? "" : (String)request.getParameter("excelaction");
   	String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle"); //108.05.28 add

   	if(excelAction.equals("view")){
   	   //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
   	   //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔
   	   response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.28調整顯示的副檔名
   	}else if (excelAction.equals("download")){
   		response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.28調整顯示的副檔名
   	}
%>
<%
	try{
	    String actMsg = "";
	    String filename = ""; //108.05.28 add 
	    if(rptStyle.equals("0")){//總表
			filename = "全體"+(bank_type.equals("6")?"農":"漁")+"會信用部自動化機器彙計.xls";//108.05.28 add
			actMsg = FR025W_Excel.createRpt(S_YEAR,S_MONTH,bank_type,Unit);
	       //fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+"全體"+(bank_type.equals("6")?"農":"漁")+"會信用部自動化機器彙計.xls");
	    }else{//明細表.96.11.30新增
	    	filename = (bank_type.equals("6")?"農":"漁")+"會信用部金融卡發卡及ATM裝設情形資料_明細表.xls";//108.05.28 add
			actMsg = RptFR025WB.createRpt(S_YEAR,S_MONTH,bank_type,Unit,showEng);
	       //fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+(bank_type.equals("6")?"農":"漁")+"會信用部金融卡發卡及ATM裝設情形資料_明細表.xls");
	    }   
	    
		if(!printStyle.equalsIgnoreCase("xls")) {//108.05.28非xls檔須執行轉換	                
		   rptTrans rptTrans = new rptTrans();	  	  			  	
		   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
		   System.out.println("newfilename="+filename);	  			   
		}
		  
	    System.out.println("createRpt="+actMsg);
	    FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);//108.05.28 add
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

    System.out.println("FR025W_Excel.jsp End...");
%>
