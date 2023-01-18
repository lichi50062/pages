<%
//94.01.11 create by egg
//94.03.04 1.fix 金融機構類別預設為全部類別及下拉選單全部產品查詢受檢單位僅需輸出全部調整
//		   2.getQryResult() add DISTINCT 敘述取得單一資料
//96.11.22 fix 若回文紀錄有.則該發文文號(sn_docno).不列入逾期天數統計 by 2295
//99.06.01 fix 縣市合併 & 套用Header.include by 2808
//101.07.13 add 追蹤歷程紀錄查詢log by 2968 
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>

<%
	System.out.println("@@TC35.jsp Start...");
	String pgId = "TC35";
	String userId = session.getAttribute("muser_id") != null ? (String) session.getAttribute("muser_id") : "" ;
	String userName = session.getAttribute("muser_name") != null ? (String) session.getAttribute("muser_name") : "" ;
	String nowact = ( request.getParameter("nowact")==null ) ? "" : (String)request.getParameter("nowact");
	String bank_type = ( request.getParameter("BANK_TYPE")==null ) ? "" : (String)request.getParameter("BANK_TYPE");
	String bank_no = ( request.getParameter("BANK_NO")==null ) ? "" : (String)request.getParameter("BANK_NO");
	String delay_days = ( request.getParameter("DELAY_DAYS")==null ) ? "" : (String)request.getParameter("DELAY_DAYS");
	String doctype = ( request.getParameter("DOC_TYPE")==null ) ? "" : (String)request.getParameter("DOC_TYPE");
	//String BASE_DATE_BEG_Y = Utility.getTrimString(dataMap.get("BASE_DATE_BEG_Y")) ;
	String BASE_DATE_BEG_Y = ( request.getParameter("BASE_DATE_BEG_Y")==null ) ? "" : (String)request.getParameter("BASE_DATE_BEG_Y") ;
	String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH")) ;
	System.out.println("BASE_DATE_BEG_Y="+BASE_DATE_BEG_Y);
	System.out.println("S_MONTH="+S_MONTH);
    // 2005.4.21 取得縣市
	String u_year = "99" ;
	if(!"".equals(BASE_DATE_BEG_Y) && Integer.parseInt(BASE_DATE_BEG_Y) > 99) {
		u_year = "100" ;
	}
	System.out.println("u_year="+u_year) ;
	// 2005.4.21 取得縣市
	String cityType = Utility.getTrimString(dataMap.get("cityType"));
	request.setAttribute("cityType",cityType) ;
	request.setAttribute("BASE_DATE_BEG_Y",BASE_DATE_BEG_Y) ;
	System.out.println("act="+act);
	System.out.println("nowact="+nowact);
	System.out.println("bank_type="+bank_type);
	System.out.println("bank_no="+bank_no);
	System.out.println("delay_days="+delay_days);
	System.out.println("doctype="+doctype);

	if(session.getAttribute("muser_id") == null){
      System.out.println("TC35 login timeout");
	  rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );
      rd.forward(request,response);
    }
	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    	System.out.println("@X rquest無權限時,導向到LoginError.jsp");
        rd = application.getRequestDispatcher( LoginErrorPgName );
    }else{
    	//set next jsp
    	if(act.equals("new") || act.equals("getData") || act.equals("List") || act.equals("Qry")){
    	    System.out.println("TC35.act=new or getData or List.bank_type="+bank_type);
    	    System.out.println("TC35.act=new or getData or List.bank_no="+bank_no);
    	    request.setAttribute("City", Utility.getCity());
			//List時先預設機構類別為0:全部類別
			if(bank_type.equals("")){
				bank_type="0";
				System.out.println("bank_type空白設定bank_type="+bank_type);
			}
    		List bank_no_list = GetBank_No(bank_type, cityType,u_year);
    		request.setAttribute("bank_no",bank_no_list);
			
    		if(act.equals("new")){
        	   	rd = application.getRequestDispatcher( EditPgName +"?act=new");
        	}
        	if(act.equals("List")){
        		System.out.println("act.equals(List)");
        	   	rd = application.getRequestDispatcher( ListPgName +"?act=List&SZBANK_TYPE="+bank_type);
        	}
        	if(act.equals("Qry")){
        		System.out.println("Qry.bank_type="+bank_type);
        		System.out.println("Qry.bank_no="+bank_no);
    		    List EXSNDOCFList = getQryResult(bank_type,bank_no,delay_days,doctype, cityType,u_year,BASE_DATE_BEG_Y,S_MONTH);
    		    request.setAttribute("EXSNDOCFList",EXSNDOCFList);
    		    actMsg = Utility.insertDataToLog(request, userId, pgId);
    			rd = application.getRequestDispatcher( ListPgName +"?act=Qry&SZBANK_TYPE="+bank_type+"&SZBANK_NO="+bank_no+"&SZDELAY_DAYS="+delay_days+"&SZDOC_TYPE="+doctype);
    		}
    		if(act.equals("getData")){
        		System.out.println("TC35_act=getData Start ....");
        		System.out.println("TC35_act=getData.bank_type="+bank_type);
        	    if(nowact.equals("new") || nowact.equals("Edit")){
        	    	System.out.println("act=getData,nowact=new or edit");
        	       	rd = application.getRequestDispatcher( EditPgName +"?act="+nowact+"&bank_type="+bank_type);
        	    }
        	    if(nowact.equals("List") || nowact.equals("Qry")){
        	       	System.out.println("act=getData,nowact=List or Qry");
        	        rd = application.getRequestDispatcher( ListPgName +"?act="+nowact+"&SZBANK_TYPE="+bank_type+"&SZBANK_NO="+bank_no);
        	    }
        	}
    	}else if(act.equals("Edit")){//編輯(新增or修改)作業處理
			System.out.println("@@act=Edit...");
			actMsg = Utility.insertDataToLog(request, userId, pgId);
    	}else if(act.equals("Insert")){//新增資料處理
    		System.out.println("@@act=Insert...");
    	    actMsg = InsertDB(request,lguser_id,lguser_name);
    	    actMsg = Utility.insertDataToLog(request, userId, pgId);
        	//rd = application.getRequestDispatcher( nextPgName );
        }else if(act.equals("Update")){//更新資料處理
    	    actMsg = UpdateDB(request,lguser_id,lguser_name);
    	    actMsg = Utility.insertDataToLog(request, userId, pgId);
        	//rd = application.getRequestDispatcher( nextPgName );
        }else if(act.equals("Delete")){//刪除資料處理
    	    actMsg = DeleteDB(request,lguser_id,lguser_name);
    	    actMsg = Utility.insertDataToLog(request, userId, pgId);
        	//rd = application.getRequestDispatcher( nextPgName );
        }
		//設定頁面移轉輸出(錯誤)訊息
    	request.setAttribute("actMsg",actMsg);
	}
%>
<%@include file="./include/Tail.include" %>


<%!
	private final static String report_no = "TC35" ;
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
    private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    

    //取得機構代號 2005.4.21 新增縣市別查詢
    private List GetBank_No(String bank_type, String cityType,String u_year){
    		System.out.println("TC14.Method GetBank_No Start..");
    		System.out.println("Inpute bank_type="+bank_type);
    		StringBuffer sqlCmd = new StringBuffer() ;
    		List paramList = new ArrayList() ;
    		//查詢條件
    		
    		if(bank_type.equals("0")) {
    			System.out.println("全部機構類別(1,6,7,8)查詢");
    			sqlCmd.append(" SELECT BANK_NO,BANK_NAME  " );
    			sqlCmd.append(" FROM  BA01 WHERE m_year=? and BANK_TYPE IN (?,?,?,?) ORDER BY BANK_NO" );
    			paramList.add(u_year) ;
    			paramList.add("1") ;
    			paramList.add("7") ;
    			paramList.add("6") ;
    			paramList.add("8") ;
    			
    		} else if(!cityType.equals("") && (bank_type.equals("6") || bank_type.equals("7"))) {
    		    System.out.println("農漁會縣市別查詢");
    		    sqlCmd.append(" SELECT T1.* FROM ( ");
    		    sqlCmd.append(" SELECT BANK_NO,BANK_NAME  " );
    		    sqlCmd.append(
    		     " , TBANK_NO From (( select a.BANK_NO as TBANK_NO,a.BANK_NO as BANK_NO,  a.BANK_NAME as BANK_NAME " +
                 " from (select * from ba01 where m_year=? ) a, (select * from wlx01 where m_year= ? ) b where a.bank_type =? and a.bank_no = b.bank_no AND " +
                 " b.hsien_id = ?) union ALL (select d.TBANK_NO as TBANK_NO, "+
                 " d.BANK_NO as BANK_NO, a.BANK_NAME as BANK_NAME from (select * from ba01 where m_year=?) a, (select * from wlx01 where m_year=? ) b, (select * from wlx02 where m_year=?) d " +
                 " where a.bank_type = ?  and a.BANK_KIND = ? and " +
                 " a.bank_no = d.bank_no and a.pbank_no = d.Tbank_no  and d.Tbank_no = b.bank_no   and "+
                 " b.hsien_id = ?)) order by  TBANK_NO, BANK_NO, BANK_NAME"); 
    		    sqlCmd.append(" ) T1 , v_bank_location T2 ");
    		    sqlCmd.append(" Where T1.Bank_no = T2.Bank_no and T2.m_year = ? ");
    		    sqlCmd.append(" ORDER BY T2.fr001w_output_order ");
    			paramList.add(u_year) ;
    			paramList.add(u_year) ;
    			paramList.add(bank_type) ;
    			paramList.add(cityType) ;
    			paramList.add(u_year) ;
    			paramList.add(u_year) ;
    			paramList.add(u_year) ;
    			paramList.add(bank_type) ;
    			paramList.add("1") ;
    			paramList.add(cityType) ;
    			paramList.add(u_year) ;
    		}else {
    			System.out.println("單一機構類別查詢");
    			sqlCmd.append(" select T1.* from ( "); 
    			sqlCmd.append(" SELECT BANK_NO,BANK_NAME  " );
    			sqlCmd.append(" FROM BA01 WHERE m_year=? and BANK_TYPE=? ");
    			sqlCmd.append(" ) T1 ,v_bank_location T2 ") ;
    			sqlCmd.append(" Where T1.Bank_no = T2.Bank_no and T2.m_year = ? ");
    		    sqlCmd.append(" ORDER BY T2.fr001w_output_order ");
    			paramList.add(u_year) ;
    			paramList.add(bank_type  ) ;
    			paramList.add(u_year) ;
    		} 
    		System.out.println(" i am testing u are ? =====================================") ;
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");

            System.out.println("TC14.Method GetBank_No End..");
            return dbData;
    }
    
    

    //取得查詢結果
    private List getQryResult(String bank_type,String bank_no,String delay_days,String doctype, String cityType,String u_year,String BASE_DATE_BEG_Y,String S_MONTH){
    		//查詢條件
    		StringBuffer sqlCmd = new StringBuffer () ;
    		List paramList = new ArrayList() ;
    		System.out.println("Method getQryResult Start ..");
    		System.out.println("Input var bank_no="+bank_no); 
    		System.out.println("Input var bank_type="+bank_type);
    		System.out.println("Input var delay_days="+delay_days);
    		System.out.println("Input var doctype="+doctype);

			/*
				1.依檢查報告之"檢查報告編號"取得發文記錄檔資料
				2.LEFT JOIN BA01取得機構名稱資料
				3.LEFT JOIN CDSHARENO 取得對應之公文類別中文資料
				4.計算限期函報日(LIMITDATE)至目前系統時間(SYSDATE)之相距天數比對逾期天數資料
				5.FLOOR取得整數，但不四捨五入
				6.若回文紀錄有.則該發文文號(sn_docno).不列入逾期天數統計 by 2295
			*/
			sqlCmd.append( "SELECT DISTINCT E.BANK_NO,A.BANK_NAME,E1.SN_DOCNO,E1.SN_DATE,E1.DOCTYPE,C.CMUSE_NAME, "
					+ "FLOOR((SYSDATE-E1.LIMITDATE)) AS DELAY_DAYS "
					+ "FROM EXREPORTF E "
					+ "LEFT JOIN (select * from ba01 where m_year=? ) A ON A.BANK_NO = E.BANK_NO "
					+ ",(select EXSNDOCF.* "
		            + "  from EXSNDOCF "
			        + "  where EXSNDOCF.SN_DOCNO not in (select SN_DOCNO from ExRtDocF))E1 "					
					+ "LEFT JOIN CDSHARENO C ON CMUSE_DIV=? AND CMUSE_ID = E1.DOCTYPE "
					+ "LEFT JOIN EXRTDOCF E2 ON E1.SN_DOCNO <> E2.SN_DOCNO "
					+ "	WHERE 	E.REPORTNO = E1.REPORTNO "
					+ "	AND 	LIMITDATE IS NOT NULL ");
			paramList.add(u_year) ;
			paramList.add("025") ;
			if(bank_type.equals("0")){
    			sqlCmd.append( "AND E.BANK_NO IN (SELECT BANK_NO FROM BA01 WHERE m_year=? and BANK_TYPE IN (?,?,?,?)) " );
    			paramList.add(u_year) ;
    			paramList.add("1") ;
    			paramList.add("6") ;
    			paramList.add("7") ;
    			paramList.add("8") ;
    		}else {
    			sqlCmd.append( "AND E.BANK_NO IN (SELECT BANK_NO FROM BA01 WHERE m_year=? and BANK_TYPE = ? ) " );
    			paramList.add(u_year) ;
    			paramList.add(bank_type) ;
    		}
			
					
			if(!bank_no.equals("")){
    			System.out.println("機構代號非空白處理");
    			sqlCmd.append("AND 	E.BANK_NO = ? " );
    			paramList.add(bank_no) ;
    		}
			if(!doctype.equals("")){
    			System.out.println("公文類別非空白處理");
    			sqlCmd.append( "AND		E1.DOCTYPE = ? " );
    			paramList.add(doctype) ;
    		}
			if(!delay_days.equals("")){
    			System.out.println("逾期天數非空白處理");
    			sqlCmd.append("AND	(SYSDATE - E1.LIMITDATE) >= ? " );
    			paramList.add(delay_days) ;
    		}
    	    if(!cityType.equals("")) {
    		            sqlCmd.append(" and E.TBANK_NO in (select BANK_NO  from WLX01  where m_year=? and HSIEN_ID = ?) ");
    		            paramList.add(u_year) ;
    		            paramList.add(cityType) ;
    		}
    	    
    	    /*
			if(!BASE_DATE_BEG_Y.equals("")&&!S_MONTH.equals("")){
    			sqlCmd.append("AND 	E1.SN_DATE like ? " );
    			paramList.add((Integer.parseInt(BASE_DATE_BEG_Y)+1911)+"/"+Integer.parseInt(S_MONTH)+"%") ;
    		}*/
			sqlCmd.append(" ORDER BY BANK_NO" );
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"delay_days,sn_date,update_date");

            System.out.println("Method getQryResult End ..");
            return dbData;
    }
	//新增
	public String InsertDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		String errMsg="";

		System.out.println("Method InserDB Start...");

		System.out.println("Method InserDB End...");
		return errMsg;
	}
	//修改
	private String UpdateDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		String errMsg="";

		System.out.println("@@Method UpdateDB Start...");

		System.out.println("@@Method UpdateDB End...");
		return errMsg;
	}
	//刪除
    private String DeleteDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{

		String errMsg="";

		System.out.println("@@Method DeleteDB Start...");

		System.out.println("@@Method DeleteDB End...");
		return errMsg;
	}
  
%>
<%System.out.println("@@TC35.jsp End...");%>