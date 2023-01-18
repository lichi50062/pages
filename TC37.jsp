<%
/* 94.4.13 createed
   
   報表--農業金融機構缺失統計表
 //99.06.01 fix 套用Header.include & sql injection by 2808
//101.07.13 add 追蹤歷程紀錄查詢log by 2968 

 */
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>
<%
	String userId = session.getAttribute("muser_id") != null ? (String) session.getAttribute("muser_id") : "" ;
	String userName = session.getAttribute("muser_name") != null ? (String) session.getAttribute("muser_name") : "" ;
	String pgId = "TC37";
	
	System.out.println("Page: TC37.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );


	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
        rd = application.getRequestDispatcher( LoginErrorPgName ); 
	  } else {
	      if(act.equals("List") ) {
    	    
    	    rd = application.getRequestDispatcher( ListPgName +"?act=List");
    	  }
    	  if(act.equals("Report") ) {
    	    actMsg = Utility.insertDataToLog(request, userId, pgId);
    	    String startDate = request.getParameter("startDate" )== null  ? "" : (String)request.getParameter("startDate");
            String endDate = request.getParameter("endDate" )== null  ? "" : (String)request.getParameter("endDate");
            String excelaction = ( request.getParameter("excelaction")==null ) ? "view" : (String)request.getParameter("excelaction");
            String duringDate = ( request.getParameter("duringDate")==null ) ? "" : (String)request.getParameter("duringDate");
            //request.setAttribute("duringDate",duringDate);
            //request.setAttribute("excelaction",excelaction);
            //request.setAttribute("startDate",startDate);
    		//request.setAttribute("endDate",endDate);
    	    //request.setAttribute("ReportBody",getQueryResult(request));
    	    rd = application.getRequestDispatcher( ReportPgName +"?act=Report&startDate="+startDate+"&endDate="+endDate+"&duringDate="+duringDate);
    	  }
      }

%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no ="TC37" ;
private final static String nextPgName = "/pages/message.jsp";    
private final static String ReportPgName = "/pages/"+report_no+"_Report.jsp";    
private final static String ListPgName = "/pages/"+report_no+"_List.jsp";        
private final static String LoginErrorPgName = "/pages/LoginError.jsp";

    

    //取得查詢資料
    private List getQueryResult(HttpServletRequest request){
            String startDate = request.getParameter("startDate" )== null  ? "" : (String)request.getParameter("startDate");
            String endDate = request.getParameter("endDate" )== null  ? "" : (String)request.getParameter("endDate");
            String excelaction = ( request.getParameter("excelaction")==null ) ? "view" : (String)request.getParameter("excelaction");
            String duringDate = ( request.getParameter("duringDate")==null ) ? "" : (String)request.getParameter("duringDate");
            request.setAttribute("duringDate",duringDate);
            request.setAttribute("excelaction",excelaction);
            request.setAttribute("startDate",startDate);
    		request.setAttribute("endDate",endDate);
    		//20060126 by 2495   
		    System.out.println("startDate ="+startDate);
		    System.out.println("endDate ="+endDate);
			String u_year = "99" ;
			if(!"".equals(startDate) && Integer.parseInt(startDate.substring(0,4))>2010) {
				u_year = "100" ;
			}
			StringBuffer sqlCmd = new StringBuffer() ;
			List paramList = new ArrayList();
    		//查詢條件    
    		sqlCmd.append(" select a.fault_id, c.FAULT_NAME,  b.bank_no,  ba01.bank_name, tmp.cnt "+
                            " from exdefgoodf a, exreportf  b, ExFaultF c, (select * from ba01 where m_year=? )ba01, "+
	                        " (select a.fault_id, count(*) cnt from exdefgoodf a, exreportf  b, ExFaultF c"+ 
	                        "    where a.reportno=b.reportno"+ 
	                        "    and ((to_char(b.report_In_date,'yyyymmdd') between ?  and ? )"+
	                        "    or  (to_char(b.report_En_date,'yyyymmdd') between  ? and ? ))"+
	                        "    and a.fault_id = c.fault_id"+
	                        "    group by a.fault_id"+
	                        "    order by cnt DESC) tmp "+
	                        " where a.reportno = b.reportno"+
	                        " and b.bank_no = ba01.bank_no"+
	                        " and tmp.fault_id = a.fault_id"+
	                        " and a.fault_id = c.fault_id"+
	                        " order by cnt desc, a.fault_id, b.bank_no" );
    		paramList.add(u_year) ;
    		paramList.add(startDate);
    		paramList.add(endDate);
    		paramList.add(startDate);
    		paramList.add(endDate);
	        
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"cnt");            
            return dbData;
    }
  
%>



