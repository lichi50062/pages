<%
// 95.10.20
// AN008W 某年底全體農漁會信用部逾期放款及存款、放款、淨值備抵呆帳分析表
// created by ABYSS Brenda
//108.05.28 add 報表格式挑選 by rock.tsai
//108.06.12 fix 調整因檔名造成無法轉ods/pdf問題 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.RptAN008W" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%
	System.out.println("AN008W_Excel.jsp Start...");
	response.setContentType("application/octet-stream");//以上這行設定本網頁為excel格式的網頁
	
	//取得參數 查詢年、月，行庫編號，顯示動作(下載或是檢視)
   	String S_YEAR = ( request.getAttribute("S_YEAR")==null ) ? "" :request.getAttribute("S_YEAR").toString();
   	String bankType = ( request.getAttribute("bankType")==null ) ? "" :request.getAttribute("bankType").toString();
   	String unit = ( request.getAttribute("unit")==null ) ? "" :request.getAttribute("unit").toString();
   	String printStyle = ( request.getAttribute("printStyle")==null ) ? "" :request.getAttribute("printStyle").toString(); //108.05.28 add
   	System.out.println("printStyle="+printStyle);
   	response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.28調整顯示的副檔名
    //以上這行設定傳送到前端瀏覽器時的檔名為view.xls
    //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔

	try{
		//生成report
	    String actMsg =RptAN008W.createRpt(S_YEAR, bankType, unit);
	    System.out.println("createRpt = "+actMsg);
	    
	    FileInputStream fin = null;
	    
    	//System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+Utility.ISOtoBig5("某年底全體農漁會信用部逾期放款及存款、放款、淨值備抵呆帳分析表.xls"));
    	String filename = "某年底全體農漁會信用部逾期放款及存款_放款_淨值備抵呆帳分析表.xls";//108.05.28 add
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
	
	System.out.println("AN008W_Excel.jsp End...");
%>
