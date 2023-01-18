<%
//107.05.21 create 洗錢關鍵字_依檢查報告編號_分年度 by Etahn
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.RptFR079W" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>

<%
	response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
	String act = (request.getParameter("act") == null) ? "view" : (String) request.getParameter("act");
	String bank_type = (request.getParameter("bank_type") == null) ? "" : (String) request.getParameter("bank_type");
	String strYear = (request.getParameter("S_YEAR") == null) ? "" : (String) request.getParameter("S_YEAR");
	String strMonth = (request.getParameter("S_MONTH") == null) ? "" : (String) request.getParameter("S_MONTH");
	String endYear = (request.getParameter("E_YEAR") == null) ? "" : (String) request.getParameter("E_YEAR");
	String endMonth = (request.getParameter("E_MONTH") == null) ? "" : (String) request.getParameter("E_MONTH");
	String report = (request.getParameter("REPORT_NO") == null) ? "" : (String) request.getParameter("REPORT_NO");
	String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle"); //108.05.28 add
	String[] extraKeyword = request.getParameterValues("extraKeyword");
		
	String filename = "洗錢關鍵字_依檢查報告編號_分年度.xls";

	System.out.println("strYear=" + strYear);
	System.out.println("strMonth=" + strMonth);
	System.out.println("endYear=" + endYear);
	System.out.println("endMonth=" + endMonth);	
	System.out.println("act=" + act);
	System.out.println("bank_type=" + bank_type);
	System.out.println("report_no="+report);

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
			response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.28調整顯示的副檔名
		} else if (act.equals("download")) {
			response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.28調整顯示的副檔名
		}

		if (act.equals("view") || act.equals("download")) {
			try {
				actMsg = RptFR079W.createRpt(strYear, strMonth, endYear, endMonth, bank_type, report, extraKeyword);
				System.out.println("createRpt=" + actMsg);
				System.out.println("filename=" + Utility.getProperties("reportDir")
						+ System.getProperty("file.separator") + filename);
				if(!printStyle.equalsIgnoreCase("xls")) {//108.05.28非xls檔須執行轉換	                
				   rptTrans rptTrans = new rptTrans();	  	  			  	
				   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
				   System.out.println("newfilename="+filename);	  			   
				}
				FileInputStream fin = new FileInputStream(
						Utility.getProperties("reportDir") + System.getProperty("file.separator") + filename);
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
	private final static String report_no = "FR079W";
	private final static String nextPgName = "/pages/ActMsg.jsp";
	private final static String QryPgName = "/pages/FR079W_Qry.jsp";
	private final static String RptCreatePgName = "/pages/FR079W_Excel.jsp";
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";
%>
