<%
/* 94.1.18 createed
   99.05.31 fix 套用Header.include & sql injection by 2808
   檢查行政系統 - 檢查行程計劃 主控制頁面
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
	
	
    
    Enumeration parName = request.getParameterNames();
	System.out.println("\n\n======= START SAVE REQUEST PARAMETER TO ATTRIBUTE =======");
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
	
    
	System.out.println("Page: TC12.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );
	
	String u_year = "99" ;
	String begY = Utility.getTrimString(dataMap.get("begY")) ;

	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
            rd = application.getRequestDispatcher( LoginErrorPgName ); 
	        
	} else {
    	if(act.equals("List") || act.equals("Qry") || act.equals("Edit") ||  act.equals("New")) {
    	    request.setAttribute("Bank_Type", getCDShareNOWith(BANK_TYPE));
            request.setAttribute("TBank", getTatolBankType());
            request.setAttribute("Bank_No",getBankNo());
    	    request.setAttribute("Ch_Type",getCDShareNOWith(CH_TYPE));
    	    request.setAttribute("Exam_Div", getCDShareNOWith(EXAM_DIV));
    	    request.setAttribute("City", Utility.getCity());
    	    if(act.equals("List")) {
    	        rd = application.getRequestDispatcher( ListPgName +"?act=List"); 
    	    } else if(act.equals("Edit") || act.equals("New")) {
    	        String disp_id = request.getParameter("disp_id" )== null  ? "" : (String)request.getParameter("disp_id");
    	        List exTripList = getExTrip(disp_id,begY);
    	        if(exTripList.size() > 0) {
    	            request.setAttribute("ExTrip", exTripList);
    	            request.setAttribute("Inspector", getInspector(disp_id));
    	            
    	            if(act.equals("New")) {
    	                if(isExist(disp_id)) {
    	                    actMsg = "派差通知單編號"+disp_id+"已經建檔";
    	                    rd = application.getRequestDispatcher(nextPgName);
    	                } else {
    	                    rd = application.getRequestDispatcher( EditPgName +"?act=New");
    	                }
    	            }else{
    	                request.setAttribute("Exist", isExistReportF(disp_id));
    	                request.setAttribute("ExDate", getExDate(disp_id));
    	                rd = application.getRequestDispatcher( EditPgName +"?act=Edit");
    	            }
    	        } else {
    	            actMsg = "查不到派差通知單編號為"+disp_id+"的資料, 請查明鍵入編號是否錯誤或是不存在";
    	            request.setAttribute("actMsg", actMsg);
    	            rd = application.getRequestDispatcher(nextPgName);
    	        }
    	    } else if(act.equals("Qry")) {
    	        List result = getQueryResult(request);
    	        request.setAttribute("QueryResult",result);
    	        rd = application.getRequestDispatcher( ListPgName +"?act=Qry");
    	    }
        } else if(act.equals("Insert")){
            String disp_id = request.getParameter("disp_id" )== null  ? "" : (String)request.getParameter("disp_id");
    	    actMsg = insertDataToDB(request,userId,userName);
    	    if(actMsg.equals("")) {
    	        actMsg = "相關資料已寫入資料庫";
    	        request.setAttribute("prePageURL","TC12.jsp?act=Edit&disp_id="+disp_id);
    	    }
        	rd = application.getRequestDispatcher( nextPgName );         
        } else if(act.equals("Update")){
            String disp_id = request.getParameter("disp_id" )== null  ? "" : (String)request.getParameter("disp_id");
            actMsg = insertDataToDB(request,userId,userName); 
            if(actMsg.equals("")) {
    	        actMsg = "相關資料已寫入資料庫";
    	        request.setAttribute("prePageURL","TC12.jsp?act=Edit&disp_id="+disp_id);
    	    }
        	rd = application.getRequestDispatcher( nextPgName );         
        } else if(act.equals("Delete")){
            String disp_id = request.getParameter("disp_id" )== null  ? "" : (String)request.getParameter("disp_id");
    	    actMsg = deleteDataToDB(request,userId,userName);
    	    if(actMsg.equals("")) {
              actMsg = "相關資料已刪除";
              request.setAttribute("prePageURL","TC12.jsp?act=List");
            }
        	rd = application.getRequestDispatcher( nextPgName );                 
        }
        request.setAttribute("queryURL","TC12.jsp?act=List");
    	request.setAttribute("actMsg",actMsg);
      }   
%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "TC12" ;
private final static String nextPgName = "/pages/message.jsp";    
private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";    
private final static String ListPgName = "/pages/"+report_no+"_List.jsp";        
private final static String LoginErrorPgName = "/pages/LoginError.jsp";

private final static String BANK_TYPE = "020"; //金融機構代碼
private final static String EXAM_DIV = "022";  //檢查評等
private final static String CH_TYPE = "023"; //檢查性質
private final static String ORIGINUNT_ID = "024";   //檢查報告單位
     
              
     //取得CDShareNO, 欄位cmuse_div為id的所有內容
    private List getCDShareNOWith(String id){
    		//查詢條件    
    		String sqlCmd = " select cmuse_id, cmuse_name from cdshareno where cmuse_div = ? order by cmuse_id"; 
    		List paramList = new ArrayList () ;
    		paramList.add(id) ;
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");            
            return dbData;
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
		String sqlCmd = " Select BANK_NO , BANK_NAME , TBANK_NO  from  BN02 WHERE bank_type in ( select cmuse_id from cdshareno where cmuse_div = ? )  order by BANK_NO ";
		List paramList = new ArrayList() ;
		paramList.add("020") ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");            
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
            String examine = Utility.getTrimString(request.getParameter("examine" ));
            String property = Utility.getTrimString(request.getParameter("property" ));
    		String exam_div = Utility.getTrimString(request.getParameter("exam_div" ));
    		String cityType = Utility.getTrimString(request.getParameter("cityType" ));		
    		
            request.setAttribute("cityType",cityType);
    		request.setAttribute("disp_id",disp_id);
    		request.setAttribute("exam_id",exam_id);
    		request.setAttribute("begDate",begDate);
    		request.setAttribute("endDate",endDate);
    		request.setAttribute("bankType",bankType);
    		request.setAttribute("examine",examine);
    		request.setAttribute("property",property);
			String u_year = "99" ;
			if(!"".equals(begDate) && Integer.parseInt(begDate.substring(0,4))>99) {
				u_year = "100" ;
			}
    		//查詢條件    
    		StringBuffer sqlCmd = new StringBuffer() ;
    		List paramList = new ArrayList () ;
    		sqlCmd.append("select a.disp_id, a.exam_id, ((TO_CHAR(b.base_date,'yyyy')-1911)||'/'|| TO_CHAR(b.base_date,'mm/dd')) as base_date, c.bank_no, a.ch_type ");
    		sqlCmd.append(" from ExDisTripF a, ExScheduleF b, (select * from ba01 where m_year=?) c, CDshareNO d ");
    		sqlCmd.append(" where a.disp_id=b.disp_id(+) and a.bank_no = c.bank_no and ( a.ch_type=d.cmuse_id and d.cmuse_div = ? ) and TO_CHAR(b.base_date,'yyyymmdd') between ? and ? ");
    		paramList.add(u_year) ;
    		paramList.add("023") ;
    		paramList.add(begDate) ;
    		paramList.add(endDate);
    		if(!disp_id.equals("")) {
    		    sqlCmd.append( " and a.disp_id = ? ");
    			paramList.add(disp_id) ;
    		}
    		if(!exam_id.equals("")) {
    		    sqlCmd.append( " and a.exam_id = ? ");
    		    paramList.add(exam_id) ;
    		}
    		if(!bankType.equals("") && !bankType.equals("0")) {
    			sqlCmd.append( " and a.bank_type = ? ");
    			paramList.add(bankType) ;
    		}
    		if(!tbank_no.equals("")) {
    		    sqlCmd.append( " and a.tbank_no = ? ");
    		    paramList.add(tbank_no) ;
    		}
    		if(!examine.equals("")) {
    		    sqlCmd.append( " and a.bank_no =? ");
    		    paramList.add(examine) ;
    		} 
    		if(!property.equals("")) {
    		   sqlCmd.append( " and a.ch_type = ? ");
    		   paramList.add(property) ;
    		}
    		
    		if(!exam_div.equals("")) {
    		   sqlCmd.append( " and a.exam_div = ? ");
    		   paramList.add(exam_div) ;
    		}
    		
    		if(!cityType.equals("")) {
    		   sqlCmd.append( " and TBANK_NO in (select BANK_NO  from WLX01  where HSIEN_ID =  ? and m_year=? ) ");
    		   paramList.add(cityType) ;
    		   paramList.add(u_year) ;
    		}
    		sqlCmd.append( " order by disp_id");
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");            
            return dbData;
    }
    
    // 取得派差資料
    private List getExTrip(String disp_id,String begY) {
    	
    	String u_year = "99" ;
    	if(!"".equals(begY) && Integer.parseInt(begY) > 99) {
    		u_year = "100" ;
    	}
        //查詢條件
        StringBuffer sqlCmd = new StringBuffer() ;
        List paramList = new ArrayList() ;
        sqlCmd.append(" select a.disp_id, a.exam_id, a.exam_div, a.bank_no, b.bank_name "+
    		    "from exdistripf a, (select * from ba01 where m_year =? ) b "+
    		    "where  b.bank_type in ( select cmuse_id from cdshareno where cmuse_div = ?)"+
    		    " and a.bank_no = b.bank_no and disp_id = ?");
        paramList.add(u_year) ;
        paramList.add("020");
        paramList.add(disp_id) ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");            
        return dbData;
    }
    
    // 檢查報告資料是否存在
    private  boolean isExist(String disp_id) {
        //查詢條件
        StringBuffer sqlCmd = new StringBuffer () ;
        List paramList = new ArrayList() ;
        sqlCmd.append(" select disp_id from ExScheduleF where disp_id = ? ");
        paramList.add(disp_id) ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
        if(dbData != null && dbData.size() > 0) {
          return true;
        } else {
          return false;
        }
    }
    
    private  String isExistReportF(String disp_id) {
        //查詢條件
        StringBuffer sqlCmd = new StringBuffer() ;
        List paramList = new ArrayList() ;
        sqlCmd.append( " select disp_id from ExReportF where disp_id = ? ");
        paramList.add(disp_id) ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
        if(dbData != null && dbData.size() > 0) {
          return "T";
        } else {
          return "F";
        }
    }

    // 取得檢查人員
    private List getInspector(String disp_id){
    		//查詢條件 
    		StringBuffer sqlCmd = new StringBuffer() ;
    		List paramList = new ArrayList() ;
    		sqlCmd.append( " select a.disp_id, b.muser_name, c.expertNo_name "+
    		  " from exhelpitemf a, wtt01 b, expertNoF c "+ 
    		  " where a.muser_id = b.muser_id "+
    		  " and a.exam_item = c.expertNo_id "+
    		  " and a.disp_id = ? ");
    		paramList.add(disp_id) ;
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
            return dbData;
    }
    
    // 查詢單筆資料
    private List getExDate(String disp_id) {
        //查詢條件    
        StringBuffer sqlCmd = new StringBuffer() ;
        List paramList = new ArrayList() ;
        sqlCmd.append( " select disp_id, "+
    		   " to_char(base_date,'yyyy') as base_dateY, to_char(base_date,'mm') as base_dateM, to_char(base_date,'dd') as base_dateD, "+
    		   " to_char(go_date,'yyyy') as go_dateY, to_char(go_date,'mm') as go_dateM, to_char(go_date,'dd') as go_dateD, "+
    		   " to_char(bk_date,'yyyy') as bk_dateY, to_char(bk_date,'mm') as bk_dateM, to_char(bk_date,'dd') as bk_dateD, "+
    		   " to_char(ware_date,'yyyy') as ware_dateY, to_char(ware_date,'mm') as ware_dateM,to_char(ware_date,'dd') as ware_dateD, "+
    		   " to_char(st_date,'yyyy') as st_dateY, to_char(st_date,'mm') as st_dateM, to_char(st_date,'dd') as st_dateD, "+
    		   " to_char(en_date,'yyyy') as en_dateY, to_char(en_date,'mm') as en_dateM, to_char(en_date,'dd') as en_dateD, "+
    		   " to_char(report_date,'yyyy') as report_dateY, to_char(report_date,'mm') as report_dateM, to_char(report_date,'dd') as report_dateD, "+
      		   " go_ampm,bk_ampm,st_ampm,en_ampm,to_char(workdays,'999') as workdays ,to_char(workmdays,'999') as workmdays "+
    		   " from ExScheduleF where disp_id = ? ");  
        paramList.add(disp_id) ;
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");            
            return dbData;
    }
    
    // 新增修改資料到資料庫
    private String insertDataToDB(HttpServletRequest request, String loginID, String loginName) {
        String actMsg = "";
        String errMsg = "";
        String disp_id = Utility.getTrimString(request.getParameter("disp_id" ));
        String base_date = Utility.getTrimString(request.getParameter("base_date" ));
        String go_date = Utility.getTrimString(request.getParameter("go_date" ));
        String ware_date = Utility.getTrimString(request.getParameter("ware_date" ));
        String st_date = Utility.getTrimString(request.getParameter("st_date" ));
        String en_date = Utility.getTrimString(request.getParameter("en_date" ));
        String bk_date = Utility.getTrimString(request.getParameter("bk_date" ));
        String go_dateAP =Utility.getTrimString(request.getParameter("go_dateAP" ));
        String st_dateAP = Utility.getTrimString(request.getParameter("st_dateAP" ));
        String en_dateAP = Utility.getTrimString(request.getParameter("en_dateAP" ));
        String bk_dateAP = Utility.getTrimString(request.getParameter("bk_dateAP" ));
        String report_date = Utility.getTrimString(request.getParameter("report_date" ));
        String workday =Utility.getTrimString(request.getParameter("workday" ));
        String workmdays = Utility.getTrimString(request.getParameter("workmdays" ));
        
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
        try {
            // 檢查是否有這一筆資料, 如果沒有就新增, 如果有就先刪除再新增
            StringBuffer sqlCmd = new StringBuffer() ;
            sqlCmd.append("select disp_id from ExScheduleF where disp_id = ? " );
            paramList.add(disp_id) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
		    System.out.println("ExScheduleF Size="+data.size());
			if(data.size() > 0) {
				sqlCmd.setLength(0) ;
				paramList.clear() ;
				sqlCmd.append("delete from ExScheduleF WHERE DISP_ID = ? ");
                paramList.add(disp_id) ;
                //insertDBSqlList.add(sqlCmd);
                updateDBSqlList.add(sqlCmd.toString()) ;
        		updateDBDataList.add(paramList) ;
        		updateDBSqlList.add(updateDBDataList) ;
        		updateDBList.add(updateDBSqlList) ;
        		
            }
			sqlCmd.setLength(0) ;
    		paramList = new ArrayList() ;
    		updateDBSqlList = new ArrayList () ;
    		updateDBDataList = new ArrayList<List> () ;
    		
    		
    		sqlCmd.append( "insert into ExScheduleF(disp_id,base_date,go_date,go_ampm,bk_date,bk_ampm,ware_date,st_date,st_ampm,en_date,en_ampm,report_date,workdays,workmdays,user_id, user_name, update_date) " +
            " values(?, "
            +" TO_DATE(?,'YYYY/MM/DD'), "
            +" TO_DATE(?,'YYYY/MM/DD'), "
            +" ?, "
            +" TO_DATE(?,'YYYY/MM/DD'), "
            +" ?, "
            +" TO_DATE(?,'YYYY/MM/DD'), "
            +" TO_DATE(?,'YYYY/MM/DD'), "
            +" ?, "
            +" TO_DATE(?,'YYYY/MM/DD'), "
            +" ?, "
            +" TO_DATE(?,'YYYY/MM/DD'), "
            +" ?, ?, ?, ?, sysdate) ");
			
    		paramList.add(disp_id) ;
    		paramList.add(base_date) ;
    		paramList.add(go_date) ;
    		paramList.add(go_dateAP) ;
    		paramList.add(bk_date) ;
    		paramList.add(bk_dateAP) ;
    		paramList.add(ware_date) ;
    		paramList.add(st_date) ;
    		paramList.add(st_dateAP) ;
    		paramList.add(en_date) ;
    		paramList.add(en_dateAP) ;
    		paramList.add(report_date) ;
    		paramList.add(workday) ;
    		paramList.add(workmdays) ;
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
	
	// 刪除資料
	private String deleteDataToDB(HttpServletRequest request, String loginID, String loginName) {
	    String actMsg = "";
        String errMsg = "";
        
        String disp_id = Utility.getTrimString(request.getParameter("disp_id" ));
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {
	    
	        // 檢查檢查報告是否有這一筆資料, 如果有則不可刪除
	        StringBuffer sqlCmd = new StringBuffer() ;
            sqlCmd.append("select disp_id from ExReportF where disp_id =? ");
            paramList.add(disp_id) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
		    System.out.println("ExReportF Size="+data.size());
			if(data.size() > 0) {
                return "派差通知單編號"+disp_id+"已存在檢查報告中, 不可刪除";
            }
	        
            //List DBSqlList = new LinkedList();
            sqlCmd.setLength(0) ;
            paramList.clear() ;
            sqlCmd.append("delete from ExScheduleF WHERE DISP_ID = ? ");
            paramList.add(disp_id) ;
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



