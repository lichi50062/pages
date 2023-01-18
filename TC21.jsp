<%
/* 94.1.18 createed
   
   檢查行政系統 - 檢查報告編號維護 主控制頁面
   99.05.31 fix 套用Header.include & sql injection by 2808 
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
	String begY = Utility.getTrimString(dataMap.get("begY")) ;
	
	System.out.println("Page: TC21.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );
	

	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
            rd = application.getRequestDispatcher( LoginErrorPgName ); 
	        
	    } else {
    	if(act.equals("List") || act.equals("Qry") || act.equals("Edit") ||  act.equals("New")) {
    	    request.setAttribute("Bank_Type", getCDShareNOWith(BANK_TYPE));
            request.setAttribute("TBank", getTatolBankType());
            request.setAttribute("Bank_No",getBankNo());
    	    request.setAttribute("Ch_Type",getCDShareNOWith(CH_TYPE));
    	    request.setAttribute("Exam_Div", getCDShareNOWith(EXAM_DIV));
    	    request.setAttribute("Originunt_Id",getCDShareNOWith(ORIGINUNT_ID));
    	    request.setAttribute("City", Utility.getCity());
    	    if(act.equals("List")) {
    	        rd = application.getRequestDispatcher( ListPgName +"?act=List"); 
    	    } else if(act.equals("Edit") || act.equals("New")) {
    	        String disp_id = request.getParameter("disp_id" )== null  ? "" : (String)request.getParameter("disp_id");
    	        String exam_id = request.getParameter("exam_id" )== null  ? "" : (String)request.getParameter("exam_id");
    	        request.setAttribute("Inspector", getInspector(disp_id));
    	        
    	        if(act.equals("New")) {
    	            if(!disp_id.equals("")) {
    	                List exTrip = getExTrip(disp_id,begY);
    	                if( exTrip != null && exTrip.size() < 1){
    	                    System.out.println("exTrip size = "+exTrip.size());
    	                    actMsg = "找不到派差通知單編號 "+disp_id;
    	                    rd = application.getRequestDispatcher( nextPgName );
    	                } else if(getDispIdInReport(disp_id).size() > 0 ) {
    	                    actMsg = "派差通知單編號 "+disp_id+ " 已建立檢查報告, 請查證";
    	                    rd = application.getRequestDispatcher( nextPgName );
    	                } else if(!isExist(disp_id)) {
    	                    actMsg = "派差通知單編號"+disp_id+" 不存在行程計畫中";
    	                    rd = application.getRequestDispatcher( nextPgName );
    	                } else {
    	                    request.setAttribute("ExTrip", exTrip);
    	                    rd = application.getRequestDispatcher( EditPgName +"?act=New");
    	                }
    	            } else {
    	                rd = application.getRequestDispatcher( EditPgName +"?act=New");
    	            }
    	        }else{
    	            request.setAttribute("ExDate", getExSchedule(disp_id, exam_id,begY));
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit");
    	        }
    	    } else if(act.equals("Qry")) {
    	        List result = getQueryResult(request);
    	        request.setAttribute("QueryResult",result);
    	        rd = application.getRequestDispatcher( ListPgName +"?act=Qry");
    	    }
        } else if(act.equals("Insert")){
            String reportno = request.getParameter("exam_id" )== null  ? "" : (String)request.getParameter("exam_id");
    	    actMsg = insertDataToDB(request,userId,userName);
    	    if(actMsg.equals("")) {
    	      actMsg = "相關資料已寫入資料庫";
    	      request.setAttribute("prePageURL","TC21.jsp?act=Edit&exam_id="+reportno);
    	    }
        	rd = application.getRequestDispatcher( nextPgName );         
        } else if(act.equals("Update")){
            String reportno = request.getParameter("exam_id" )== null  ? "" : (String)request.getParameter("exam_id");
            actMsg = updateDataToDB(request,userId,userName); 
            if(actMsg.equals("")) {
    	      actMsg = "相關資料已寫入資料庫";
    	      request.setAttribute("prePageURL","TC21.jsp?act=Edit&exam_id="+reportno);
    	    }
        	rd = application.getRequestDispatcher( nextPgName );         
        } else if(act.equals("Delete")){
            String reportno = request.getParameter("exam_id" )== null  ? "" : (String)request.getParameter("exam_id");
    	    actMsg = deleteDataToDB(request,userId,userName); 
    	    if(actMsg.equals("")) {
              actMsg = "相關資料已刪除";
              request.setAttribute("prePageURL","TC21.jsp?act=List");
            }
        	rd = application.getRequestDispatcher( nextPgName );                 
        }
        request.setAttribute("queryURL","TC21.jsp?act=List");
    	request.setAttribute("actMsg",actMsg); 
      }
    
	
%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no ="TC21" ;
private final static String nextPgName = "/pages/message.jsp";    
private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";    
private final static String ListPgName = "/pages/"+report_no+"_List.jsp";        
private final static String LoginErrorPgName = "/pages/LoginError.jsp";

private final static String BANK_TYPE = "020"; //金融機構代碼
private final static String EXAM_DIV = "022";  //檢查評等
private final static String CH_TYPE = "023"; //檢查性質
private final static String ORIGINUNT_ID = "024";   //檢查報告單位
    
    private boolean CheckPermission(HttpServletRequest request){//檢核權限    	    
    	    boolean CheckOK=false;
    	    HttpSession session = request.getSession();            
            Properties permission = ( session.getAttribute("TC21")==null ) ? new Properties() : (Properties)session.getAttribute("TC21");				                
            if(permission == null){
              System.out.println("TC21.permission == null");
            }else{
               System.out.println("TC21.permission.size ="+permission.size());
               
            }
            //只要有Query的權限,就可以進入畫面
        	if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){            
        	   CheckOK = true;//Query
        	}
        	return CheckOK;
    }
    
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
    
    // ExreportF 內的是否有相同的ID
    private List getDispIdInReport(String id){
    		//查詢條件    
    		StringBuffer  sqlCmd = new StringBuffer() ;
    		List paramList = new ArrayList() ;
    		sqlCmd.append(" select disp_id from ExReportF where disp_id = ? " );  
    		paramList.add(id) ;
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");            
            return dbData;
    }
    //取得查詢資料
    private List getQueryResult(HttpServletRequest request){
    	
            String disp_id = Utility.getTrimString(request.getParameter("disp_id" ));
            String exam_id = Utility.getTrimString(request.getParameter("exam_id" ));
            String begDate = Utility.getTrimString(request.getParameter("begDate" ));
            String endDate = Utility.getTrimString(request.getParameter("endDate" ));
            String bankType = Utility.getTrimString(request.getParameter("bankType" ));
            String tbank_no = Utility.getTrimString(request.getParameter("tbank_no" ));
            String examine =  Utility.getTrimString(request.getParameter("examine" ));
            String property = Utility.getTrimString(request.getParameter("property" ));
    		String exam_div = Utility.getTrimString(request.getParameter("exam_div" ));
    		String cityType = Utility.getTrimString(request.getParameter("cityType" ));  		
    		String u_year = "99" ;
    		if(!"".equals(begDate) && Integer.parseInt(begDate.substring(0,4))>2010) {
    			u_year= "100" ;
    		}
            request.setAttribute("cityType",cityType);
    		request.setAttribute("disp_id",disp_id);
    		request.setAttribute("exam_id",exam_id);
    		request.setAttribute("begDate",begDate);
    		request.setAttribute("endDate",endDate);
    		request.setAttribute("bankType",bankType);
    		request.setAttribute("examine",examine);
    		request.setAttribute("property",property);

    		//查詢條件    
    		StringBuffer sqlCmd = new StringBuffer () ;
    		List paramList = new ArrayList() ;
    		sqlCmd.append("select disp_id, reportno, ((TO_CHAR(base_date,'yyyy')-1911)||'/'|| TO_CHAR(base_date,'mm/dd')) as base_date, TO_CHAR(report_in_date,'yyyy/mm/dd') as ware_date, bank_no, ch_type, bank_type, originUnt_id  from ExReportF "+
    		    " where TO_CHAR(base_date,'yyyymmdd') between ? and ? ");
    		paramList.add(begDate) ;
    		paramList.add(endDate) ;
    		if(!disp_id.equals("")) {
    		    sqlCmd.append( " and disp_id = ? ");
    		    paramList.add(disp_id) ;
    		
    		}
    		if(!exam_id.equals("")) {
    		    sqlCmd.append( " and reportno = ? ");
    		    paramList.add(exam_id) ;
    		}
    		if(!bankType.equals("") && !bankType.equals("0")) {
    		    sqlCmd.append( " and bank_type =? " );
    		    paramList.add(bankType) ;
    		}
    		if(!tbank_no.equals("")) {
    		    sqlCmd.append( " and tbank_no =? " );
    		    paramList.add(examine) ;
    		}
    		if(!examine.equals("")) {
    		    sqlCmd.append( " and bank_no =? ");
    		    paramList.add(examine) ;
    		}
    		if(!property.equals("")) {
    		   sqlCmd.append( " and ch_type = ? ");
    		   paramList.add(property) ;
    		}
    		if(!cityType.equals("")) {
    		   sqlCmd.append( " and TBANK_NO in (select BANK_NO  from WLX01  where HSIEN_ID = ? and u_year = ? ) ");
    		   paramList.add(cityType) ;
    		   paramList.add(u_year) ;
    		}
    		
    		sqlCmd.append( " order by reportno,disp_id" );
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");            
            return dbData;
    }

    // 取得派差基本資料
    private List getExTrip(String disp_id,String begY) {
        //查詢條件
        String u_year = "99" ;
        if(!"".equals(begY) && Integer.parseInt(begY) > 99) {
        	u_year= "100" ;
        }
        StringBuffer sqlCmd = new StringBuffer() ;
        List paramList = new ArrayList() ;
        sqlCmd.append(" select a.disp_id, a.exam_id, to_char(c.st_date, 'yyyy') ware_dateY1, to_char(c.st_date, 'mm') ware_datem1,to_char(c.st_date, 'dd') ware_dated1, to_char(c.en_date, 'yyyy') ware_dateY2, to_char(c.en_date, 'mm') ware_datem2, to_char(c.en_date, 'dd') ware_dated2, a.exam_div,a.bank_type, a.ch_type, a.bank_no, a.tbank_no, b.bank_name "+
    		    " from exdistripf a, (select * from ba01 where m_year=?) b, exschedulef c "+
    		    " where a.disp_id = c.disp_id and b.bank_type in ( select cmuse_id from cdshareno where cmuse_div = ? ) "+
    		    " and a.bank_no = b.bank_no and a.disp_id = ? ");
        paramList.add(u_year) ;
        paramList.add("020") ;
        paramList.add(disp_id) ;
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");            
            return dbData;
    }
    
    // 檢查是否存在
    private  boolean isExist(String disp_id) {
        //查詢條件
        StringBuffer sqlCmd = new StringBuffer() ;
        List paramList = new ArrayList() ;
        sqlCmd.append( " select disp_id from ExScheduleF where disp_id = ?");
        paramList.add(disp_id) ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
        if(dbData != null && dbData.size() > 0) {
          return true;
        } else {
          return false;
        }
    }

    // 取得派差行程資料
    private List getExSchedule(String disp_id, String reportno,String begY ) {
    	StringBuffer sqlCmd = new StringBuffer() ;
    	List paramList = new ArrayList() ;
    	String u_year = "99" ;
        if(!"".equals(begY) && Integer.parseInt(begY) > 99) {
        	u_year= "100" ;
        }
        //查詢條件
        sqlCmd.append( " select hsien_id, report_come_docno, report_receive_docno, disp_id, reportno, originUnt_id, ch_type, exreportf.bank_type, exreportf.tbank_no, exreportf.bank_no, "+
    		    " to_char(base_date,'yyyy') as base_dateY, to_char(base_date,'mm') as base_dateM, to_char(base_date,'dd') as base_dateD, "+
    		    " to_char(report_in_date,'yyyy') as ware_dateY1, to_char(report_in_date,'mm') as ware_dateM1,to_char(report_in_date,'dd') as ware_dateD1,  "+
    		    " to_char(report_en_date,'yyyy') as ware_dateY2, to_char(report_en_date,'mm') as ware_dateM2,to_char(report_en_date,'dd') as ware_dateD2,  "+
    		    " to_char(report_come_date,'yyyy') as come_dateY, to_char(report_come_date,'mm') as come_dateM,to_char(report_come_date,'dd') as come_dateD  "+
    		    " from exreportf, (select * from wlx01 where m_year=? )WLX01 where exreportf.TBANK_NO = WLX01.BANK_NO(+)  and (disp_id = ? OR reportno = ?) ");
        paramList.add(u_year) ;
        paramList.add(disp_id ) ;
        paramList.add(reportno) ;
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");            
            return dbData;
    }


    // 取得檢查人員
    private List getInspector(String disp_id){
    		//查詢條件
    		StringBuffer sqlCmd = new StringBuffer() ;
    		List paramList = new ArrayList () ;
    		sqlCmd.append(" select a.disp_id, b.muser_name, c.expertNo_name "+
    		  " from exhelpitemf a, wtt01 b, expertNoF c "+ 
    		  " where a.muser_id = b.muser_id "+
    		  " and a.exam_item = c.expertNo_id "+
    		  " and a.disp_id = ? ");
    		paramList.add(disp_id) ;
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
            return dbData;
    }


    // 新增資料到資料庫
    private String insertDataToDB(HttpServletRequest request, String loginID, String loginName) {
        String actMsg = "";
        String errMsg = "";
        String disp_id = request.getParameter("disp_id" )== null  ? "" : (String)request.getParameter("disp_id").trim();
        String base_date = request.getParameter("base_date" )== null  ? "" : (String)request.getParameter("base_date").trim();
        String report_in_date = request.getParameter("ware_date1" )== null  ? "" : (String)request.getParameter("ware_date1").trim();
        String originunt_id = request.getParameter("originunt_id" )== null  ? "" : (String)request.getParameter("originunt_id");
        String reportno = request.getParameter("exam_id" )== null  ? "" : (String)request.getParameter("exam_id");
        String bankType = request.getParameter("bankType" )== null    ? "" : (String)request.getParameter("bankType");
        String tbank_no = request.getParameter("tbank" )== null    ? "" : (String)request.getParameter("tbank");
        String examine = request.getParameter("examine" )== null  ? "" : (String)request.getParameter("examine");
        String property = request.getParameter("property" )== null  ? "" : (String)request.getParameter("property");
        String report_come_date = request.getParameter("come_date" )== null  ? "" : (String)request.getParameter("come_date");
        String report_come_docno = request.getParameter("come_docno" )== null    ? "" : (String)request.getParameter("come_docno");
        String report_receive_docno = request.getParameter("receive_docno" )== null    ? "" : (String)request.getParameter("receive_docno");
        String report_en_date = request.getParameter("ware_date2" )== null  ? "" : (String)request.getParameter("ware_date2").trim();
        
        
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
        try {
            // 檢查是否有這一筆資料, 如果沒有就新增, 如果有就先刪除再新增
            StringBuffer sqlCmd = new StringBuffer() ;
            sqlCmd.append("select disp_id from ExReportF where reportno = ? " );
            paramList.add(reportno) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
		    System.out.println("ExReportF Size="+data.size());
			if(data.size() > 0) {
                errMsg = "檢查報告編號 "+reportno+" 資料已存在資料庫中";
                return errMsg; 
            }
			sqlCmd.setLength(0) ;
			paramList.clear() ;
            sqlCmd.append( "insert into ExReportF(reportno, report_in_date, report_en_date, report_come_date, report_come_docno, report_receive_docno, base_date, disp_id, originunt_id, ch_type, bank_type, tbank_no, bank_no, user_id, user_name, update_date) " +
                " values(?, "
                +" TO_DATE(?,'YYYY/MM/DD'), "
                +" TO_DATE(?,'YYYY/MM/DD'), "
                +" TO_DATE(?,'YYYY/MM/DD'), "
                +" ?, "
                +" ?, "
                +" TO_DATE(?,'YYYY/MM/DD'), "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?,?, ?, sysdate) ");
            paramList.add(reportno) ;
            paramList.add(report_in_date) ;
            paramList.add(report_en_date) ;
            paramList.add(report_come_date) ;
            paramList.add(report_come_docno) ;
            paramList.add(report_receive_docno) ;
            paramList.add(base_date) ;
            paramList.add(disp_id) ;
            paramList.add(originunt_id) ;
            paramList.add(property) ;
            paramList.add(bankType) ;
            paramList.add(tbank_no) ;
            paramList.add(examine) ;
            paramList.add(loginID) ;
            paramList.add(loginName) ;
            
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
        String disp_id = request.getParameter("disp_id" )== null  ? "" : (String)request.getParameter("disp_id").trim();
        String base_date = request.getParameter("base_date" )== null  ? "" : (String)request.getParameter("base_date").trim();
        String report_in_date = request.getParameter("ware_date1" )== null  ? "" : (String)request.getParameter("ware_date1").trim();
        String originunt_id = request.getParameter("originunt_id" )== null  ? "" : (String)request.getParameter("originunt_id");
        String reportno = request.getParameter("exam_id" )== null  ? "" : (String)request.getParameter("exam_id");
        String bankType = request.getParameter("bankType" )== null    ? "" : (String)request.getParameter("bankType");
        String tbank_no = request.getParameter("tbank" )== null    ? "" : (String)request.getParameter("tbank");
        String examine = request.getParameter("examine" )== null  ? "" : (String)request.getParameter("examine");
        String property = request.getParameter("property" )== null  ? "" : (String)request.getParameter("property");
	    String report_come_date = request.getParameter("come_date" )== null  ? "" : (String)request.getParameter("come_date");
        String report_come_docno = request.getParameter("come_docno" )== null    ? "" : (String)request.getParameter("come_docno");
        String report_receive_docno = request.getParameter("receive_docno" )== null    ? "" : (String)request.getParameter("receive_docno");
        String report_en_date = request.getParameter("ware_date2" )== null  ? "" : (String)request.getParameter("ware_date2").trim();
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {
	        // 檢查是否有這一筆資料
	        StringBuffer sqlCmd = new StringBuffer() ;
            sqlCmd.append( "select reportno from ExReportF where reportno =?" );
            paramList.add(reportno) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
		    System.out.println("ExReportF Size="+data.size());
			if(data.size() < 1 ) {
                errMsg = "找不到檢查報告編號 "+reportno ;
                return errMsg; 
            }
            sqlCmd.setLength(0) ;
            paramList.clear() ;
            sqlCmd.append( " UPDATE ExReportF SET report_in_date = TO_DATE(?,'yyyy/mm/dd'), "+
                " base_date = TO_DATE(?,'yyyy/mm/dd'), "+
                " report_en_date = TO_DATE(?,'yyyy/mm/dd'), "+
                " report_come_date = TO_DATE(?,'yyyy/mm/dd'), "+
                " report_come_docno = ?, " +
                " report_receive_docno = ?, " +
                " disp_id = ?, " +
                " originUnt_id = ?, "+
                " ch_type = ?, "+
                " bank_type = ?, " +
                " tbank_no = ?, " +
                " bank_no = ?, " +
                " user_id = ?, "+
                " user_name = ?, " +
                " update_date = sysdate WHERE reportno =? " );
            paramList.add(report_in_date) ;
            paramList.add(base_date) ;
            paramList.add(report_en_date) ;
            paramList.add(report_come_date) ;
            paramList.add(report_come_docno) ;
            paramList.add(report_receive_docno) ;
            paramList.add(disp_id) ;
            paramList.add(originunt_id) ;
            paramList.add(property) ;
            paramList.add(bankType) ;
            paramList.add(tbank_no) ;
            paramList.add(examine) ;
            paramList.add(loginID) ;
            paramList.add(loginName) ;
            paramList.add(reportno) ;
            
            updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
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
        
        String reportno = request.getParameter("exam_id" )== null  ? "" : (String)request.getParameter("exam_id");
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {
	        // 檢查缺失改善報告是否有這一筆資料, 如果有則不可刪除
	        StringBuffer sqlCmd = new StringBuffer() ;
            sqlCmd.append( "select reportno from ExDefGoodF where reportno = ? " );
            paramList.add(reportno) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
		    System.out.println("ExDefGoodF Size="+data.size());
			if(data.size() > 0) {
                return "檢查報告"+reportno+"已存在缺失改善報告中, 不可刪除";
            }
            sqlCmd.setLength(0) ;
            paramList.clear() ;
            // 檢查是否有這一筆資料
            sqlCmd.append( "select reportno FROM ExSnDocF where reportno = ? " );
            paramList.add(reportno) ;
            data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
		    System.out.println("ExSnDocFSize="+data.size());
			if(data.size() > 0 ) {
                errMsg = "檢查報告"+reportno+"已存在發文報告中, 不可刪除" ;
                return errMsg; 
            }
	        sqlCmd.setLength(0) ;
	        paramList.clear() ;
	        // 檢查是否有這一筆資料
            sqlCmd.append( "select reportno from ExReportF where reportno =? " );
	        paramList.add(reportno) ;
            data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
		    System.out.println("ExReportF Size="+data.size());
			if(data.size() < 1 ) {
                errMsg = "找不到檢查報告編號 "+reportno ;
                return errMsg; 
            }
	        sqlCmd.setLength(0) ;
	        paramList.clear() ;
	        sqlCmd.append( " DELETE FROM ExReportF WHERE reportno =? " );
	        paramList.add(reportno) ;
            
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



