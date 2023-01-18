<%
// 95.10.23
// AN009W 某年底各縣市農漁會信用部逾期放款、比率及存放款及比率彙總表
// created by ABYSS Brenda
// 99.05.12 fix 修改部分程式以共用方式撰寫 by 2808
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.RptAN009W" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%
	System.out.println("AN009W_Excel.jsp Start...");
    Map dataMap =Utility.saveSearchParameter(request);
	response.setContentType("application/octet-stream");//以上這行設定本網頁為excel格式的網頁
	
	//取得參數 查詢年、月，行庫編號，顯示動作(下載或是檢視)
   	String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR")) ;
   	String bankType = Utility.getTrimString(dataMap.get("bankType")) ; 
   	String unit = Utility.getTrimString(dataMap.get("unit")) ; 
   	String printStyle = Utility.getTrimString(dataMap.get("printStyle")); //108.05.28 add
   	response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.28調整顯示的副檔名
    //以上這行設定傳送到前端瀏覽器時的檔名為view.xls
    //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔

	try{
		//生成report
	    String actMsg =RptAN009W.createRpt(S_YEAR, bankType, unit);
	    System.out.println("createRpt = "+actMsg);
	    
	    FileInputStream fin = null;
	    
    	//System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+Utility.ISOtoBig5("某年底各縣市農漁會信用部逾期放款、比率及存放款及比率彙總表.xls"));
    	String filename = "某年底各縣市農漁會信用部逾期放款、比率及存放款及比率彙總表.xls";//108.05.28 add
    	if(!printStyle.equalsIgnoreCase("xls")) {//108.05.28非xls檔須執行轉換	                
		   rptTrans rptTrans = new rptTrans();	  	  			  	
		   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
		   System.out.println("newfilename="+filename);	  			   
		}
    	fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);//108.05.28 fix
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
	
	System.out.println("AN009W_Excel.jsp End...");
%>
