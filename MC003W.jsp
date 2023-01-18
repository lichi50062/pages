<%
//97.09.09 create 年報(MC003W) by 2295
//99.05.26 fix 縣市合併調整&sql injection by 2808
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
    String Come_begDate = Utility.getTrimString(request.getParameter("Come_begDate")) ;
	
	System.out.println("Page: MC003W.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );


	    if(!Utility.CheckPermission(request,"MC003W")){//無權限時,導向到LoginError.jsp
            rd = application.getRequestDispatcher( LoginErrorPgName );
	    } else {
    	if(act.equals("List") || act.equals("Qry") || act.equals("Edit") ||  act.equals("New")) {    	    
    		request.setAttribute("TBank", getTatolBankType());           
    	    request.setAttribute("City", Utility.getCity());
    	    if(act.equals("List")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));    	       
    	        rd = application.getRequestDispatcher( ListPgName +"?act=List");
    	    } else if(act.equals("Edit") || act.equals("New")) {    	       
    	        if(act.equals("New")) {    	          
    	            rd = application.getRequestDispatcher( EditPgName +"?act=New");
    	        }else{
    	            String bank_no = request.getParameter("bank_no") != null ? request.getParameter("bank_no") : "";
    	            String rptyear = request.getParameter("rptyear") != null ? request.getParameter("rptyear") : "";    	           
    	            request.setAttribute("DETAIL",getDetail(rptyear,bank_no,Come_begDate));    	           
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit");
    	        }
    	    } else if(act.equals("Qry")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));    	        
    	        rd = application.getRequestDispatcher( ListPgName +"?act=Qry");  
    	    }     	    
        } else if(act.equals("Insert")){
    	    actMsg = insertDataToDB(request,userId,userName);
    	    request.setAttribute("actMsg",actMsg); 
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=MC003W.jsp&act=List");        	
        } else if(act.equals("Update")){
            actMsg = updateDataToDB(request,userId,userName);                   
            rd = application.getRequestDispatcher( nextPgName+"?goPages=MC003W.jsp&act=List");         	
        } else if(act.equals("Delete")){
    	    actMsg = deleteDataToDB(request,userId,userName);
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=MC003W.jsp&act=List");
        }        
    	request.setAttribute("actMsg",actMsg);
      }

	

%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "MC003W" ;
private final static String nextPgName = "/pages/ActMsg.jsp";
private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
private final static String LoginErrorPgName = "/pages/LoginError.jsp";

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

	//取得所有縣市
    private List getCity(){
    		//查詢條件
    		String sqlCmd = " SELECT HSIEN_id, HSIEN_name from cd01 order by input_order, hsien_id ";
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"");
            return dbData;
    }

    //取得查詢資料
    private List getQueryResult(HttpServletRequest request){
        String bankType = Utility.getTrimString(request.getParameter("bankType" ));
        String cityType = Utility.getTrimString(request.getParameter("cityType" ));
        String RptYear = Utility.getTrimString(request.getParameter("RptYear" ));//年報年份
        String tbank = Utility.getTrimString(request.getParameter("tbank" ));//機構名稱
        String Come_begDate =Utility.getTrimString(request.getParameter("Come_begDate" ));//來文日期-起始
        String Come_endDate =Utility.getTrimString(request.getParameter("Come_endDate" ));//來文日期-結束        
        String Come_docno =Utility.getTrimString(request.getParameter("Come_docno" ));//來文文號
        String Sn_begDate =Utility.getTrimString(request.getParameter("Sn_begDate" ));//發文日期-起始
        String Sn_endDate =Utility.getTrimString(request.getParameter("Sn_endDate" ));//發文日期-結束        
        String Sn_docno = Utility.getTrimString(request.getParameter("Sn_docno" ));//發文文號
        String content =Utility.getTrimString(request.getParameter("content" ));//處理情形
        String u_year = "99" ;
        if(!"".equals(Come_begDate) && Come_begDate.length() > 0 ) {
        	if(Integer.parseInt(Come_begDate.substring(0,4)) > 2010 ){
        		u_year = "100" ;
        	}
        }else {
        	if(Integer.parseInt(Utility.getYear()) > 99 ){
        		u_year = "100" ;
        	}
        }
        System.out.println("Come_begDate="+Come_begDate);
        System.out.println("Come_endDate="+Come_endDate);
        System.out.println("Sn_begDate="+Sn_begDate);
        System.out.println("Sn_endDate="+Sn_endDate);
    	request.setAttribute("content",content);
    	request.setAttribute("RptYear",RptYear);
    	request.setAttribute("bankType",bankType);
    	request.setAttribute("cityType",cityType);        
    	request.setAttribute("Come_begDate",Come_begDate);
    	request.setAttribute("Come_endDate",Come_endDate);
    	request.setAttribute("Sn_begDate",Sn_begDate);
    	request.setAttribute("Sn_endDate",Sn_endDate);
    	request.setAttribute("Come_docno",Come_docno);
    	request.setAttribute("Sn_docno",Sn_docno);
		
		StringBuffer condition= new StringBuffer();
		StringBuffer sqlCmd = new StringBuffer() ;
		List sqlCmdList = new ArrayList() ;
    	//查詢條件    	
    	sqlCmd.append( " select rptyear,bn01.bank_no,bn01.bank_name,"					  
					  + " ((TO_CHAR(come_date,'yyyy')-1911)||'/'|| TO_CHAR(come_date,'mm/dd')) as come_date,"
					  + " TO_CHAR(come_date,'yyyy/mm/dd') as come_date_1,"
					  + " ((TO_CHAR(sn_date,'yyyy')-1911)||'/'|| TO_CHAR(sn_date,'mm/dd')) as sn_date,"
					  + " TO_CHAR(sn_date,'yyyy/mm/dd') as sn_date_1,"
					  + " come_docno,sn_docno,"
					  + " decode(content,'01','同意備查','02','修正',content) as content"
					  + " from mis_rptyear "
					  + " left join (select * from bn01 where m_year = ? ) bn01 on mis_rptyear.bank_no = bn01.bank_no ");
		sqlCmdList.add(u_year) ;
		if(!RptYear.equals("")) {
            condition.append( (condition.length() > 0 ? " and":"")+" mis_rptyear.RptYear=? ");	
            sqlCmdList.add(RptYear) ;
        }
		
        if(!bankType.equals("")) {
            condition.append( (condition.length() > 0 ? " and":"")+" mis_rptyear.bank_type=? ");	
            sqlCmdList.add(bankType) ;
        }
    	if(!cityType.equals("")) {
    		condition.append( (condition.length() > 0 ? " and":"")+" mis_rptyear.BANK_NO in (select BANK_NO  from WLX01  where HSIEN_ID = ? ) ");
    		sqlCmdList.add(cityType) ;
    	}
    	if(!tbank.equals("")) {
    	    condition.append( (condition.length() > 0 ? " and":"")+" mis_rptyear.bank_no=? ");		
    	    sqlCmdList.add(tbank) ;
    	}
    	if(!content.equals("") && !content.equals("ALL")) {
    	    condition.append( (condition.length() > 0 ? " and":"")+" content = ? " );
    	    sqlCmdList.add(content) ;
    	}    	
    	if(!Come_docno.equals("")) {
    	    condition.append( (condition.length() > 0 ? " and":"")+" come_docno = ? " );
    	    sqlCmdList.add(Come_docno) ;
    	}
    	if(!Sn_docno.equals("")) {
    	    condition.append( (condition.length() > 0 ? " and":"")+" sn_docno = ? " );
    	    sqlCmdList.add(Sn_docno) ;
    	}
    	if(!Come_begDate.equals("") && !Come_endDate.equals("")){
    	    condition.append( (condition.length() > 0 ? " and":"")+" TO_CHAR(come_date, 'yyyymmdd') BETWEEN ? AND ? " );
    	    sqlCmdList.add(Come_begDate) ;
    	    sqlCmdList.add(Come_endDate) ;
    	}
    	if(!Sn_begDate.equals("") && !Sn_endDate.equals("")){
    	    condition.append( (condition.length() > 0 ? " and":"")+" TO_CHAR(sn_date, 'yyyymmdd') BETWEEN ? AND ? " );
    	    sqlCmdList.add(Sn_begDate) ;
    	    sqlCmdList.add(Sn_endDate) ;
    	}
    	
    	if(condition.length() > 0) {
    		sqlCmd.append( "where ").append(condition.toString());
    	}
    	
    	sqlCmd.append( " ORDER BY rptyear,bank_no,come_date,sn_date" );
		
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),sqlCmdList,"rptyear,come_date,come_date_1,sn_date,sn_date_1");
        System.out.println("dbData= "+dbData.size());
        return dbData;
    }
    
    // 取得單筆資料
    private DataObject getDetail(String rptyear,String bank_no,String Come_begDate) {
        DataObject ob = null;
        StringBuffer sqlCmd = new StringBuffer() ;
        List sqlCmdList = new ArrayList() ;
        String u_year = "99" ;
        if(!"".equals(Come_begDate) && Come_begDate.length() > 0 ) {
        	if(Integer.parseInt(Come_begDate.substring(0,4)) > 2010 ){
        		u_year = "100" ;
        	}
        }else {
        	if(Integer.parseInt(Utility.getYear()) > 99 ){
        		u_year = "100" ;
        	}
        }
        sqlCmd.append( " select rptyear,bn01.bank_no,bn01.bank_name,"					  
					  + " ((TO_CHAR(come_date,'yyyy')-1911)||'/'|| TO_CHAR(come_date,'mm/dd')) as come_date,"
					  + " TO_CHAR(come_date,'yyyy/mm/dd') as come_date_1,"
					  + " ((TO_CHAR(sn_date,'yyyy')-1911)||'/'|| TO_CHAR(sn_date,'mm/dd')) as sn_date,"
					  + " TO_CHAR(sn_date,'yyyy/mm/dd') as sn_date_1,"
					  + " come_docno,sn_docno,content"					  
					  + " from mis_rptyear "
					  + " left join (select * from bn01 where m_year = ? )bn01 on mis_rptyear.bank_no = bn01.bank_no "
					  + " where mis_rptyear.bank_no=?"
					  + " and  rptyear = ?");
        sqlCmdList.add(u_year) ;
        sqlCmdList.add(bank_no) ;
        sqlCmdList.add(rptyear) ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),sqlCmdList,"rptyear,come_date,come_date_1,sn_date,sn_date_1");
        if(dbData.size() > 0) {
            ob = (DataObject)dbData.get(0);
        }
        return ob;
    }
    
    private String insertDataToDB(HttpServletRequest request, String loginID, String loginName) {
        String actMsg = "";
        String errMsg = "";
        String RptYear = Utility.getTrimString(request.getParameter("RptYear" ));//年報年份
        String bankType =Utility.getTrimString(request.getParameter("bankType" ));//金融機構類別
        String tbank = Utility.getTrimString(request.getParameter("tbank" ));//機構名稱
        String COME_DATE = Utility.getTrimString(request.getParameter("COME_DATE" ));//來文日期
        String come_docno =Utility.getTrimString(request.getParameter("come_docno" ));//來文文號
        String SN_DATE = Utility.getTrimString(request.getParameter("SN_DATE" ));//發文日期
        String sn_docno = Utility.getTrimString(request.getParameter("sn_docno" ));//發文文號
        String content = Utility.getTrimString(request.getParameter("content" ));//處理情形       
       
        //List insertDBSqlList = new LinkedList();
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
        try {
            StringBuffer sqlCmd = new StringBuffer() ;
            // 檢查是否有這一筆資料, 如果沒有就新增
            sqlCmd.append( "select count(*) as count from MIS_RPTYEAR where bank_no = ? AND RptYear = ?");
            paramList.add(tbank) ;
            paramList.add(RptYear) ;
            
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");
		    System.out.println("MIS_RPTYEAR.size="+data.size());
			if(data != null && data.size() > 0) {
			    DataObject bean = (DataObject)data.get(0);
			    String rs = String.valueOf(bean.getValue("count"));
			    System.out.println("Count ="+rs);
			    if(!rs.equals("0")) {
			        errMsg += "此筆資料已存在無法新增<br>";
                    return errMsg;
			    }
            }
			sqlCmd.setLength(0) ;
			paramList.clear() ;
			sqlCmd.append("INSERT INTO MIS_RPTYEAR VALUES(?,?,?,"
		           +"to_date(?,'YYYY/MM/DD'),?,"+"to_date(?,'YYYY/MM/DD'),?,?,?,?,sysdate)");
		    paramList.add(RptYear) ;
		    paramList.add(bankType) ;
		    paramList.add(tbank) ;
		    paramList.add(COME_DATE) ;
		    paramList.add(come_docno) ;
		    paramList.add(SN_DATE) ;
		    paramList.add(sn_docno) ;
		    paramList.add(content) ;
		    paramList.add(loginID) ;
		    paramList.add(loginName) ;
		    
			//insertDBSqlList.add(sqlCmd);
			updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
		    
            if(DBManager.updateDB_ps(updateDBList)){
			   errMsg = errMsg + "相關資料寫入資料庫成功";
			}else{
			  errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
			}
        }catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗\n[Exception Error]: ";
		}
		return errMsg;
	}

	private String updateDataToDB(HttpServletRequest request, String loginID, String loginName) {
	    String actMsg = "";
        String errMsg = "";
       
        String RptYear = Utility.getTrimString(request.getParameter("RptYear" ));//年報年份
        String bankType =Utility.getTrimString(request.getParameter("bankType" ));//金融機構類別
        String tbank = Utility.getTrimString(request.getParameter("tbank" ));//機構名稱
        String COME_DATE = Utility.getTrimString(request.getParameter("COME_DATE" ));//來文日期
        String come_docno =Utility.getTrimString(request.getParameter("come_docno" ));//來文文號
        String SN_DATE = Utility.getTrimString(request.getParameter("SN_DATE" ));//發文日期
        String sn_docno = Utility.getTrimString(request.getParameter("sn_docno" ));//發文文號
        String content = Utility.getTrimString(request.getParameter("content" ));//處理情形
		//List updateDBSqlList = new LinkedList();
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {
            // 檢查是否存在
            StringBuffer sqlCmd = new StringBuffer() ;
            sqlCmd.append( "select count(*) as count from MIS_RPTYEAR where bank_no = ? AND RptYear = ?");
            paramList.add(tbank) ;
            paramList.add(RptYear) ;
            
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");
		    System.out.println("MIS_RPTYEAR.size="+data.size());
			if(data.size() < 1) {
     	        errMsg = errMsg + "此筆資料不存在無法修改<br>";
                return errMsg;
            }
            
            
            /*寫入log檔中*/
            sqlCmd.setLength(0) ;
            paramList.clear() ;
			sqlCmd.append( "INSERT INTO MIS_RPTYEAR_LOG "
		     	   +"select rptyear,bank_type,bank_no,come_date,come_docno,sn_date,sn_docno,content,"
		     	   +"user_id,user_name,update_date,?,?,sysdate,'U' from MIS_RPTYEAR where bank_no = ? AND RptYear = ?");      
		    paramList.add(loginID) ;
		    paramList.add(loginName) ;
		    paramList.add(tbank) ;
		    paramList.add(RptYear) ;
		    
		    //updateDBSqlList.add(sqlCmd);  
            updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
		    //update MIS_RPTYEAR
		    sqlCmd.setLength(0) ;
		    paramList = new ArrayList () ;
		    updateDBSqlList = new ArrayList() ;
		    updateDBDataList = new ArrayList<List> () ;
            sqlCmd.append( " UPDATE MIS_RPTYEAR SET "
                   +" come_date = to_date(?,'YYYY/MM/DD'),"
                   +" come_docno =?, "                     
                   +" sn_date = to_date(?,'YYYY/MM/DD'),"   
                   +" sn_docno = ?, "                                                     
                   +" content = ?, "                     
                   +" user_id = ?, user_name = ?, update_date = sysdate " 
                   +" where bank_no = ? AND RptYear = ?"); 
            //updateDBSqlList.add(sqlCmd);
			paramList.add(COME_DATE) ;
			paramList.add(come_docno) ;
			paramList.add(SN_DATE) ;
			paramList.add(sn_docno) ;
			paramList.add(content) ;
			paramList.add(loginID) ;
			paramList.add(loginName) ;
			paramList.add(tbank) ;
			paramList.add(RptYear) ;
			
			updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
		    
            if(DBManager.updateDB_ps(updateDBList)){
				errMsg = errMsg + "相關資料寫入資料庫成功";
			}else{
				errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
			}
        } catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				return "相關資料寫入資料庫失敗 <br>[Exception Error]<br> ";
		}
		return errMsg;
	}

	// 刪除資料
	private String deleteDataToDB(HttpServletRequest request, String loginID, String loginName) {
	    String actMsg = "";
        String errMsg = "";
        String RptYear = Utility.getTrimString(request.getParameter("RptYear" ));//年報年份
 		String tbank = Utility.getTrimString(request.getParameter("tbank" ));//機構名稱        
        
	    try {
	    	List paramList = new ArrayList() ;
	        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
	        List updateDBSqlList = new ArrayList();
	        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	        StringBuffer sqlCmd = new StringBuffer() ;
            List DBSqlList = new LinkedList();

             // 檢查是否存在
            sqlCmd.append("select count(*) as count from MIS_RPTYEAR where bank_no = ? AND RptYear = ?");
            paramList.add(tbank) ;
            paramList.add(RptYear) ;
            
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");
		    System.out.println("MIS_RPTYEAR.size="+data.size());
			if(data.size() < 1) {
     	        errMsg = errMsg + "此筆資料不存在無法刪除<br>";
                return errMsg;
            }
			sqlCmd.setLength(0) ;
			paramList.clear() ;
             /*寫入log檔中*/
			sqlCmd.append( "INSERT INTO MIS_RPTYEAR_LOG "
		     	   +"select rptyear,bank_type,bank_no,come_date,come_docno,sn_date,sn_docno,content,"
		     	   +"user_id,user_name,update_date,?,?,sysdate,'D' from MIS_RPTYEAR where bank_no = ? AND RptYear = ? ");
             paramList.add(loginID) ;
             paramList.add(loginName) ;
             paramList.add(tbank) ;
             paramList.add(RptYear) ;
            //DBSqlList.add(sqlCmd);
			updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
		    //delete db 
		    sqlCmd.setLength(0) ;
		    paramList  = new ArrayList() ;
		    updateDBSqlList = new ArrayList() ;
		    updateDBDataList = new ArrayList<List> () ;
		    
            sqlCmd.append( " DELETE FROM MIS_RPTYEAR where bank_no = ? AND RptYear = ? "); 
            paramList.add(tbank) ;
            paramList.add(RptYear) ;
            
            updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;

            if(DBManager.updateDB_ps(updateDBList)){
			   errMsg = errMsg + "相關資料刪除成功";
		    }else{
			   errMsg = errMsg + "相關資料刪除失敗<br>[DBManager.getErrMsg()]<br>" + DBManager.getErrMsg();
			}

        } catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				return "相關資料刪除失敗<br>[Exception Error]<br>";
		}
		return errMsg;


	}
%>
