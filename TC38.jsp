<%
//101.07 create by 2968
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>
<%
	String pgId = "TC38";
	System.out.println("@@TC38.jsp Start...");
	String excelaction = ( request.getParameter("excelaction")==null ) ? "view" : (String)request.getParameter("excelaction");
	String duringDate = ( request.getParameter("duringDate")==null ) ? "" : (String)request.getParameter("duringDate");	
	String userId = session.getAttribute("muser_id") != null ? (String) session.getAttribute("muser_id") : "" ;
	String userName = session.getAttribute("muser_name") != null ? (String) session.getAttribute("muser_name") : "" ;
	String program_id = ( request.getParameter("program_id")==null ) ? "" : (String)request.getParameter("program_id");
	String begDate = ( request.getParameter("begDate")==null ) ? "" : (String)request.getParameter("begDate");
	String endDate = ( request.getParameter("endDate")==null ) ? "" : (String)request.getParameter("endDate");
	String updType1 = ( request.getParameter("updType1")==null ) ? "" : (String)request.getParameter("updType1");
	String updType2 = ( request.getParameter("updType2")==null ) ? "" : (String)request.getParameter("updType2");
	String updType3 = ( request.getParameter("updType3")==null ) ? "" : (String)request.getParameter("updType3");
	String updType4 = ( request.getParameter("updType4")==null ) ? "" : (String)request.getParameter("updType4");
	String updType5 = ( request.getParameter("updType5")==null ) ? "" : (String)request.getParameter("updType5");
	String sn_docno = ( request.getParameter("sn_docno")==null ) ? "" : (String)request.getParameter("sn_docno");
	String rt_docno = ( request.getParameter("rt_docno")==null ) ? "" : (String)request.getParameter("rt_docno");
	String reportno = ( request.getParameter("reportno")==null ) ? "" : (String)request.getParameter("reportno");
	request.setAttribute("excelaction",excelaction);
    request.setAttribute("duringDate",duringDate);
    
	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
            rd = application.getRequestDispatcher( LoginErrorPgName ); 
	        
	    } else {
    	    actMsg = request.getAttribute("actMsg") != null ? (String) request.getAttribute("actMsg") : "";
    	    request.setAttribute("getPgName",getPgName("TC3%"));
    	    System.out.println("act= "+act);
    	    if("List".equals(act)) {
    	        rd = application.getRequestDispatcher( ListPgName +"?act=List"); 
    	    } else if("Qry".equals(act)) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName +"?act=Qry");
    	    } else if("Report".equals(act)) {
    	    	    request.setAttribute("ReportBody",getQueryResult(request));
    	    	    rd = application.getRequestDispatcher( ReportPgName +"?act=Report");
        	}
	    }
        request.setAttribute("queryURL","TC38.jsp?act=List");
    	request.setAttribute("actMsg",actMsg); 

%>
<%@include file="./include/Tail.include" %>
<%!
	private final static String report_no = "TC38" ;
	private final static String nextPgName = "/pages/message.jsp";
	private final static String ConPgName = "/pages/"+report_no+".jsp";
	private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";    
	private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
	private final static String ReportPgName = "/pages/"+report_no+"_Report.jsp";
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";

    
    //功能名稱選單
    private List getPgName(String id){
    	//查詢條件    
		StringBuffer sqlCmd = new StringBuffer() ;
		List paramList = new ArrayList () ;
		sqlCmd.append("select program_id,program_name || '(' || program_id || ')' as pg_name "); 
		sqlCmd.append("from wtt03_1 where program_id like ? ");  
		paramList.add(id) ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
        System.out.println(" getPgName.size= "+dbData.size());
        return dbData;
    }
    //取得查詢資料
    private List getQueryResult(HttpServletRequest request){
        int flag = 0;
        String program_id = Utility.getTrimString(request.getParameter("program_id" ));
        String begDate = Utility.getTrimString(request.getParameter("begDate" ));
        String endDate = Utility.getTrimString(request.getParameter("endDate" ));
        String updType1 = Utility.getTrimString(request.getParameter("updType1" ));
        String updType2 = Utility.getTrimString(request.getParameter("updType2" ));
        String updType3 = Utility.getTrimString(request.getParameter("updType3" ));
        String updType4 = Utility.getTrimString(request.getParameter("updType4" ));
        String updType5 = Utility.getTrimString(request.getParameter("updType5" ));
        String sn_docno = Utility.getTrimString(request.getParameter("sn_docno" ));
        String reportno = Utility.getTrimString(request.getParameter("reportno" ));
        String reportno_seq = Utility.getTrimString(request.getParameter("reportno_seq" ));
        String rt_docno = Utility.getTrimString(request.getParameter("rt_docno" ));
        request.setAttribute("program_id",program_id);
        request.setAttribute("sn_docno",sn_docno);
        request.setAttribute("rt_docno",rt_docno);
    	request.setAttribute("reportno",reportno);
    	request.setAttribute("begDate",begDate);
    	request.setAttribute("endDate",endDate);
    	
    	StringBuffer sqlCmd = new StringBuffer() ;
    	List paramList = new ArrayList() ;
    	//查詢條件   
        sqlCmd.append("select wtt03_1.program_name || '(' || wtt03_1.program_id || ')' as pg_name, "+ //--功能名稱
    		    			" wtt01.muser_name, "+ //--使用者名稱
    		    			" to_char(use_date,'yyyy/mm/dd') as use_date, "+ //--使用日期
    		                " ip_address, "+ //--來源IP
    		                " sn_docno, "+ //--發文文號
    		                " rt_docno, "+ //--回文文號
    		                " exoperate_log.reportno, "+ //--檢查報告編號
    		                " item_no,"+ //--檢查缺失事項序號
    		                " decode(update_type,'I','新增','U','修改','D','刪除','Q','明細','P','列印','') as update_type "+ //--操作類別
    		          " from exoperate_log "+
    		          " left join wtt03_1 on exoperate_log.program_id = wtt03_1.program_id "+
    		          " left join wtt01 on exoperate_log.muser_id = wtt01.muser_id "+
    		          " left join exdefgoodf on exoperate_log.reportno_seq = exdefgoodf.reportno_seq "+
					  " WHERE 1=1 ");
    	if(!"".equals(program_id) && !"TC38".equals(program_id)){
    	    sqlCmd.append(" AND wtt03_1.program_id=? ");
    	    paramList.add(program_id) ;
    	}
    	if(!"".equals(updType1)){
    	    if(flag==0){
    	        sqlCmd.append(" AND (update_type =? ");
    	        flag = 1;
    	    }else{
    	        sqlCmd.append(" or update_type =? ");
    	    }
    	    paramList.add(updType1) ;
    	}
    	if(!"".equals(updType2)){
    	    if(flag==0){
    	        sqlCmd.append(" AND (update_type =? ");
    	        flag = 1;
    	    }else{
    	        sqlCmd.append(" or update_type =? ");
    	    }
    	    paramList.add(updType2) ;
    	}
    	if(!"".equals(updType3)){
    	    if(flag==0){
    	        sqlCmd.append(" AND (update_type =? ");
    	        flag = 1;
    	    }else{
    	        sqlCmd.append(" or update_type =? ");
    	    }
    	    paramList.add(updType3) ;
    	}
    	if(!"".equals(updType4)){
    	    if(flag==0){
    	        sqlCmd.append(" AND (update_type =? ");
    	        flag = 1;
    	    }else{
    	        sqlCmd.append(" or update_type =? ");
    	    }
    	    paramList.add(updType4) ;
    	}
    	if(!"".equals(updType5)){
    	    if(flag==0){
    	        sqlCmd.append(" AND (update_type =? ");
    	        flag = 1;
    	    }else{
    	        sqlCmd.append(" or update_type =? ");
    	    }
    	    paramList.add(updType5) ;
    	}
    	if(!"".equals(updType1)||!"".equals(updType2)||!"".equals(updType3)||!"".equals(updType4)||!"".equals(updType5)){
    		sqlCmd.append(")  ");
    	}
    	if(!"".equals(begDate) && !"".equals(endDate)){
    	    sqlCmd.append(" AND TO_CHAR(use_date ,'yyyymmdd') BETWEEN ? AND ? ");
    	    paramList.add(begDate) ;
    	    paramList.add(endDate) ;
    	}
    	if(!"".equals(sn_docno)){
    	    sqlCmd.append(" AND sn_docno like ? ");
    	    paramList.add(sn_docno+"%") ;
    	}
    	if(!"".equals(rt_docno)){
    	    sqlCmd.append(" AND rt_docno like ? ");
    	    paramList.add(rt_docno+"%") ;
    	}
    	if(!"".equals(reportno)){
    	    sqlCmd.append(" AND exoperate_log.reportno like ? ");
    	    paramList.add(reportno+"%") ;
    	}
    	sqlCmd.append(" order by use_date desc ");
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
        System.out.println(" getQueryResult.size= "+dbData.size());          
        return dbData;
    }
  
    
%>
