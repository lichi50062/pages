<%
// 97.08.29-09.01 create 違反農金法及其子法而遭罰款 by 2295
// 99.05.13 fix 縣市合併調整&sql injection by 2808
//101.05.07 add 處分方式 by 2295
//103.09.11 add 訴願欄位 by 2968
//103.09.18 add 調整上傳檔名格式yyyyMMddHHmmss by 2295
//104.03.09 fix 編緝時,無法顯示100年以後新增機構名稱 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.dao.DAOFactory" %>
<%@ page import="com.tradevan.util.dao.RdbCommonDao" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.tradevan.util.UpdateTimeOut" %>
<%@ page import="com.tradevan.util.ftp.MyFTPClient" %>
<%@include file="./include/Header.include" %>
<%
	
	String userId = session.getAttribute("muser_id") != null ? (String) session.getAttribute("muser_id") : "" ;
	String userName = session.getAttribute("muser_name") != null ? (String) session.getAttribute("muser_name") : "" ;
    String begY = Utility.getTrimString(dataMap.get("begY")) ;
    request.setAttribute("TBank", getTatolBankType());
    request.setAttribute("City", Utility.getCity()); //改用utility.getcity(); by 2808
    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
        rd = application.getRequestDispatcher( LoginErrorPgName );
    } else {
    	if(act.equals("List") || act.equals("Qry") || act.equals("Edit") ||  act.equals("New")) {
    	    if(act.equals("List")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName +"?act=List");
    	    } else if(act.equals("Edit") || act.equals("New")) { 
    	        if(act.equals("New")) {    	
    	        	rd = application.getRequestDispatcher( EditPgName +"?act=New");
    	        }else{
    	        	String bankType = Utility.getTrimString(request.getParameter("bankType"));
    	            String bank_no = Utility.getTrimString(request.getParameter("bank_no"));
    	            String violate_date = Utility.getTrimString(request.getParameter("violate_date"));
    	            String append_file = Utility.getTrimString(request.getParameter("append_file"));
    	            /*if(!"".equals(append_file)){
    	            	updateFileDataToDB(request,userId,userName,bank_no,violate_date);
    	            }*/
    	            request.setAttribute("DETAIL",getDetail(bank_no,violate_date,begY)); 
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit&bankType="+bankType);
    	        }
    	    } else if(act.equals("Qry")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName +"?act=Qry");  
    	    }     	    
        } else if(act.equals("Insert")){
    	    actMsg = insertDataToDB(request,userId,userName);
    	    request.setAttribute("actMsg",actMsg); 
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=MC001W.jsp&act=List");        	
        } else if(act.equals("Update")){
            actMsg = updateDataToDB(request,userId,userName);                   
            rd = application.getRequestDispatcher( nextPgName+"?goPages=MC001W.jsp&act=List");         	
        } else if(act.equals("Delete")){
    	    actMsg = deleteDataToDB(request,userId,userName);
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=MC001W.jsp&act=List");
        } else if(act.equals("Clear")){
        	/*String bank_no = Utility.getTrimString(request.getParameter("bank_no"));
            String violate_date = Utility.getTrimString(request.getParameter("violate_date"));
        	//
        	//String saveDirectory = Utility.getProperties("reportDir")+System.getProperty("file.separator")+append_file;
	  		//java.io.File myDelFile = new java.io.File(saveDirectory);
			//if(myDelFile.exists())myDelFile.delete();
			
            request.setAttribute("DETAIL",getDetail(bank_no,violate_date,begY));
            //request.setAttribute("TBank", getTatolBankType());
            //request.setAttribute("City", Utility.getCity());
            System.out.println("******************************************************** go Edit");
  			rd = application.getRequestDispatcher( EditPgName +"?act=Edit");  */
  			String bankType = Utility.getTrimString(request.getParameter("bankType"));
        	String bank_no = Utility.getTrimString(request.getParameter("bank_no"));
            String violate_date = Utility.getTrimString(request.getParameter("violate_date"));
            String append_file = Utility.getTrimString(request.getParameter("append_file"));
            if(!"".equals(append_file)){
            	updateFileDataToDB(request,userId,userName,bank_no,violate_date);
            }
            request.setAttribute("bankType",bankType); 
            request.setAttribute("DETAIL",getDetail(bank_no,violate_date,begY));    	           
            rd = application.getRequestDispatcher( EditPgName +"?act=Edit");
		}
    	request.setAttribute("actMsg",actMsg);
      }
%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "MC001W" ;
private final static String nextPgName = "/pages/ActMsg.jsp";
private final static String downloadPgName = "/pages/DownloadFile.jsp";
private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
private final static String LoginErrorPgName = "/pages/LoginError.jsp";

    //取得所有總機構資料
    private List getTatolBankType(){
    		//查詢條件
    		//String sqlCmd = " Select HSIEN_id, BN01.BANK_NO , BANK_NAME, BANK_TYPE  from  BN01, WLX01  WHERE BN01.BANK_NO = WLX01.BANK_NO(+) AND bank_type in ( select cmuse_id from cdshareno where cmuse_div = '020' ) order by BANK_NO ";
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
	//取得查詢資料
    private List getQueryResult(HttpServletRequest request){
        String bankType = Utility.getTrimString(request.getParameter("bankType" )) ;
        String cityType = Utility.getTrimString(request.getParameter("cityType" )) ;
        String tbank = Utility.getTrimString(request.getParameter("tbank" )) ;//受處份機構
        String begDate = Utility.getTrimString(request.getParameter("begDate" )) ;//受處分日期-起始
        String endDate = Utility.getTrimString(request.getParameter("endDate" )) ;//受處分日期-結束        
        String content = Utility.getTrimString(request.getParameter("content" )) ;//受處分說明
        
        String begY = Utility.getTrimString(request.getParameter("begY"));
        //System.out.println("begY="+begY);
        String u_year = "100" ;
        if("".equals(begY)||Integer.parseInt(begY)<=99) {
        	u_year = "99" ;
        }
        System.out.println("begDate="+begDate);
        System.out.println("endDate="+endDate);
    	request.setAttribute("content",content);
    	request.setAttribute("bankType",bankType);
    	request.setAttribute("cityType",cityType);        
    	request.setAttribute("begDate",begDate);
    	request.setAttribute("endDate",endDate);
		 
		  
		    
		  
		//String condition="";
    	//查詢條件    	
    	/*
    	String sqlCmd = " select bn01.bank_no,bn01.bank_name,"					  
					  + " ((TO_CHAR(violate_date,'yyyy')-1911)||'/'|| TO_CHAR(violate_date,'mm/dd')) as violate_date,"
					  + " TO_CHAR(violate_date,'yyyy/mm/dd') as violate_date_1,"
					  + " title,content,law_content "
					  + " from mis_violatelaw "
					  + " left join bn01 on mis_violatelaw.bank_no = bn01.bank_no ";
    				 
		*/
		StringBuffer condition = new StringBuffer() ;
		StringBuffer sql = new StringBuffer() ;
		List paramList = new ArrayList() ;
    	sql.append(" select bn01.bank_no,bn01.bank_name, ") ;
    	sql.append(" ((TO_CHAR(violate_date,'yyyy')-1911)||'/'|| TO_CHAR(violate_date,'mm/dd')) as violate_date, ");
    	sql.append(" TO_CHAR(violate_date,'yyyy/mm/dd') as violate_date_1,violate_type, ");
    	sql.append(" title,content,law_content ");
    	sql.append(" from mis_violatelaw ");
    	sql.append(" left join (select * from bn01 where m_year= ? )bn01  on mis_violatelaw.bank_no = bn01.bank_no ");
    	paramList.add(u_year) ;
        if(!bankType.equals("")) {
            condition.append(condition.length() > 0 ? " and":"").append(" mis_violatelaw.bank_type= ? ");
            paramList.add(bankType) ;
        }
    	if(!cityType.equals("")) {
    		condition.append(condition.length() > 0 ? " and":"").append(" mis_violatelaw.BANK_NO in (select BANK_NO  from (select * from wlx01 where m_year=? )WLX01  where HSIEN_ID =  ?  and m_year=? )  ");
    		paramList.add(u_year) ;
    		paramList.add(cityType) ;
    		paramList.add(u_year) ;
    	}
    	if(!tbank.equals("")) {
    	    condition.append(condition.length() > 0 ? " and":"").append(" mis_violatelaw.bank_no= ? ");	
    	    paramList.add(tbank) ;
    	}
    	if(!content.equals("")) {
    	    condition.append(condition.length() > 0 ? " and":"").append(" content like ? ");
    	    paramList.add("%"+content+"%");
    	}
    	if(!begDate.equals("") && !endDate.equals("")){
    	    condition.append(condition.length() > 0 ? " and":"").append(" TO_CHAR(violate_date, 'yyyymmdd') BETWEEN ? AND ? ") ;
    	    paramList.add(begDate) ;
    	    paramList.add(endDate) ;
    	}
    	
    	String violate_type = "" ;//處分方式
    	String violate_type_req = "";//查詢畫面用
    	//取出form裡的所有變數=================================== 
		  	Enumeration ep = request.getParameterNames();
		  	Enumeration ea = request.getAttributeNames();
		  	Hashtable t = new Hashtable();
		  	String name = "";
		  	String violate_type_condition = "";
		  	for ( ; ep.hasMoreElements() ; ) {
			   		name = (String)ep.nextElement();
			   		t.put( name, request.getParameter(name) );		
			   		System.out.println(name+"="+request.getParameter(name));	   
		  	}	
		  	
		  	for(int i=0;i<9;i++){	
        		if(t.get("violate_type_" + (i+1)) != null ) {	        		   
        		   //violate_type += (violate_type.length() > 0?",":"")+"'"+t.get("violate_type_" + (i+1))+"'";
        		   violate_type_condition += (violate_type_condition.length() > 0?" or ":"") + " violate_type like '%"+t.get("violate_type_" + (i+1))+"%'";
        		   violate_type_req += t.get("violate_type_" + (i+1))+":";//for查詢條件.頁面記錄原Qry條件
        		}
        }
        System.out.println("violate_type_condition="+violate_type_condition);
    	  if(violate_type_condition.indexOf("7") != -1){
    	     violate_type_condition = "";//選全部時，清成空白
    	     System.out.println("violate_type_condition="+violate_type_condition);
    	  }   
    	if(!violate_type_condition.equals("")) {
    	    condition.append(condition.length() > 0 ? " and":"").append(" ("+violate_type_condition+")");
    	}
    	 request.setAttribute("violate_type",violate_type_req);
    	
    	if(condition.length() > 0) {
    		//sqlCmd += "where "+condition;
    		sql.append(" where ").append(condition.toString()) ;
    	}
    	//sqlCmd += " ORDER BY violate_date";
    	sql.append(" ORDER BY violate_date ") ;
		
        //List dbData = DBManager.QueryDB(sqlCmd,"violate_date,violate_date_1");
        List dbData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"violate_date,violate_date_1") ;
        System.out.println("dbData= "+dbData.size());
        return dbData;
    }
    
    // 取得單筆資料
    private DataObject getDetail(String bank_no, String violate_date,String begY) {
    	
    	String u_year = "99" ;
    	if(Integer.parseInt(violate_date.substring(0,4)) > 2010) {
    		u_year = "100" ;
    	}
    	System.out.println("getDetail.u_year="+u_year);
        DataObject ob = null;
        StringBuffer sqlCmd = new StringBuffer() ;
        List sqlCmdList = new ArrayList () ;
        sqlCmd.append(" select bn01.bank_no,bn01.bank_name,violate_type,content,law_content,title,"					  
					  + " ((TO_CHAR(violate_date,'yyyy')-1911)||'/'|| TO_CHAR(violate_date,'mm/dd')) as violate_date,"
					  + " TO_CHAR(violate_date,'yyyy/mm/dd') as violate_date_1,TO_CHAR(TO_CHAR (violate_date, 'yyyy') - 1911) AS begy,"
					  + " TO_CHAR(violate_date, 'mm') AS begm,"
					  + " TO_CHAR(violate_date, 'dd') AS begd,"
					  + " nvl2(lawSuit_date,TO_CHAR(TO_CHAR(lawSuit_date, 'yyyy') - 1911),'') AS lawSuity,"
					  + " nvl2(lawSuit_date,TO_CHAR(lawSuit_date, 'mm'),'') AS lawSuitm,"
				      + " nvl2(lawSuit_date,TO_CHAR (lawSuit_date, 'dd'),'') AS lawSuitd,"
				      + " nvl2(gov_date,TO_CHAR(TO_CHAR(gov_date, 'yyyy') - 1911),'') AS govy,"
				      + " nvl2(gov_date,TO_CHAR(gov_date, 'mm'),'') AS govm,"
				      + " nvl2(gov_date,TO_CHAR (gov_date, 'dd'),'') AS govd,"
				      + " nvl2(reply_date,TO_CHAR(TO_CHAR(reply_date, 'yyyy') - 1911),'') AS replyy,"
				      + " nvl2(reply_date,TO_CHAR(reply_date, 'mm'),'') AS replym,"
				      + " nvl2(reply_date,TO_CHAR (reply_date, 'dd'),'') AS replyd,"
				      + " nvl2(lawSuit_Decdate,TO_CHAR(TO_CHAR(lawSuit_Decdate, 'yyyy') - 1911),'') AS lawsuit_decy,"
				      + " nvl2(lawSuit_Decdate,TO_CHAR(lawSuit_Decdate, 'mm'),'') AS lawsuit_decm,"
				      + " nvl2(lawSuit_Decdate,TO_CHAR (lawSuit_Decdate, 'dd'),'') AS lawsuit_decd,"
					  + " lawsuit_item,lawsuit_date,lawsuit_reason,reply_doc,lawsuit_result,issue "
					  + " from mis_violatelaw "
					  + " left join (select * from bn01 where m_year=? ) bn01 on mis_violatelaw.bank_no = bn01.bank_no "
					  + " where mis_violatelaw.bank_no= ? "
					  + " and TO_CHAR(violate_date, 'yyyy/mm/dd') = ? ");
        sqlCmdList.add(u_year) ;
        sqlCmdList.add(bank_no) ;
        sqlCmdList.add(violate_date) ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),sqlCmdList,
				        						"violate_date,violate_date_1");
        if(dbData !=null && dbData.size() > 0) {
            ob = (DataObject)dbData.get(0);
        }
        return ob;
    }
    
    private String insertDataToDB(HttpServletRequest request, String loginID, String loginName) {
        String actMsg = "";
        String errMsg = "";
        List insertDBSqlList = new LinkedList();
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
        
        String bankType =  Utility.getTrimString(request.getParameter("bankType"));//金融機構類別
        String tbank = Utility.getTrimString(request.getParameter("tbank"));//受處分機構
        String violate_Date = Utility.getTrimString(request.getParameter("violate_Date"));//受處分日期
      	String title = Utility.getTrimString(request.getParameter("title" ));//主旨
        String content = Utility.getTrimString(request.getParameter("content" ));//說明
        String law_content = Utility.getTrimString(request.getParameter("law_Content" ));//法令依據
        String lawSuit_Date = Utility.getTrimString(request.getParameter("lawSuit_Date"));//訴願日期
        String gov_Date = Utility.getTrimString(request.getParameter("gov_Date"));//移送訴願管轄機關日期
        String reply_Date = Utility.getTrimString(request.getParameter("reply_Date"));//檢卷答辯日期
        String lawSuit_DecDate = Utility.getTrimString(request.getParameter("lawSuit_DecDate"));//訴願決定日期
        String lawSuit_Item = Utility.getTrimString(request.getParameter("lawSuit_Item"));//訴願人
        String lawSuit_Reason = Utility.getTrimString(request.getParameter("lawSuit_Reason"));//訴願案由
        String lawSuit_Result = Utility.getTrimString(request.getParameter("lawSuit_Result"));//訴願決定結果
        String isSue = Utility.getTrimString(request.getParameter("isSue"));//有無提起行政訴訟
        String violate_Type = Utility.getTrimString(request.getParameter("violate_Type"));//處分方式 
        try {
            // 檢查是否有這一筆資料, 如果沒有就新增
            StringBuffer sql = new StringBuffer () ;
            sql.append("select count(*) as count ");
            sql.append(" from MIS_VIOLATELAW ");
            sql.append(" where bank_type=? AND bank_no = ? AND TO_CHAR(violate_date,'yyyy/mm/dd') = ? ");
            paramList.add(bankType) ;
            paramList.add(tbank) ;
            paramList.add(violate_Date) ;
            
            List data = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"count") ;
		    System.out.println("MIS_VIOLATELAW.size="+data.size());
			if(data != null && data.size() > 0) {
			    DataObject bean = (DataObject)data.get(0);
			    String rs = String.valueOf(bean.getValue("count"));
			    System.out.println("Count ="+rs);
			    if(!rs.equals("0")) {
			        errMsg += "此筆資料已存在無法新增<br>";
                    return errMsg;
			    }
            }
			String reply_Doc = updFile(request);
			sql.setLength(0);
			paramList.clear();
			sql.append("INSERT INTO MIS_VIOLATELAW(title,content,law_content");
			sql.append("		,BANK_TYPE,BANK_NO,VIOLATE_DATE,VIOLATE_TYPE,LAWSUIT_ITEM");
			sql.append("		,LAWSUIT_DATE,LAWSUIT_REASON,GOV_DATE,REPLY_DATE,REPLY_DOC");
			sql.append("		,LAWSUIT_DECDATE,LAWSUIT_RESULT,ISSUE,USER_ID,USER_NAME,UPDATE_DATE)"); 
			sql.append(" VALUES(?,?,?,?,?,to_date(?,'YYYY/MM/DD'),?,?");
			sql.append("		 ,to_date(?,'YYYY/MM/DD'),?,to_date(?,'YYYY/MM/DD'),to_date(?,'YYYY/MM/DD'),?");
			sql.append("		 ,to_date(?,'YYYY/MM/DD'),?,?,?,?,sysdate)");
			updateDBSqlList.add(sql.toString()) ;
			paramList.add(title) ;
			paramList.add(content) ;
			paramList.add(law_content) ;
			paramList.add(bankType) ;
			paramList.add(tbank) ;
			paramList.add(violate_Date) ;
			paramList.add(violate_Type) ;
			paramList.add(lawSuit_Item) ;
			paramList.add(lawSuit_Date) ;
			paramList.add(lawSuit_Reason) ;
			paramList.add(gov_Date) ;
			paramList.add(reply_Date) ;
			paramList.add(reply_Doc) ;
			paramList.add(lawSuit_DecDate) ;
			paramList.add(lawSuit_Result) ;
			paramList.add(isSue) ;
			paramList.add(loginID) ;
			paramList.add(loginName) ;
			updateDBDataList.add(paramList);//1:傳內的參數List
			updateDBSqlList.add(updateDBDataList);//0:sql 1:參數List
			updateDBList.add(updateDBSqlList);
            if(DBManager.updateDB_ps(updateDBList)){
			   errMsg = errMsg + "相關資料寫入資料庫成功";
			}else{
			   errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
			}
            
        }catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗\n[Exception Error]:";
		}
		return errMsg;
	}

	private String updateDataToDB(HttpServletRequest request, String loginID, String loginName) {
	    String actMsg = "";
        String errMsg = "";
        String bankType =  Utility.getTrimString(request.getParameter("bankType"));//金融機構類別
        String tbank = Utility.getTrimString(request.getParameter("tbank"));//受處分機構
        String violate_Date = Utility.getTrimString(request.getParameter("violate_Date"));//受處分日期
      	String title = Utility.getTrimString(request.getParameter("title" ));//主旨
        String content = Utility.getTrimString(request.getParameter("content" ));//說明
        String law_content = Utility.getTrimString(request.getParameter("law_Content" ));//法令依據
        String lawSuit_Date = Utility.getTrimString(request.getParameter("lawSuit_Date"));//訴願日期
        String gov_Date = Utility.getTrimString(request.getParameter("gov_Date"));//移送訴願管轄機關日期
        String reply_Date = Utility.getTrimString(request.getParameter("reply_Date"));//檢卷答辯日期
        String lawSuit_DecDate = Utility.getTrimString(request.getParameter("lawSuit_DecDate"));//訴願決定日期
        String lawSuit_Item = Utility.getTrimString(request.getParameter("lawSuit_Item"));//訴願人
        String lawSuit_Reason = Utility.getTrimString(request.getParameter("lawSuit_Reason"));//訴願案由
        String lawSuit_Result = Utility.getTrimString(request.getParameter("lawSuit_Result"));//訴願決定結果
        String isSue = Utility.getTrimString(request.getParameter("isSue"));//有無提起行政訴訟
        String violate_Type = Utility.getTrimString(request.getParameter("violate_Type"));//處分方式  
        String preTbank = Utility.getTrimString(request.getParameter("preTbank"));
        String preViolate_Date = Utility.getTrimString(request.getParameter("preViolate_Date"));
		List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
	    List updateDBSqlList = new ArrayList();
	    List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {
            // 檢查是否存在
            StringBuffer sqlCmd = new StringBuffer() ;
            List<String> paramList = new ArrayList<String>();
            
            sqlCmd.append("select count(*) as count from MIS_VIOLATELAW where bank_no = ? AND TO_CHAR(violate_date,'yyyy/mm/dd') = ? ");
            paramList.add(preTbank) ;
            paramList.add(preViolate_Date) ;
            
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");
		    System.out.println("MIS_VIOLATELAW.size="+data.size());
			if(data.size() < 1) {
     	        errMsg = errMsg + "此筆資料不存在無法修改<br>";
                return errMsg;
        	}
			
			sqlCmd.setLength(0) ;
			paramList = new ArrayList<String>();
	     	// 檢查是否有這一筆資料, 如果沒有就新增
	     	if(!(preTbank).equals(tbank) || !(preViolate_Date).equals(violate_Date)){
	            sqlCmd.append("select count(*) as count ");
	            sqlCmd.append(" from MIS_VIOLATELAW ");
	            sqlCmd.append(" where bank_type=? AND bank_no = ? AND TO_CHAR(violate_date,'yyyy/mm/dd') = ? ");
	            paramList.add(bankType) ;
	            paramList.add(tbank) ;
	            paramList.add(violate_Date) ;
	            
	            data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count") ;
			    System.out.println("MIS_VIOLATELAW.size="+data.size());
				if(data != null && data.size() > 0) {
				    DataObject bean = (DataObject)data.get(0);
				    String rs = String.valueOf(bean.getValue("count"));
				    System.out.println("Count ="+rs);
				    if(!rs.equals("0")) {
				        errMsg += "此筆資料已存在無法新增<br>";
	                    return errMsg;
				    }
	            }
	     	}
	        /*寫入log檔中*/
	        sqlCmd.setLength(0) ;
	        paramList = new ArrayList<String>();
	        sqlCmd.append(" INSERT INTO MIS_VIOLATELAW_LOG "); 
	        sqlCmd.append(" SELECT BANK_TYPE,BANK_NO,VIOLATE_DATE,VIOLATE_TYPE,TITLE,CONTENT ");
	        sqlCmd.append(" ,LAW_CONTENT,LAWSUIT_ITEM,LAWSUIT_DATE,LAWSUIT_REASON,GOV_DATE ");
	        sqlCmd.append(" ,REPLY_DATE,REPLY_DOC,LAWSUIT_DECDATE,LAWSUIT_RESULT,ISSUE "); 
	        sqlCmd.append(" ,USER_ID,USER_NAME,UPDATE_DATE ");
	        sqlCmd.append(" ,?,?,sysdate,? FROM MIS_VIOLATELAW ");
	        sqlCmd.append(" WHERE bank_no = ? AND TO_CHAR(violate_date,'yyyy/mm/dd') = ? ");                                                                                               
			paramList.add(loginID) ;
			paramList.add(loginName) ;
			paramList.add("U") ;
			paramList.add(preTbank) ;
            paramList.add(preViolate_Date) ;
			updateDBSqlList.add(sqlCmd.toString()) ;
			updateDBDataList.add(paramList);//1:傳內的參數List
			updateDBSqlList.add(updateDBDataList);//0:sql 1:參數List
			updateDBList.add(updateDBSqlList);
			
			
			String reply_Doc = updFile(request);
	        sqlCmd.setLength(0) ;
	        paramList = new ArrayList<String>();
			updateDBDataList = new ArrayList<List>();
			updateDBSqlList = new ArrayList();
			sqlCmd.append("UPDATE MIS_VIOLATELAW ");
			sqlCmd.append("   SET title=?,content=?,law_content=?,BANK_TYPE=?,BANK_NO=?,VIOLATE_DATE=to_date(?,'YYYY/MM/DD'),VIOLATE_TYPE=?,LAWSUIT_ITEM=?");
			sqlCmd.append("		,LAWSUIT_DATE=to_date(?,'YYYY/MM/DD'),LAWSUIT_REASON=?,GOV_DATE=to_date(?,'YYYY/MM/DD'),REPLY_DATE=to_date(?,'YYYY/MM/DD') ");
			paramList.add(title) ;
			paramList.add(content) ;
			paramList.add(law_content) ;
			paramList.add(bankType) ;
			paramList.add(tbank) ;
			paramList.add(violate_Date) ;
			paramList.add(violate_Type) ;
			paramList.add(lawSuit_Item) ;
			paramList.add(lawSuit_Date) ;
			paramList.add(lawSuit_Reason) ;
			paramList.add(gov_Date) ;
			paramList.add(reply_Date) ;
			if(!"".equals(reply_Doc)){
				sqlCmd.append(",REPLY_DOC=?");
				paramList.add(reply_Doc);
			}
			sqlCmd.append("		,LAWSUIT_DECDATE=to_date(?,'YYYY/MM/DD'),LAWSUIT_RESULT=?,ISSUE=?,USER_ID=?,USER_NAME=?,UPDATE_DATE=sysdate "); 
			sqlCmd.append(" WHERE bank_no = ? AND TO_CHAR(violate_date,'yyyy/mm/dd') = ? ");
			paramList.add(lawSuit_DecDate) ;
			paramList.add(lawSuit_Result) ;
			paramList.add(isSue) ;
			paramList.add(loginID) ;
			paramList.add(loginName) ;
			paramList.add(preTbank) ;
            paramList.add(preViolate_Date) ;
	        updateDBSqlList.add(sqlCmd.toString()) ;
			updateDBDataList.add(paramList);//1:傳內的參數List
			updateDBSqlList.add(updateDBDataList);//0:sql 1:參數List
			updateDBList.add(updateDBSqlList);
	
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
	private String updateFileDataToDB(HttpServletRequest request, String loginID, String loginName,String preTbank,String preViolate_Date) {
	    String actMsg = "";
        String errMsg = "";
		List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
	    List updateDBSqlList = new ArrayList();
	    List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    StringBuffer sqlCmd = new StringBuffer() ;
        List<String> paramList = new ArrayList<String>();
	    try {
			sqlCmd.append("UPDATE MIS_VIOLATELAW ");
			sqlCmd.append("   SET REPLY_DOC = ?,USER_ID=?,USER_NAME=?,UPDATE_DATE=sysdate ");
			sqlCmd.append(" WHERE bank_no = ? AND TO_CHAR(violate_date,'yyyy/mm/dd') = ? ");
			paramList.add("") ;
			paramList.add(loginID) ;
			paramList.add(loginName) ;
			paramList.add(preTbank) ;
            paramList.add(preViolate_Date) ;
	        updateDBSqlList.add(sqlCmd.toString()) ;
			updateDBDataList.add(paramList);//1:傳內的參數List
			updateDBSqlList.add(updateDBDataList);//0:sql 1:參數List
			updateDBList.add(updateDBSqlList);
	
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
        String preTbank = Utility.getTrimString(request.getParameter("preTbank"));
        String preViolate_Date = Utility.getTrimString(request.getParameter("preViolate_Date"));
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
	    List updateDBSqlList = new ArrayList();
	    List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {

            List DBSqlList = new LinkedList();

             // 檢查是否存在
            StringBuffer sqlCmd = new StringBuffer() ;
            List paramList = new ArrayList() ;
            sqlCmd.append("select count(*) as count from MIS_VIOLATELAW where bank_no = ? AND TO_CHAR(violate_date,'yyyy/mm/dd') = ? " );
            paramList.add(preTbank) ;
            paramList.add(preViolate_Date) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");
            System.out.println("MIS_VIOLATELAW.size="+data.size());
			if(data.size() < 1) {
     	        errMsg = errMsg + "此筆資料不存在無法刪除<br>";
                return errMsg;
            }
            
            
			/*寫入log檔中*/
	        sqlCmd.setLength(0) ;
	        paramList.clear() ;
	        sqlCmd.append(" INSERT INTO MIS_VIOLATELAW_LOG "); 
	        sqlCmd.append(" SELECT BANK_TYPE,BANK_NO,VIOLATE_DATE,VIOLATE_TYPE,TITLE,CONTENT ");
	        sqlCmd.append(" ,LAW_CONTENT,LAWSUIT_ITEM,LAWSUIT_DATE,LAWSUIT_REASON,GOV_DATE ");
	        sqlCmd.append(" ,REPLY_DATE,REPLY_DOC,LAWSUIT_DECDATE,LAWSUIT_RESULT,ISSUE "); 
	        sqlCmd.append(" ,USER_ID,USER_NAME,UPDATE_DATE ");
	        sqlCmd.append(" ,?,?,sysdate,? FROM MIS_VIOLATELAW ");
	        sqlCmd.append(" WHERE bank_no = ? AND TO_CHAR(violate_date,'yyyy/mm/dd') = ?  ");                                                                                               
			paramList.add(loginID) ;
			paramList.add(loginName) ;
			paramList.add("D") ;
			paramList.add(preTbank) ;
            paramList.add(preViolate_Date) ;
			    
			updateDBSqlList.add(sqlCmd.toString()) ;
			updateDBDataList.add(paramList);//1:傳內的參數List
			updateDBSqlList.add(updateDBDataList);//0:sql 1:參數List
			updateDBList.add(updateDBSqlList);
		    
            //DEl data
			sqlCmd.setLength(0) ;
            paramList=  new ArrayList() ;
            updateDBSqlList = new ArrayList() ;
            updateDBDataList = new ArrayList<List>();//儲存參數的List 
            sqlCmd.append(" DELETE FROM MIS_VIOLATELAW where bank_no = ? AND TO_CHAR(violate_date,'yyyy/mm/dd') =? ");
            paramList.add(preTbank) ;
            paramList.add(preViolate_Date) ;
            updateDBSqlList.add(sqlCmd.toString()) ;
            updateDBDataList.add(paramList) ;
            updateDBSqlList.add(updateDBDataList) ;
            updateDBList.add(updateDBSqlList) ;
            
            if(DBManager.updateDB_ps(updateDBList)){
            	String append_file = Utility.getTrimString(request.getParameter("append_file"));
			   	if(!"".equals(append_file)){
			   		System.out.println("***"+Utility.getProperties("reportDir") + System.getProperty("file.separator")+append_file);
			  		File objFile_del = new File(Utility.getProperties("reportDir") + System.getProperty("file.separator")+append_file);
			  		String bank_no = Utility.getTrimString(request.getParameter("bank_no"));
		            String violate_date = Utility.getTrimString(request.getParameter("violate_date"));
			  		objFile_del.delete();
			   	}
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
	public static String addZeroForNum(String str, int strLength) {
	    int strLen = str.length();
	    if (strLen < strLength) {
	        while (strLen < strLength) {
	            StringBuffer sb = new StringBuffer();
	            sb.append("0").append(str);// 左補0
	            // sb.append(str).append("0");//右補0
	            str = sb.toString();
	            strLen = str.length();
	        }
	    }
	    return str;
	} 

	private String updFile(HttpServletRequest request) throws Exception{
		String saveDirectory = Utility.getProperties("reportDir");
		int maxPostSize = 100*1024*1024;   		  
	  	int count = 0;
		File objFile = new File(saveDirectory);
		if(!objFile.exists())
	  		objFile.mkdir();   		     
		//宣告上傳檔案名稱
		String FileName = null;
		//支援中文檔名
		String enCoding = "MS950";
		//產生一個新的MultipartRequest的物件,multi
		MultipartRequest  multi = new MultipartRequest(request,saveDirectory,maxPostSize,enCoding);    		   		    		   
	  	//取得所有上傳之檔案輸入型態名稱
	  	Enumeration filesname = multi.getFileNames();
	  	String appfile_link="",reFileName="";
	  	List filename_List  = new LinkedList();
	  	while(filesname.hasMoreElements()){	      		                		   		    
	    	String nextFilename = (String)filesname.nextElement();
	     	FileName = multi.getFilesystemName(nextFilename); 
	     	System.out.println("上傳之檔案FileName ="+FileName);
	     	if( !(FileName == null)){
	     		/*
				Calendar calendar=new GregorianCalendar();
				int year=calendar.get(Calendar.YEAR);
				String str_year=addZeroForNum(Integer.toString(year),3);
				int month=calendar.get(Calendar.MONTH);
				String str_month=addZeroForNum(Integer.toString(month),3);
				int day=calendar.get(Calendar.DATE);
				String str_day=addZeroForNum(Integer.toString(day),3);
				int hour=calendar.get(Calendar.HOUR_OF_DAY);
				String str_hour=Integer.toString(hour);
				int minute=calendar.get(Calendar.MINUTE);
				String str_minute=Integer.toString(minute);
				int second=calendar.get(Calendar.SECOND);
				String str_second=Integer.toString(second);
				*/
				int index = FileName.indexOf('.');      
				String file_type = FileName.substring(index+1,index+4);
				//reFileName=str_year+str_month+str_day+str_hour+str_minute+str_second+"."+file_type;
				
				
				reFileName = Utility.getDateFormat("yyyyMMddHHmmss")+"."+file_type;
				
	     		appfile_link = Utility.getProperties("reportDir") + System.getProperty("file.separator")+FileName;
				File f1 = new File(appfile_link);
				System.out.println("********** appfile_link="+appfile_link);
				appfile_link = Utility.getProperties("reportDir") + System.getProperty("file.separator")+reFileName;
				File f2 = new File(appfile_link);
				System.out.println("********** appfile_link="+appfile_link);
				f1.renameTo(f2);
				
				filename_List.add(reFileName);
				
				File rptFile = null;
				String rptIP=Utility.getProperties("rptIP");			
		        String rptID=Utility.getProperties("rptID");			
		        String rptPwd=Utility.getProperties("rptPwd");
				//String[] fname1= objFile.list(); //====列出此目錄下的所有檔案===================
				/*for(int c=0;c<fname1.length;c++){
					rptFile = new File(saveDirectory+System.getProperty("file.separator")+fname1[c]);
					if(!rptFile.isDirectory()) filename_List.add(fname1[c]);
				}*/
				MyFTPClient ftpC = new MyFTPClient(rptIP, rptID, rptPwd);
				                   //putFiles(String remote_path, String local_path,String workDir,List filename)
			    String putMsg = ftpC.putFiles(Utility.getProperties("serverRptDir"), saveDirectory + System.getProperty("file.separator"),"MC001W",filename_List);
			    if(putMsg == null){//上傳檔案成功		                     
                    for(int i=0;i<filename_List.size();i++){
                        rptFile = new File(saveDirectory+System.getProperty("file.separator")+(String)filename_List.get(i));
                        if(rptFile.exists()) rptFile.delete();
                        System.out.println((String)filename_List.get(i)+"檔案上傳成功"); 
                    }
                }else{//end of 上傳檔案成功
                	System.out.println("上傳至Sever未成功"+putMsg);     	           	       	
                }
	     	}else{
	     		appfile_link = " ";
	     	}
	   	}
		return reFileName;
	}
		//101.05.07 取得處分類別
    public static List getViolateType(String cmuser_div) throws Exception {    	
    List paramList = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" select cmuse_id,cmuse_name from cdshareno where cmuse_div=? order by input_order"); 
		paramList.add(cmuser_div);		
		List dbData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"");                    
        return dbData;        
    }
	
%>
