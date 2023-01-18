<%
//110.09.30 create 系統登錄紀錄查詢 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="com.tradevan.util.dao.RdbCommonDao" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@include file="./include/Header.include" %>

<%


System.out.println("Page: ZZ094W.jsp    Action:"+act+"    LoginID:"+lguser_id+"    UserName:"+lguser_name );
if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    rd = application.getRequestDispatcher( LoginErrorPgName );
} else {
	
	if("List".equals(act)) {    	    
		//setQueryCodition(request) ;
		keepQueryCondition(request) ;
		request.setAttribute("act" ,act) ;
	    rd = application.getRequestDispatcher( ListPgName );
	} else if("Qry".equals(act)) {
		keepQueryCondition(request) ;
		request.setAttribute("dataList" , getQueryList(request)) ;
		//request.setAttribute("qtbank",Utility.getTrimString(request.getParameter("tbank"))) ;
		//setQueryCodition(request) ;
		
		request.setAttribute("act" ,act) ;
		rd = application.getRequestDispatcher( ListPgName );
	} 
	
	request.setAttribute("actMsg",actMsg);
}

%>
<%@include file="./include/Tail.include" %>
<%!

private final static String report_no = "ZZ094W" ;
private final static String nextPgName = "/pages/ActMsg.jsp";
private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
private final static String MtnPgName = "/pages/"+report_no+"_Mtn.jsp";
private final static String DetailPgName = "/pages/"+report_no+"_DetailList.jsp";
private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";
private final static String RptCreatePgName1 = "/pages/"+report_no+"_Excel1.jsp";
private final static String LoginErrorPgName = "/pages/LoginError.jsp";

private void keepQueryCondition(HttpServletRequest req ) {
	String muserId = Utility.getTrimString(req.getParameter("muserId"));
	String sysType = Utility.getTrimString(req.getParameter("sysType"));
	String begDate = Utility.getTrimString(req.getParameter("begDate"));
	String endDate = Utility.getTrimString(req.getParameter("endDate"));
	String loginFlag = Utility.getTrimString(req.getParameter("loginFlag"));
	String ipAddr = Utility.getTrimString(req.getParameter("ipAddr"));
	
	
	req.setAttribute("q_muserId" , muserId ) ;	
	req.setAttribute("q_sysType" , sysType ) ;
	req.setAttribute("q_begDate" , begDate ) ;
	req.setAttribute("q_endDate" , endDate ) ;
	req.setAttribute("q_loginFlag" , loginFlag ) ;
	req.setAttribute("q_ipAddr" , ipAddr ) ;
}
private List getQueryList(HttpServletRequest req ) {
	
	String muserId = Utility.getTrimString(req.getParameter("muserId"));
	String begDate = Utility.getTrimString(req.getParameter("begDate"));
	String endDate = Utility.getTrimString(req.getParameter("endDate"));	
	String sysType = Utility.getTrimString(req.getParameter("sysType"));
	String loginFlag = Utility.getTrimString(req.getParameter("loginFlag"));
	String ipAddr = Utility.getTrimString(req.getParameter("ipAddr"));
	System.out.println("muserId="+muserId+":begDate="+begDate+":endDate="+endDate+":sysType="+sysType+":loginFlag"+loginFlag+":ipAddr="+ipAddr);
	StringBuffer sql  = new StringBuffer();
	List p = new ArrayList();
	
	sql.append(" select wtt06.muser_id,");//--登入帳號
    sql.append(" bank_type,tbank_no,");//
    sql.append(" bank_name,");//--總機構名稱
    sql.append(" muser_name,");//--使用者名稱
    sql.append(" F_TRANSCHINESEDATE(input_date) || to_char(wtt06.input_date,' HH24:MI:SS') as input_date,");//--登入時間
    sql.append(" case login_flag ");
    sql.append(" when 'Y' then '成功'");
    sql.append(" when 'N' then '失敗'");
    sql.append(" end as login_flag,");//--登入狀態
    sql.append(" F_TRANSCHINESEDATE(logout_time) || to_char(wtt06.logout_time,' HH24:MI:SS') as logout_time,");//--登出時間
    sql.append(" decode(type,'1','申報系統','2','MIS管理系統','') as type,");//--系統類別
    sql.append(" ip_address ");//--來源IP
    sql.append(" from wtt06 left join (select muser_id,muser_name,wtt01.bank_type,tbank_no,bank_name ");
    sql.append(" from wtt01 left join (select * from bn01 where m_year=100)bn01 on wtt01.tbank_no=bn01.bank_no ");
    sql.append(" )wtt01 on wtt06.muser_id=wtt01.muser_id ");
    sql.append(" where 1=1 ");
    if(!"".equals(muserId)) {//登入帳號
		sql.append(" and wtt06.muser_id like ? "); 
		p.add("%"+muserId+"%");
	}
	if(!"".equals(begDate) && !"".equals(endDate)) {//登入時間
    	sql.append(" and TO_CHAR(input_date ,'yyyymmdd') BETWEEN ? AND ? ");
    	p.add(String.valueOf(Integer.parseInt(begDate)+19110000));
    	p.add(String.valueOf(Integer.parseInt(endDate)+19110000));
	}
	if(!"".equals(sysType) && !"ALL".equals(sysType)) {//系統類別
		sql.append(" and type = ? ");
		p.add(sysType);
	}

    if(!"".equals(loginFlag) && !"ALL".equals(loginFlag)) {//登入狀態
		sql.append(" and login_flag = ? ");
		p.add(loginFlag);
	}
	if(!"".equals(ipAddr)) {//來源IP
		sql.append(" and ip_address like ? ");
		p.add("%"+ipAddr+"%");
	}

	sql.append(" order by wtt06.input_date desc ");

	return DBManager.QueryDB_SQLParam(sql.toString(),p,"input_date,logout_time");
	
}
%>