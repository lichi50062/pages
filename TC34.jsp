<%
//94.01.11 create by egg
//99.06.01 fix 縣市合併 & 套用Header.include by 2808
//101.07.13 add 追蹤歷程紀錄查詢log by 2968 
//101.09.07 fix 修正查詢SQL.拿掉 CDSHARENO D 否則都會查不到資料,年度區分為99或100年度  by 2968
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>

<%
	System.out.println("@@TC34.jsp Start...");


	String pgId = "TC34";
	String userId = session.getAttribute("muser_id") != null ? (String) session.getAttribute("muser_id") : "" ;
	String userName = session.getAttribute("muser_name") != null ? (String) session.getAttribute("muser_name") : "" ;
	String nowact = ( request.getParameter("nowact")==null ) ? "" : (String)request.getParameter("nowact");
	String bank_type = ( request.getParameter("BANK_TYPE")==null ) ? "" : (String)request.getParameter("BANK_TYPE");
	String bank_no = ( request.getParameter("BANK_NO")==null ) ? "" : (String)request.getParameter("BANK_NO");
	String reportno = ( request.getParameter("REPORTNO")==null ) ? "" : (String)request.getParameter("REPORTNO");
	String base_date_beg = ( request.getParameter("BASE_DATE_BEG")==null ) ? "" : (String)request.getParameter("BASE_DATE_BEG");
	String base_date_end = ( request.getParameter("BASE_DATE_END")==null ) ? "" : (String)request.getParameter("BASE_DATE_END");
	String BASE_DATE_BEG_Y = Utility.getTrimString(dataMap.get("BASE_DATE_BEG_Y")) ;
    // 2005.4.21 取得縣市
	String u_year = "99" ;
	if(!"".equals(BASE_DATE_BEG_Y) && Integer.parseInt(BASE_DATE_BEG_Y) > 99) {
		u_year = "100" ;
	}
	System.out.println("u_year="+u_year) ;
	// 2005.4.21 取得縣市
	String cityType = Utility.getTrimString(dataMap.get("cityType"));
	request.setAttribute("cityType",cityType) ;
	
	System.out.println("act="+act);
	System.out.println("nowact="+nowact);
	System.out.println("bank_type="+bank_type);
	System.out.println("bank_no="+bank_no);
	System.out.println("reportno="+reportno);
	System.out.println("TC41.jsp BASE_DATE_BEG="+base_date_beg);
	System.out.println("TC41.jsp BASE_DATE_END="+base_date_end);

	if(session.getAttribute("muser_id") == null){
      System.out.println("TC34 login timeout");
	  rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );
      rd.forward(request,response);
    }

	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    	System.out.println("@X rquest無權限時,導向到LoginError.jsp");
        rd = application.getRequestDispatcher( LoginErrorPgName );
    }else{
    	//set next jsp
    	if(act.equals("new") || act.equals("getData") || act.equals("List") || act.equals("Qry")){
    	    System.out.println("TC34.act=new or getData or List.bank_type="+bank_type);
    	    request.setAttribute("City", Utility.getCity());
			//List時先預設機構類別為0:全部類別
			if(bank_type.equals("")){
				bank_type="0";
				//System.out.println("bank_type空白設定bank_type="+bank_type);
			}
    		List bank_no_list = GetBank_No(bank_type, cityType,u_year);
    		//if(bank_no.equals("") && (bank_no_list.size() != 0)){
            //   	bank_no= (String)((DataObject)bank_no_list.get(0)).getValue("bank_no");
            //}
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
    		    List EXDEFGOODFList = getQryResult(bank_type,bank_no,reportno,base_date_beg,base_date_end,cityType,u_year);
    		    request.setAttribute("EXDEFGOODFList",EXDEFGOODFList);
    		    actMsg = Utility.insertDataToLog(request, userId, pgId);
    		    System.out.println("InsertDataToLog OK!!! ");
    			rd = application.getRequestDispatcher( ListPgName +"?act=Qry&SZBANK_TYPE="+bank_type+"&SZBANK_NO="+bank_no+"&SZREPORTNO="+reportno);
    		}
    		if(act.equals("getData")){
        		System.out.println("TC34_act=getData Start ....");
        		System.out.println("TC34_act=getData.bank_type="+bank_type);
        	    if(nowact.equals("new") || nowact.equals("Edit")){
        	    	System.out.println("act=getData,nowact=new or edit");
        	       	rd = application.getRequestDispatcher( EditPgName +"?act="+nowact+"&bank_type="+bank_type);
        	    }
        	    if(nowact.equals("List") || nowact.equals("Qry")){
        	       	System.out.println("act=getData,nowact=List or Qry");
        	        rd = application.getRequestDispatcher( ListPgName +"?act="+nowact+"&SZBANK_TYPE="+bank_type+"&SZBANK_NO="+bank_no+"&SZREPORTNO="+reportno);
        	    }
        	}
    	}else if(act.equals("Edit")){//編輯(新增or修改)作業處理
			System.out.println("@@act=Edit...");
			actMsg = Utility.insertDataToLog(request, userId, pgId);
    	}else if(act.equals("Insert")){//新增資料處理
    		System.out.println("@@act=Insert...");
    		actMsg = Utility.insertDataToLog(request, userId, pgId);
    	    actMsg = InsertDB(request,lguser_id,lguser_name);
        	//rd = application.getRequestDispatcher( nextPgName );
        }else if(act.equals("Update")){//更新資料處理
    	    actMsg = UpdateDB(request,lguser_id,lguser_name);
        	//rd = application.getRequestDispatcher( nextPgName );
    	    actMsg = Utility.insertDataToLog(request, userId, pgId);
        }else if(act.equals("Delete")){//刪除資料處理
    	    actMsg = DeleteDB(request,lguser_id,lguser_name);
        	//rd = application.getRequestDispatcher( nextPgName );
    	    actMsg = Utility.insertDataToLog(request, userId, pgId);
        }
		//設定頁面移轉輸出(錯誤)訊息
    	request.setAttribute("actMsg",actMsg);
	}
%>

<%@include file="./include/Tail.include" %>

<%!
    private final static String report_no = "TC34" ;
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
    		sqlCmd.append( " SELECT BANK_NO,BANK_NAME  " );
    		if(bank_type.equals("0")) {
    			System.out.println("全部機構類別(1,6,7,8)查詢");
    			sqlCmd.append(" FROM BA01 WHERE m_year=? and BANK_TYPE IN (?,?,?,?) ORDER BY BANK_NO" );
    			paramList.add(u_year) ;
    			paramList.add("1") ;
    			paramList.add("6") ;
    			paramList.add("7") ;
    			paramList.add("8") ;
    		} else if(!cityType.equals("") && (bank_type.equals("6") || bank_type.equals("7"))) {
    		    System.out.println("農漁會縣市別查詢");
    		    sqlCmd.append(
    		     " , TBANK_NO From (( select a.BANK_NO as TBANK_NO,a.BANK_NO as BANK_NO,  a.BANK_NAME as BANK_NAME " +
                 " from (select * from bn01 where m_year=? ) a, (select * from wlx01 where m_year=?) b where a.bank_type =?  and a.bank_no = b.bank_no AND " +
                 " b.hsien_id =? ) union ALL (select d.TBANK_NO as TBANK_NO, "+
                 " d.BANK_NO as BANK_NO, a.BANK_NAME as BANK_NAME from (select * from ba01 where m_year=?) a, (select * from wlx01 where m_year=?) b, (select * from wlx02 where m_year=? ) d " +
                 " where a.bank_type = ? and a.BANK_KIND = ? and " +
                 " a.bank_no = d.bank_no and a.pbank_no = d.Tbank_no  and d.Tbank_no = b.bank_no   and "+
                 " b.hsien_id = ? )) order by  TBANK_NO, BANK_NO, BANK_NAME" ); 
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
    		}else {
    			System.out.println("單一機構類別查詢");
    			sqlCmd.append( " FROM (select * from ba01 where m_year=? ) WHERE BANK_TYPE=? ORDER BY BANK_NO" );
    			paramList.add(u_year) ;
    			paramList.add(bank_type) ;
    		} 
    		
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");

            System.out.println("TC14.Method GetBank_No End..");
            return dbData;
    }
    
   

    //取得查詢結果
    private List getQryResult(String bank_type,String bank_no,String reportno,String base_date_beg,String base_date_end, String cityType,String u_year){
    		//查詢條件
    		StringBuffer sqlCmd = new StringBuffer () ;
    		List paramList = new ArrayList() ;
    		base_date_beg =Utility.getDatetoString(base_date_beg);
    		base_date_end =Utility.getDatetoString(base_date_end);
    		System.out.println("Method getQryResult Start ..");
    		//System.out.println("Input var bank_no="+bank_no);
    		//System.out.println("Input var bank_type="+bank_type);
    		//System.out.println("Input var reportno="+reportno);
    		System.out.println("Input var base_date_beg="+base_date_beg);
    		System.out.println("Input var base_date_end="+base_date_end);

			sqlCmd.append(	"SELECT DISTINCT A.BANK_NO,C.BANK_NAME,A.REPORTNO,A.BASE_DATE "
					+	"FROM EXREPORTF A,EXDEFGOODF B,(select * from BA01 where m_year=?) C  "
					+	"WHERE A.REPORTNO = B.REPORTNO "
					+	"AND   A.BANK_NO = C.BANK_NO "
					//+	"AND   ( A.CH_TYPE = D.CMUSE_ID AND CMUSE_DIV = '026' ) "	//依94/2/24經理提供文件修改
					+	"AND   B.AUDIT_RESULT NOT IN ( ? ,?) ");
			paramList.add(u_year) ;
			paramList.add("1") ;
			paramList.add("2") ;
			if(bank_type.equals("0")){
    			sqlCmd.append("AND A.BANK_NO IN (SELECT BANK_NO FROM BA01 WHERE m_year=? and BANK_TYPE IN (?,?,?,?)) " );
    			paramList.add(u_year) ;
    			paramList.add("1") ;
    			paramList.add("6") ;
    			paramList.add("7") ;
    			paramList.add("8") ;
    		}else {
    			sqlCmd.append("AND A.BANK_NO IN (SELECT BANK_NO FROM BA01 WHERE m_year=? and BANK_TYPE = ? ) " );
    			paramList.add(u_year) ;
    			paramList.add(bank_type) ;
    		}
					if(!bank_no.equals("")){
    					//System.out.println("機構代號非空白處理");
    					sqlCmd.append("AND A.BANK_NO = ? " );
    					paramList.add(bank_no) ;
    				}
					if(!base_date_beg.equals("") || !base_date_end.equals("")){
    					//System.out.println("基準日非空白");
    					sqlCmd.append( "AND A.BASE_DATE BETWEEN TO_DATE(?,'yyyymmddhh24miss') "+ "AND TO_DATE(?,'yyyymmddhh24miss')");
    					paramList.add(base_date_beg) ;
    					paramList.add(base_date_end) ;
    				}
					if(!reportno.equals("")){
    					//System.out.println("檢查編號非空白處理");
    					sqlCmd.append( "AND	A.REPORTNO= ? " );
    					paramList.add(reportno) ;
    				}
    	     if(!cityType.equals("")) {
    		            sqlCmd.append( " and A.TBANK_NO in (select BANK_NO  from WLX01  where m_year=? and HSIEN_ID =  ? ) " );
    		            paramList.add(u_year) ;
    		            paramList.add(cityType) ;
    		}
			sqlCmd.append(" GROUP BY A.BANK_NO,C.BANK_NAME,A.REPORTNO,A.BASE_DATE ORDER BY BANK_NO ,A.REPORTNO" );
			
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"base_date");

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
<%System.out.println("@@TC34.jsp End...");%>