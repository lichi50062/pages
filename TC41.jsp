<%
//94.01.11 	create by egg
//94.03.04 	fix 金融機構類別預設為全部類別及下拉選單全部產品查詢受檢單位僅需輸出全部調整
//94.03.07	fix 修改時下拉選單未依選擇調整而異動處理
//99.06.01 fix 縣市合併 & 套用Header.include by 2808
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>

<%
	System.out.println("@@TC41.jsp Start...");
	//取得session資料,取得成功時,才繼續往下執行===================================================

	String nowact = ( request.getParameter("nowact")==null ) ? "" : (String)request.getParameter("nowact");
	String bank_type = ( request.getParameter("BANK_TYPE")==null ) ? "" : (String)request.getParameter("BANK_TYPE");
	String bank_no = ( request.getParameter("BANK_NO")==null ) ? "" : (String)request.getParameter("BANK_NO");
	String serial = ( request.getParameter("SERIAL")==null ) ? "" : (String)request.getParameter("SERIAL");
	String rt_docno = ( request.getParameter("RT_DOCNO")==null ) ? "" : (String)request.getParameter("RT_DOCNO");
	String item_id = ( request.getParameter("ITEM_ID")==null ) ? "" : (String)request.getParameter("ITEM_ID");
	String track = ( request.getParameter("TRACK")==null ) ? "" : (String)request.getParameter("TRACK");
	String event_date_beg = ( request.getParameter("EVENT_DATE_BEG")==null ) ? "" : (String)request.getParameter("EVENT_DATE_BEG");
	String event_date_end = ( request.getParameter("EVENT_DATE_END")==null ) ? "" : (String)request.getParameter("EVENT_DATE_END");
	String EVENT_DATE_Y = Utility.getTrimString(dataMap.get("EVENT_DATE_Y") ) ;
	String EVENT_DATE_BEG_Y = Utility.getTrimString(dataMap.get("EVENT_DATE_BEG_Y")) ;
	/*String EVENT_DATE_M = Utility.getTrimString(dataMap.get("EVENT_DATE_M")) ;
	String EVENT_DATE_D = Utility.getTrimString(dataMap.get("EVENT_DATE_D")) ;
	String RT_DOCNO = Utility.getTrimString(dataMap.get("RT_DOCNO")) ;
	String RT_DATE_M = Utility.getTrimString(dataMap.get("RT_DATE_M")) ;
	String RT_DATE_D = Utility.getTrimString(dataMap.get("RT_DATE_D")) ;
	String ITEM_ID = Utility.getTrimString(dataMap.get("ITEM_ID")) ;
	String TRACK = Utility.getTrimString(dataMap.get("TRACK")) ;
	String SUMMARY = Utility.getTrimString(dataMap.get("SUMMARY")) ;
	String REMARK = Utility.getTrimString(dataMap.get("REMARK")) ;*/
    // 2005.4.21 取得縣市
	String u_year = "100" ;
	if(!"".equals(EVENT_DATE_BEG_Y) && Integer.parseInt(EVENT_DATE_BEG_Y) < 100) {
		u_year = "99" ;
	}else if("".equals(EVENT_DATE_BEG_Y) && !"".equals(EVENT_DATE_Y) && Integer.parseInt(EVENT_DATE_Y) <100) {
		u_year = "99" ;
	}
	System.out.println("u_year="+u_year) ;
	// 2005.4.21 取得縣市
	String cityType = Utility.getTrimString(dataMap.get("cityType"));
	request.setAttribute("cityType",cityType) ;
	request.setAttribute("BANK_NO",Utility.getTrimString(dataMap.get("BANK_NO"))) ;
	request.setAttribute("EVENT_DATE_BEG_Y",EVENT_DATE_BEG_Y) ;
    request.setAttribute("EVENT_DATE_Y",EVENT_DATE_Y) ;
    request.setAttribute("EVENT_DATE_M",Utility.getTrimString(dataMap.get("EVENT_DATE_M"))) ;
    request.setAttribute("EVENT_DATE_D",Utility.getTrimString(dataMap.get("EVENT_DATE_D"))) ;
    request.setAttribute("RT_DOCNO",Utility.getTrimString(dataMap.get("RT_DOCNO"))) ;
    request.setAttribute("RT_DATE_Y",Utility.getTrimString(dataMap.get("RT_DATE_Y"))) ;
    request.setAttribute("RT_DATE_M",Utility.getTrimString(dataMap.get("RT_DATE_M"))) ;
    request.setAttribute("RT_DATE_D",Utility.getTrimString(dataMap.get("RT_DATE_D"))) ;
    request.setAttribute("ITEM_ID",Utility.getTrimString(dataMap.get("ITEM_ID"))) ;
    request.setAttribute("TRACK",Utility.getTrimString(dataMap.get("TRACK"))) ;
    request.setAttribute("SUMMARY",Utility.getTrimString(dataMap.get("SUMMARY"))) ;
    request.setAttribute("REMARK",Utility.getTrimString(dataMap.get("REMARK"))) ;
	System.out.println("act="+act);
	System.out.println("nowact="+nowact);
	System.out.println("bank_type="+bank_type);
	System.out.println("bank_no="+bank_no);
	System.out.println("serial="+serial);
	System.out.println("TC41.jsp EVENT_DATE_BEG="+event_date_beg);
	System.out.println("TC41.jsp EVENT_DATE_END="+event_date_end);

	if(session.getAttribute("muser_id") == null){
      System.out.println("TC41 login timeout");
	  rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );
      rd.forward(request,response);
    }


	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    	System.out.println("@X rquest無權限時,導向到LoginError.jsp");
        rd = application.getRequestDispatcher( LoginErrorPgName );
    }else{
    	//set next jsp
    	if(act.equals("new") || act.equals("getData") || act.equals("List") || act.equals("Qry")){
    	    System.out.println("TC41.act=new or getData or List.bank_type="+bank_type);
    	    System.out.println("TC41.act=new or getData or List.bank_no="+bank_no);
    	    request.setAttribute("City", Utility.getCity());
			//List時先預設機構類別為0:全部類別,new時預設為1:金國農業金庫
			if(bank_type.equals("")){
				bank_type="0";
				System.out.println("bank_type空白設定bank_type="+bank_type);
			}
			if(act.equals("new")){
				bank_type="1";
			}
    		List bank_no_list = GetBank_No(bank_type, cityType,u_year);
    		//if(bank_no.equals("") && (bank_no_list.size() != 0)){
    		//	System.out.println("初始bank_no資料");
            //   	bank_no= (String)((DataObject)bank_no_list.get(0)).getValue("bank_no");
            //}
    	    request.setAttribute("bank_no",bank_no_list);
    	    

    		if(act.equals("new")){
				List EXWARNINGF = GetWarning_No(serial,u_year);
            	request.setAttribute("EXWARNINGF",EXWARNINGF);
        	   	rd = application.getRequestDispatcher( EditPgName +"?act=new");
        	}
        	if(act.equals("List")){
        		System.out.println("act.equals(List)");
        	   	rd = application.getRequestDispatcher( ListPgName +"?act=List&SZBANK_TYPE="+bank_type);
        	}
        	if(act.equals("Qry")){
        		System.out.println("Qry.bank_type="+bank_type);
        		System.out.println("Qry.bank_no="+bank_no);
    		    List EXWARNINGFList = getQryResult(bank_type,bank_no,event_date_beg,event_date_end,rt_docno,item_id,track,cityType);
    		    request.setAttribute("EXWARNINGFList",EXWARNINGFList);
    		    //rd = application.getRequestDispatcher( ListPgName +"?act=Qry&bank_no="+bank_no);
    			rd = application.getRequestDispatcher( ListPgName +"?act=Qry&SZBANK_TYPE="+bank_type+"&SZBANK_NO="+bank_no+"&SZRT_DOCNO="+rt_docno+"&SZITEM_ID="+item_id+"&SZTRACK="+track);
    		}
    		if(act.equals("getData")){
        		System.out.println("TC41_act=getData Start ....");
        		System.out.println("TC41_act=getData.bank_type="+bank_type);
        	    if(nowact.equals("new") || nowact.equals("Edit")){
        	    	System.out.println("act=getData,nowact=new or edit");
        	    	List EXWARNINGF = GetWarning_No(serial,u_year);
            		request.setAttribute("EXWARNINGF",EXWARNINGF);
            		String check = request.getParameter("CHECK") != null ? "T" : "F";
                    System.out.println("CHECK = " + check );
                    request.setAttribute("isChecked", check);
        	       	rd = application.getRequestDispatcher( EditPgName +"?act="+nowact+"&SZBANK_TYPE="+bank_type+"&SZBANK_NO="+bank_no);
        	       	//rd = application.getRequestDispatcher( EditPgName +"?act="+nowact+"&bank_type="+bank_type);
        	    }
        	    if(nowact.equals("List") || nowact.equals("Qry")){
        	       	System.out.println("act=getData,nowact=List or Qry");
        	        rd = application.getRequestDispatcher( ListPgName +"?act="+nowact+"&SZBANK_TYPE="+bank_type+"&SZBANK_NO="+bank_no);
        	    }
        	}
    	}else if(act.equals("Edit")){//編輯(新增or修改)作業處理
    		System.out.println("act=Edit時bank_type="+bank_type);
            List bank_no_list = GetBank_No(bank_type, cityType,u_year);
            request.setAttribute("bank_no",bank_no_list);
            request.setAttribute("City", Utility.getCity());
            String check = request.getParameter("CHECK") != null ? "T" : "F";
            System.out.println("CHECK = " + check );
            request.setAttribute("isChecked", check);
            List EXWARNINGF = GetWarning_No(serial,u_year);
            request.setAttribute("EXWARNINGF",EXWARNINGF);
            //if(EXWARNINGF.size() != 0){
            //   bank_no = (String)((DataObject)EXWARNINGF.get(0)).getValue("bank_no");
            //}
            //設定異動者資訊======================================================================
			request.setAttribute("maintainInfo","select * from EXWARNINGF WHERE bank_no='" + bank_no+"'");
			//=======================================================================================================================
    	 	rd = application.getRequestDispatcher( EditPgName +"?act=Edit&SERIAL="+serial);
    	}else if(act.equals("Insert")){//新增資料處理
    		System.out.println("@@act=Insert...");
    	    actMsg = InsertDB(request,lguser_id,lguser_name);
        	rd = application.getRequestDispatcher( nextPgName );
        }else if(act.equals("Update")){//更新資料處理
    	    actMsg = UpdateDB(request,lguser_id,lguser_name);
        	rd = application.getRequestDispatcher( nextPgName );
        }else if(act.equals("Delete")){//刪除資料處理
    	    actMsg = DeleteDB(request,lguser_id,lguser_name);
        	rd = application.getRequestDispatcher( nextPgName );
        }
		//設定頁面移轉輸出(錯誤)訊息
    	request.setAttribute("actMsg",actMsg);
	}
%>
<%@include file="./include/Tail.include" %>

<%!
	private final static String report_no = "TC41" ;
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
    		sqlCmd.append(" SELECT BANK_NO,BANK_NAME  " );
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
                 " from (select * from bn01 where m_year= ? ) a, (select * from wlx01 where m_year=? ) b where a.bank_type = ? and a.bank_no = b.bank_no AND " +
                 " b.hsien_id = ?) union ALL (select d.TBANK_NO as TBANK_NO, "+
                 " d.BANK_NO as BANK_NO, a.BANK_NAME as BANK_NAME from (select * from ba01 where m_year=? )a, (select * from wlx01 where m_year=? )b, (select * from wlx02 where m_year=? ) d " +
                 " where a.bank_type = ? and a.BANK_KIND = ? and " +
                 " a.bank_no = d.bank_no and a.pbank_no = d.Tbank_no  and d.Tbank_no = b.bank_no   and "+
                 " b.hsien_id = ?)) order by  TBANK_NO, BANK_NO, BANK_NAME" ); 
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
    			sqlCmd.append(" FROM BA01 WHERE BANK_TYPE=? and m_year=?  ORDER BY BANK_NO" );
    			paramList.add(bank_type) ;
    			paramList.add(u_year) ;
    		} 
    		
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");

            System.out.println("TC14.Method GetBank_No End..");
            return dbData;
    }
    
    
    //取得異常警訊資料
    private List GetWarning_No(String serial,String u_year){
    		System.out.println("TC41.Method GetWarning_No Start..");
    		System.out.println("Inpute serial="+serial);
			StringBuffer sqlCmd = new StringBuffer() ;
			List paramList = new ArrayList() ;
    		//查詢條件
    		sqlCmd.append( " SELECT distinct b.bank_type, c.hsien_id, SERIAL,A.BANK_NO,B.BANK_NAME,EVENTDATE,RT_DOCNO,RT_DATE,ITEM_ID,TRACK,SUMMARY,REMARK "
    					  + " FROM EXWARNINGF A,(select * from BA01 where m_year=? )B, (select bank_no, hsien_id from wlx01 where m_year=? union select bank_no, hsien_id from wlx02 where m_year=?) c"
    					  + " WHERE SERIAL=? "
    					  + " AND c.bank_no(+) = a.bank_no "
    					  + " AND A.BANK_NO = B.BANK_NO "
    					  //+ " and BANK_KIND='1'"
    		    		  + " ORDER BY BANK_NO" );
    		paramList.add(u_year) ;
    		paramList.add(u_year) ;
    		paramList.add(u_year) ;
    		paramList.add(serial) ;
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"serial,eventdate,rt_date,update_date");

            System.out.println("TC41.Method GetWarning_No End..");
            return dbData;
    }

    //取得查詢結果
    private List getQryResult(String bank_type,String bank_no,String event_date_beg,String event_date_end,String rt_docno,String item_id,String track, String cityType){
    		//查詢條件
    		StringBuffer sqlCmd = new StringBuffer();
    		List paramList = new ArrayList() ;
    		//轉換日期ex:2004/01/01-->20040101提供日期btween比對
    		event_date_beg =Utility.getDatetoString(event_date_beg);
    		event_date_end =Utility.getDatetoString(event_date_end);
    		
    		System.out.println("Method getQryResult Start ..");
    		System.out.println("inpute bank_type="+bank_type);
    		System.out.println("inpute bank_no="+bank_no);
    		System.out.println("inpute item_id="+item_id);
    		System.out.println("inpute track="+track);
    		System.out.println("inpute event_date_beg="+event_date_beg);
    		System.out.println("inpute event_date_end="+event_date_end);
			String u_year = "99" ;
			if(!"".equals(event_date_beg) && Integer.parseInt(event_date_beg.substring(0,4))> 2010) {
				u_year= "100" ;
			}
    		sqlCmd.append("SELECT E.SERIAL,E.BANK_NO,B.BANK_NAME,B.BANK_TYPE,E.EVENTDATE,RT_DOCNO,E1.ITEM_NAME,C.CMUSE_NAME "
    				+ "FROM  EXWARNINGF E "
    				+ "LEFT JOIN (select * from BA01  where m_year=? ) B ON BANK_TYPE IN (?,?,?,?) AND B.BANK_NO = E.BANK_NO "
    			    + "LEFT JOIN EXWARNIDF E1 ON E1.ITEM_ID = E.ITEM_ID "
    			   	+ "LEFT JOIN CDSHARENO C ON CMUSE_ID = E.TRACK AND CMUSE_DIV =? ");
    				//+ "WHERE ";
    		 paramList.add(u_year) ;
    		 paramList.add("1") ;
    		 paramList.add("6") ;
    		 paramList.add("7") ;
    		 paramList.add("8") ;
    		 paramList.add("027") ;
    		 if(bank_type.equals("0")){
    		 	sqlCmd.append( "WHERE E.BANK_NO IN (SELECT BANK_NO FROM BA01 WHERE m_year=? and BANK_TYPE IN (?,?,?,?)) ");
    		 	paramList.add(u_year) ;
    		 	paramList.add("1") ;
	       		 paramList.add("6") ;
	       		 paramList.add("7") ;
	       		 paramList.add("8") ;
    		 }else {
    		 	sqlCmd.append("WHERE E.BANK_NO IN (SELECT BANK_NO FROM BA01 WHERE BANK_TYPE = ? and m_year=? ) ");
    		 	paramList.add(bank_type) ;
    		 	paramList.add(u_year) ;
    		 }
    		 
    		if(!bank_no.equals("")) {
    			System.out.println("單一金融機構查詢");
    			sqlCmd.append(" AND E.BANK_NO =? " );
    			paramList.add(bank_no) ;
    		}
    		if(!event_date_beg.equals("") || !event_date_end.equals("")){
    		   sqlCmd.append("AND E.EVENTDATE BETWEEN TO_DATE(?,'yyyymmddhh24miss') "+ "AND TO_DATE(?,'yyyymmddhh24miss')" );
    		   paramList.add(event_date_beg) ;
    		   paramList.add(event_date_end) ;
    		}
    		if(!rt_docno.equals("")){
    	   	  sqlCmd.append("AND RT_DOCNO = ? " );
    	   	  paramList.add(rt_docno) ;
    		}
    		if(!item_id.equals("")){
    		  sqlCmd.append("AND ITEM_ID = '"+item_id+"'" );
    		  paramList.add(item_id) ;
    		}
    		if(!track.equals("")){
    		   sqlCmd.append("AND TRACK = ? " );
    		   paramList.add(track) ;
    		}
    	
    		if(!cityType.equals("")) {
    		            sqlCmd.append(" and E.BANK_NO in (select BANK_NO  from WLX01  where HSIEN_ID = ? and m_year=?) " );
    		            paramList.add(cityType) ;
    		            paramList.add(u_year) ;
    		}
    			
    		sqlCmd.append(" ORDER BY BANK_NO" );
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"serial,eventdate,update_date");
            System.out.println("Method getQryResult End ..");
            return dbData;
    }

	public String InsertDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		StringBuffer sqlCmd =new StringBuffer() ;
		String errMsg="";
		String bank_no=((String)request.getParameter("BANK_NO")==null)?" ":(String)request.getParameter("BANK_NO");
		String event_date=((String)request.getParameter("EVENT_DATE")==null)?" ":(String)request.getParameter("EVENT_DATE");
		String rt_docno=((String)request.getParameter("RT_DOCNO")==null)?" ":(String)request.getParameter("RT_DOCNO");
		String rt_date=((String)request.getParameter("RT_DATE")==null)?" ":(String)request.getParameter("RT_DATE");
		String item_id=((String)request.getParameter("ITEM_ID")==null)?" ":(String)request.getParameter("ITEM_ID");
		String track=((String)request.getParameter("TRACK")==null)?" ":(String)request.getParameter("TRACK");
		String summary=((String)request.getParameter("SUMMARY")==null)?" ":(String)request.getParameter("SUMMARY");
		String remark=((String)request.getParameter("REMARK")==null)?" ":(String)request.getParameter("REMARK");

		String add_user=lguser_id;
		String add_name=lguser_name;

		System.out.println("Method InserDB Start...");
		System.out.println("inpute bank_no="+bank_no);
		System.out.println("inpute event_date="+event_date);
		System.out.println("inpute rt_docno="+rt_docno);
		System.out.println("inpute rt_date ="+rt_date);
		System.out.println("inpute item_id="+item_id);
		System.out.println("inpute track="+track);
		System.out.println("inpute summary="+summary);
		System.out.println("inpute remark="+remark);
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		try {
			    sqlCmd.append( "SELECT * FROM EXWARNINGF WHERE BANK_NO=? "
			    		+ "AND RT_DOCNO=?"
			    		+ "AND ITEM_ID=? "
			    		+ "AND TRACK=?");
			    paramList.add(bank_no) ;
			    paramList.add(rt_docno) ;
			    paramList.add(item_id) ;
			    paramList.add(track) ;
				List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"eventdate,rt_date,update_date");

				System.out.println("@@data.size="+data.size());
				String max_cnt ="";
				paramList.clear() ;
				sqlCmd.setLength(0) ;
				if (data.size() != 0){
				    errMsg = errMsg + "此筆專長代碼資料已存在無法新增<br>";
				}else{
					//int max_cnt=0;
					//取得序號最大值
			        //sqlCmd  = "SELECT MAX(SUBSTR(SERIAL, 4, 4) ) as max_cnt "
			        sqlCmd.append("SELECT nvl(MAX(SERIAL), '0') as max_cnt FROM  EXWARNINGF ");
							//+ "WHERE SUBSTR(SERIAL, 1, 3) ="+ sysdate_yy;
					List max_data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"max_cnt");
					System.out.println("max_data.size()="+max_data.size());
					if(max_data.size() != 0){
						for(int i=0;i<max_data.size();i++){
							System.out.println("max_data.size not zeros");
							max_cnt = (((DataObject)max_data.get(0)).getValue("max_cnt")).toString();
							//累計序號
							max_cnt = String.valueOf(Integer.parseInt(max_cnt)+1);
							System.out.println("max_cnt = "+max_cnt );
						}
					}
					paramList.clear() ;
					sqlCmd.setLength(0) ;
					
					sqlCmd.append("INSERT INTO EXWARNINGF VALUES (?,?,"  + "to_date(?,'YYYY/MM/DD')"
			       	+ ",?,"  + "to_date(?,'YYYY/MM/DD')"
			       	+ ",?,?,?,?,?,?,sysdate)");
			        paramList.add(max_cnt) ;
			        paramList.add(bank_no) ;
			        paramList.add(event_date) ;
			        paramList.add(rt_docno) ;
			        paramList.add(rt_date) ;
			        paramList.add(item_id) ;
			        paramList.add(track) ;
			        paramList.add(summary) ;
			        paramList.add(remark) ;
			        paramList.add(add_user) ;
			        paramList.add(add_name) ;
			        
			        updateDBSqlList.add(sqlCmd.toString()) ;
		    		updateDBDataList.add(paramList) ;
		    		updateDBSqlList.add(updateDBDataList) ;
		    		updateDBList.add(updateDBSqlList) ;
   					

				    if(DBManager.updateDB_ps(updateDBList)){
					   errMsg = errMsg + "相關資料寫入資料庫成功";
				    }else{
				 	   errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
				    }
				}
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗<br>[Exception Error]:<br>";
		}
		System.out.println("Method InserDB End...");
		return errMsg;
	}


	private String UpdateDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		StringBuffer sqlCmd = new StringBuffer () ;
		String errMsg="";
		String serial=((String)request.getParameter("SERIAL")==null)?" ":(String)request.getParameter("SERIAL");
		String bank_no=((String)request.getParameter("BANK_NO")==null)?" ":(String)request.getParameter("BANK_NO");
		String event_date=((String)request.getParameter("EVENT_DATE")==null)?" ":(String)request.getParameter("EVENT_DATE");
		String rt_docno=((String)request.getParameter("RT_DOCNO")==null)?" ":(String)request.getParameter("RT_DOCNO");
		String rt_date=((String)request.getParameter("RT_DATE")==null)?" ":(String)request.getParameter("RT_DATE");
		String item_id=((String)request.getParameter("ITEM_ID")==null)?" ":(String)request.getParameter("ITEM_ID");
		String track=((String)request.getParameter("TRACK")==null)?" ":(String)request.getParameter("TRACK");
		String summary=((String)request.getParameter("SUMMARY")==null)?" ":(String)request.getParameter("SUMMARY");
		String remark=((String)request.getParameter("REMARK")==null)?" ":(String)request.getParameter("REMARK");

		String add_user=lguser_id;
		String add_name=lguser_name;

		System.out.println("@@Method UpdateDB Start...");
		System.out.println("inpute serial="+serial);
		System.out.println("inpute bank_no="+bank_no);
		System.out.println("inpute event_date="+event_date);
		System.out.println("inpute rt_docno="+rt_docno);
		System.out.println("inpute rt_date ="+rt_date);
		System.out.println("inpute item_id="+item_id);
		System.out.println("inpute track="+track);
		System.out.println("inpute summary="+summary);
		System.out.println("inpute remark="+remark);
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		try {
				sqlCmd.append( "SELECT * FROM EXWARNINGF WHERE SERIAL= ?"   );
				paramList.add(serial) ;
			    List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"serial,eventdate,rt_date,update_date");
				paramList.clear() ;
				sqlCmd.setLength(0) ;
				System.out.println("data.size="+data.size());
				if (data.size() == 0){
				    errMsg = errMsg + "此筆資料不存在無法修改<br>";
				}else{
				    //insert EXWARNINGF_LOG
					sqlCmd.append(" INSERT INTO EXWARNINGF_LOG "
					       + " select SERIAL, BANK_NO, EVENTDATE, RT_DOCNO, RT_DATE, ITEM_ID, TRACK, SUMMARY, REMARK,"
					       + " ?,?,sysdate,?"
					       + " from EXWARNINGF"
					       + " WHERE SERIAL= ?");
				    paramList.add(add_user) ;
				    paramList.add(add_name) ;
				    paramList.add("U") ;
				    paramList.add(serial) ;
					
				    updateDBSqlList.add(sqlCmd.toString()) ;
		    		updateDBDataList.add(paramList) ;
		    		updateDBSqlList.add(updateDBDataList) ;
		    		updateDBList.add(updateDBSqlList) ;
		    		
		    		paramList = new ArrayList() ;
		    		sqlCmd.setLength(0) ;
		    		updateDBSqlList = new ArrayList() ;
		    		updateDBDataList = new ArrayList <List>() ;
				    //=========================================================================
				    sqlCmd.append("UPDATE EXWARNINGF SET "
				    	   + " EVENTDATE=to_date(?,'YYYY/MM/DD')"
				    	   + ",BANK_NO = ?"
				    	   + ",RT_DOCNO=?"
				    	   + ",RT_DATE=to_date(?,'YYYY/MM/DD')"
					       + ",ITEM_ID=?"
					       + ",TRACK=?"
					       + ",SUMMARY=?"
					       + ",REMARK=?"
					       + ",USER_ID=?"
					       + ",USER_NAME=?"
					       + ",UPDATE_DATE=sysdate"
						   + " where SERIAL= ?" );
		            paramList.add(event_date) ;
		            paramList.add(bank_no) ;
		            paramList.add(rt_docno) ;
		            paramList.add(rt_date) ;
		            paramList.add(item_id) ;
		            paramList.add(track) ;
		            paramList.add(summary) ;
		            paramList.add(remark) ;
		            paramList.add(add_user) ;
		            paramList.add(add_name) ;
		            paramList.add(serial) ;
		            
		            updateDBSqlList.add(sqlCmd.toString()) ;
		    		updateDBDataList.add(paramList) ;
		    		updateDBSqlList.add(updateDBDataList) ;
		    		updateDBList.add(updateDBSqlList) ;
		    		
					if(DBManager.updateDB_ps(updateDBList)){
						errMsg = errMsg + "相關資料寫入資料庫成功";
					}else{
				   		errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
					}
    	   		}
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗<br>[Exception Error]:<br>";
		}
		System.out.println("@@Method UpdateDB End...");
		return errMsg;
	}

    private String DeleteDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		StringBuffer sqlCmd = new StringBuffer() ;
		String errMsg="";
		String serial=((String)request.getParameter("SERIAL")==null)?" ":(String)request.getParameter("SERIAL");
		String bank_no=((String)request.getParameter("BANK_NO")==null)?" ":(String)request.getParameter("BANK_NO");
		String add_user=lguser_id;
		String add_name=lguser_name;

		System.out.println("@@Method DeleteDB Start...");
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		try {
				sqlCmd.append("SELECT * FROM EXWARNINGF WHERE SERIAL=? AND BANK_NO=? " );
				paramList.add(serial) ;
				paramList.add(bank_no) ;
			    List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"serial,eventdate,rt_date,update_date");

				System.out.println("data.size="+data.size());
				paramList.clear() ;
				sqlCmd.setLength(0) ;
				if (data.size() == 0){
					errMsg = errMsg + "此筆資料不存在無法刪除<br>";
				}else{
				 	//insert EXWARNINGF_LOG
					sqlCmd.append(" INSERT INTO EXWARNINGF_LOG "
					       + " select SERIAL, BANK_NO, EVENTDATE, RT_DOCNO, RT_DATE, ITEM_ID, TRACK, SUMMARY, REMARK,"
					       + " ?,?,sysdate,?"
					       + " from EXWARNINGF"
					       + " WHERE SERIAL= ?") ;
					//updateDBSqlList.add(sqlCmd);
					paramList.add(add_user) ;
					paramList.add(add_name) ;
					paramList.add("U") ;
					paramList.add(serial) ;
					
					updateDBSqlList.add(sqlCmd.toString()) ;
		    		updateDBDataList.add(paramList) ;
		    		updateDBSqlList.add(updateDBDataList) ;
		    		updateDBList.add(updateDBSqlList) ;
		    		
		    		paramList = new ArrayList() ;
		    		sqlCmd.setLength(0) ;
		    		updateDBSqlList = new ArrayList() ;
		    		updateDBDataList = new ArrayList <List>() ;
		    		
				 	//delete EXWARNINGF
					sqlCmd.append(" DELETE FROM EXWARNINGF WHERE SERIAL= ?");
				 	paramList.add(serial) ;
					
				 	updateDBSqlList.add(sqlCmd.toString()) ;
		    		updateDBDataList.add(paramList) ;
		    		updateDBSqlList.add(updateDBDataList) ;
		    		updateDBList.add(updateDBSqlList) ;
		    		
					if(DBManager.updateDB_ps(updateDBList)){
						errMsg = errMsg + "相關資料寫入資料庫成功";
					}else{
				   		errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
					}
    	   		}
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗<br>[Exception Error]:<br>";
		}
		System.out.println("@@Method DeleteDB End...");
		return errMsg;
	}
%>
<%System.out.println("@@TC41.jsp End...");%>