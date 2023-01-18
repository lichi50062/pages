<%
//106.05.23 create 農漁會信用部超逾法定比率一覽表 by George
//108.11.05 add 報表格式挑選 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.RptFR078W" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>

<%
	response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
	String act = (request.getParameter("act") == null) ? "view" : (String) request.getParameter("act");
	String bank_type = (request.getParameter("bank_type") == null) ? "" : (String) request.getParameter("bank_type");
	String S_YEAR = (request.getParameter("S_YEAR") == null) ? "" : (String) request.getParameter("S_YEAR");
	String S_MONTH = (request.getParameter("S_MONTH") == null) ? "" : (String) request.getParameter("S_MONTH");
	String printStyle = (request.getParameter("printStyle") == null) ? "" : (String) request.getParameter("printStyle");//108.11.05 add

	String filename = "超逾法定比率一覽表.xls";

	System.out.println("S_YEAR=" + S_YEAR);
	System.out.println("S_MONTH=" + S_MONTH);
	System.out.println("act=" + act);
	System.out.println("bank_type=" + bank_type);

	RequestDispatcher rd = null;
	boolean doProcess = false;
	String actMsg = "";

	if (!Utility.CheckPermission(request, report_no)) {//無權限時,導向到LoginError.jsp
		rd = application.getRequestDispatcher(LoginErrorPgName);
	} else {
		if (act.equals("Qry")) {
			rd = application.getRequestDispatcher(QryPgName + "?bank_type=" + bank_type);
		} else if (act.equals("view")) {
			//以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
			//就是靠這一行，讓前端瀏覽器以為接收到一個excel檔
			response.setHeader("Content-disposition", "inline; filename=view."+printStyle);//108.11.05調整顯示的副檔名   
		} else if (act.equals("download")) {
			response.setHeader("Content-Disposition", "attachment; filename=download."+printStyle);//108.11.05調整顯示的副檔名   
		}

		if (act.equals("view") || act.equals("download")) {
			try {
				actMsg = RptFR078W.createRpt(S_YEAR, S_MONTH, bank_type);
				System.out.println("createRpt=" + actMsg);
				System.out.println("filename=" + Utility.getProperties("reportDir")	+ System.getProperty("file.separator") + filename);
				if(!printStyle.equalsIgnoreCase("xls")) {//108.11.05非xls檔須執行轉換	                
	  			   rptTrans rptTrans = new rptTrans();	  			
	  			   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
	  			   System.out.println("newfilename="+filename);	  			   
                };
				FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir") + System.getProperty("file.separator") + filename);
				ServletOutputStream out1 = response.getOutputStream();
				byte[] line = new byte[8196];
				int getBytes = 0;
				while (((getBytes = fin.read(line, 0, 8196))) != -1) {
					out1.write(line, 0, getBytes);
					out1.flush();
				}

				fin.close();
				out1.close();

			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
	}
	request.setAttribute("actMsg", actMsg);
%>
<%@include file="./include/Tail.include" %>

<%!
	private final static String report_no = "FR078W";
	private final static String nextPgName = "/pages/ActMsg.jsp";
	private final static String QryPgName = "/pages/FR078W_Qry.jsp";
	private final static String RptCreatePgName = "/pages/FR078W_Excel.jsp";
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";
%>
