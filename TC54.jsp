<%
//94.01.11 create by egg
//99.06.02 fix 套用Header.include & sql Injection by 2808
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>

<%
	System.out.println("@@TC54.jsp Start...");

	String nowact = Utility.getTrimString(dataMap.get("nowact")) ;
	String fault_id = Utility.getTrimString(dataMap.get("FAULT_ID")) ;
	String fault_name = Utility.getTrimString(dataMap.get("FAULT_NAME")) ;

	System.out.println("act="+act);
	System.out.println("nowact="+nowact);
	System.out.println("@@fault_id request.getParameter="+fault_id);

	if(session.getAttribute("muser_id") == null){
      System.out.println("TC54 login timeout");
	  rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );
      rd.forward(request,response);
    }

	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    	System.out.println("@X rquest無權限時,導向到LoginError.jsp");
        rd = application.getRequestDispatcher( LoginErrorPgName );
    }else{
    	//set next jsp
    	if(act.equals("new")){
           rd = application.getRequestDispatcher( EditPgName +"?act=new");
        }else if(act.equals("List")){
           rd = application.getRequestDispatcher( ListPgName +"?act=List");
        }else if(act.equals("Qry")){
    	    List EXFAULTFList = getQryResult(fault_id);
    	    request.setAttribute("EXFAULTFList",EXFAULTFList);
    	    rd = application.getRequestDispatcher( ListPgName +"?act=Qry&fault_id="+fault_id);
    	}else if(act.equals("Edit")){
            List EXFAULTF = getEXFAULTF(fault_id);
            request.setAttribute("EXFAULTF",EXFAULTF);
            if(EXFAULTF.size() != 0){
               fault_id = (String)((DataObject)EXFAULTF.get(0)).getValue("fault_id");
               System.out.println("@X act=Edit fault_id="+fault_id);
            }
            //設定異動者資訊======================================================================
			request.setAttribute("maintainInfo","select * from EXFAULTF WHERE fault_id='" + fault_id+"'");
			//=======================================================================================================================
    	 	rd = application.getRequestDispatcher( EditPgName +"?act=Edit&fault_id=");
    	}else if(act.equals("Insert")){
    		System.out.println("@@act=Insert...");
    	    actMsg = InsertDB(request,lguser_id,lguser_name);
        	rd = application.getRequestDispatcher( nextPgName );
        }else if(act.equals("Update")){
    	    actMsg = UpdateDB(request,lguser_id,lguser_name);
        	rd = application.getRequestDispatcher( nextPgName );
        }else if(act.equals("Delete")){
    	    actMsg = DeleteDB(request,lguser_id,lguser_name);
        	rd = application.getRequestDispatcher( nextPgName );
        }
    	request.setAttribute("actMsg",actMsg);
    }

%>
<%@include file="./include/Tail.include" %>

<%!
	private final static String report_no = "TC54" ;
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
    private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";

   
    //取得EXFAULTF該檢查意見代碼資料
    private List getEXFAULTF(String fault_id){
    		//查詢條件
    		StringBuffer sqlCmd = new StringBuffer () ;
    		List paramList = new ArrayList() ;
    		sqlCmd.append(" select * from EXFAULTF  where fault_id=? ");
			paramList.add(fault_id) ;
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"update_date");
            return dbData;
    }
    //取得查詢結果
    private List getQryResult(String fault_id){
    		//查詢條件
    		StringBuffer sqlCmd = new StringBuffer() ;
    		List paramList = new ArrayList() ;
    		System.out.println("Method getQryResult Start..");
			System.out.println("fault_id:"+fault_id);

    		if(fault_id.equals("")){
    			sqlCmd.append("select fault_id,fault_name from EXFAULTF ORDER BY FAULT_ID" );
    		}else{
			   	sqlCmd.append("select fault_id,fault_name "
			   			+ "from EXFAULTF where  FAULT_ID =? "
			   			+ "ORDER BY FAULT_ID" );
			   	paramList.add(fault_id) ;
			}
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"update_date");
            return dbData;
    }

	public String InsertDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		StringBuffer sqlCmd = new StringBuffer() ;
		String errMsg="";
		String fault_id=((String)request.getParameter("FAULT_ID")==null)?" ":(String)request.getParameter("FAULT_ID");
		String fault_name=((String)request.getParameter("FAULT_NAME")==null)?" ":(String)request.getParameter("FAULT_NAME");
		String add_user=lguser_id;
		String add_name=lguser_name;

		System.out.println("@@Method InserDB Start...");
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		try {
			    sqlCmd.append( "SELECT * FROM EXFAULTF WHERE FAULT_ID=? " );
			    paramList.add(fault_id) ;
				List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"update_date");
				paramList.clear() ;
				sqlCmd.setLength(0) ;
				System.out.println("@@EXFAULTF:data.size="+data.size());

				if (data.size() != 0){
				    errMsg = errMsg + "此筆檢查意見代碼資料已存在無法新增<br>";
				}else{
			        sqlCmd.append("INSERT INTO EXFAULTF VALUES (? "
					       + ",?"
					       + ",?"
					       + ",?"
					       + ",sysdate)" );
			        paramList.add(fault_id) ;
			        paramList.add(fault_name) ;
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
		System.out.println("@@Method InserDB End...");
		return errMsg;
	}


	private String UpdateDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		StringBuffer sqlCmd = new StringBuffer();
		String errMsg="";
		String fault_id= Utility.getTrimString(request.getParameter("FAULT_ID")) ;
		String fault_name= Utility.getTrimString(request.getParameter("FAULT_NAME")) ;
		String add_user=lguser_id;
		String add_name=lguser_name;

		System.out.println("@@Method UpdateDB Start...");
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		try {
				sqlCmd.append( "SELECT * FROM EXFAULTF WHERE FAULT_ID=? " );
				paramList.add(fault_id) ;
				
			    List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"update_date");
				System.out.println("@@EXFAULTF data.size="+data.size());
				sqlCmd.setLength(0) ;
				paramList.clear() ;
				if (data.size() == 0){
				    errMsg = errMsg + "此筆資料不存在無法修改<br>";
				}else{
				    //=========================================================================
				    sqlCmd.append( "UPDATE EXFAULTF SET "
				    	   + " FAULT_NAME=?"
					       + ",USER_ID=? "
					       + ",USER_NAME=? "
					       + ",UPDATE_DATE=sysdate"
						   + " where FAULT_ID=? ");
		            paramList.add(fault_name) ;
		            paramList.add(add_user) ;
		            paramList.add(add_name) ;
		            paramList.add(fault_id) ;
		            
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
		String fault_id= Utility.getTrimString(request.getParameter("FAULT_ID") );
		String fault_name= Utility.getTrimString(request.getParameter("FAULT_NAME") );
		String add_user=lguser_id;
		String add_name=lguser_name;

		System.out.println("@@Method DeleteDB Start...");
		System.out.println("fault_id="+fault_id);
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List

		try {
				sqlCmd.append( "SELECT * FROM EXFAULTF WHERE FAULT_ID=? " );
				paramList.add(fault_id) ;
			    List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"update_date");
				paramList.clear() ;
				sqlCmd.setLength(0) ;
				System.out.println("@@EXFAULTF:data.size="+data.size());

				if (data.size() == 0){
					errMsg = errMsg + "此筆資料不存在無法刪除<br>";
				}else{
				 	//delete EXFAULTF檢查意見代碼檔
				 	sqlCmd.append("DELETE from EXFAULTF where FAULT_ID = ? " );
				 	paramList.add(fault_id) ;
				 	
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
<%System.out.println("@@TC54.jsp End...");%>