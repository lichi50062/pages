<%
//98.06.08 個別農漁會解釋函令查詢--by 2756
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
	String begY = Utility.getTrimString(request.getParameter("begY")) ;
	System.out.println("Page: MC011W.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );

	    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
            rd = application.getRequestDispatcher( LoginErrorPgName );
	    } else {
    	if(act.equals("List") || act.equals("Qry") || act.equals("Edit") ||  act.equals("New")) {    	    
            request.setAttribute("TBank", getTatolBankType());           
            request.setAttribute("City", Utility.getCity());
    	    request.setAttribute("DType",getDType());
    	    request.setAttribute("DBType",getDBType());

    	    if(act.equals("List")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName +"?act=List");
    	    } else if(act.equals("Edit") || act.equals("New")) {    	       
    	        if(act.equals("New")) {    	          
    	            rd = application.getRequestDispatcher( EditPgName +"?act=New");
    	        }else{
    	            String dffe_No = request.getParameter("dffeNo") != null ? request.getParameter("dffeNo") : "";
    	            request.setAttribute("DETAIL",getDetail(dffe_No,begY));    	           
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit");
    	        }
    	    } else if(act.equals("Qry")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName +"?act=Qry");  
    	    }     	    
        } 
    	else if(act.equals("Insert")){
    	    actMsg = insertDataToDB(request,userId,userName);
    	    request.setAttribute("actMsg",actMsg); 
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=MC011W.jsp&act=List");        	
        } else if(act.equals("Update")){
            actMsg = updateDataToDB(request,userId,userName);                   
            rd = application.getRequestDispatcher( nextPgName+"?goPages=MC011W.jsp&act=List");         	
        } else if(act.equals("Delete")){
    	    actMsg = deleteDataToDB(request,userId,userName);
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=MC011W.jsp&act=List");
        }        
    	request.setAttribute("actMsg",actMsg);
      }

%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "MC011W" ;
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

	
	
	//取得業務類別
    private List getDType(){
    		//查詢條件
    		String sqlCmd = " select select_num,select_name from mis_select where select_id='DFFE_TYPE'  order by select_num";
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"select_num");
            return dbData;
    }	
	
	//取得機構類別
    private List getDBType(){
    		//查詢條件
    		String sqlCmd = " select select_num,select_name from mis_select where select_id='LOAL_B_TYPE' order by select_num";
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"select_num");
            return dbData;
    }	
    //取得查詢資料
    private List getQueryResult(HttpServletRequest request){
        String bankType = Utility.getTrimString(request.getParameter("bankType" ));//金融機構類別
        String cityType = Utility.getTrimString(request.getParameter("cityType" ));//縣市別
        String tbank = Utility.getTrimString(request.getParameter("tbank" ));//發文對象
        String begDate = Utility.getTrimString(request.getParameter("begDate" ));//發文日期-起始
        String endDate = Utility.getTrimString(request.getParameter("endDate" ));//發文日期-結束        
        String dffeTypeQry[]= request.getParameterValues("dffeTypeQry" );//業務類別
        String dffeBTypeQry[] = request.getParameterValues("dffeBTypeQry" );//機構類別
        String dffeTitle= Utility.getTrimString(request.getParameter("dffeTitle" ));//主旨
        String dffeContent= Utility.getTrimString(request.getParameter("dffeContent" ));//內容
		
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
        
        String dfTypeQry="";
        String dfBTypeQry="";
        if(dffeTypeQry!=null)
        	dfTypeQry=getReqStr(dffeTypeQry); //取得回傳的checkbox資料
        if(dffeBTypeQry!=null)
        	dfBTypeQry=getReqStr(dffeBTypeQry);        
        
        System.out.println("begDate="+begDate);
        System.out.println("endDate="+endDate);      
        System.out.println("bankType="+bankType);
        System.out.println("cityType="+cityType);

    	request.setAttribute("bankType",bankType);
    	request.setAttribute("cityType",cityType);        
    	request.setAttribute("tbank",tbank);
    	request.setAttribute("begDate",begDate);
    	request.setAttribute("endDate",endDate);

    	//查詢條件 
    	StringBuffer sb=new StringBuffer();
    	List paramList = new ArrayList() ;
    	sb.append("select dffe_number,((TO_CHAR(dffe_date,'yyyy')-1911)||'/'|| TO_CHAR(dffe_date,'mm/dd')) as dffe_date,dffe_title,dffe_content,dffe_no");     	
    	sb.append(" from mis_dffe left join (select * from ba01 where m_year=? )ba01 on mis_dffe .bank_no=ba01.bank_no"); 
    	paramList.add(u_year) ;

        StringBuffer sb2=new StringBuffer();

    	if(!bankType.equals("")) 
    	{
            sb2.append((!sb2.toString().equals("")? " and":"")+" mis_dffe.bank_no in (select bank_no  from ba01  where bank_type = ? and m_year =?  )");
            paramList.add(bankType) ;
            paramList.add(u_year) ;

        }
    	if(!cityType.equals("")) 
    	{
    		sb2.append((!sb2.toString().equals("")? " and":"")+" mis_dffe.bank_no in (select bank_no from wlx01  where HSIEN_ID =? and m_year=? union select bank_no from wlx02 where  HSIEN_ID = ? and m_year=? )");
    		paramList.add(cityType) ;
    		paramList.add(u_year) ;
    		paramList.add(cityType) ;
    		paramList.add(u_year) ;
    	}
    	if(!tbank.equals("")) 
    	{
    	    sb2.append((!sb2.toString().equals("")? " and":"")+" mis_dffe.bank_no = ? ");
    	    paramList.add(tbank) ;
    	}
    	if(!begDate.equals("") && !endDate.equals(""))
    	{
    	    sb2.append((!sb2.toString().equals("")? " and":"")+" TO_CHAR(dffe_date, 'yyyymmdd') BETWEEN ? AND ? ");
    	    paramList.add(begDate) ;
    		paramList.add(endDate) ;
    	}
    	if(!dfTypeQry.equals(""))
    	{
    		sb2.append((!sb2.toString().equals("")? " and":"")+" dffe_type in ("+dfTypeQry+")");
    	}
    	if(!dfBTypeQry.equals(""))
    	{
    		sb2.append((!sb2.toString().equals("")? " and":"")+" dffe_b_type in ("+dfBTypeQry+")");
    	}
    	if(!dffeTitle.equals("")) 
    	{
    	    sb2.append((!sb2.toString().equals("")? " and":"")+" dffe_title like ? ");
    	    paramList.add("%"+dffeTitle+"%") ;
    	}
    	if(!dffeContent.equals("")) 
    	{
    	    sb2.append((!sb2.toString().equals("")? " and":"")+" dffe_content like ? ");
    	    paramList.add("%"+dffeContent+"%") ;
    	}
        if(!sb2.toString().equals(""))
        {
          sb.append(" where ").append(sb2.toString());
        }
 
    	sb.append(" order by dffe_date desc");
    	
    	List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"dffe_no");
        System.out.println("dbData= "+dbData.size());
        return dbData;
    }
    //98.06.08  將checkbox選項值變成 ('a','b','c'....)的型式以供sql查詢
    private String getReqStr(String[] arr)
    {
    	int size=java.lang.reflect.Array.getLength(arr);
    	String sbStr;
    	StringBuffer sb=new StringBuffer(),sb2=new StringBuffer();
    	for (int i=0;i<size-1;i++) 
    	{ 
    	  sb.append("'"+arr[i]+"',");
    	} 
    	sb.append("'"+arr[size-1]+"'");
    	sbStr=sb.toString();
    	return sbStr;
    }
    // 取得單筆資料
    private DataObject getDetail(String dffe_no,String begY) {
        DataObject ob = null;
        String u_year = "99" ;
		if(!"".equals(begY) && Integer.parseInt(begY) > 99) {
			u_year = "100" ;
		}
        StringBuffer sb=new StringBuffer();
        List paramList = new ArrayList() ;
        sb.append(" select mis_dffe.bank_no,ba01.bank_name,((TO_CHAR(dffe_date,'yyyy')-1911)||'/'|| TO_CHAR(dffe_date,'mm/dd')) as dffe_date,dffe_number,dffe_no,");
        sb.append(" dffe_title,dffe_content,dffe_type,mis_select.select_name as dffe_type_name,dffe_b_type,mis_select1.select_name as dffe_b_type_name,dffe_hide");
        sb.append(" from mis_dffe left join (select * from ba01 where m_year=?)ba01 on mis_dffe.bank_no=ba01.bank_no");
        sb.append(" left join (select * from mis_select where select_id=? )mis_select");
        sb.append(" on mis_dffe.dffe_type = mis_select.select_num");
        sb.append(" left join (select * from mis_select where select_id=? )mis_select1");
        sb.append(" on mis_dffe.dffe_b_type = mis_select1.select_num");        
        sb.append(" where dffe_no=? ");
        paramList.add(u_year) ; 
        paramList.add("DFFE_TYPE") ; 
        paramList.add("LOAL_B_TYPE") ; 
        paramList.add(dffe_no) ; 
        
        

        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"dffe_no");
        if(dbData.size() > 0) {
            ob = (DataObject)dbData.get(0);
        }
        return ob;
    }
    
    private String insertDataToDB(HttpServletRequest request, String loginID, String loginName) {
      String actMsg = "";
      String errMsg = "";
      String bankType = Utility.getTrimString(request.getParameter("bankType" ));//金融機構類別
      String tbank = Utility.getTrimString(request.getParameter("tbank" ));//發文對象機構代碼
      String dffeDate = Utility.getTrimString(request.getParameter("dffeDate" ));//發文日期    
      String dffeNum = Utility.getTrimString(request.getParameter("dffeNum" ));//發文文號      
      String dffeTitle = Utility.getTrimString(request.getParameter("dffeTitle" ));//函令主旨
      String dffeContent = Utility.getTrimString(request.getParameter("dffeContent" ));//內容
      
      String dffeType =Utility.getTrimString(request.getParameter("dffeType" ));//業務類別
      String dffeBType = Utility.getTrimString(request.getParameter("dffeBType" ));//機構類別
      String dffeNo =Utility.getTrimString(request.getParameter("dffeNo" ));//序號
      String dffeHide = Utility.getTrimString(request.getParameter("dffeHide" ));//資料交檢查局與否
            
      List paramList = new ArrayList() ;
      List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
      List updateDBSqlList = new ArrayList();
      List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
        
        try {
             StringBuffer sb=new StringBuffer();
             sb.append("Insert into MIS_DFFE values(?,"+"to_date(?,'YYYY/MM/DD'),?,?,");
             sb.append("?,?,?,SEQ_DFFE.NEXTVAL,?,sysdate,'')");
             paramList.add(tbank) ;
             paramList.add(dffeDate) ;
             paramList.add(dffeNum) ;
             paramList.add(dffeTitle) ;
             paramList.add(dffeContent) ;
             paramList.add(dffeType) ;
             paramList.add(dffeBType) ;
             paramList.add(dffeHide) ;
             String sqlCmd=sb.toString();
             
             //insertDBSqlList.add(sqlCmd);
			 updateDBSqlList.add(sb.toString()) ;
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
        String dffeNo = Utility.getTrimString(request.getParameter("dffeNo")) ;//序號
        String dffeTitle = Utility.getTrimString(request.getParameter("dffeTitle"));//主旨
        String dffeContent = Utility.getTrimString(request.getParameter("dffeContent"));//內容
        String dffeType = Utility.getTrimString(request.getParameter("dffeType"));//業務類別
        String dffeBType = Utility.getTrimString(request.getParameter("dffeBType"));//機構類別
        String dffeHide = Utility.getTrimString(request.getParameter("dffeHide"));//資料交檢查局與否
                
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;

	    try {
            // 檢查是否存在
            StringBuffer sqlCmd = new StringBuffer() ;
            sqlCmd.append("select count(*) as count from MIS_DFFE where dffe_no=? " );
            paramList.add(dffeNo ) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");
		    System.out.println("MIS_LOAL.size="+data.size());
			if(data.size() < 1) {
     	        errMsg = errMsg + "此筆資料不存在無法修改<br>";
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
		     	   +loginName+"',sysdate,'U' from MIS_VIOLATELAW where bank_no = '"+bank_no+"' AND TO_CHAR(violate_date,'yyyy/mm/dd') = '"+violate_date+"' ";                                                                                                
		    
		    updateDBSqlList.add(sqlCmd);  
            */
			sqlCmd.append(" UPDATE MIS_DFFE SET dffe_title = ?,dffe_content =?,dffe_type =?, ");
            sqlCmd.append(" dffe_b_type =?, dffe_hide=?,update_time = sysdate where dffe_no = ? ");
            paramList.add(dffeTitle) ;
            paramList.add(dffeContent) ;
            paramList.add(dffeType) ;
            paramList.add(dffeBType) ;
            paramList.add(dffeHide) ;
            paramList.add(dffeNo) ;
            
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
        String dffeNo = Utility.getTrimString(request.getParameter("dffeNo")) ;//序號
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
	    try {
			// 檢查是否存在
			StringBuffer sqlCmd = new StringBuffer() ;
			
            sqlCmd.append("select count(*) as count from MIS_DFFE where dffe_no =? " );
            paramList.add(dffeNo) ;
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
            
            sqlCmd.append(" DELETE FROM MIS_DFFE where dffe_no = ? " );
            paramList.add(dffeNo) ;
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
