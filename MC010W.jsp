<%
//98.06.02 限制或核准業務函令查詢--by 2756
//98.10.16 fix 只取得總機構名稱 by 2295
//99.05.27 fix 縣市合併調整&sql injection by 2808
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
	System.out.println("Page: MC010W.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );

	    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
            rd = application.getRequestDispatcher( LoginErrorPgName );
	    } else {
    	if(act.equals("List") || act.equals("Qry") || act.equals("Edit") ||  act.equals("New")) {    	    
    		request.setAttribute("TBank", getTatolBankType());           
    	    request.setAttribute("City", Utility.getCity());
    	    request.setAttribute("LState", getLState());
    	    request.setAttribute("LMgr", getLMgr());
    	    if(act.equals("List")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName +"?act=List");
    	    } else if(act.equals("Edit") || act.equals("New")) {    	       
    	        if(act.equals("New")) {    	          
    	            rd = application.getRequestDispatcher( EditPgName +"?act=New");
    	        }else{
    	            String loal_no = request.getParameter("loalNo") != null ? request.getParameter("loalNo") : "";
    	            request.setAttribute("DETAIL",getDetail(loal_no,begY));    	           
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit");
    	        }
    	    } else if(act.equals("Qry")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName +"?act=Qry");  
    	    }     	    
        } else if(act.equals("Insert")){
    	    actMsg = insertDataToDB(request,userId,userName);
    	    request.setAttribute("actMsg",actMsg); 
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=MC010W.jsp&act=List");        	
        } else if(act.equals("Update")){
            actMsg = updateDataToDB(request,userId,userName);                   
            rd = application.getRequestDispatcher( nextPgName+"?goPages=MC010W.jsp&act=List");         	
        } else if(act.equals("Delete")){
    	    actMsg = deleteDataToDB(request,userId,userName);
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=MC010W.jsp&act=List");
        }        
    	request.setAttribute("actMsg",actMsg);
      }

	
%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "MC010W" ;
private final static String nextPgName = "/pages/ActMsg.jsp";
private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
private final static String LoginErrorPgName = "/pages/LoginError.jsp";

    //取得所有總機構資料
    private List getTatolBankType(){
    	 	/*
    		//查詢條件
            StringBuffer sb=new StringBuffer();  
            //98.10.16 fix 只取得總機構
            sb.append(" select * from ");
		    sb.append(" ( ");
			sb.append(" select * ");
			sb.append(" from( ");
			sb.append(" select wlx01.hsien_id, bn01.bank_no , bn01.bank_name, ");
			sb.append(" bn01.bank_type,FR001W_output_order ");
			sb.append(" from  bn01, (select wlx01.hsien_id,wlx01.bank_no,cd01.FR001W_output_order from wlx01 left join cd01 on wlx01.hsien_id = cd01.hsien_id)wlx01 "); 
			sb.append(" where bn01.bank_no = wlx01.bank_no(+) ");//--總機構
			sb.append(" and bank_type in ('6','7') ");
			sb.append(" and bn_type <> '2' ");
			sb.append(" ) ");
			sb.append(" where hsien_id is not null and hsien_id <> ' ' ");//--有縣市別的機構
			sb.append(" union ");
			sb.append(" select 'Y',bank_no,bank_name,bank_type,FR001W_output_order ");
			sb.append(" from( ");
			sb.append(" select wlx01.hsien_id, bn01.bank_no , bn01.bank_name, ");
			sb.append(" bn01.bank_type,'99' as FR001W_output_order ");
			sb.append(" from  bn01, (select wlx01.hsien_id,wlx01.bank_no,cd01.FR001W_output_order from wlx01 left join cd01 on wlx01.hsien_id = cd01.hsien_id)wlx01 ");
			sb.append(" where bn01.bank_no = wlx01.bank_no(+) ");//--總構機
			sb.append(" and bank_type in ('6','7') ");
			sb.append(" and bn_type <> '2' ");
			sb.append(" ) ");
			sb.append(" where hsien_id is null ");//--無縣市別的機構.歸類到其他
			sb.append(" ) order by FR001W_output_order,hsien_id,bank_no ");
            /*取得總.分支機構
            sb.append(" select * from(select wlx01.hsien_id, bn01.bank_no as tbank_no,bn01.bank_no , bn01.bank_name,bn01.bank_type,'1' as ordertype ");
            sb.append(" from  bn01, wlx01 ");  
            sb.append(" where bn01.bank_no = wlx01.bank_no(+) and bank_type in ('6','7') and bn_type <> '2' ");
            sb.append(" union ");
            sb.append(" select wlx02.hsien_id, bn02.tbank_no,bn02.bank_no , bn02.bank_name, bn02.bank_type,'2' as ordertype ");
            sb.append(" from  bn02, wlx02 ,bn01 "); 
            sb.append(" where bn02.bank_no = wlx02.bank_no(+) and bn02.bank_type in ('6','7' ) and bn02.bn_type <> '2' and bn02.TBANK_NO = bn01.BANK_NO) ");
            sb.append(" where hsien_id is not null and hsien_id <> ' ' ");
            sb.append(" union ");
            sb.append(" select 'Y',tbank_no,bank_no,bank_name,bank_type,ordertype ");
            sb.append(" from(select wlx01.hsien_id, bn01.bank_no as tbank_no,bn01.bank_no , bn01.bank_name, bn01.bank_type,'1' as ordertype ");  
            sb.append(" from  bn01, wlx01 ");  
            sb.append(" where bn01.bank_no = wlx01.bank_no(+) and bank_type in ('6','7') and bn_type <> '2' ");
            sb.append(" union ");
            sb.append(" select wlx02.hsien_id, bn02.tbank_no,bn02.bank_no , bn02.bank_name, bn02.bank_type,'2' as ordertype "); 
            sb.append(" from  bn02, wlx02 ,bn01 "); 
            sb.append(" where bn02.bank_no = wlx02.bank_no(+) and bn02.bank_type in ('6','7' ) and bn02.bn_type <> '2' and bn02.TBANK_NO = bn01.BANK_NO) ");
            sb.append(" where hsien_id is null");    
            String sqlCmd=sb.toString();
            System.out.println("Searching banks:"+sqlCmd);
    		List dbData = DBManager.QueryDB(sqlCmd,"");
            return dbData;
            */
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

	//取得狀態
    private List getLState(){
    		//查詢條件
    		String sqlCmd = " SELECT TO_CHAR(select_num) as select_num, select_name from mis_select where select_id='LOAL_STATES' order by select_num ";
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"");
            return dbData;
    }	
	
	//取得限制/核准機關
    private List getLMgr(){
    		//查詢條件
    		String sqlCmd = " SELECT TO_CHAR(select_num) as select_num, select_name from mis_select where select_id='LOAL_MANAGER'";
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"");
            return dbData;
    }	
    //取得查詢資料
    private List getQueryResult(HttpServletRequest request){
        String bankType = Utility.getTrimString(request.getParameter("bankType" ));
        String cityType =  Utility.getTrimString(request.getParameter("cityType" ));
        String tbank =  Utility.getTrimString(request.getParameter("tbank" ));//受限制機構
        String begDate =  Utility.getTrimString(request.getParameter("begDate" ));//函文日期-起始
        String endDate =  Utility.getTrimString(request.getParameter("endDate" ));//函文日期-結束        
        String loalState =  Utility.getTrimString(request.getParameter("loalState" ));//狀態
        String u_year = "99" ;
        if(!"".equals(begDate) && begDate.length() > 0 ) {
        	if(Integer.parseInt(begDate.substring(0,4)) > 2010 ){
        		u_year = "100" ;
        	}
        }else {
        	if(Integer.parseInt(Utility.getYear()) > 99 ){
        		u_year = "100" ;
        	}
        }
        System.out.println("begDate="+begDate);
        System.out.println("endDate="+endDate);
        System.out.println("loalState="+loalState);
        System.out.println("bankType="+bankType);
        System.out.println("cityType="+cityType);
        
    	request.setAttribute("loalState",loalState);
    	request.setAttribute("bankType",bankType);
    	request.setAttribute("cityType",cityType);        
    	request.setAttribute("begDate",begDate);
    	request.setAttribute("endDate",endDate);
		

    	//查詢條件 

    	StringBuffer sb=new StringBuffer();
    	List sqlList = new ArrayList() ;
    	sb.append(" select mis_loal.bank_no,ba01.bank_name,loal_number,loal_content,loal_states,select_name,loal_ps,loal_no ");
    	sb.append(" from mis_loal left join (select * from ba01 where m_year=? )ba01 on mis_loal.bank_no=ba01.bank_no"); 
    	sb.append(" left join (select * from mis_select where select_id='LOAL_STATES')mis_select");
    	sb.append(" on mis_loal.loal_states = mis_select.select_num ");
		sqlList.add(u_year) ;
		
        StringBuffer sb2=new StringBuffer();

    	if(!bankType.equals("")) {
            sb2.append((!sb2.toString().equals("")? " and":"")+" mis_loal.bank_no in (select BANK_NO  from ba01  where bank_type =  ? and m_year=? )");
            sqlList.add(bankType) ;
            sqlList.add(u_year) ;
        }
    	if(!cityType.equals("")) {
    		sb2.append((!sb2.toString().equals("")? " and":"")+" mis_loal.bank_no in (select BANK_NO  from WLX01  where HSIEN_ID =  ? and m_year=? ) ");
    		 sqlList.add(cityType) ;
             sqlList.add(u_year) ;
    	}
    	if(!tbank.equals("")) {
    		sb2.append((!sb2.toString().equals("")? " and":"")+" mis_loal.bank_no=? ");
    		sqlList.add(tbank) ;
    	}
    	if(!loalState.equals("")) {
    		sb2.append((!sb2.toString().equals("")? " and":"")+" loal_states =? ");
    		sqlList.add(loalState) ;
    	}
    	if(!begDate.equals("") && !endDate.equals("")){
    		sb2.append((!sb2.toString().equals("")? " and":"")+" TO_CHAR(loal_add_date, 'yyyymmdd') BETWEEN ? AND ? ");
    		sqlList.add(begDate) ;
    		sqlList.add(endDate) ;
    	}
        if(!begDate.equals(""))
    	  sb.append("where ").append(sb2.toString());
        
    	sb.append(" order by loal_add_date desc");
    	
    	
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),sqlList,"loal_no");
        System.out.println("dbData= "+dbData.size());

        return dbData;

    }

    // 取得單筆資料
    private DataObject getDetail(String loal_no,String begY ) {
        DataObject ob = null;
		String u_year = "99" ;
		if(!"".equals(begY) && Integer.parseInt(begY) > 99) {
			u_year = "100" ;
		}
        StringBuffer sb=new StringBuffer();
        List paramList = new ArrayList() ;
        sb.append(" select mis_loal.bank_no,ba01.bank_name,loal_no,");
        sb.append("((TO_CHAR(loal_add_date,'yyyy')-1911)||'/'|| TO_CHAR(loal_add_date,'mm/dd')) as loal_add_date,");
        sb.append("loal_manager,loal_number,decode(loal_open_flag,'Y','尚未開辦', decode(loal_open_date,null,'',((TO_CHAR(loal_open_date,'yyyy')-1911)||'/'|| TO_CHAR(loal_open_date,'mm/dd')))) as loal_open_date,loal_content,loal_states,loal_ps,loal_hide,loal_open_flag ");
        sb.append("from mis_loal left join (select * from ba01 where m_year = ? )ba01 on mis_loal.bank_no=ba01.bank_no "); 
        sb.append("left join (select * from mis_select where select_id='LOAL_STATES')mis_select ");
        sb.append("on mis_loal.loal_states = mis_select.select_num ");
        sb.append("where loal_no=? ");
        paramList.add(u_year) ;
        paramList.add(loal_no) ;
        

        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"loal_no");
        if(dbData.size() > 0) {
            ob = (DataObject)dbData.get(0);
        }
        return ob;
    }
    
    private String insertDataToDB(HttpServletRequest request, String loginID, String loginName) {
      String actMsg = "";
      String errMsg = "";
      String bankType = Utility.getTrimString(request.getParameter("bankType" ));//金融機構類別
      String tbank = Utility.getTrimString(request.getParameter("tbank" ));//受限制機構
      String loalAddDate = Utility.getTrimString(request.getParameter("loalAddDate" ));//函文日期    
      String loalMgr = Utility.getTrimString(request.getParameter("loalMgr" ));//限制機關
      String loalNum = Utility.getTrimString(request.getParameter("loalNum" ));//限制函號
      String loalContent = Utility.getTrimString(request.getParameter("loalContent" ));//函文內容
      String loalState = Utility.getTrimString(request.getParameter("loalState" ));//狀態
      String loalPs = Utility.getTrimString(request.getParameter("loalPs" ));//備註
      String loalNo = Utility.getTrimString(request.getParameter("loalNo" ));//序號
      String loalHide =Utility.getTrimString(request.getParameter("loalHide" ));//資料交檢查局與否
      String loalOpenDate = Utility.getTrimString(request.getParameter("loalOpenDate" ));//業務開辦日期
      String loalOpenFlag = Utility.getTrimString(request.getParameter("loalOpenFlag" ));//開辦與否

      System.out.println("loalopendate="+loalOpenDate);
      System.out.println("loalopenflag="+loalOpenFlag);
      //List insertDBSqlList = new LinkedList();        
      List paramList = new ArrayList() ;
      List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
      List updateDBSqlList = new ArrayList();
      List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
        try {
             StringBuffer sb=new StringBuffer();
             sb.append("Insert into MIS_LOAL values(?,?,?,"+"to_date(?,'YYYY/MM/DD'),");
             sb.append(" ?,?,?,SEQ_LOAL.NEXTVAL,?,sysdate,'',");
             paramList.add(loalNum) ;
             paramList.add(loalMgr) ;
             paramList.add(tbank) ;
             paramList.add(loalAddDate) ;
             paramList.add(loalContent) ;
             paramList.add(loalState) ;
             paramList.add(loalPs) ;
             paramList.add(loalHide) ;
             if(loalOpenDate.equals(""))
             {
            	 sb.append("'',?)");
                 paramList.add(loalOpenFlag) ;
             }
             else
             {
            	 sb.append(""+"to_date(?,'YYYY/MM/DD'),?)");
            	 paramList.add(loalOpenDate) ;
            	 paramList.add(loalOpenFlag) ;
             }
             
             updateDBSqlList.add(sb.toString()) ;
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
        String loalNo = Utility.getTrimString(request.getParameter("loalNo"));//序號
        String loalContent = Utility.getTrimString(request.getParameter("loalContent"));//函文內容
        String loalState =Utility.getTrimString(request.getParameter("loalState"));//狀態
        String loalPs = Utility.getTrimString(request.getParameter("loalPs"));//備註
        String loalHide = Utility.getTrimString(request.getParameter("loalHide"));//資料交檢查局與否
        String loalOpenDate =Utility.getTrimString(request.getParameter("loalOpenDate"));//業務開辦日期
                
		//List updateDBSqlList = new LinkedList();
		List paramList = new ArrayList() ;
	    List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
	    List updateDBSqlList = new ArrayList();
	    List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {
            // 檢查是否存在
            StringBuffer sqlCmd = new StringBuffer() ;
            sqlCmd.append( "select count(*) as count from MIS_LOAL where loal_no=? " );
            paramList.add(loalNo ) ;
            
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");
		    System.out.println("MIS_LOAL.size="+data.size());
			if(data.size() < 1) {
     	        errMsg = errMsg + "此筆資料不存在無法修改<br>";
                return errMsg;
            }
            /*寫入log檔中*/
            
			/*
			sqlCmd = "INSERT INTO MIS_VIOLATELAW_LOG "
		     	   +"select bank_type,bank_no,violate_date,title,content,law_content,"
		     	   +"user_id,user_name,update_date,'"
		     	   +loginID+"','"
		     	   +loginName+"',sysdate,'U' from MIS_VIOLATELAW where bank_no = '"+bank_no+"' AND TO_CHAR(violate_date,'yyyy/mm/dd') = '"+violate_date+"' ";                                                                                                
		    
		    updateDBSqlList.add(sqlCmd);  
            */
			sqlCmd.setLength(0) ;
            paramList.clear() ;
            
            sqlCmd.append(" UPDATE MIS_LOAL SET loal_content = ?,loal_states = ?,loal_ps = ?, ");
            sqlCmd.append(" loal_hide = ?,update_time = sysdate ");
            paramList.add(loalContent) ;
            paramList.add(loalState) ;
            paramList.add(loalPs) ;
            paramList.add(loalHide) ;
            
            if(!loalOpenDate.equals(""))
            {
            	sqlCmd.append(" ,loal_open_date=to_date(?,'YYYY/MM/DD'),loal_open_flag= ? ");
            	paramList.add(loalOpenDate) ;
            	paramList.add("N") ;
            }
            sqlCmd.append(" where loal_no = ? ");
            paramList.add(loalNo) ;
            
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
        String loalNo = Utility.getTrimString(request.getParameter("loalNo"));//序號
        List paramList = new ArrayList() ;
	    List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
	    List updateDBSqlList = new ArrayList();
	    List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {
			StringBuffer sqlCmd = new StringBuffer() ;
			 // 檢查是否存在
            sqlCmd.append("select count(*) as count from MIS_LOAL where loal_no = ? " );
			paramList.add(loalNo) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");
		    System.out.println("MIS_VIOLATELAW.size="+data.size());
			if(data.size() < 1) {
     	        errMsg = errMsg + "此筆資料不存在無法刪除<br>";
                return errMsg;
            }
			sqlCmd.setLength(0) ;
			paramList.clear() ;
             /*寫入log檔中*/
			/*
             sqlCmd = "INSERT INTO MIS_VIOLATELAW_LOG "
		     	   +"select bank_type,bank_no,violate_date,title,content,law_content,"
		     	   +"user_id,user_name,update_date,'"
		     	   +loginID+"','"
		     	   +loginName+"',sysdate,'D' from MIS_VIOLATELAW where bank_no = '"+bank_no+"' AND TO_CHAR(violate_date,'yyyy/mm/dd') = '"+violate_date+"' ";                                                                                                		    
		    
            DBSqlList.add(sqlCmd);
           
            */
            
            sqlCmd.append(" DELETE FROM MIS_LOAL where loal_no = ? " );
            paramList.add(loalNo ) ;
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
