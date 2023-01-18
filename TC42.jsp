<%
//1 94.01.11 create by egg
//2 94.03.07	Fix 下拉選單資料末依編緝條件異動錯誤處理
//99.06.02 fix 套用Header.include & sql injection by 2808
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>

<%
	System.out.println("@@TC42.jsp Start...");

	String nowact = ( request.getParameter("nowact")==null ) ? "" : (String)request.getParameter("nowact");
	String getNo = ( request.getParameter("GETNO")==null ) ? "" : (String)request.getParameter("GETNO");
	String base_date = ( request.getParameter("BASE_DATE")==null ) ? "" : (String)request.getParameter("BASE_DATE");
	String report_type = ( request.getParameter("REPORT_TYPE")==null ) ? "" : (String)request.getParameter("REPORT_TYPE");

	System.out.println("act="+act);
	System.out.println("nowact="+nowact);
	System.out.println("getNo="+getNo);
	System.out.println("TC42.jsp BASE_DATE="+base_date);
	System.out.println("report_type="+report_type);

	if(session.getAttribute("muser_id") == null){
      System.out.println("TC42 login timeout");
	  rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );
      rd.forward(request,response);
    }


	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    	System.out.println("@X rquest無權限時,導向到LoginError.jsp");
        rd = application.getRequestDispatcher( LoginErrorPgName );
    }else{
    	//set next jsp
    	if(act.equals("new") || act.equals("List") || act.equals("Qry")){
			if(act.equals("new")){
        	   rd = application.getRequestDispatcher( EditPgName +"?act=new");
        	}
        	if(act.equals("List")){
        		//System.out.println("act.equals(List)");
        		//System.out.println("report_type="+report_type);
        	   rd = application.getRequestDispatcher( ListPgName +"?act=List&report_type="+report_type);
        	}
        	if(act.equals("Qry")){
        		System.out.println("act=Qry,getNo="+getNo);
        		System.out.println("act=Qry,report_type="+report_type);
    		    List EXREPORTFList = getQryResult(report_type,getNo,base_date);
    		    request.setAttribute("EXREPORTFList",EXREPORTFList);
    		    rd = application.getRequestDispatcher( ListPgName +"?act=Qry&getNo="+getNo+"&report_type="+report_type);
    		}
    	}else if(act.equals("Edit")){//編輯(新增or修改)作業處理
    		/*
            List bank_no_list = GetBank_No(bank_type);
            request.setAttribute("bank_no",bank_no_list);
            List EXREPORTF = GetWarning_No(serial);
            request.setAttribute("EXREPORTF",EXREPORTF);
            if(EXREPORTF.size() != 0){
               bank_no = (String)((DataObject)EXREPORTF.get(0)).getValue("bank_no");
            }*/
            //設定異動者資訊======================================================================
			//request.setAttribute("'","select * from EXREPORTF WHERE bank_no='" + bank_no+"'");
			//=======================================================================================================================
    	 	rd = application.getRequestDispatcher( EditPgName +"?act=Edit&bank_no=");
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
	private final static String report_no = "TC42" ;
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
    private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    

    /*取得機構代號
    private List GetBank_No(String bank_type){
    		System.out.println("TC42.Method GetBank_No Start..");
    		System.out.println("Inpute bank_type="+bank_type);

    		//查詢條件
    		String sqlCmd = " SELECT BANK_NO,BANK_NAME FROM BA01 "
    					  + " WHERE BANK_TYPE='"+bank_type+"'"
    					  //+ " and BANK_KIND='1'"
    		    		  + " ORDER BY BANK_NO";
            List dbData = DBManager.QueryDB(sqlCmd,"");

            System.out.println("TC42.Method GetBank_No End..");
            return dbData;
    }*/
    //取得異常警訊資料
    private List GetWarning_No(String serial){
    		System.out.println("TC42.Method GetWarning_No Start..");
    		System.out.println("Inpute serial="+serial);
			StringBuffer sqlCmd = new StringBuffer() ;
			List paramList = new ArrayList() ;
    		//查詢條件
    		sqlCmd.append(" SELECT * FROM EXREPORTF "
    					  + " WHERE SERIAL=? "
    					  //+ " and BANK_KIND='1'"
    		    		  + " ORDER BY BANK_NO" );
    		paramList.add(serial) ;
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"serial,eventdate,rt_date,update_date");

            System.out.println("TC42.Method GetWarning_No End..");
            return dbData;
    }

    //取得查詢結果(List)
    private List getQryResult(String report_type,String getNo,String base_date){
    		//查詢條件
    		StringBuffer sqlCmd = new StringBuffer() ;
    		List paramList = new ArrayList() ;
    		System.out.println("Method getQryResult Start ..");
    		System.out.println("input getNo="+getNo);

    		//取得目前日期處理
			GregorianCalendar tmp_Date = new GregorianCalendar();
    		String tmp_year,tmp_month,tmp_date;
    		String now_date="";
			//取得年月日
    		tmp_year = String.valueOf(tmp_Date.get(tmp_Date.YEAR));
    		tmp_month = String.valueOf(tmp_Date.get(tmp_Date.MONTH)+1);
    		if(Integer.parseInt(tmp_month) < 10){
    			tmp_month="0"+tmp_month;
			}
    		tmp_date = String.valueOf(tmp_Date.get(tmp_Date.DATE));
    		if(Integer.parseInt(tmp_date) < 10){
    			tmp_date="0"+tmp_date;
			}
    		now_date = tmp_year+'/'+tmp_month+"/"+tmp_date;

    		//轉換日期ex:2004/01/01-->20040101提供日期btween比對
    		base_date =Utility.getDatetoString(base_date);
    		now_date = Utility.getDatetoString(now_date);
			String u_year = "99" ;
			if(!"".equals(base_date) && Integer.parseInt(base_date.substring(0,4))>2010) {
				u_year = "100" ;
			}
    		System.out.println("inpute base_date="+base_date);
			System.out.println("get now_date="+now_date);
			System.out.println("intput report_type="+report_type);

			if(report_type.equals("0")){
				System.out.println("report_type=0");
				sqlCmd.append("SELECT BANK_NO,BANK_NAME FROM BA01 "
						+ "WHERE m_year=? and BANK_TYPE IN (?,?,?,?) "
						+ "AND ( BANK_NO NOT IN ( SELECT BANK_NO FROM EXREPORTF) OR BANK_NO NOT IN ( SELECT BANK_NO FROM EXDISTRIPF) ) "); 
				paramList.add(u_year) ;
				paramList.add("1") ;
				paramList.add("6") ;
				paramList.add("7") ;
				paramList.add("8") ;
				if(!getNo.equals("")){
    				System.out.println("家數非空白");
    				sqlCmd.append("AND  ROWNUM <=? ORDER BY BANK_NO " );
    				paramList.add(getNo) ;
    			}else{
    				sqlCmd.append(" ORDER BY BANK_NO" );
    			}
			}else {
				System.out.println("report_type=1");
				sqlCmd.append("SELECT *	FROM ( "
	     				+ "( SELECT E.CH_TYPE AS CH_TYPE,C.CMUSE_NAME AS CMUSE_NAME,E.BANK_TYPE AS BANK_TYPE,E.BANK_NO AS BANK_NO,B.BANK_NAME AS BANK_NAME,E.BASE_DATE AS BASE_DATE "
	        	  		+ "		FROM EXREPORTF E "
	        	  		+ "     LEFT JOIN (select * from ba01 where m_year=? ) B ON BANK_NO = E.BANK_NO"
	        	  		+ "		LEFT JOIN CDSHARENO C ON C.CMUSE_DIV = ? AND C.CMUSE_ID = E.CH_TYPE"
	        	  		+ "		WHERE ORIGINUNT_ID <> ? ");
				paramList.add(u_year) ;
				paramList.add("023") ;
				paramList.add("2") ;
	        	if(!base_date.equals("") || !now_date.equals("")){
    				//System.out.println("查詢日期非空白");
    				sqlCmd.append(" AND BASE_DATE BETWEEN TO_DATE(?,'yyyymmddhh24miss') "+ "AND TO_DATE(?,'yyyymmddhh24miss')" );
    				paramList.add(base_date+"000000") ;
    				paramList.add(now_date+"235959") ;
    			}
	     		sqlCmd.append( ") union ( "
	        	  		+ "	 SELECT A.CH_TYPE AS CH_TYPE,D.CMUSE_NAME AS CMUSE_NAME,A.BANK_TYPE AS BANK_TYPE,A.BANK_NO AS BANK_NO,C.BANK_NAME AS BANK_NAME,B.BASE_DATE AS BASE_DATE "
	        	    	+ "	 FROM EXDISTRIPF A JOIN EXSCHEDULEF B ON A.DISP_ID=B.DISP_ID "
	        	    	+ "  LEFT JOIN (select * from ba01 where m_year=?) C ON BANK_NO = A.BANK_NO"
	        	    	+ "	 LEFT JOIN CDSHARENO D ON D.CMUSE_DIV = ? AND D.CMUSE_ID = A.CH_TYPE"
	        	   		+ "	 WHERE A.DISP_ID NOT IN ( "
	        	        + "		 SELECT DISP_ID "
	        	        + "    	 FROM EXREPORTF "
	        	        + " 	 WHERE ORIGINUNT_ID =? ");
	     		paramList.add(u_year) ;
	     		paramList.add("023") ;
	     		paramList.add("2") ;
   				if(!base_date.equals("") || !now_date.equals("")){
    				//System.out.println("查詢日期非空白");
    				sqlCmd.append("AND BASE_DATE BETWEEN TO_DATE(?,'yyyymmddhh24miss') "+ "AND TO_DATE(?,'yyyymmddhh24miss')" );
    				paramList.add(base_date) ;
    				paramList.add(now_date) ;
    			}
    			if(!getNo.equals("")){
    				System.out.println("家數非空白");
    				sqlCmd.append( " ) ) ) WHERE ROWNUM <=? ORDER BY CH_TYPE" );
					paramList.add(getNo) ;
    			}else{
    				sqlCmd.append( " ) ) ) ORDER BY CH_TYPE" );
    			}
    		}
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"base_date");

            System.out.println("Method getQryResult End ..");
            return dbData;
    }

	public String InsertDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		String sqlCmd = "";
		String errMsg="";
		/*
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

		try {
			    List updateDBSqlList = new LinkedList();
			    sqlCmd 	= "SELECT * FROM EXREPORTF WHERE BANK_NO='" + bank_no + "' "
			    		+ "AND RT_DOCNO='"+rt_docno+"' "
			    		+ "AND ITEM_ID='"+item_id+"' "
			    		+ "AND TRACK='"+track+"'";
				List data = DBManager.QueryDB(sqlCmd,"eventdate,rt_date,update_date");

				System.out.println("@@data.size="+data.size());
				String max_cnt ="";

				if (data.size() != 0){
				    errMsg = errMsg + "此筆專長代碼資料已存在無法新增<br>";
				}else{
					//int max_cnt=0;
					String s_year =
			        //取得序號最大值
			        //sqlCmd  = "SELECT MAX(SUBSTR(SERIAL, 4, 4) ) as max_cnt "
			        sqlCmd  = "SELECT MAX(SERIAL) as max_cnt "
							+ "FROM  EXREPORTF ";
							//+ "WHERE SUBSTR(SERIAL, 1, 3) ="+ sysdate_yy;
					List max_data = DBManager.QueryDB(sqlCmd,"max_cnt");
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
			        sqlCmd 	= "INSERT INTO EXREPORTF VALUES ("+max_cnt
			        		+ ",'" + bank_no + "'"
					       	+ ","  + "to_date('"+event_date+"','YYYY/MM/DD')"
					       	+ ",'" + rt_docno + "'"
					       	+ ","  + "to_date('"+rt_date + "','YYYY/MM/DD')"
					       	+ ",'" + item_id + "'"
					       	+ ",'" + track + "'"
					       	+ ",'" + summary + "'"
					       	+ ",'" + remark + "'"
					       	+ ",'" + add_user + "'"
					       	+ ",'" + add_name +"'"
					       	+ ",sysdate)";
   					updateDBSqlList.add(sqlCmd);

				    if(DBManager.updateDB(updateDBSqlList)){
					   errMsg = errMsg + "相關資料寫入資料庫成功";
				    }else{
				 	   errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
				    }
				}
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗<br>[Exception Error]:<br>";
		}*/
		System.out.println("Method InserDB End...");
		return errMsg;
	}


	private String UpdateDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		String sqlCmd = "";
		String errMsg="";
		/*
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

		try {
				List updateDBSqlList = new LinkedList();

				sqlCmd 	= "SELECT * FROM EXREPORTF WHERE SERIAL=" + serial
						+ "AND BANK_NO='" + bank_no + "'";
			    List data = DBManager.QueryDB(sqlCmd,"serial,eventdate,rt_date,update_date");

				System.out.println("data.size="+data.size());
				if (data.size() == 0){
				    errMsg = errMsg + "此筆資料不存在無法修改<br>";
				}else{
				    //insert EXREPORTF_LOG
					sqlCmd = " INSERT INTO EXREPORTF_LOG "
					       + " select SERIAL, BANK_NO, EVENTDATE, RT_DOCNO, RT_DATE, ITEM_ID, TRACK, SUMMARY, REMARK,"
					       + " '"+add_user+"','"+add_name+"',sysdate,'U'"
					       + " from EXREPORTF"
					       + " WHERE SERIAL=" + serial + " AND BANK_NO='" + bank_no +"'";
					updateDBSqlList.add(sqlCmd);

					//delete EXREPORTF
					//sqlCmd=" delete from EXREPORTF WHERE SERIAL=" + serial + " AND BANK_NO=" + bank_no ;
					//updateDBSqlList.add(sqlCmd);

				    //=========================================================================
				    sqlCmd = "UPDATE EXREPORTF SET "
				    	   + " EVENTDATE=to_date('"+event_date+"','YYYY/MM/DD')"
				    	   + ",RT_DOCNO='"+ rt_docno + "'"
				    	   + ",RT_DATE=to_date('"+rt_date+"','YYYY/MM/DD')"
					       + ",ITEM_ID='" + item_id +"'"
					       + ",TRACK='" + track + "'"
					       + ",SUMMARY='"+summary + "'"
					       + ",REMARK='"+remark + "'"
					       + ",USER_ID='" + add_user +"'"
					       + ",USER_NAME='" + add_name + "'"
					       + ",UPDATE_DATE=sysdate"
						   + " where SERIAL=" + serial + " AND BANK_NO='" + bank_no +"'";
		            updateDBSqlList.add(sqlCmd);

					if(DBManager.updateDB(updateDBSqlList)){
						errMsg = errMsg + "相關資料寫入資料庫成功";
					}else{
				   		errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
					}
    	   		}
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗<br>[Exception Error]:<br>";
		}*/
		System.out.println("@@Method UpdateDB End...");
		return errMsg;
	}

    private String DeleteDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		String sqlCmd = "";
		String errMsg="";
		/*
		String serial=((String)request.getParameter("SERIAL")==null)?" ":(String)request.getParameter("SERIAL");
		String bank_no=((String)request.getParameter("BANK_NO")==null)?" ":(String)request.getParameter("BANK_NO");
		String add_user=lguser_id;
		String add_name=lguser_name;

		System.out.println("@@Method DeleteDB Start...");

		try {
				List updateDBSqlList = new LinkedList();

				sqlCmd 	= "SELECT * FROM EXREPORTF WHERE SERIAL=" + serial
						+ "AND BANK_NO='" + bank_no + "'";
			    List data = DBManager.QueryDB(sqlCmd,"serial,eventdate,rt_date,update_date");

				System.out.println("data.size="+data.size());

				if (data.size() == 0){
					errMsg = errMsg + "此筆資料不存在無法刪除<br>";
				}else{
				 	//insert EXREPORTF_LOG
					sqlCmd = " INSERT INTO EXREPORTF_LOG "
					       + " select SERIAL, BANK_NO, EVENTDATE, RT_DOCNO, RT_DATE, ITEM_ID, TRACK, SUMMARY, REMARK,"
					       + " '"+add_user+"','"+add_name+"',sysdate,'U'"
					       + " from EXREPORTF"
					       + " WHERE SERIAL=" + serial + " AND BANK_NO='" + bank_no +"'";
					updateDBSqlList.add(sqlCmd);

				 	//delete EXREPORTF
					sqlCmd=" DELETE FROM EXREPORTF WHERE SERIAL=" + serial + " AND BANK_NO='" + bank_no +"'";
					updateDBSqlList.add(sqlCmd);

					if(DBManager.updateDB(updateDBSqlList)){
						errMsg = errMsg + "相關資料寫入資料庫成功";
					}else{
				   		errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
					}
    	   		}
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗<br>[Exception Error]:<br>";
		}*/
		System.out.println("@@Method DeleteDB End...");
		return errMsg;
	}
%>
<%System.out.println("@@TC42.jsp End...");%>