<%
//107.05.18 create 洗錢關鍵字報表-依縣市別 by 6417
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.RptFR080W" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@include file="./include/Header.include" %>
<%!
	private final static String report_no = "FR080W";
	private final static String nextPgName = "/pages/ActMsg.jsp";
	private final static String QryPgName = "/pages/FR080W_Qry.jsp";
	private final static String RptCreatePgName = "/pages/FR080W_Excel.jsp";
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";
%>
<%
	response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
	String bank_type = (request.getParameter("bank_type") == null) ? "" : (String) request.getParameter("bank_type");
	String S_YEAR = (request.getParameter("S_YEAR") == null) ? "" : String.valueOf(Integer.parseInt(request.getParameter("S_YEAR"))+1911);
	String S_MONTH = (request.getParameter("S_MONTH") == null) ? "" : (String) request.getParameter("S_MONTH");
	String E_YEAR = (request.getParameter("E_YEAR") == null) ? "" : String.valueOf(Integer.parseInt(request.getParameter("E_YEAR"))+1911);
	String E_MONTH = (request.getParameter("E_MONTH") == null) ? "" : (String) request.getParameter("E_MONTH");
	String cityType = (request.getParameter("cityType") == null) ? "" : (String) request.getParameter("cityType");
	String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle"); //108.05.28 add
	String[] extraKeyword = request.getParameterValues("extraKeyword");
	
	System.out.println("act=" + act);
	System.out.println("bank_type=" + bank_type);
	System.out.println("cityType=" + cityType);
	System.out.println("extraKeyword=" + extraKeyword);
	

	if (!Utility.CheckPermission(request, report_no)) {//無權限時,導向到LoginError.jsp
		rd = application.getRequestDispatcher(LoginErrorPgName);
	} else {
		if (act.equals("Qry")) {
	        session.setAttribute("nowbank_type",bank_type);//100.06.24
			request.setAttribute("TBank",Utility.getBankList(request) );
			request.setAttribute("City", Utility.getCity());
			rd = application.getRequestDispatcher(QryPgName + "?bank_type=" + bank_type);
		} else if (act.equals("download")) {
				
			try {
				String filename = null;
				if("ALL".equals(cityType)){
					 filename = "洗錢關鍵字_依縣市別_總表.xls";
				}else{
					 filename = "洗錢關鍵字_依縣市別.xls";
				}
				response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.28調整顯示的副檔名
				//write data to excel
				actMsg = RptFR080W.createRpt(S_YEAR, S_MONTH, E_YEAR, E_MONTH, cityType, extraKeyword);
				System.out.println("createRpt=" + actMsg);
				String writtenFilePath = Utility.getProperties("reportDir")+ System.getProperty("file.separator") + filename;
				System.out.println("filename=" + writtenFilePath);
				if(!printStyle.equalsIgnoreCase("xls")) {//108.05.28非xls檔須執行轉換	                
				   rptTrans rptTrans = new rptTrans();	  	  			  	
				   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
				   System.out.println("newfilename="+filename);	  			   
				}
				//get written file path
				FileInputStream inputStream = new FileInputStream(Utility.getProperties("reportDir") + System.getProperty("file.separator") + filename);
				//data to outputStream
				ServletOutputStream outputStream = response.getOutputStream();
				int byteSize = 8196;
				byte[] line = new byte[byteSize];
				int getBytes = 0;
				while (((getBytes = inputStream.read(line, 0, byteSize))) != -1) {
					outputStream.write(line, 0, getBytes);
					outputStream.flush();
				}

				inputStream.close();
				outputStream.close();
				out.clear(); 
				out = pageContext.pushBody(); 

			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
	}
	request.setAttribute("actMsg", actMsg);
	
	try {
        rd.forward(request, response);
    } catch (NullPointerException npe) {
    }
%>


