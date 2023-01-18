<%
/* 94.1.26 createed
   
   檢查缺失處理系統 - 回文記錄維護 主控制頁面
   99.06.01 fix 套用Header.include & sql injection by 2808
   101.07.13 add 追蹤歷程紀錄查詢log by 2968 
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
	

  String pgId = "TC32";
  String userId = session.getAttribute("muser_id") != null ? (String) session.getAttribute("muser_id") : "" ;
  String userName = session.getAttribute("muser_name") != null ? (String) session.getAttribute("muser_name") : "" ;
  Enumeration parName = request.getParameterNames();
	System.out.println("\n\n======= START SAVE REQUEST PARAMETER TO ATTRIBUTE =======");
	String flag = request.getParameter("flag") != null ? request.getParameter("flag") : "";
    request.setAttribute("flag",flag);
	while(parName.hasMoreElements()) {
	  String name = (String) parName.nextElement();
	  String value = request.getParameter(name) != null ? (String) request.getParameter(name) : "";
	  System.out.println(name + " = " + value);
	  request.setAttribute(name, value.trim());
	}
	System.out.println("\n\n======= END SAVE REQUEST PARAMETER ATTRIBUTE =======");
	parName = request.getAttributeNames();
	System.out.println("\n\n======= START SAVE REQUEST ATTRIBUTE TO ATTRIBUTE =======");
	while(parName.hasMoreElements()) {
	  String name = (String) parName.nextElement();
	  String value = request.getAttribute(name) != null ? (String) request.getAttribute(name) : "";
	  System.out.println(name + " = " + value);
	  request.setAttribute(name, value.trim());
	}
	System.out.println("\n\n======= END SAVE REQUEST ATTRIBUTE ATTRIBUTE =======\n\n");
  
  
	System.out.println("Page: TC32.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );
	
	
	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
        rd = application.getRequestDispatcher( LoginErrorPgName ); 
	    
	    } else {
    	if(act.equals("List") || act.equals("Qry") || act.equals("Edit") ||  act.equals("New")) {
    	    actMsg = request.getAttribute("actMsg") != null ? (String) request.getAttribute("actMsg") : "";
    	    if(act.equals("List")) {
    	        rd = application.getRequestDispatcher( ListPgName +"?act=List"); 
    	    } else if(act.equals("Edit") || act.equals("New")) {
    	        String sn_docno = Utility.getTrimString(dataMap.get("sn_docno"));
    	        String rt_docno = Utility.getTrimString(dataMap.get("rt_docno"));
    	        String reportno = Utility.getTrimString(dataMap.get("reportno"));
    	        DataObject b = getReportDataObject(sn_docno);
    	        if(!sn_docno.equals("") && b == null) {
    	            actMsg = "查不到發文文號所對應的檢查報告編號";
    	        }
    	        request.setAttribute("reportOB",b);
    	        flag = Utility.getTrimString(dataMap.get("flag"));
    	        request.setAttribute("flag",flag);
    	        
    	        if(act.equals("New")) {
    	          rd = application.getRequestDispatcher( EditPgName +"?act=New");
    	        }else{
    	            if("1".equals(flag)){
    	                actMsg = Utility.insertDataToLog(request, userId, pgId);
    	            	flag = "0";
    	            }
    	            request.setAttribute("DETAIL",getQueryDetail(rt_docno));
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit");
    	        }
    	    } else if(act.equals("Qry")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName +"?act=Qry");
    	    }
        } else if(act.equals("Insert")){
    	    String rt_docno = request.getParameter("rt_docno" )== null  ? "" : (String)request.getParameter("rt_docno");
            String sn_docno = request.getParameter("sn_docno" )== null  ? "" : (String)request.getParameter("sn_docno");
            String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
            actMsg = insertDataToDB(request,userId,userName);
    	    actMsg = Utility.insertDataToLog(request, userId, pgId);
    	    if(actMsg.equals("")) {
    	      actMsg = "相關資料已寫入資料庫";
    	    }
        	rd = application.getRequestDispatcher( ConPgName +"?act=New&rt_docno=&sn_docno="+sn_docno );
        } else if(act.equals("Update")){
            String rt_docno = request.getParameter("rt_docno" )== null  ? "" : (String)request.getParameter("rt_docno");
            String sn_docno = request.getParameter("sn_docno" )== null  ? "" : (String)request.getParameter("sn_docno");
            String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
            actMsg = updateDataToDB(request,userId,userName);
            actMsg = Utility.insertDataToLog(request, userId, pgId);
            if(actMsg.equals("")) {
    	      actMsg = "相關資料已寫入資料庫";
    	      request.setAttribute("prePageURL","TC32.jsp?act=Edit&sn_docno="+sn_docno+"&rt_docno="+rt_docno+"&reportno="+reportno);
    	    }
        	rd = application.getRequestDispatcher( nextPgName );         
        } else if(act.equals("Delete")){
            String rt_docno = request.getParameter("rt_docno" )== null  ? "" : (String)request.getParameter("rt_docno");
            String sn_docno = request.getParameter("sn_docno" )== null  ? "" : (String)request.getParameter("sn_docno");
            String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
            actMsg = deleteDataToDB(request,userId,userName);
    	    actMsg = Utility.insertDataToLog(request, userId, pgId);
    	    if(actMsg.equals("")) {
              actMsg = "相關資料已刪除";
              request.setAttribute("prePageURL","TC32.jsp?act=List");
            }
        	rd = application.getRequestDispatcher( nextPgName );                 
        }
        request.setAttribute("queryURL","TC32.jsp?act=List");
    	request.setAttribute("actMsg",actMsg);  
      }  
%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "TC32" ;
private final static String nextPgName = "/pages/message.jsp";    
private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";    
private final static String ListPgName = "/pages/"+report_no+"_List.jsp";        
private final static String LoginErrorPgName = "/pages/LoginError.jsp";
private final static String ConPgName = "/pages/"+report_no+".jsp";
private final static String BANK_TYPE = "020"; //金融機構代碼
private final static String EXAM_DIV = "022";  //檢查評等
private final static String CH_TYPE = "023"; //檢查性質
private final static String ORIGINUNT_ID = "024";   //檢查報告單位
private final static String DOCTYPE = "025";   //公文類別
    
    
    private boolean CheckPermission(HttpServletRequest request){//檢核權限    	    
    	    boolean CheckOK=false;
    	    HttpSession session = request.getSession();            
            Properties permission = ( session.getAttribute("TC32")==null ) ? new Properties() : (Properties)session.getAttribute("TC32");				                
            if(permission == null){
              System.out.println("TC32.permission == null");
            }else{
               System.out.println("TC32.permission.size ="+permission.size());
               
            }
            //只要有Query的權限,就可以進入畫面
        	if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){            
        	   CheckOK = true;//Query
        	}
        	return CheckOK;
}    
    
    //取得所有受檢單位資料
    private List getAllExamine(){
    		//查詢條件    
    		String sqlCmd = " select bank_no, bank_name, bank_type from ba01 where bank_type in ( select cmuse_id from cdshareno where cmuse_div = '020') order by bank_no, bank_type ";  
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"");            
            return dbData;
    }

    //取得CDShareNO, 欄位cmuse_div為id的所有內容
    private List getCDShareNOWith(String id){
    		//查詢條件    
    		List paramList = new ArrayList();
    		String sqlCmd = " select cmuse_id, cmuse_name from cdshareno where cmuse_div = ? order by cmuse_id";
    		paramList.add(id);
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");            
            return dbData;
    }
    
    //取得查詢資料
    private List getQueryResult(HttpServletRequest request){
        String sn_docno = request.getParameter("sn_docno" )== null  ? "" : (String)request.getParameter("sn_docno");
        String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
        String rt_docno = request.getParameter("rt_docno" )== null  ? "" : (String)request.getParameter("rt_docno");
        String begDate = request.getParameter("begDate" )== null  ? "" : (String)request.getParameter("begDate");
        String endDate = request.getParameter("endDate" )== null  ? "" : (String)request.getParameter("endDate");
        String receive_docno = request.getParameter("receive_docno" )== null  ? "" : (String)request.getParameter("receive_docno");
        request.setAttribute("sn_docno",sn_docno);
    	request.setAttribute("reportno",reportno);
    	request.setAttribute("rt_docno",rt_docno);
    	request.setAttribute("begDate",begDate);
    	request.setAttribute("endDate",endDate);
    	request.setAttribute("receive_docno",receive_docno);
    	
    	List paramList = new ArrayList();
    	//查詢條件    
    		String sqlCmd = "SELECT DISTINCT c.bank_name, a.reportno, a.sn_docno, e.rt_docno, ((TO_CHAR(e.rt_date,'yyyy')-1911)||'/'|| TO_CHAR(e.rt_date,'mm/dd'))  as rt_date "+
    		    " FROM ExRtDocF e, ExSnDocF a, ExReportF b, BA01 c, CDShareNo d  "+
    		    " WHERE e.sn_docno = a.sn_docno AND a.reportno = b.reportno AND b.bank_no = c.bank_no " +
    		    " AND TO_CHAR(e.rt_date, 'yyyymmdd') BETWEEN ? AND ? " ;
    	paramList.add(begDate);
    	paramList.add(endDate);
    		    
    	if(!reportno.equals("")) {
    	    sqlCmd += "  AND a.reportno = ?"; 
    	    paramList.add(reportno);
    	}
    	if(!sn_docno.equals("")) {
    	    sqlCmd += "  AND a.sn_docno = ?"; 
    	    paramList.add(sn_docno);
    	}
        if(!rt_docno.equals("")) {
    	    sqlCmd += "  AND e.rt_docno = ?"; 
    	    paramList.add(rt_docno);
    	}
    	if(!receive_docno.equals("")) {
    	    sqlCmd += "  AND e.receive_docno = ?"; 
    	    paramList.add(receive_docno);
    	}
    	
    	sqlCmd += "ORDER BY e.rt_docno";
    	
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");
        System.out.println("dbData= "+dbData.size());          
        return dbData;
    }
    
    // 取得單筆查詢資料
    private List getQueryDetail(String rt_docno) {
        List paramList = new ArrayList();
        String sqlCmd = " SELECT rt_docno, sn_docno, receive_docno, TO_CHAR(rt_date,'yyyy') as rt_dateY, TO_CHAR(rt_date,'mm') as rt_dateM, TO_CHAR(rt_date,'dd') as rt_dateD FROM ExRtDocF WHERE rt_docno = ? ";
        paramList.add(rt_docno);
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");
        return dbData;
    }
    
    // 取得Report NO的資料
    private DataObject getReportDataObject(String sn_docno) {
        DataObject ob = null;
        StringBuffer sqlCmd = new StringBuffer() ;
        List paramList = new ArrayList() ;
        sqlCmd.append("SELECT reportno, TO_CHAR(sn_date, 'yyyymmdd') as sn_date FROM ExSnDocF WHERE sn_docno = ? " ); 
        paramList.add(sn_docno) ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
        if(dbData.size() > 0) {
            ob = (DataObject)dbData.get(0);
        }
        return ob;
    }

       // 新增資料到資料庫
    private String insertDataToDB(HttpServletRequest request, String loginID, String loginName) {
        String actMsg = "";
        String errMsg = "";
        String sn_docno = Utility.getTrimString(request.getParameter("sn_docno"));
        String reportno = Utility.getTrimString(request.getParameter("reportno"));
        String rt_date = Utility.getTrimString(request.getParameter("rt_date"));
        String rt_docno = Utility.getTrimString(request.getParameter("rt_docno"));
        String receive_docno = Utility.getTrimString(request.getParameter("receive_docno"));
        
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
        try {
            StringBuffer sqlCmd = new StringBuffer() ;
            // 檢查是否有這一筆資料, 如果有就新增
            sqlCmd.append("select count(*) as count from ExSnDocF where sn_docno = ? " );
            paramList.add(sn_docno) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");		 			    
		    System.out.println("ExSnDocF Size="+data.size());
			if(data.size() > 0) {
			    DataObject bean = (DataObject)data.get(0);
			    String rs = String.valueOf(bean.getValue("count"));
			    System.out.println("Count ="+rs);
			    if(rs.equals("0")) {
			        errMsg = "發文文號"+sn_docno+" 不存在資料庫";
                    return errMsg;
			    }
            }
            paramList.clear() ;
            sqlCmd.setLength(0) ;
            data = null;
            // 檢查是否有這一筆資料, 如果沒有就新增
            sqlCmd.append( "select count(*) as count from ExRtDocF where rt_docno = ? " );
            paramList.add(rt_docno) ;
            data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");		 			    
		    System.out.println("ExRtDocF Size="+data.size());
			if(data.size() > 0) {
			    DataObject bean = (DataObject)data.get(0);
			    String rs = String.valueOf(bean.getValue("count"));
			    System.out.println("Count ="+rs);
			    if(!rs.equals("0")) {
			        errMsg = "回文文號"+rt_docno+" 重複";
                    return errMsg;
			    }
            }
			paramList.clear() ;
			sqlCmd.setLength(0) ;
            sqlCmd.append("insert into ExRtDocF(rt_docno, rt_date, sn_docno, user_id, user_name, update_date, receive_docno) " +
                " values(?, "
                +" TO_DATE(?,'YYYY/MM/DD'), "
                +"?, "
                +" ?, ?, sysdate, ?) " );
            paramList.add(rt_docno) ;
            paramList.add(rt_date) ;
            paramList.add(sn_docno) ;
            paramList.add(loginID) ;
            paramList.add(loginName) ;
            paramList.add(receive_docno) ;
            updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
            //insertDBSqlList.add(sqlCmd);
             if(DBManager.updateDB_ps(updateDBList)){
			       errMsg = "";
		     }else{
				   errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
			  }
        }catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗<br>[Exception Error]:<br>";
		}
		return errMsg;
	}
	
	private String updateDataToDB(HttpServletRequest request, String loginID, String loginName) {
	    String actMsg = "";
        String errMsg = "";
        String sn_docno = Utility.getTrimString(request.getParameter("sn_docno" ));
        String reportno = Utility.getTrimString(request.getParameter("reportno" ));
        String rt_date = Utility.getTrimString(request.getParameter("rt_date" ));
        String rt_docno = Utility.getTrimString(request.getParameter("rt_docno" ));
        String receive_docno = Utility.getTrimString(request.getParameter("receive_docno" ));
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {
	        StringBuffer sqlCmd =new StringBuffer() ;
           
            // 檢查是否有這一筆資料, 如果有就新增
            sqlCmd.append( "select count(*) as count from ExSnDocF where sn_docno = ? " );
            paramList.add(sn_docno) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");		 			    
		    System.out.println("ExSnDocF Size="+data.size());
			if(data.size() > 0) {
			    DataObject bean = (DataObject)data.get(0);
			    String rs = String.valueOf(bean.getValue("count"));
			    System.out.println("Count ="+rs);
			    if(rs.equals("0")) {
			        errMsg = "發文文號"+sn_docno+" 不存在資料庫";
                    return errMsg;
			    }
            }
            paramList.clear() ;
            sqlCmd.setLength(0) ;
            data = null;
            // 檢查是否有這一筆資料
            sqlCmd.append("select count(*) as count from ExRtDocF where rt_docno = ? " );
            paramList.add(rt_docno) ;
            
            data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");		 			    
		    System.out.println("ExRtDocF Size="+data.size());
			if(data != null) {
			    DataObject bean = (DataObject)data.get(0);
			    String rs = String.valueOf(bean.getValue("count"));
			    System.out.println("Count ="+rs);
			    if(rs.equals("0")) {
			        errMsg = "回文文號"+rt_docno+" 不存在";
                    return errMsg;
			    }else if(!rs.equals("1")) {
			        errMsg = "回文文號"+rt_docno+" 重複";
                    return errMsg;
			    }
            }
            paramList.clear() ;
            sqlCmd.setLength(0) ;
            sqlCmd.append( " UPDATE ExRtDocF SET rt_date = TO_DATE(?,'yyyy/mm/dd'), "+
                " rt_docno = ?, " +
                " sn_docno = ?, " +
                " user_id = ?, "+
                " receive_docno = ?, "+
                " user_name = ?, " +
                " update_date = sysdate WHERE rt_docno = ?" );
            paramList.add(rt_date) ;
            paramList.add(rt_docno) ;
            paramList.add(sn_docno) ;
            paramList.add(loginID) ;
            paramList.add(receive_docno) ;
            paramList.add(loginName) ;
            paramList.add(rt_docno) ;
            updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
             //updateDBSqlList.add(sqlCmd);
            if(DBManager.updateDB_ps(updateDBList)){
			       errMsg = "";
		     }else{
				   errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
			  }
            
        } catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				return "相關資料寫入資料庫失敗<br>[Exception Error]:<br>";							
		}	
		return errMsg;
	}
	
	// 刪除資料
	private String deleteDataToDB(HttpServletRequest request, String loginID, String loginName) {
	    String actMsg = "";
        String errMsg = "";
        
        String rt_docno = Utility.getTrimString(request.getParameter("rt_docno" ));
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {
	        // 檢查是否有這一筆資料
	        StringBuffer sqlCmd = new StringBuffer() ;
            sqlCmd.append( "select count(*) as count from ExRtDocF where rt_docno = ? " );
            paramList.add(rt_docno) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");		 			    
		    System.out.println("ExRtDocF Size="+data.size());
			if(data != null) {
			    DataObject bean = (DataObject)data.get(0);
			    String rs = String.valueOf(bean.getValue("count"));
			    System.out.println("Count ="+rs);
			    if(rs.equals("0")) {
			        errMsg = "回文文號"+rt_docno+" 不存在";
                    return errMsg;
			    }
            }
            paramList.clear() ;
            sqlCmd.setLength(0) ;
            
            sqlCmd.append( " DELETE FROM ExRtDocF WHERE rt_docno = ?" );
            paramList.add(rt_docno) ;
            updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
            
            if(DBManager.updateDB_ps(updateDBList)){
			       errMsg = "";
		     }else{
				   errMsg = errMsg + "相關資料刪除失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
			  }
            
        } catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				return "相關資料刪除失敗<br>[Exception Error]:<br>";						
		}	
		return errMsg;
	
	
	}
	

%>
