<%
/* 94.1.24 createed
   
   檢查缺失處理系統 - 發文記錄維護 主控制頁面
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
	
	String pgId = "TC31";
	String userId = session.getAttribute("muser_id") != null ? (String) session.getAttribute("muser_id") : "" ;
	String userName = session.getAttribute("muser_name") != null ? (String) session.getAttribute("muser_name") : "" ;
	
	Enumeration parName = request.getParameterNames();	
	while(parName.hasMoreElements()) {
	  String name = (String) parName.nextElement();
	  String value = request.getParameter(name) != null ? (String) request.getParameter(name) : "";
	  System.out.println(name + " = " + value);
	  request.setAttribute(name, value.trim());
	}	
	parName = request.getAttributeNames();	
	while(parName.hasMoreElements()) {
	  String name = (String) parName.nextElement();
	  String value = request.getAttribute(name) != null ? (String) request.getAttribute(name) : "";
	  System.out.println(name + " = " + value);
	  request.setAttribute(name, value.trim());
	}	
	System.out.println("Page: TC31.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );
	String begY = Utility.getTrimString(dataMap.get("begY")) ;
	
	
	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
            rd = application.getRequestDispatcher( LoginErrorPgName ); 
	        
	    } else {
    	if(act.equals("List") || act.equals("Qry") || act.equals("Edit") ||  act.equals("New") ) {
    	    actMsg = request.getAttribute("actMsg") != null ? (String) request.getAttribute("actMsg") : "";
    	    request.setAttribute("act", getCDShareNOWith(act));
    	    System.out.println("act= "+act);
    	    request.setAttribute("Bank_Type", getCDShareNOWith(BANK_TYPE));
            request.setAttribute("TBank", getTatolBankType());
            request.setAttribute("Bank_No",getBankNo());
    	    request.setAttribute("DOCTYPE",getCDShareNOWith(DOCTYPE));
    	    request.setAttribute("City", Utility.getCity());
    	    if(act.equals("List")) {
    	        rd = application.getRequestDispatcher( ListPgName +"?act=List"); 
    	    } else if(act.equals("Edit") || act.equals("New")) { 
    	        String reportno = request.getParameter("reportno") != null ? request.getParameter("reportno") : "";
    	        String sn_docno = request.getParameter("sn_docno") != null ? request.getParameter("sn_docno") : "";
    	        String flag = request.getParameter("flag") != null ? request.getParameter("flag") : "";
    	        request.setAttribute("reportno",reportno);
    	        request.setAttribute("flag",flag);
    	        List b = getBank(reportno,begY);
    	        if(!reportno.equals("") && b.size() < 1) {
    	            actMsg = "查不到檢查報告編號所對應的金融機構資訊";
    	        }
    	        request.setAttribute("BANK", b);
    	        if(act.equals("New")) {
    	          rd = application.getRequestDispatcher( EditPgName +"?act=New");
    	        }else{
    	            if("1".equals(flag)){
    	                actMsg = Utility.insertDataToLog(request, userId, pgId);
	    	            flag = "0";
    	            }
    	            request.setAttribute("DETAIL",getQueryDetail(sn_docno));
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit");
    	        }
    	    } else if(act.equals("Qry")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName +"?act=Qry");
    	    }
        } else if(act.equals("Insert")){
            String sn_docno = request.getParameter("sn_docno" )== null  ? "" : (String)request.getParameter("sn_docno");
            actMsg = insertDataToDB(request,userId,userName);
            actMsg = Utility.insertDataToLog(request, userId, pgId);
    	    if(actMsg.equals("")) {
    	      actMsg = "相關資料已寫入資料庫";
    	    }
        	rd = application.getRequestDispatcher( ConPgName +"?act=New&sn_docno="+ sn_docno);         
        } else if(act.equals("Update")){
            String sn_docno = request.getParameter("sn_docno" )== null  ? "" : (String)request.getParameter("sn_docno");
            String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
            actMsg = updateDataToDB(request,userId,userName);
            actMsg = Utility.insertDataToLog(request, userId, pgId);
            request.setAttribute("prePageURL","TC31.jsp?act=Edit&sn_docno="+sn_docno+"&reportno="+reportno); 
        	rd = application.getRequestDispatcher( nextPgName );         
        } else if(act.equals("Delete")){
            String sn_docno = request.getParameter("sn_docno" )== null  ? "" : (String)request.getParameter("sn_docno");
            String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
            actMsg = Utility.insertDataToLog(request, userId, pgId);
    	    actMsg = deleteDataToDB(request,userId,userName);
    	    if(actMsg.equals("")) {
              actMsg = "相關資料已刪除";
              request.setAttribute("prePageURL","TC31.jsp?act=List");
            }
        	rd = application.getRequestDispatcher( nextPgName );                 
        }
        request.setAttribute("queryURL","TC31.jsp?act=List");
    	request.setAttribute("actMsg",actMsg); 
      }   

%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "TC31" ;
private final static String nextPgName = "/pages/message.jsp";
private final static String ConPgName = "/pages/"+report_no+".jsp";
private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";    
private final static String ListPgName = "/pages/"+report_no+"_List.jsp";        
private final static String LoginErrorPgName = "/pages/LoginError.jsp";

private final static String BANK_TYPE = "020"; //金融機構代碼
private final static String EXAM_DIV = "022";  //檢查評等
private final static String CH_TYPE = "023"; //檢查性質
private final static String ORIGINUNT_ID = "024";   //檢查報告單位
private final static String DOCTYPE = "025";   //公文類別
          
    
    //取得所有總機構資料
    private List getTatolBankType(){
    	//查詢條件
		//fix 增加縣市合併判斷用m_year by 2808
		StringBuffer sql = new StringBuffer() ;
		sql.append(" select bn01.bn_type,HSIEN_id, BN01.BANK_NO , BANK_NAME, BANK_TYPE,bn01.m_year  ");
		sql.append(" from  BN01, WLX01 ");
		sql.append(" where BN01.BANK_NO = WLX01.BANK_NO(+) ");
		sql.append(" and wlx01.m_year = bn01.m_year ");    		
		sql.append(" order by BANK_NO  ");  
	    List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,"m_year");
	    return dbData;
    }





//取得所有受檢單位資料
private List getBankNo(){
	//查詢條件
	StringBuffer sqlCmd = new StringBuffer() ;
	List paramList = new ArrayList () ;
	sqlCmd.append( " Select BANK_NO , BANK_NAME , TBANK_NO  from  BN02 WHERE bank_type in ( select cmuse_id from cdshareno where cmuse_div =? )  order by BANK_NO ");
	paramList.add("020") ;
	
    List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");            
    return dbData;
}


    //取得CDShareNO, 欄位cmuse_div為id的所有內容
    private List getCDShareNOWith(String id){
    	//查詢條件    
		StringBuffer sqlCmd = new StringBuffer() ;
		List paramList = new ArrayList () ;
		sqlCmd.append( " select cmuse_id, cmuse_name from cdshareno where cmuse_div = ? order by cmuse_id " );  
		paramList.add(id) ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");            
        return dbData;
    }
    
    //取得查詢資料
    private List getQueryResult(HttpServletRequest request){
        String sn_docno = Utility.getTrimString(request.getParameter("sn_docno" ));
        String reportno = Utility.getTrimString(request.getParameter("reportno" ));
        String sn_date = Utility.getTrimString(request.getParameter("sn_date" ));
        String doctype = Utility.getTrimString(request.getParameter("doctype" ));
        String bankType = Utility.getTrimString(request.getParameter("bankType" ));
        String tbank_no =Utility.getTrimString( request.getParameter("tbank" ));
        String examine = Utility.getTrimString(request.getParameter("examine" ));
        String limitdate = Utility.getTrimString(request.getParameter("limitdate" ));
        String begDate = Utility.getTrimString(request.getParameter("begDate" ));
        String endDate = Utility.getTrimString(request.getParameter("endDate" ));
        String cityType = Utility.getTrimString(request.getParameter("cityType" ));  		
    		
        request.setAttribute("cityType",cityType);
        request.setAttribute("sn_docno",sn_docno);
    	request.setAttribute("reportno",reportno);
    	request.setAttribute("sn_date",sn_date);
    	request.setAttribute("doctype",doctype);
    	request.setAttribute("bankType",bankType);
    	request.setAttribute("examine",examine);
    	request.setAttribute("limitdate",limitdate);
    	request.setAttribute("begDate",begDate);
    	request.setAttribute("endDate",endDate);
    	String u_year = "99" ;
    	if(!"".equals(begDate) && Integer.parseInt(begDate.substring(0,4))>2010 ) {
    		u_year = "100" ;
    	}
    	if(bankType.equals("0")) {
    	    bankType = "";
    	}
    	StringBuffer sqlCmd = new StringBuffer() ;
    	List paramList = new ArrayList() ;
    	//查詢條件    
        sqlCmd.append("SELECT c.bank_name, a.reportno, a.sn_docno, ((TO_CHAR(a.sn_date,'yyyy')-1911)||'/'|| TO_CHAR(a.sn_date,'mm/dd'))  as sn_date, d.cmuse_name "+
    		    " FROM ExSnDocF a, ExReportF b, (select * from ba01 where m_year= ? ) c, CdShareNo d "+
    		    " WHERE a.reportno = b.reportno AND b.bank_no = c.bank_no AND"+
    		    " (a.doctype = d.cmuse_id AND d.cmuse_div = ?)" +
    		    " AND TO_CHAR(a.sn_date ,'yyyymmdd') BETWEEN ? AND ? " );
    	
    	paramList.add(u_year) ;
    	paramList.add("025") ;
    	paramList.add(begDate) ;
    	paramList.add(endDate) ;
    	if(!reportno.equals("")) {
    	    sqlCmd.append( "  AND a.reportno = ?" );
    	    paramList.add(reportno) ;
    	}
    	if(!sn_docno.equals("")) {
    	    sqlCmd.append( "  AND a.sn_docno = ? ");
    	    paramList.add(sn_docno ) ;
    	}
    	if(!tbank_no.equals("")) {
    	    sqlCmd.append( "  AND b.tbank_no = ? "); 
    	    paramList.add(tbank_no) ;
    	}
        if(!doctype.equals("")) {
    	    sqlCmd.append( "  AND a.doctype = ? " );
    	    paramList.add(doctype) ;
    	}
    	if(!bankType.equals("")) {
    	    sqlCmd.append( "  AND b.bank_type = ? " );
    	    paramList.add(bankType) ;
    	}
    	if(!examine.equals("")) {
    	    sqlCmd.append( "  AND b.bank_no = ? " );
    	    paramList.add(examine) ;
    	}
    	if(!limitdate.equals("")) {
    	    sqlCmd.append( "  AND a.limitdate = ? " );
    	    paramList.add(limitdate) ;
    	}
    	if(!cityType.equals("")) {
    		   sqlCmd.append( " and TBANK_NO in (select BANK_NO  from WLX01  where HSIEN_ID =  ? and m_year=? ) ");
    		   paramList.add(cityType) ;
    		   paramList.add(u_year) ;
    	}
    	
    	sqlCmd.append( " order by a.sn_docno, a.reportno " );
    	
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
        System.out.println("dbData= "+dbData.size());          
        return dbData;
    }
    
    // 取得單筆查詢資料
    private List getQueryDetail(String sn_docno) {
    	StringBuffer sqlCmd = new StringBuffer() ;
    	List paramList = new ArrayList () ;
        sqlCmd.append(" SELECT sn_docno, reportno, TO_CHAR(sn_date,'yyyy') as sn_dateY, TO_CHAR(sn_date,'mm') as sn_dateM,");
        sqlCmd.append(" TO_CHAR(sn_date,'dd') as sn_dateD, doctype, doctype_cnt, TO_CHAR(limitdate,'yyyy') as limitY,");
        sqlCmd.append(" TO_CHAR(limitdate,'mm') as limitM, TO_CHAR(limitdate,'dd') as limitD ");
        sqlCmd.append(" FROM ExSnDocF WHERE sn_docno = ?" );
        paramList.add(sn_docno) ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
        return dbData;
    }
    
    // 取得金融機構的資料
    private List getBank(String reportno,String begY) {
    	StringBuffer sqlCmd = new StringBuffer() ;
    	List paramList = new ArrayList() ;
    	String u_year = "99" ;
    	if(!"".equals(begY) && Integer.parseInt(begY) > 99) {
    		u_year = "100" ;
    	}
        sqlCmd.append( "SELECT d.cmuse_name, (b.bank_no || '  ' || c.bank_name) as bank_no ");
        sqlCmd.append(" FROM ExReportF b, (select * from ba01 where m_year=?) c, CDShareNo d ");
        sqlCmd.append(" WHERE b.reportno = ? AND b.bank_no = c.bank_no AND ( b.bank_type = d.cmuse_id and d.cmuse_div = ? )");
        paramList.add(u_year) ;
        paramList.add(reportno) ;
        paramList.add("020") ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
        return dbData;
    }

       // 新增資料到資料庫
    private String insertDataToDB(HttpServletRequest request, String loginID, String loginName) {
        String actMsg = "";
        String errMsg = "";
        String sn_docno = Utility.getTrimString(request.getParameter("sn_docno" ));
        String reportno = Utility.getTrimString(request.getParameter("reportno" ));
        String sn_date = Utility.getTrimString(request.getParameter("sn_date" ));
        String doctype = Utility.getTrimString(request.getParameter("doctype" ));
        String doctype_cnt = Utility.getTrimString(request.getParameter("doctype_cnt" ));
        String limitdate = Utility.getTrimString(request.getParameter("limitdate" ));             
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
        try {
            StringBuffer sqlCmd = new StringBuffer() ;
            // 檢查是否有這一筆資料, 如果沒有就新增, 如果有就先刪除再新增
            sqlCmd.append( "select count(*) as count from ExSnDocF where sn_docno = ? ");
            paramList.add(sn_docno) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");		 			    
		    System.out.println("ExSnDocF Size="+data.size());
			if(data.size() > 0) {
			    DataObject bean = (DataObject)data.get(0);
			    String rs = String.valueOf(bean.getValue("count"));
			    System.out.println("Count ="+rs);
			    if(!rs.equals("0")) {
			        errMsg = "發文文號"+sn_docno+" 重複";
                    return errMsg;
			    }
            }
            paramList.clear() ;
            sqlCmd.setLength(0) ;
            // 檢查檢查編號是否存在
            sqlCmd.append("SELECT reportno FROM ExReportF WHERE reportno = ? " );
            paramList.add(reportno) ;
            data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
		    System.out.println("ExReportF Size="+data.size());
			if(data.size() < 1) {
     	        errMsg = "檢查編號"+reportno+" 不存在";
                return errMsg;
            }
			paramList.clear() ;
			sqlCmd.setLength(0) ;
            sqlCmd.append( "insert into ExSnDocF(sn_docno, reportno, sn_date, doctype, doctype_cnt, limitdate, user_id, user_name, update_date) " +
                " values(?, "
                +" ?, "
                +" TO_DATE(?,'YYYY/MM/DD'), "
                +" ?, "
                +" ?, "
                +" TO_DATE(?,'YYYY/MM/DD'), ?, ?, sysdate) " );
            paramList.add(sn_docno) ;
            paramList.add(reportno) ;
            paramList.add(sn_date) ;
            paramList.add(doctype) ;
            paramList.add(doctype_cnt) ;
            paramList.add(limitdate) ;
            paramList.add(loginID) ;
            paramList.add(loginName) ;
            //insertDBSqlList.add(sqlCmd);
            updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
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
        String sn_date = Utility.getTrimString(request.getParameter("sn_date" ));
        String doctype = Utility.getTrimString(request.getParameter("doctype" ));
        String doctype_cnt = Utility.getTrimString(request.getParameter("doctype_cnt" ));
        String limitdate = Utility.getTrimString(request.getParameter("limitdate" ));             
   
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {
	        StringBuffer sqlCmd = new StringBuffer () ;
            // 檢查是否有這一筆資料
            sqlCmd.append("select reportno FROM ExSnDocF where sn_docno = ? ");
            paramList.add(sn_docno) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
		    System.out.println("ExSnDocF Size="+data.size());
			if(data.size() < 1) {
                errMsg = "找不到發文文號 "+sn_docno ;
                return errMsg; 
            }
            paramList.clear() ;
            sqlCmd.setLength(0) ;
            
            // 檢查檢查編號是否存在
            sqlCmd.append( "SELECT reportno FROM ExReportF WHERE reportno =?" );
            paramList.add(reportno) ;
            
            data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
		    System.out.println("ExReportF Size="+data.size());
			if(data.size() < 1) {
     	        errMsg = "檢查編號"+reportno+" 不存在";
                return errMsg;
            }
            paramList.clear() ;
            sqlCmd.setLength(0) ;
            sqlCmd.append(" UPDATE ExSnDocF SET sn_date = TO_DATE(?,'yyyy/mm/dd'), "+
                " limitdate = TO_DATE(?,'yyyy/mm/dd'), "+
                " sn_docno = ?, " +
                " reportno = ?, "+
                " doctype = ?, "+
                " doctype_cnt = ?, " + 
                " user_id = ?, "+
                " user_name =?, " +
                " update_date = sysdate WHERE sn_docno =?");
            paramList.add(sn_date) ;
            paramList.add(limitdate) ;
            paramList.add(sn_docno) ;
            paramList.add(reportno) ;
            paramList.add(doctype) ;
            paramList.add(doctype_cnt) ;
            paramList.add(loginID) ;
            paramList.add(loginName) ;
            paramList.add(sn_docno) ;
            //updateDBSqlList.add(sqlCmd);
            updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
            if(DBManager.updateDB_ps(updateDBList)){
			       errMsg += "相關資料已寫入資料庫";
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
        
        String sn_docno = Utility.getTrimString(request.getParameter("sn_docno"));
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {
	        // 檢查回文報告是否有這一筆資料, 如果有則不可刪除
	        StringBuffer sqlCmd = new StringBuffer() ;
            sqlCmd.append("select sn_docno from ExRtdocf where sn_docno = ? " );
            paramList.add(sn_docno) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
		    System.out.println("ExRtdocf Size="+data.size());
			if(data.size() > 0) {
                return "發文文號"+sn_docno+"已存在回文報告中, 不可刪除";
            }
            paramList.clear() ;
            sqlCmd.setLength(0) ;
            sqlCmd.append( " DELETE FROM ExSnDocF WHERE sn_docno = ? " ); 
            paramList.add(sn_docno) ;
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
