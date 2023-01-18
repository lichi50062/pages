<%
//95.10.19 
//AN002W 歷年來全體農漁會信用部簡明放款結構比較表
//Create By Allen
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.RptAN002W"%>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%
	//System.out.println("AN001W_Excel.jsp Start...");
	response.setContentType("application/octet-stream");
   	String starYear = Utility.getTrimString(request.getAttribute("S_YEAR1").toString());
   	String endYear = Utility.getTrimString(request.getAttribute("S_YEAR2").toString());
   	String bankType = Utility.getTrimString(request.getAttribute("bankType").toString());
   	String priceUtil = ( request.getAttribute("priceUtil")==null ) ? "1000" :request.getAttribute("priceUtil").toString();
   	String printStyle = ( request.getAttribute("printStyle")==null ) ? " " :request.getAttribute("printStyle").toString(); //108.05.28 add 
   	response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.28調整顯示的副檔名
	try{
	    String actMsg = RptAN002W.createRpt(starYear,endYear,bankType,Integer.parseInt(priceUtil));
	    //System.out.println("RptAN002W.createRpt = "+actMsg);
	    String titleStr = "";
		if(bankType.equals("ALL")){
			titleStr = "歷年來全體農漁會信用部簡明放款結構比較表";
		}else if(bankType.equals("6")){
			titleStr = "歷年來全體農會信用部簡明放款結構比較表";
		}else{
			titleStr = "歷年來全體漁會信用部簡明放款結構比較表";
		}
	    FileInputStream fin = null;
    	//System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+Utility.ISOtoBig5("歷年來全體農漁會信用部簡明放款結構比較表.xls"));
    	String filename = titleStr+".xls";//108.05.28 add
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

		fin.close();
		output.close();
	}catch(Exception ex){
	   System.out.println("//.... jsp/Report/AN002W_Excel.jsp Have Error...");
	   ex.printStackTrace();
	   System.out.println("//.....................................");
	}
	//System.out.println("AN002W_Excel.jsp End...");
%>
