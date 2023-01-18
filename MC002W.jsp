<%
//97.09.03 create 信用部防治洗錢注意事項修正(MC002W) by 2295
//97.09.05 add 函請修正發文文號(用來記錄前一次發文文號) by 2295
//99.05.26 fix 縣市合併調整&sql injection by 2808
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>
<%
	
	String userId = session.getAttribute("muser_id") != null ? (String) session.getAttribute("muser_id") : "" ;
	String userName = session.getAttribute("muser_name") != null ? (String) session.getAttribute("muser_name") : "" ;
	String Come_begDate = Utility.getTrimString(request.getParameter("Come_begDate")) ;
	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
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
    	            String come_docno = request.getParameter("come_docno") != null ? request.getParameter("come_docno") : "";
    	            String sn_docno = request.getParameter("sn_docno") != null ? request.getParameter("sn_docno") : "";    	            
    	            request.setAttribute("DETAIL",getDetail(bank_no,come_docno,sn_docno,Come_begDate));    	            
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit");
    	        }
    	    } else if(act.equals("Qry")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));    	        
    	        rd = application.getRequestDispatcher( ListPgName +"?act=Qry");  
    	    }     	    
        } else if(act.equals("Insert")){
    	    actMsg = insertDataToDB(request,userId,userName);
    	    request.setAttribute("actMsg",actMsg); 
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=MC002W.jsp&act=List");        	
        } else if(act.equals("Update")){
            actMsg = updateDataToDB(request,userId,userName);                   
            rd = application.getRequestDispatcher( nextPgName+"?goPages=MC002W.jsp&act=List");         	
        } else if(act.equals("Delete")){
    	    actMsg = deleteDataToDB(request,userId,userName);
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=MC002W.jsp&act=List");
        }        
    	request.setAttribute("actMsg",actMsg);
      }

%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "MC002W" ;
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


    //取得查詢資料
    private List getQueryResult(HttpServletRequest request){
        String bankType = Utility.getTrimString(request.getParameter("bankType" ));
        String cityType = Utility.getTrimString(request.getParameter("cityType" ));
        String tbank = Utility.getTrimString(request.getParameter("tbank" ));//機構名稱
        String Come_begDate = Utility.getTrimString(request.getParameter("Come_begDate" ));//來文日期-起始
        String Come_endDate = Utility.getTrimString(request.getParameter("Come_endDate" ));//來文日期-結束        
        String Come_docno =Utility.getTrimString(request.getParameter("Come_docno" ));//來文文號
        String Sn_begDate = Utility.getTrimString(request.getParameter("Sn_begDate" ));//發文日期-起始
        String Sn_endDate = Utility.getTrimString(request.getParameter("Sn_endDate" ));//發文日期-結束        
        String Sn_docno = Utility.getTrimString(request.getParameter("Sn_docno" ));//發文文號
        String content = Utility.getTrimString(request.getParameter("content" ));//處理情形
        
        String u_year = "99" ;
        
        System.out.println("Come_begDate="+Come_begDate);
        System.out.println("Come_endDate="+Come_endDate);
        System.out.println("Sn_begDate="+Sn_begDate);
        System.out.println("Sn_endDate="+Sn_endDate);
        if(!"".equals(Come_begDate) && Come_begDate.length() > 0 ) {
        	if(Integer.parseInt(Come_begDate.substring(0,4)) > 2010 ){
        		u_year = "100" ;
        	}
        }else {
        	if(Integer.parseInt(Utility.getYear()) > 99 ){
        		u_year = "100" ;
        	}
        }
    	request.setAttribute("content",content);
    	request.setAttribute("bankType",bankType);
    	request.setAttribute("cityType",cityType);        
    	request.setAttribute("Come_begDate",Come_begDate);
    	request.setAttribute("Come_endDate",Come_endDate);
    	request.setAttribute("Sn_begDate",Sn_begDate);
    	request.setAttribute("Sn_endDate",Sn_endDate);
    	request.setAttribute("Come_docno",Come_docno);
    	request.setAttribute("Sn_docno",Sn_docno);
		
		StringBuffer condition= new StringBuffer() ;
		List conditionList = new ArrayList() ;
    	//查詢條件    	
    	StringBuffer sqlCmd = new StringBuffer() ;
    	List paramList =new ArrayList() ;
    	
    	sqlCmd.append( " select bn01.bank_no,bn01.bank_name,"					  
					  + " ((TO_CHAR(come_date,'yyyy')-1911)||'/'|| TO_CHAR(come_date,'mm/dd')) as come_date,"
					  + " TO_CHAR(come_date,'yyyy/mm/dd') as come_date_1,"
					  + " ((TO_CHAR(sn_date,'yyyy')-1911)||'/'|| TO_CHAR(sn_date,'mm/dd')) as sn_date,"
					  + " TO_CHAR(sn_date,'yyyy/mm/dd') as sn_date_1,"
					  + " come_docno,sn_docno,pre_sn_docno,"
					  + " decode(content,'01','同意備查','02','應修改',content) as content"
					  + " from mis_moneylaunder "
					  + " left join (select * from bn01 where m_year=? )bn01 on mis_moneylaunder.bank_no = bn01.bank_no " );
		paramList.add(u_year) ;
        if(!bankType.equals("")) {
            condition.append( (condition.length() > 0 ? " and":"")+" mis_moneylaunder.bank_type=? " );
            conditionList.add(bankType) ;
        }
    	if(!cityType.equals("")) {
    		condition.append( (condition.length() > 0 ? " and":"")+" mis_moneylaunder.BANK_NO in (select BANK_NO  from (select * from wlx01 where m_year=? )WLX01  where HSIEN_ID =  '"+cityType+"' ) ");
    		conditionList.add(u_year) ;
    		conditionList.add(cityType) ;
    	}
    	if(!tbank.equals("")) {
    	    condition.append( (condition.length() > 0 ? " and":"")+" mis_moneylaunder.bank_no=? " );		
    	    conditionList.add(tbank) ;
    	}
    	if(!content.equals("") && !content.equals("ALL")) {
    	    condition.append( (condition.length() > 0 ? " and":"")+" content = ? " );
    	    conditionList.add(content) ;
    	}    	
    	if(!Come_docno.equals("")) {
    	    condition.append((condition.length() > 0 ? " and":"")+" come_docno = ? " );
    	    conditionList.add(Come_docno) ;
    	}
    	if(!Sn_docno.equals("")) {
    	    condition.append( (condition.length() > 0 ? " and":"")+" sn_docno = '"+Sn_docno+"'" );
    	    conditionList.add(Sn_docno) ;
    	}
    	if(!Come_begDate.equals("") && !Come_endDate.equals("")){
    	    condition.append( (condition.length() > 0 ? " and":"")+" TO_CHAR(come_date, 'yyyymmdd') BETWEEN ? AND ? " );
    	    conditionList.add(Come_begDate) ;
    	    conditionList.add(Come_endDate) ;
    	}
    	if(!Sn_begDate.equals("") && !Sn_endDate.equals("")){
    	    condition.append( (condition.length() > 0 ? " and":"")+" TO_CHAR(sn_date, 'yyyymmdd') BETWEEN ? AND ? " );
    	    conditionList.add(Sn_begDate) ;
    	    conditionList.add(Sn_endDate) ;
    	}
    	/*
    	if(pre_sn_doc.equals("01")){//無第二次來文資料
    	   condition += (condition.length() > 0 ? " and":"")+" pre_sn_docno is null" ;
        }else{
           condition += (condition.length() > 0 ? " and":"")+" pre_sn_docno is not null" ;
        }
        */
    	if(condition.length() > 0) {
    		sqlCmd.append( "where ").append(condition.toString() ) ;
    		for(int i =0 ;i<conditionList.size() ;i++) {
    			paramList.add(conditionList.get(i)) ;
    		}
    	}
    	
    	sqlCmd.append( " ORDER BY bank_no,come_date,sn_date" );
		
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"come_date,come_date_1,sn_date,sn_date_1");
        System.out.println("dbData= "+dbData.size());
        return dbData;
    }
    
    // 取得單筆資料
    private DataObject getDetail(String bank_no,String come_docno, String sn_docno ,String Come_begDate) {
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
        sqlCmd.append( " select bn01.bank_no,bn01.bank_name,"					  
					  + " ((TO_CHAR(come_date,'yyyy')-1911)||'/'|| TO_CHAR(come_date,'mm/dd')) as come_date,"
					  + " TO_CHAR(come_date,'yyyy/mm/dd') as come_date_1,"
					  + " ((TO_CHAR(sn_date,'yyyy')-1911)||'/'|| TO_CHAR(sn_date,'mm/dd')) as sn_date,"
					  + " TO_CHAR(sn_date,'yyyy/mm/dd') as sn_date_1,"
					  + " come_docno,sn_docno,pre_sn_docno,content"					  
					  + " from mis_moneylaunder "
					  + " left join (select * from bn01 where m_year=? ) bn01 on mis_moneylaunder.bank_no = bn01.bank_no "
					  + " where mis_moneylaunder.bank_no=?"
					  + " and  come_docno = ?"
					  + " and sn_docno =?" );
        sqlCmdList.add(u_year) ;
        sqlCmdList.add(bank_no) ;
        sqlCmdList.add(come_docno) ;
        sqlCmdList.add(sn_docno) ;
        
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),sqlCmdList,"come_date,come_date_1,sn_date,sn_date_1");
        if(dbData.size() > 0) {
            ob = (DataObject)dbData.get(0);
        }
        return ob;
    }
    
    private String insertDataToDB(HttpServletRequest request, String loginID, String loginName) {
        String actMsg = "";
        String errMsg = "";
        String bankType = Utility.getTrimString(request.getParameter("bankType" ));//金融機構類別
        String tbank = Utility.getTrimString(request.getParameter("tbank" ));//機構名稱
        String COME_DATE = Utility.getTrimString(request.getParameter("COME_DATE" ));//來文日期
        String come_docno = Utility.getTrimString(request.getParameter("come_docno" ));//來文文號
        String SN_DATE = Utility.getTrimString(request.getParameter("SN_DATE" ));//發文日期
        String sn_docno = Utility.getTrimString(request.getParameter("sn_docno" ));//發文文號
        String pre_sn_docno = Utility.getTrimString(request.getParameter("pre_sn_docno" ));//函請修正發文文號
        String content = Utility.getTrimString(request.getParameter("content" ));//處理情形       
       
        //List insertDBSqlList = new LinkedList();
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
        try {
            StringBuffer sqlCmd = new StringBuffer() ;
            
            // 檢查是否有這一筆資料, 如果沒有就新增
            sqlCmd.append("select count(*) as count from MIS_MONEYLAUNDER where bank_no = ? AND come_docno = ? AND sn_docno=? ");
            paramList.add(tbank);
            paramList.add(come_docno);
            paramList.add(sn_docno);
            
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");
		    System.out.println("MIS_MONEYLAUNDER.size="+data.size());
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
			
			sqlCmd.append( "INSERT INTO MIS_MONEYLAUNDER VALUES(?,?,"+"to_date(?,'YYYY/MM/DD'),?,"
		           +"to_date(?,'YYYY/MM/DD'),?,?,?,?,?,sysdate)");
		    paramList.add(bankType) ;
		    paramList.add(tbank) ;
		    paramList.add(COME_DATE) ;
		    paramList.add(come_docno) ;
		    paramList.add(SN_DATE) ;
		    paramList.add(sn_docno) ;
		    paramList.add(pre_sn_docno) ;
		    paramList.add(content) ;
		    paramList.add(loginID) ;
		    paramList.add(loginName) ;
		    
		    updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
			//insertDBSqlList.add(sqlCmd);

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
        
        String tbank = Utility.getTrimString(request.getParameter("tbank" ));//機構名稱
        String COME_DATE = Utility.getTrimString(request.getParameter("COME_DATE" ));//來文日期
        String come_docno = Utility.getTrimString(request.getParameter("come_docno" ));//來文文號
        String SN_DATE = Utility.getTrimString(request.getParameter("SN_DATE" ));//發文日期
        String sn_docno = Utility.getTrimString(request.getParameter("sn_docno" ));//發文文號
        String pre_sn_docno = Utility.getTrimString(request.getParameter("pre_sn_docno" ));//函請修正發文文號
        String content =Utility.getTrimString( request.getParameter("content" ));//處理情形       
       
		//List updateDBSqlList = new LinkedList();
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
        StringBuffer sqlCmd = new StringBuffer() ;
	    try {
            // 檢查是否存在
            sqlCmd.append( "select count(*) as count from MIS_MONEYLAUNDER where bank_no = ? AND come_docno = ? AND sn_docno=? ");
            paramList.add(tbank) ;
            paramList.add(come_docno) ;
            paramList.add(sn_docno) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");
		    System.out.println("MIS_MONEYLAUNDER.size="+data.size());
			if(data.size() < 1) {
     	        errMsg = errMsg + "此筆資料不存在無法修改<br>";
                return errMsg;
            }
            
            
            /*寫入log檔中*/
            sqlCmd.setLength(0) ;
            paramList.clear() ;
			sqlCmd.append( "INSERT INTO MIS_MONEYLAUNDER_LOG "
		     	   +"select bank_type,bank_no,come_date,come_docno,sn_date,sn_docno,pre_sn_docno,content,"
		     	   +"user_id,user_name,update_date,?,?,sysdate,'U' from MIS_MONEYLAUNDER where bank_no =? AND come_docno = ? AND sn_docno=?" );                                                                                               
		    paramList.add(loginID) ;
		    paramList.add(loginName) ;
		    paramList.add(tbank) ;
		    paramList.add(come_docno) ;
		    paramList.add(sn_docno) ;
		    
		    updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
		    //updateDBSqlList.add(sqlCmd);  
            
		    sqlCmd.setLength(0) ;
		    paramList = new ArrayList() ;
		    updateDBSqlList = new ArrayList() ;
		    updateDBDataList =	new ArrayList<List>();
            sqlCmd.append( " UPDATE MIS_MONEYLAUNDER SET "
                   +" come_date = to_date(?,'YYYY/MM/DD'),"
                   +" sn_date = to_date(?,'YYYY/MM/DD'),"  
                   +" pre_sn_docno = ?, "                             
                   +" content = ?, "                     
                   +" user_id = ?, user_name = ?, update_date = sysdate " 
                   +" where bank_no = ? AND come_docno =? AND sn_docno=?");
            paramList.add(COME_DATE) ;
            paramList.add(SN_DATE) ;
            paramList.add(pre_sn_docno) ;
            paramList.add(content) ;
            paramList.add(loginID) ;
            paramList.add(loginName) ;
            paramList.add(tbank) ;
            paramList.add(come_docno) ;
            paramList.add(sn_docno) ;
            updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
            //updateDBSqlList.add(sqlCmd);


            if(DBManager.updateDB_ps(updateDBList)){
				errMsg = errMsg + "相關資料寫入資料庫成功";
			}else{
				errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
			}
        } catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				return "相關資料寫入資料庫失敗 <br>[Exception Error]<br> ";
		} finally{
			try{
				paramList.clear() ;
				updateDBList.clear() ;
				updateDBSqlList.clear() ;
				updateDBDataList.clear() ;
			}catch(Exception e){
				System.out.println(e+":"+e.getMessage());
				return "相關資料寫入資料庫失敗 <br>[Exception Error]<br> "+e.getMessage();
			}
		}
		return errMsg;
	}

	// 刪除資料
	private String deleteDataToDB(HttpServletRequest request, String loginID, String loginName) {
	    String actMsg = "";
        String errMsg = "";
        
 		String tbank = Utility.getTrimString(request.getParameter("tbank" ));//機構名稱        
        String come_docno = Utility.getTrimString(request.getParameter("come_docno" ));//來文文號        
        String sn_docno = Utility.getTrimString(request.getParameter("sn_docno" ));//發文文號
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
        StringBuffer sqlCmd = new StringBuffer() ;
	    try {

            List DBSqlList = new LinkedList();

             // 檢查是否存在
            sqlCmd.append( "select count(*) as count from MIS_MONEYLAUNDER where bank_no = ? AND come_docno =? AND sn_docno=?");
            paramList.add(tbank) ;
            paramList.add(come_docno) ;
            paramList.add(sn_docno) ;
            
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");
		    System.out.println("MIS_MONEYLAUNDER.size="+data.size());
			if(data.size() < 1) {
     	        errMsg = errMsg + "此筆資料不存在無法刪除<br>";
                return errMsg;
            }

             /*寫入log檔中*/
             sqlCmd.setLength(0) ;
             paramList.clear() ;
			sqlCmd.append("INSERT INTO MIS_MONEYLAUNDER_LOG "
		     	   +"select bank_type,bank_no,come_date,come_docno,sn_date,sn_docno,pre_sn_docno,content,"
		     	   +"user_id,user_name,update_date,?,?,sysdate,'D' from MIS_MONEYLAUNDER where bank_no = ? AND come_docno = ? AND sn_docno=?");                                                                                               
		     paramList.add(loginID) ;
		     paramList.add(loginName) ;
		     paramList.add(tbank) ;
		     paramList.add(come_docno) ;
		     paramList.add(sn_docno) ;
		     
		     updateDBSqlList.add(sqlCmd.toString()) ;
		     updateDBDataList.add(paramList) ;
		     updateDBSqlList.add(updateDBDataList) ;
		     updateDBList.add(updateDBSqlList) ;
              //DBSqlList.add(sqlCmd);
			
              sqlCmd.setLength(0) ;
              paramList = new ArrayList() ;
              updateDBSqlList = new ArrayList() ;
              updateDBDataList = new ArrayList<List> () ;
              
              sqlCmd.append( " DELETE FROM MIS_MONEYLAUNDER where bank_no = ? AND come_docno = ? AND sn_docno=? " );
              paramList.add(tbank) ;
              paramList.add(come_docno) ;
              paramList.add(sn_docno) ;
              
              updateDBSqlList.add(sqlCmd.toString()) ;
 		      updateDBDataList.add(paramList) ;
 		      updateDBSqlList.add(updateDBDataList) ;
 		      updateDBList.add(updateDBSqlList) ;
              //DBSqlList.add(sqlCmd);

             if(DBManager.updateDB_ps(updateDBList)){
			   errMsg = errMsg + "相關資料刪除成功";
		     }else{
			   errMsg = errMsg + "相關資料刪除失敗<br>[DBManager.getErrMsg()]<br>" + DBManager.getErrMsg();
			 }

        } catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				return "相關資料刪除失敗<br>[Exception Error]<br>";
		}finally{
			try{
				paramList.clear() ;
				updateDBList.clear() ;
				updateDBSqlList.clear() ;
				updateDBDataList.clear() ;
			}catch(Exception e){
				System.out.println(e+":"+e.getMessage());
				return "相關資料寫入資料庫失敗 <br>[Exception Error]<br> ";
			}
		}
		return errMsg;


	}
%>
