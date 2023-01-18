<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@include file="./include/Header.include" %>
<%
	String pgId = "TM008W";
	String accTrType = Utility.getTrimString(request.getParameter("accTrType"));
	String accTrTypeName = Utility.getTrimString(request.getParameter("accTrTypeName"));
	String applyDate = Utility.getTrimString(request.getParameter("applyDate"));
	
	if(!"".equals(applyDate)) {
		applyDate = applyDate.split("_")[1];
	}
	
	//無權限時,導向到LoginError.jsp
	if(!Utility.CheckPermission(request,report_no)){
		rd = application.getRequestDispatcher( LoginErrorPgName ); 
	} else {
		if("Qry".equals(act)) {
			request.setAttribute("loanapplyNcacnos", getLoanapplyNcacno());
			request.setAttribute("applyDates", getApplyDates());
			rd = application.getRequestDispatcher(RptQryPgName +"?act=Qry");
		} else if("createRpt".equals(act)) {
// 			String excelAction = ( request.getParameter("excelaction")==null ) ? "" : (String)request.getParameter("excelaction");
// 			this.InsertWlXOPERATE_LOG(request,lguser_id,report_no,"P");
// 			rd = application.getRequestDispatcher( RptCreatePgName +"?act="+excelAction+"&hsien_id="+hsien_id+"&cancel_no="+cancel_no);
			request.setAttribute("accTrType", accTrType);
			request.setAttribute("accTrTypeName", accTrTypeName);
			request.setAttribute("applyDate", applyDate);
			request.setAttribute("rptData", getRptData(accTrType , applyDate));
			rd = application.getRequestDispatcher(RptCreatePgName +"?act=createRpt");
		}
	}
	
	request.setAttribute("act",act);
// 	request.setAttribute("actMsg",actMsg);
%>
<%@include file="./include/Tail.include" %>
<%!
	private final static String report_no = "TM008W" ;
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";
	private final static String RptQryPgName = "/pages/"+report_no+"_Qry.jsp";
	private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";
	
	
	private List getLoanapplyNcacno() {
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT acc_tr_type , acc_tr_name   ");
		sql.append(" FROM loanapply_ncacno              ");
		sql.append(" GROUP BY acc_tr_type , acc_tr_name ");
		sql.append(" ORDER BY acc_tr_type               ");
		
		List paramList = new ArrayList();
		List dbData = DBManager.QueryDB_SQLParam(sql.toString() , paramList , "");
		return dbData;
	}
	
	private List getApplyDates() {
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT acc_tr_type,                         ");
		sql.append("   applydate,                                ");
		sql.append("   F_TRANSCHINESEDATE(applydate) chineseDate ");
		sql.append(" FROM loanapply_period                       ");
		sql.append(" ORDER BY acc_tr_type,applydate              ");
		
		List paramList = new ArrayList();
		List dbData = DBManager.QueryDB_SQLParam(sql.toString() , paramList , "");
		return dbData;
	}
	
	private List getRptData(String accTrType , String applyDate) {
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT a.bank_code,                                              ");
		sql.append("   bank_name,                                                     ");
		sql.append("   applydate,                                                     ");
		sql.append("   wml01_status,                                                  ");
		sql.append("   DECODE(cnt_name,NULL,wlx01.telno,cnt_name                      ");
		sql.append("   ||' '                                                          ");
		sql.append("   ||cnt_tel) AS cnt_name                                         ");
		sql.append(" FROM                                                             ");
		sql.append("   (SELECT loanapply_bn01.bank_code,                              ");
		sql.append("     CASE                                                         ");
		sql.append("       WHEN loanapply_bn01.bank_code = loanapply_wml01.bank_code  ");
		sql.append("       THEN '已申報'                                              ");
		sql.append("       ELSE '未申報'                                              ");
		sql.append("     END AS wml01_status,                                         ");
		sql.append("     loanapply_period.applydate,                                  ");
		sql.append("     CASE                                                         ");
		sql.append("       WHEN loanapply_bn01.bank_code = loanapply_wml01.bank_code  ");
		sql.append("       THEN loanapply_wml01.add_date                              ");
		sql.append("       ELSE NULL                                                  ");
		sql.append("     END AS wml01_add_date                                        ");
		sql.append("   FROM loanapply_period                                          ");
		sql.append("   LEFT JOIN loanapply_wml01                                      ");
		sql.append("   ON loanapply_period.acc_tr_type=loanapply_wml01.acc_tr_type    ");
		sql.append("   AND loanapply_period.applydate =loanapply_wml01.applydate      ");
		sql.append("   LEFT JOIN loanapply_bn01                                       ");
		sql.append("   ON loanapply_period.acc_tr_type   =loanapply_bn01.acc_tr_type  ");
		sql.append("   WHERE loanapply_period.acc_tr_type= ?                          ");
		sql.append("   AND loanapply_period.applydate    = TO_DATE( ? , 'YYYY/MM/DD') ");
		sql.append("   )a                                                             ");
		sql.append(" LEFT JOIN                                                        ");
		sql.append("   (SELECT bank_code,                                             ");
		sql.append("     MAX(cnt_name) AS cnt_name,                                   ");
		sql.append("     MAX(cnt_tel)  AS cnt_tel                                     ");
		sql.append("   FROM loanapply_wml01                                           ");
		sql.append("   WHERE acc_tr_type= ?                                           ");
		sql.append("   GROUP BY bank_code                                             ");
		sql.append("   )loanapply_wml_cnt                                             ");
		sql.append(" ON a.bank_code = loanapply_wml_cnt.bank_code                     ");
		sql.append(" LEFT JOIN wlx01                                                  ");
		sql.append(" ON a.bank_code=wlx01.bank_no                                     ");
		sql.append(" LEFT JOIN                                                        ");
		sql.append("   (SELECT * FROM bn01 WHERE m_year=100                           ");
		sql.append("   )bn01                                                          ");
		sql.append(" ON a.bank_code = bn01.bank_no                                    ");
		sql.append(" GROUP BY a.bank_code,                                            ");
		sql.append("   bank_name,                                                     ");
		sql.append("   applydate,                                                     ");
		sql.append("   wml01_status,                                                  ");
		sql.append("   DECODE(cnt_name,NULL,wlx01.telno,cnt_name                      ");
		sql.append("   ||' '                                                          ");
		sql.append("   ||cnt_tel)                                                     ");
		sql.append(" ORDER BY a.bank_code , applydate                                 ");
		
		if(!"".equals(applyDate) && applyDate.length() == 9) {
			String wyear = String.valueOf(Integer.parseInt(applyDate.substring(0 , 3)) + 1911);
			applyDate = wyear + applyDate.substring(3, 9);
		}
		
		List paramList = new ArrayList();
		paramList.add(accTrType);
		paramList.add(applyDate);
		paramList.add(accTrType);
		
		List dbData = DBManager.QueryDB_SQLParam(sql.toString() , paramList , "");
		return dbData;
	}
	
%>