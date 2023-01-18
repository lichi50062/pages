<%
//98.06.18 檢舉書查詢--by 2756
//98.10.16 fix 只取得總機構名稱 by 2295
//99.05.28 fix 縣市合併調整&sql injection by 2808
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
	
	System.out.println("Page: MC014W.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );
	String flag= Utility.getTrimString(dataMap.get("flag"));//判斷為那一種查詢狀態(R:發文,B:回文,"":檢舉書)
	String item= Utility.getTrimString(dataMap.get("item"));//判斷是否已為查詢狀態下的table資料("1":發文,"2":回文,"3":檢舉書)
	String Report_no= Utility.getTrimString(dataMap.get("Report_no"));
		
	System.out.println("Page: MC014W.jsp    flag:"+flag+"    LoginID:"+userId+"    UserName:"+userName );
	System.out.println("Page: MC014W.jsp    item:"+item+"    LoginID:"+userId+"    UserName:"+userName );
	System.out.println("Page: MC014W.jsp    Report_no:"+Report_no+"    LoginID:"+userId+"    UserName:"+userName );

    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
           rd = application.getRequestDispatcher( LoginErrorPgName );
    } else {
    	if(act.equals("List") ||act.equals("Qry") || act.equals("Edit") ||  act.equals("New")) {    	    
    		request.setAttribute("TBank", getTatolBankType());           
    	    request.setAttribute("City", Utility.getCity());

    	    if(act.equals("Edit") || act.equals("New")) {
    	        if(act.equals("New")) {    	          
    	            rd = application.getRequestDispatcher( EditPgName +"?act=New");
    	        }else{
    	            String ta_No = request.getParameter("taNo") != null ? request.getParameter("taNo") : "";
    	            request.setAttribute("DETAIL",this.getDetail(ta_No,begY));    	               	           
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit&flag="+flag+"&item="+item+"");
    	        }
    	    } 
    	    else if(act.equals("Qry")) 
    	    {
    	        request.setAttribute("QueryResult",getQueryResult(request,flag));
    	        if(Report_no.equals(""))//一般查詢
    	        {
    	            rd = application.getRequestDispatcher( ListPgName +"?act=Qry&flag="+flag+"");
    	        }
    	        else //增改刪動作完成後回到那一個查詢頁(Report_no--N:受理,R:發文,B:回文,"":檢舉書)
    	        {
    	        	rd = application.getRequestDispatcher( ListPgName +"?act=Qry&flag="+Report_no+"");
    	        }
    	    }     	    
        } else if(act.equals("Insert")){
    	    actMsg = insertDataToDB(request,userId,userName);
    	    request.setAttribute("actMsg",actMsg); 
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=MC014W.jsp&act=Qry&Report_no=N");        	
        } else if(act.equals("Update")){
            actMsg = updateDataToDB(request,userId,userName,flag);
            rd = application.getRequestDispatcher( nextPgName+"?goPages=MC014W.jsp&act=Qry&Report_no="+flag+"");
        } else if(act.equals("Delete")){
    	    actMsg = deleteDataToDB(request,userId,userName);
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=MC014W.jsp&act=Qry&Report_no="+flag+"");
        }        
    	request.setAttribute("actMsg",actMsg);
      }
    
	

%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "MC014W" ;
private final static String nextPgName = "/pages/ActMsg.jsp";
private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
private final static String LoginErrorPgName = "/pages/LoginError.jsp";

    //取得所有總機構資料
    private List getTatolBankType(){//查詢條件
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
    private List getQueryResult(HttpServletRequest request,String parFlag){
        String bankType = Utility.getTrimString(request.getParameter("bankType" ));//金融機構類別
        String cityType = Utility.getTrimString(request.getParameter("cityType" ));//縣市別
        String tbank = Utility.getTrimString(request.getParameter("tbank" ));//被檢舉機構
        String begDate = Utility.getTrimString(request.getParameter("begDate" ));//受理日期-起始
        String endDate = Utility.getTrimString(request.getParameter("endDate" ));//受理日期-結束
        String begDate1 = Utility.getTrimString(request.getParameter("begDate1" ));//發文日期-起始
        String endDate1 = Utility.getTrimString(request.getParameter("endDate1" ));//發文日期-結束
        String begDate2 = Utility.getTrimString(request.getParameter("begDate2" ));//回文日期-起始
        String endDate2 = Utility.getTrimString(request.getParameter("endDate2" ));//回文日期-結束
        String taContent = Utility.getTrimString(request.getParameter("taContent" ));//檢舉內容
		
        
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
        
        System.out.println("bankType="+bankType);
        System.out.println("cityType="+cityType);
        System.out.println("begDate="+begDate);
        System.out.println("endDate="+endDate); 
        System.out.println("begDate1="+begDate1);
        System.out.println("endDate1="+endDate1);      
        System.out.println("begDate2="+begDate2);
        System.out.println("endDate2="+endDate2);
        
        //設定屬性以利後續存取
    	request.setAttribute("bankType",bankType);
    	request.setAttribute("cityType",cityType);        
    	request.setAttribute("tbank",tbank);
    	request.setAttribute("begDate",begDate);
    	request.setAttribute("endDate",endDate);
    	request.setAttribute("begDate1",begDate1);
    	request.setAttribute("endDate1",endDate1);
    	request.setAttribute("begDate2",begDate2);
    	request.setAttribute("endDate2",endDate2);

    	//查詢條件 
    	StringBuffer sb=new StringBuffer();
    	List paramList = new ArrayList() ;
    	sb.append(" select ta_number,ta_reporter,mis_ta.bank_no,ba01.bank_name,((TO_CHAR(ta_date,'yyyy')-1911)||'/'||TO_CHAR(ta_date,'mm/dd')) as ta_date,ta_content,ta_no,");
    	sb.append(" ta_publicnum,((TO_CHAR(ta_publicdate,'yyyy')-1911)||'/'||TO_CHAR(ta_publicdate,'mm/dd')) as ta_publicdate,ta_publiccontent");
    	sb.append(" from mis_ta left join (select * from ba01 where m_year=? ) ba01 on mis_ta.bank_no=ba01.bank_no");
    	paramList.add(u_year) ;

        StringBuffer sb2=new StringBuffer();

    	if(!bankType.equals("")) 
    	{
            sb2.append((!sb2.toString().equals("")? " and":"")+" mis_ta.bank_no in (select bank_no  from ba01  where bank_type = ? and m_year=?)");
            paramList.add(bankType) ;
            paramList.add(u_year) ;
        }
    	if(!cityType.equals("")) 
    	{
    		sb2.append((!sb2.toString().equals("")? " and":"")+" mis_ta.bank_no in (select bank_no from wlx01  where HSIEN_ID = ? and m_year=? union select bank_no from wlx02 where  HSIEN_ID = ? and m_year=?)");
    		 paramList.add(cityType) ;
             paramList.add(u_year) ;
             paramList.add(cityType) ;
             paramList.add(u_year) ;
    	}
    	if(!tbank.equals("")) 
    	{
    	    sb2.append((!sb2.toString().equals("")? " and":"")+" mis_ta.bank_no = ? ");
    	    paramList.add(tbank) ;
    	}
    	if(!begDate.equals("") && !endDate.equals(""))
    	{
    	    sb2.append((!sb2.toString().equals("")? " and":"")+" TO_CHAR(ta_date, 'yyyymmdd') BETWEEN ? AND ?");
    	    paramList.add(begDate);
    	    paramList.add(endDate);
    	}
    	//回文及檢舉書 才有的日期區間查詢
    	if((!begDate1.equals("") && !endDate1.equals(""))&& (parFlag.equals("B")||parFlag.equals("")))
    	{
    		sb2.append((!sb2.toString().equals("")? " and":"")+" TO_CHAR(ta_publicdate, 'yyyymmdd') BETWEEN ? AND ? ");
    		paramList.add(begDate1);
    		paramList.add(endDate1);
    	}
    	//檢舉書 才有的日期區間查詢
    	if((!begDate2.equals("") && !endDate2.equals(""))&&parFlag.equals(""))
    	{
    		sb2.append((!sb2.toString().equals("")? " and":"")+" TO_CHAR(ta_bakdate, 'yyyymmdd') BETWEEN ? AND ? ");
    		paramList.add(begDate2);
    		paramList.add(endDate2);
    	}
    	//檢舉書 才有的檢舉內容查詢
    	if(!taContent.equals("")&& parFlag.equals(""))
    	{
    		sb2.append((!sb2.toString().equals("")? " and":"")+" to_char(mis_ta.ta_content) like ? ");
    		paramList.add("%"+taContent+"%");
    	}
        if(!sb2.toString().equals(""))
        {
          sb.append(" where ").append(sb2.toString());
        }
        //受理或發文或檢舉書時依收文日期排序
    	if(parFlag.equals("R")||parFlag.equals("")||parFlag.equals("N"))
    	{
    		sb.append(" order by ta_date desc");
    	}
        //回文時依發文日期排序
    	else if(parFlag.equals("B"))
    	{
    		sb.append(" order by ta_publicdate desc");
    	}
		
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"");
        System.out.println("dbData= "+dbData.size());
        return dbData;
    }

    // 取得單筆資料
    private DataObject getDetail(String ta_no,String begY) 
    {
        DataObject ob = null;
        String u_year = "99" ;
		if(!"".equals(begY) && Integer.parseInt(begY) > 99) {
			u_year = "100" ;
		}
        StringBuffer sb=new StringBuffer();
        List paramList = new ArrayList() ;
        sb.append(" select ta_number,ta_reporter,mis_ta.bank_no || ba01.bank_name as bank_name,((TO_CHAR(ta_date,'yyyy')-1911)||'/'||TO_CHAR(ta_date,'mm/dd')) as ta_date,ta_content,");
        sb.append(" ta_ps,ta_hide,ta_no,ta_publicnum,((TO_CHAR(ta_publicdate,'yyyy')-1911)||'/'||TO_CHAR(ta_publicdate,'mm/dd')) as ta_publicdate,ta_publiccontent,ta_backnum,");
        sb.append(" decode(ta_bakdate,'','',((TO_CHAR(ta_bakdate, 'yyyy')-1911)||'/'||TO_CHAR(ta_bakdate,'mm/dd'))) as ta_bakdate,ta_backresult");
        sb.append(" from mis_ta left join (select * from ba01 where m_year=? )ba01 on mis_ta.bank_no=ba01.bank_no");    
        sb.append(" where ta_no=? ");       
        paramList.add(u_year) ;
		paramList.add(ta_no) ;
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"");
        if(dbData.size() > 0) {
            ob = (DataObject)dbData.get(0);
        }
        return ob;

    }
    
    private String insertDataToDB(HttpServletRequest request, String loginID, String loginName) {
    	System.out.println("action is insertDataToDB===");
      String actMsg = "";
      String errMsg = "";
      String bankType = Utility.getTrimString(request.getParameter("bankType" ));//金融機構類別
      String tbank =  Utility.getTrimString(request.getParameter("tbank" ));//被檢舉機構代碼
      String taNum =  Utility.getTrimString(request.getParameter("taNum" ));//收文文號 
      String taRptr =  Utility.getTrimString(request.getParameter("taRptr" ));//檢舉人   
      String taContent =  Utility.getTrimString(request.getParameter("taContent" ));//檢舉內容   
      String taDate =  Utility.getTrimString(request.getParameter("taDate" ));//受理收文日期
      String taPs =  Utility.getTrimString(request.getParameter("taPs" ));//備註
      String taHide =  Utility.getTrimString(request.getParameter("taHide" ));//資料交檢查局與否
            
      List paramList = new ArrayList() ;
      List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
      List updateDBSqlList = new ArrayList();
      List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
        
        try {
             StringBuffer sb=new StringBuffer();
             sb.append("Insert into MIS_TA values(?,?,?,?,"+"to_date(?,'YYYY/MM/DD'),'','','','','','',?,SEQ_TA.NEXTVAL,'','',?,sysdate,'')");
             paramList.add(taNum) ;
             paramList.add(taRptr) ;
             paramList.add(tbank) ;
             paramList.add(taContent) ;
             paramList.add(taDate) ;
             paramList.add(taPs);
             paramList.add(taHide) ;
             
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

	private String updateDataToDB(HttpServletRequest request, String loginID, String loginName, String flag) {
	    String actMsg = "";
        String errMsg = "";
        String taNo = Utility.getTrimString(request.getParameter("taNo"));//序號
        String taPubNum =  Utility.getTrimString(request.getParameter("taPubNum"));//發文文號
        String taPubDate =  Utility.getTrimString(request.getParameter("taPubDate"));//發文日期
        String taPubContent =  Utility.getTrimString(request.getParameter("taPubContent"));//本局處理情形
        String taContent =  Utility.getTrimString(request.getParameter("taContent"));//檢舉內容
        String taHide =  Utility.getTrimString(request.getParameter("taHide"));//資料是否交予檢查局
        String taBkNum =  Utility.getTrimString(request.getParameter("taBkNum"));//回文文號
        String taBkDate =  Utility.getTrimString(request.getParameter("taBkDate"));//回文日期
        String taBkResult =  Utility.getTrimString(request.getParameter("taBkResult"));//處理情形
        String taRptr =  Utility.getTrimString(request.getParameter("taRptr"));//序號
        String bank_no =  Utility.getTrimString(request.getParameter("bank_no"));//機構編號
        String taNum =  Utility.getTrimString(request.getParameter("taNum"));//收文文號
        String taDate =  Utility.getTrimString(request.getParameter("taDate"));//收文日期
        String taPs =  Utility.getTrimString(request.getParameter("taPs"));//備註

        
                
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;

	    try {
            // 檢查是否存在
            StringBuffer sqlCmd = new StringBuffer() ;
            sqlCmd.append( "select count(*) as count from MIS_TA where ta_no=? " );
            paramList.add(taNo) ; 
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

            System.out.println("flag="+flag);
            if(flag.equals("R")){
            	sqlCmd.append(" UPDATE MIS_TA ");
            	sqlCmd.append(" SET ta_publicnum = ?,ta_publicdate="+"to_date(?,'YYYY/MM/DD'),ta_publiccontent =?");
            	sqlCmd.append(" ,ta_content=?,ta_hide=?,update_time=sysdate ");
            	sqlCmd.append(" where ta_no = ? ");
            	paramList.add(taPubNum) ;
            	paramList.add(taPubDate) ;
            	paramList.add(taPubContent) ;
            	paramList.add(taContent) ;
            	paramList.add(taHide) ;
            	paramList.add(taNo) ;
            	
            }else if(flag.equals("N")){
            	sqlCmd.append(" UPDATE MIS_TA SET ta_reporter=?,ta_content=?,ta_ps=?,ta_date="+"to_date(?,'YYYY/MM/DD'),ta_number=?,ta_hide=?,update_time=sysdate where ta_no=?");
            	paramList.add(taRptr) ;  
            	paramList.add(taContent) ; 
            	paramList.add(taPs) ; 
            	paramList.add(taDate) ; 
            	paramList.add(taNum) ; 
            	paramList.add(taHide) ; 
            	paramList.add(taNo) ; 
            }
            else if(flag.equals("B"))
            {
            	sqlCmd.append(" UPDATE MIS_TA SET ta_backnum = ?,ta_bakdate="+"to_date(?,'YYYY/MM/DD'),ta_backresult =?,update_time=sysdate where ta_no =? ");
            	paramList.add(taBkNum) ; 
            	paramList.add(taBkDate) ;
            	paramList.add(taBkResult) ;
            	paramList.add(taNo) ;
            }
            
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
        String taNo = Utility.getTrimString(request.getParameter("taNo")) ;//序號
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
	    try {
			 // 檢查是否存在
			 StringBuffer sqlCmd = new StringBuffer() ;
            sqlCmd.append( "select count(*) as count from MIS_TA where ta_no = ? " );
            paramList.add(taNo) ;
            
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");
		    System.out.println("MIS_TAsize="+data.size());
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
            
            sqlCmd.append( " DELETE FROM MIS_TA where ta_no = ? " );
            paramList.add(taNo) ;
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
