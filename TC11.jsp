<%
/* 94.1.12 createed
   99.05.28 fix 套用Header.include & sql injection by 2808
   檢查行政系統-檢查派差 主控制頁面
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
	System.out.println("Page: TC11.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );
	
	
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
    	        rd = application.getRequestDispatcher( ListPgName +"?act="+act); 
    	    } else if(act.equals("Edit") || act.equals("New")) {
    	        request.setAttribute("InspectorData", getAllInspector());
    	        request.setAttribute("ExpertData", getAllExpert());
    	        request.setAttribute("BasisList", getExbasisNOFData());
    	        if(act.equals("New")) {
    	            request.setAttribute("disp_id", getDispId());
    	            rd = application.getRequestDispatcher( EditPgName +"?act=New");
    	        }else{
    	            String disp_id = request.getParameter("disp_id" )== null  ? "" : (String)request.getParameter("disp_id");
    	            request.setAttribute("DetailData", getQueryDetail(request, disp_id));
    	            request.setAttribute("ExpertDetailData", getExpertDetail(request, disp_id));
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit");
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
    	      request.setAttribute("prePageURL","TC11.jsp?act=Edit&disp_id="+disp_id);
    	    }
        	rd = application.getRequestDispatcher( nextPgName );         
        } else if(act.equals("Update")){
            String disp_id = request.getParameter("disp_id" )== null  ? "" : (String)request.getParameter("disp_id");
            actMsg = insertDataToDB(request,userId,userName); 
            if(actMsg.equals("")) {
    	      actMsg = "相關資料已寫入資料庫";
    	      request.setAttribute("prePageURL","TC11.jsp?act=Edit&disp_id="+disp_id);
    	    }
        	rd = application.getRequestDispatcher( nextPgName );
        } else if(act.equals("Delete")){
            actMsg = deleteDataToDB(request,userId,userName);
            if(actMsg.equals("")) {
              actMsg = "相關資料已刪除";
              request.setAttribute("prePageURL","TC11.jsp?act=List");
            }
        	rd = application.getRequestDispatcher( nextPgName );                 
        }
        request.setAttribute("queryURL","TC11.jsp?act=List");
    	request.setAttribute("actMsg",actMsg);
      }   
%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "TC11" ;
private final static String nextPgName = "/pages/message.jsp";    
private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";    
private final static String ListPgName = "/pages/"+report_no+"_List.jsp";        
private final static String LoginErrorPgName = "/pages/LoginError.jsp";

private final static String BANK_TYPE = "020"; //金融機構代碼
private final static String EXAM_DIV = "022";  //檢查評等
private final static String CH_TYPE = "023"; //檢查性質
private final static String ORIGINUNT_ID = "024";   //檢查報告單位


    
    
    //取得ExbasisNOF 檢查依據
    private List getExbasisNOFData(){
    		//查詢條件    
    		String sqlCmd = " select basis_id, basis_name from ExbasisNOF ";  
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"");            
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

    		//查詢條件    
    		StringBuffer sqlCmd = new StringBuffer() ;
    		List paramList = new ArrayList() ;
    		sqlCmd.append("select disp_id, exam_id, ((TO_CHAR(appr_date,'yyyy')-1911)||'/'|| TO_CHAR(appr_date,'mm/dd'))as appr_date, bank_no, ch_type from ExDisTripF"+
    		    " where TO_CHAR(appr_date,'yyyymmdd') between ?  and ? " );
    		paramList.add(begDate) ;
    		paramList.add(endDate) ;
    		if(!disp_id.equals("")) {
    		    sqlCmd.append( " and disp_id = ? ");
    			paramList.add(disp_id) ;
    		}
    		if(!exam_id.equals("")) {
    		    sqlCmd.append( " and exam_id = ? " );
    		    paramList.add(exam_id) ;
    		}
    		if(!bankType.equals("") && !bankType.equals("0")) {
    		    sqlCmd.append( " and bank_type = ? " );
    		    paramList.add(exam_id) ;
    		}
    		if(!tbank_no.equals("") ) {
    		    sqlCmd.append( " and tbank_no = ? ");
    		    paramList.add(tbank_no) ;
    		}
    		if(!examine.equals("")) {
    		    sqlCmd.append( " and bank_no =? ");
    		    paramList.add(tbank_no) ;
    		}
    		if(!property.equals("")) {
    		   sqlCmd.append( " and ch_type =? ");
    		   paramList.add(tbank_no) ;
    		}
    		if(!exam_div.equals("")) {
    		   sqlCmd.append( " and exam_div = ? ");
    		   paramList.add(exam_div) ;
    		}
    		if(!cityType.equals("")) {
    		   sqlCmd.append( " and TBANK_NO in (select BANK_NO  from WLX01  where HSIEN_ID = ? ) ");
    		   paramList.add(cityType) ;
    		}
    		sqlCmd.append( " order by disp_id" );
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");            
            return dbData;
    }
    
    //取得所有檢查人員
    private List getAllInspector(){
    		//查詢條件    
    		String sqlCmd = " select distinct b.muser_id, b.muser_name from expersonf a, wtt01 b where a.muser_id = b.muser_id and b.muser_i_o ='I' and b.delete_mark <> 'Y' order by muser_id ";  
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"");            
            return dbData;
    }
    
    //取得所有檢查人員專長
    private List getAllExpert(){
    		//查詢條件    
    		String sqlCmd = " select distinct a.muser_id as muser_id, b.expertNo_id as expertNo_id, b.expertNo_Name  as expertNo_Name from expersonf a, expertNoF b where  a.expertNo_id = b.expertNo_id order by muser_id ";  
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"");            
            return dbData;
    }
    
    // 自動產生派差通知單編號
    private String getDispId(){
    		//查詢條件    
    		String no = "";
    		String sqlCmd = " select to_char((to_char(sysdate,'yyyy')-1911 || nvl(max(substr(disp_id,4,4)),'0000')+1),'0000000') as max_cnt from ExDisTripF  ";  
            
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"");
            if(dbData != null && dbData.size()>0) {
                DataObject bean =(DataObject)dbData.get(0);
                no = ((String)bean.getValue("max_cnt")).trim();
                System.out.println("System create serial number is "+no);
            }else{
                System.out.println(" Error !!!  Can't create serial number !!!");
            }
            return no;
    }
    
    // 查詢單筆詳細資料
    private DataObject getQueryDetail(HttpServletRequest request, String disp_id){
        	List paramList = new ArrayList();
    		//查詢條件    
    		String sqlCmd = "select hsien_id, disp_id, exam_id, exam_Div, to_char(appr_date,'yyyymmdd') as appr_date, ch_type, basis, prj_item, prj_remark, ExDisTripF.bank_type, ExDisTripF.bank_no, ExDisTripF.tbank_no "+
    		    " from ExDisTripF, WLX01 where ExDisTripF.TBANK_NO = WLX01.BANK_NO(+)  and disp_id = ? ";
    		paramList.add(disp_id);
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");
            if(dbData == null && dbData.size() == 0) {
               System.out.println(" Error !!!  Can't find detail data !!!");
               return null; 
            }
            return (DataObject)dbData.get(0);
    }
    
    // 查詢單筆檢查人員詳細資料
    private List getExpertDetail(HttpServletRequest request, String disp_id){
        	List paramList = new ArrayList();
    		//查詢條件    
    		String sqlCmd = "select disp_id, muser_id, exam_item from exhelpitemf where disp_id =? ";
    		paramList.add(disp_id);
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");
            return dbData;
    }
    
    // 新增資料到資料庫
    private String insertDataToDB(HttpServletRequest request, String loginID, String loginName) {
        String actMsg = "";
        String errMsg = "";
        String disp_id = request.getParameter("disp_id" )== null  ? "" : (String)request.getParameter("disp_id").trim();
        String exam_id = request.getParameter("exam_id" )== null  ? "" : (String)request.getParameter("exam_id").trim();
        String exam_div = request.getParameter("exam_div" )== null  ? "" : (String)request.getParameter("exam_div").trim();
        String appr_date = request.getParameter("appr_date" )== null  ? "" : (String)request.getParameter("appr_date").trim();
        String bank_type = request.getParameter("bankType" )== null    ? "" : (String)request.getParameter("bankType").trim();
        String tbank_no = request.getParameter("tbank" )== null    ? "" : (String)request.getParameter("tbank");
        String bank_no = request.getParameter("examine" )== null  ? "" : (String)request.getParameter("examine").trim();
        String ch_type = request.getParameter("property" )== null  ? "" : (String)request.getParameter("property").trim();
        String basis = request.getParameter("basis" )== null  ? "" : (String)request.getParameter("basis").trim();
        String prj_item = request.getParameter("prj_item" )== null  ? "" : (String)request.getParameter("prj_item").trim();
        String prj_remark = request.getParameter("prj_remark" )== null  ? "" : (String)request.getParameter("prj_remark").trim();
    	String[] muser_id = request.getParameterValues("inspector_id");
    	String[] user_id =  request.getParameterValues("expert_id");     
    	
    	List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
        try {
            // 檢查檢查報告是否有這一筆資料, 如果有則不可刪除
            StringBuffer sqlCmd = new StringBuffer() ;
            sqlCmd.append("select disp_id from ExReportF where disp_id = ? ");
            paramList.add(disp_id) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
		    System.out.println("ExScheduleF Size="+data.size());
			if(data.size() > 0) {
                return "派差通知編號"+disp_id+", 已存在檢查報告中, 無法修改";
            }
            sqlCmd.setLength(0) ;
            paramList.clear() ;
            // 檢查是否有這一筆資料, 如果沒有就新增, 如果有就先刪除再新增
            sqlCmd.append("select disp_id from ExDisTripF where disp_id = ? ");
            paramList.add(disp_id) ;
            data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
		    System.out.println("ExDisTripF Size="+data.size());
			if(data.size() > 0) {
				sqlCmd.setLength(0) ;
				paramList.clear() ;
                sqlCmd.append( "delete from ExDisTripF WHERE DISP_ID = ? ");
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
            sqlCmd.append("insert into ExDisTripF(disp_id,exam_id,exam_div,appr_date,ch_type,basis,prj_item,prj_remark,bank_type,bank_no,tbank_no,user_id,user_name,update_date) ");
            sqlCmd.append(" values(?,?,?,TO_DATE(?,'YYYY/MM/DD'),?,?,?,?,?,?, ?,?,?, sysdate) ");
            paramList.add(disp_id) ;
            paramList.add(exam_id) ;
            paramList.add(exam_div) ;
            paramList.add(appr_date) ;
            paramList.add(ch_type) ;
            paramList.add(basis) ;
            paramList.add(prj_item) ;
            paramList.add(prj_remark) ;
            paramList.add(bank_type) ;
            paramList.add(bank_no) ;
            paramList.add(tbank_no) ;
            paramList.add(loginID) ;
            paramList.add(loginName) ;
            //insertDBSqlList.add(sqlCmd);
            updateDBSqlList.add(sqlCmd.toString()) ;
    		updateDBDataList.add(paramList) ;
    		updateDBSqlList.add(updateDBDataList) ;
    		updateDBList.add(updateDBSqlList) ;
    		
            if(muser_id != null) {
                // 檢查是否有這一筆資料, 如果沒有就新增, 如果有就先刪除再新增
                sqlCmd.setLength(0) ;
                paramList = new ArrayList() ;
                sqlCmd.append( "SELECT disp_id FROM exhelpitemf WHERE DISP_ID = ? ");
                paramList.add(disp_id) ;
			    data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
				System.out.println("exhelpitemf.size="+data.size());
				if(data.size() > 0) {
					sqlCmd.setLength(0) ;
		            paramList = new ArrayList() ;
		            updateDBSqlList = new ArrayList () ;
		            updateDBDataList = new ArrayList<List> () ;
                    sqlCmd.append( "delete from exhelpitemf WHERE DISP_ID = ? ");
                    paramList.add(disp_id) ;
                    //insertDBSqlList.add(sqlCmd);
                    updateDBSqlList.add(sqlCmd.toString()) ;
            		updateDBDataList.add(paramList) ;
            		updateDBSqlList.add(updateDBDataList) ;
            		updateDBList.add(updateDBSqlList) ;
                }
                for(int i=0; i<muser_id.length; i++) {
                    StringTokenizer st = new StringTokenizer(user_id[i].trim(), ";");
                    while(st.hasMoreTokens()) {
                    	sqlCmd.setLength(0) ;
    		            paramList = new ArrayList() ;
    		            updateDBSqlList = new ArrayList () ;
    		            updateDBDataList = new ArrayList<List> () ;
                        sqlCmd.append( "insert into ExHelpItemF(disp_id, muser_id,exam_item,user_id,user_name,update_date) values " +
                        " (?,?,?,?,?,sysdate)");
                        //insertDBSqlList.add(sqlCmd);
                        paramList.add(disp_id) ;
                        paramList.add(muser_id[i].trim()) ;
                        paramList.add(st.nextToken()) ;
                        paramList.add(loginID) ;
                        paramList.add(loginName) ;
                        updateDBSqlList.add(sqlCmd.toString()) ;
                		updateDBDataList.add(paramList) ;
                		updateDBSqlList.add(updateDBDataList) ;
                		updateDBList.add(updateDBSqlList) ;
                     }
                }
             }else {
                System.out.println("No inspector Data");
             }
             
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
        
        String disp_id = request.getParameter("disp_id" )== null  ? "" : (String)request.getParameter("disp_id").trim();
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {
            //List DBSqlList = new LinkedList();
            
            // 檢查檢查報告是否有這一筆資料, 如果有則不可刪除
            StringBuffer sqlCmd = new StringBuffer() ;
            sqlCmd.append("select disp_id from ExReportF where disp_id = ? ");
            paramList.add(disp_id) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
		    System.out.println("ExScheduleF Size="+data.size());
			if(data.size() > 0) {
                return "派差通知編號"+disp_id+", 已存在檢查報告中, 無法刪除";
            }
			sqlCmd = new StringBuffer();
			paramList = new ArrayList() ;
            sqlCmd.append("delete from ExDisTripF WHERE DISP_ID = ? ");
            paramList.add(disp_id) ;
            updateDBSqlList.add(sqlCmd.toString()) ;
    		updateDBDataList.add(paramList) ;
    		updateDBSqlList.add(updateDBDataList) ;
    		updateDBList.add(updateDBSqlList) ;
            //DBSqlList.add(sqlCmd);
            
            // 檢查是否有這一筆資料,  如果有就刪除
            sqlCmd = new StringBuffer();
            paramList = new ArrayList() ;
    		updateDBSqlList = new ArrayList () ;
    		updateDBDataList = new ArrayList<List> () ;
            sqlCmd.append( "SELECT disp_id FROM exhelpitemf WHERE DISP_ID = ? ");	
            paramList.add(disp_id) ;
			data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");		 			    
			System.out.println("exhelpitemf.size="+data.size());
				if(data.size() > 0) {
					sqlCmd = new StringBuffer() ;
		    		paramList = new ArrayList() ;
		    		updateDBSqlList = new ArrayList () ;
		    		updateDBDataList = new ArrayList<List> () ;
                    sqlCmd.append( "delete from exhelpitemf WHERE DISP_ID = ? ");
                    paramList.add(disp_id) ;
                    updateDBSqlList.add(sqlCmd.toString()) ;
            		updateDBDataList.add(paramList) ;
            		updateDBSqlList.add(updateDBDataList) ;
            		updateDBList.add(updateDBSqlList) ;
                    //DBSqlList.add(sqlCmd);
                }
            
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