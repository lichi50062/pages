<%
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.Region" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.TM008W" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%@ page import="com.tradevan.util.report.HssfStyle" %>
<%@ page import="com.tradevan.util.report.reportUtil" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="java.lang.StringBuffer" %>
<jsp:useBean id="rptData" scope="request" class="java.util.LinkedList" />
<jsp:useBean id="accTrType" scope="request" class="java.lang.String" />
<jsp:useBean id="accTrTypeName" scope="request" class="java.lang.String" />
<jsp:useBean id="applyDate" scope="request" class="java.lang.String" />
<%
	response.setContentType("application/msexcel;charset=UTF-8");
	String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle"); //108.05.28 add
	response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.28調整顯示的副檔名
	String fileName = "辦理情形統計表.xls";
	String userName = Utility.getTrimString(request.getSession().getAttribute("muser_name"));
	TM008W.getInstance().createRpt(userName , accTrTypeName , applyDate , rptData);
	if(!printStyle.equalsIgnoreCase("xls")) {//108.05.28非xls檔須執行轉換	                
	   rptTrans rptTrans = new rptTrans();	  	  			  	
	   fileName = rptTrans.transOutputFormat (printStyle,fileName,""); 
	   System.out.println("newfilename="+fileName);	  			   
	}
	FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir") + System.getProperty("file.separator") + fileName);
	ServletOutputStream out1 = response.getOutputStream();
	byte[] line=new byte[8196];
	int getBytes=0;
	while(((getBytes=fin.read(line,0,8196))) != -1 ){
		out1.write(line,0,getBytes);
		out1.flush();
	}

	fin.close();
	out1.close();
%>
