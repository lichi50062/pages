<%
//106.06.02 create 經營月報表 by George
//108.11.05 add 報表格式挑選 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.RptFR076W" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>

<%@include file="./include/Header.include" %>

<%
	response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
	String bank_type = (request.getParameter("bank_type") == null) ? "" : (String) request.getParameter("bank_type");
	String S_YEAR = (request.getParameter("S_YEAR") == null) ? "" : (String) request.getParameter("S_YEAR");
	String S_MONTH = (request.getParameter("S_MONTH") == null) ? "" : (String) request.getParameter("S_MONTH");
	String Unit = Utility.getTrimString(dataMap.get("Unit"));
	String printStyle = Utility.getTrimString(dataMap.get("printStyle")); //108.11.05 add
	String filename = "經營月報表.xls";

	System.out.println("S_YEAR=" + S_YEAR);
	System.out.println("S_MONTH=" + S_MONTH);
	System.out.println("act=" + act);
	System.out.println("bank_type=" + bank_type);

	if (!Utility.CheckPermission(request, report_no)) {//無權限時,導向到LoginError.jsp
		rd = application.getRequestDispatcher(LoginErrorPgName);
	} else {
		if (act.equals("Qry")) {
			rd = application.getRequestDispatcher(QryPgName + "?bank_type=" + bank_type);
		} else if (act.equals("download")) {
			response.setHeader("Content-Disposition", "attachment; filename=download."+printStyle);//108.11.05調整顯示的副檔名   
		}

		if (act.equals("download")) {
			try {
				actMsg = RptFR076W.createRpt(S_YEAR, S_MONTH, bank_type, Unit);
				System.out.println("createRpt=" + actMsg);
				System.out.println("filename=" + Utility.getProperties("reportDir")+ System.getProperty("file.separator") + filename);
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
	private final static String report_no = "FR076W";
	private final static String nextPgName = "/pages/ActMsg.jsp";
	private final static String QryPgName = "/pages/FR076W_Qry.jsp";
	private final static String RptCreatePgName = "/pages/FR076W_Excel.jsp";
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";
%>
