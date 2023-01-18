<%
//93.12.26 create by 2295
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
	System.out.println("@@TC53.jsp Start...");
	String nowact = Utility.getTrimString(dataMap.get("nowact")) ;
	String basis_id = Utility.getTrimString(dataMap.get("BASIS_ID")) ;
	String basis_name = Utility.getTrimString(dataMap.get("BASIS_NAME")) ;
	

	System.out.println("act="+act);
	System.out.println("nowact="+nowact);
	
	if(session.getAttribute("muser_id") == null){
      System.out.println("TC53 login timeout");
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
    	    List EXBASISNOFList = getQryResult(basis_id);
    	    request.setAttribute("EXBASISNOFList",EXBASISNOFList);
    	    rd = application.getRequestDispatcher( ListPgName +"?act=Qry&basis_id="+basis_id);
    	}else if(act.equals("Edit")){
            List EXBASISNOF = getEXBASISNOF(basis_id);
            request.setAttribute("EXBASISNOF",EXBASISNOF);
            if(EXBASISNOF.size() != 0){
               basis_id = (String)((DataObject)EXBASISNOF.get(0)).getValue("basis_id");
            }
            //設定異動者資訊======================================================================
			request.setAttribute("maintainInfo","select * from EXBASISNOF WHERE basis_id='" + basis_id+"'");
			//=======================================================================================================================
    	 	rd = application.getRequestDispatcher( EditPgName +"?act=Edit&basis_id=");
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
	private final static String report_no = "TC53" ;
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String EditPgName = "/pages/TC53_Edit.jsp";
    private final static String ListPgName = "/pages/TC53_List.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
   

    //取得EXBASISNOF該總機構代號資料
    private List getEXBASISNOF(String basis_id){
    		//查詢條件
    		StringBuffer sqlCmd = new StringBuffer() ;
    		List paramList = new ArrayList() ;
    		sqlCmd.append(" select * from EXBASISNOF where basis_id=? " );
			paramList.add(basis_id) ;
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"update_date");
            return dbData;
    }
    //取得查詢結果
    private List getQryResult(String basis_id){
    		//查詢條件
    		StringBuffer sqlCmd = new StringBuffer() ;
    		List paramList = new ArrayList() ;
    		if(basis_id.equals("")){
    			sqlCmd.append( "select basis_id,basis_name from EXBASISNOF ORDER BY BASIS_ID" );
    		}else{
				sqlCmd.append("select basis_id,basis_name "
				   		+ "from EXBASISNOF where  basis_id =? "
				   		+ " ORDER BY BASIS_ID" );
				paramList.add(basis_id) ;
			}
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"update_date");
            return dbData;
    }

	public String InsertDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		StringBuffer sqlCmd = new StringBuffer() ;
		String errMsg="";
		String basis_id=((String)request.getParameter("BASIS_ID")==null)?" ":(String)request.getParameter("BASIS_ID");
		String basis_name=((String)request.getParameter("BASIS_NAME")==null)?" ":(String)request.getParameter("BASIS_NAME");
		String add_user=lguser_id;
		String add_name=lguser_name;

		System.out.println("@@Method InserDB Start...");
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		try {
			    sqlCmd.append( "SELECT * FROM EXBASISNOF WHERE BASIS_ID=? " );
			    paramList.add(basis_id) ;
				List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"update_date");
				sqlCmd.setLength(0) ;
				paramList.clear() ;
				System.out.println("@@data.size="+data.size());

				if (data.size() != 0){
				    errMsg = errMsg + "此筆檢查依據代碼資料已存在無法新增<br>";
				}else{
			        sqlCmd.append("INSERT INTO EXBASISNOF VALUES (?"
					       + ",?"
					       + ",?"
					       + ",?"
					       + ",sysdate)" );
   					paramList.add(basis_id) ;
   					paramList.add(basis_name) ;
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
		StringBuffer sqlCmd = new StringBuffer() ;
		String errMsg="";
		String basis_id= Utility.getTrimString(request.getParameter("BASIS_ID")) ;
		String basis_name= Utility.getTrimString(request.getParameter("BASIS_NAME")) ;
		String add_user=lguser_id;
		String add_name=lguser_name;

		System.out.println("@@Method UpdateDB Start...");
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		try {
				sqlCmd.append("SELECT * FROM EXBASISNOF WHERE BASIS_ID=? " );
				paramList.add(basis_id) ;

			    List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"update_date");
			    paramList.clear() ;
			    sqlCmd.setLength(0) ;
				System.out.println("data.size="+data.size());

				if (data.size() == 0){
				    errMsg = errMsg + "此筆資料不存在無法修改<br>";
				}else{
				    //=========================================================================
				    sqlCmd.append( "UPDATE EXBASISNOF SET "
				    	   + " BASIS_NAME=?"
					       + ",USER_ID=?"
					       + ",USER_NAME=?"
					       + ",UPDATE_DATE=sysdate"
						   + " where BASIS_ID=?" );
		            paramList.add(basis_name) ;
		            paramList.add(add_user) ;
		            paramList.add(add_name) ;
		            paramList.add(basis_id) ;
		            
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
		String basis_id= Utility.getTrimString(request.getParameter("BASIS_ID")) ;
		String basis_name= Utility.getTrimString(request.getParameter("BASIS_NAME")) ;
		String add_user=lguser_id;
		String add_name=lguser_name;

		System.out.println("@@Method DeleteDB Start...");
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		try {
				sqlCmd.append( "SELECT * FROM EXBASISNOF WHERE BASIS_ID=? " );
				paramList.add(basis_id) ;
			    List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"update_date");
				sqlCmd.setLength(0) ;
				paramList.clear() ;
				System.out.println("data.size="+data.size());

				if (data.size() == 0){
					errMsg = errMsg + "此筆資料不存在無法刪除<br>";
				}else{
				 	//delete exbasisnof檢查依據代碼檔
				 	sqlCmd.append( "DELETE from EXBASISNOF where BASIS_ID = ? " );
				 	paramList.add(basis_id) ;
				 	
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
<%System.out.println("@@TC53.jsp End...");%>