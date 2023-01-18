<%
//98.06.10 處分書查詢--by 2756
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
	
	System.out.println("Page: MC013W.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );


	    if(!Utility.CheckPermission(request,"MC013W")){//無權限時,導向到LoginError.jsp
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
    	            String ap_No = Utility.getTrimString(request.getParameter("apNo"));
    	            request.setAttribute("DETAIL",getDetail(ap_No,begY));    	           
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit");
    	        }
    	    } else if(act.equals("Qry")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName +"?act=Qry");  
    	    }     	    
        } else if(act.equals("Insert")){
    	    actMsg = insertDataToDB(request,userId,userName);
    	    request.setAttribute("actMsg",actMsg); 
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=MC013W.jsp&act=List");        	
        } else if(act.equals("Update")){
            actMsg = updateDataToDB(request,userId,userName);                   
            rd = application.getRequestDispatcher( nextPgName+"?goPages=MC013W.jsp&act=List");         	
        } else if(act.equals("Delete")){
    	    actMsg = deleteDataToDB(request,userId,userName);
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=MC013W.jsp&act=List");
        }        
    	request.setAttribute("actMsg",actMsg);
      }

%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "MC013W" ;
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
        String bankType = Utility.getTrimString(request.getParameter("bankType" ));//金融機構類別
        String cityType =Utility.getTrimString(request.getParameter("cityType" ));//縣市別
        String tbank =Utility.getTrimString(request.getParameter("tbank" ));//受處分機構
        String begDate =Utility.getTrimString(request.getParameter("begDate" ));//受處分日期-起始
        String endDate =Utility.getTrimString(request.getParameter("endDate" ));//受處分日期-結束        
        String apName=Utility.getTrimString(request.getParameter("apName" ));//受處分人
       
   
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
        System.out.println("bankType="+bankType);
        System.out.println("cityType="+cityType);
        System.out.println("apName="+apName);

    	request.setAttribute("bankType",bankType);
    	request.setAttribute("cityType",cityType);        
    	request.setAttribute("tbank",tbank);
    	request.setAttribute("begDate",begDate);
    	request.setAttribute("endDate",endDate);
    	request.setAttribute("apName",apName);

    	//查詢條件 
    	StringBuffer sb=new StringBuffer();
    	List paramList = new ArrayList() ;
    	sb.append(" select ((TO_CHAR(ap_date,'yyyy')-1911)||'/'||TO_CHAR(ap_date,'mm/dd')) as ap_date,mis_ap.bank_no,ba01.bank_name,ap_name,ap_title,ap_no");     	
    	sb.append(" from mis_ap left join (select * from ba01 where m_year=?) ba01 on mis_ap.bank_no=ba01.bank_no"); 
		paramList.add(u_year) ;
        StringBuffer sb2=new StringBuffer();

    	if(!bankType.equals("")) 
    	{
            sb2.append((!sb2.toString().equals("")? " and":"")+" mis_ap.bank_no in (select bank_no  from ba01  where bank_type = ? and m_year=? )");
            paramList.add(bankType)  ;
            paramList.add(u_year) ;
        }
    	if(!cityType.equals("")) 
    	{
    		sb2.append((!sb2.toString().equals("")? " and":"")+" mis_ap.bank_no in (select bank_no from wlx01  where HSIEN_ID =? and m_year=? union select bank_no from wlx02 where  HSIEN_ID = ? and m_year=?)");
    		paramList.add(cityType)  ;
            paramList.add(u_year) ;
            paramList.add(cityType)  ;
            paramList.add(u_year) ;
    	}
    	if(!tbank.equals("")) 
    	{
    	    sb2.append((!sb2.toString().equals("")? " and":"")+" mis_ap.bank_no =?");
    	    paramList.add(tbank) ;
    	}
    	if(!apName.equals(""))
    	{
    		sb2.append((!sb2.toString().equals("")? " and":"")+" mis_ap.ap_name = ? ");
    		paramList.add(apName) ;
    	}
    	if(!begDate.equals("") && !endDate.equals(""))
    	{
    	    sb2.append((!sb2.toString().equals("")? " and":"")+" TO_CHAR(ap_date, 'yyyymmdd') BETWEEN ? AND ? ");
    	    paramList.add(begDate) ;
    	    paramList.add(endDate) ;
    	}
        if(!sb2.toString().equals(""))
        {
          sb.append(" where ").append(sb2.toString());
        }
 
    	sb.append(" order by ap_date desc");
    	
    	List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"ap_No");
    	
        paramList.clear() ;
        return dbData;
    }

    // 取得單筆資料
    private DataObject getDetail(String ap_No,String begY) {
        DataObject ob = null;
        String u_year = "99" ;
		if(!"".equals(begY) && Integer.parseInt(begY) > 99) {
			u_year = "100" ;
		}
        StringBuffer sb=new StringBuffer();
        List paramList = new ArrayList() ;
        sb.append(" select mis_ap.bank_no,ba01.bank_name,mis_ap.ap_name,((TO_CHAR(ap_date,'yyyy')-1911)||'/'||TO_CHAR(ap_date,'mm/dd')) as ap_date,ap_no,");
        sb.append(" ap_title,ap_content,ap_laws,ap_ps,ap_hide");
        sb.append(" from mis_ap left join (select * from ba01 where m_year=? )ba01 on mis_ap.bank_no=ba01.bank_no");    
        sb.append(" where ap_No=? ");   
        paramList.add(u_year) ;
        paramList.add(ap_No) ;
        

        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"ap_No");
        if(dbData.size() > 0) {
            ob = (DataObject)dbData.get(0);
        }
        paramList.clear() ;
        return ob;
    }
    
    private String insertDataToDB(HttpServletRequest request, String loginID, String loginName) {
      String actMsg = "";
      String errMsg = "";
      String bankType = Utility.getTrimString(request.getParameter("bankType" ));//金融機構類別
      String tbank = Utility.getTrimString(request.getParameter("tbank" ));//受處分機關代碼
      String apName = Utility.getTrimString(request.getParameter("apName" ));//受處分人
      String apDate = Utility.getTrimString(request.getParameter("apDate" ));//受處分日期    
      String apTitle =Utility.getTrimString(request.getParameter("apTitle" ));//主旨文號      
      String apContent =Utility.getTrimString(request.getParameter("apContent" ));//事實及理由      
      String apLaw =Utility.getTrimString(request.getParameter("apLaw" ));//法令依據
      String apPs = Utility.getTrimString(request.getParameter("apPs" ));//注意事項
      String apNo = Utility.getTrimString(request.getParameter("apNo" ));//序號
      String apHide = Utility.getTrimString(request.getParameter("apHide" ));//資料交檢查局與否
            
      List paramList = new ArrayList() ;
      List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
      List updateDBSqlList = new ArrayList();
      List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
        
        try {
             StringBuffer sb=new StringBuffer();
             sb.append("Insert into MIS_AP values(?,?,"+"to_date(?,'YYYY/MM/DD'),?,?,?,?,SEQ_AP.NEXTVAL,?,sysdate,'')");
             paramList.add(tbank) ;
             paramList.add(apName) ;
             paramList.add(apDate) ;
             paramList.add(apTitle) ;
             paramList.add(apContent) ;
             paramList.add(apLaw) ;
             paramList.add(apPs) ;
             paramList.add(apHide) ;
             
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
        String apNo = Utility.getTrimString(request.getParameter("apNo"));//序號
        String apTitle = Utility.getTrimString(request.getParameter("apTitle"));//主旨
        String apContent = Utility.getTrimString(request.getParameter("apContent"));//內容
        String apLaw = Utility.getTrimString(request.getParameter("apLaw"));//事實及理由
        String apPs = Utility.getTrimString(request.getParameter("apPs"));//注意事項
        String apHide = Utility.getTrimString(request.getParameter("apHide"));//資料交檢查局與否
        String apName = Utility.getTrimString(request.getParameter("apName"));//受處分人
                
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;

	    try {
            // 檢查是否存在
            StringBuffer sqlCmd  = new StringBuffer() ;
            sqlCmd.append( "select count(*) as count from MIS_AP where ap_no=? " );
            paramList.add(apNo) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");
		    System.out.println("MIS_AP.size="+data.size());
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
			sqlCmd.append(" UPDATE MIS_AP SET ap_content = ?,ap_hide =?,ap_title=?,ap_laws=?,ap_ps=?,ap_name=?,update_time = sysdate where ap_No = ? ");
            paramList.add(apContent) ;
            paramList.add(apHide) ;
            paramList.add(apTitle) ;
            paramList.add(apLaw) ;
            paramList.add(apPs) ;
            paramList.add(apName) ;
            paramList.add(apNo) ;
            
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
        String apNo = Utility.getTrimString(request.getParameter("apNo") );//序號
        
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
	    try {
			 // 檢查是否存在
			 StringBuffer sqlCmd = new StringBuffer() ;
             sqlCmd.append("select count(*) as count from MIS_AP where ap_no = ? " );
             paramList.add(apNo) ;
             
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
            
            sqlCmd.append( " DELETE FROM MIS_AP where ap_no = ? " );
            paramList.add(apNo) ;
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
