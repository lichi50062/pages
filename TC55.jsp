<%
//94.01.11 create by egg
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@include file="./include/Header.include" %>
<%
	System.out.println("@@TC55.jsp Start...");

	//RequestDispatcher rd = null;
	//String actMsg = "";
	//String alertMsg = "";
	//String webURL = "";
	//boolean doProcess = false;

	//取得session資料,取得成功時,才繼續往下執行===================================================
	//if(session.getAttribute("muser_id") == null){//session timeout
    //  System.out.println("TC55 login timeout");
	//   rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );
	//   try{
    //      rd.forward(request,response);
    //   }catch(Exception e){
    //      System.out.println("forward Error:"+e+e.getMessage());
    //   }
    //}else{
    //  doProcess = true;
    //}

	if(doProcess){//若muser_id資料時,表示登入成功====================================================================

	//String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");
	String nowact = Utility.getTrimString(dataMap.get("nowact")) ;//( request.getParameter("nowact")==null ) ? "" : (String)request.getParameter("nowact");
	String act_id = Utility.getTrimString(dataMap.get("ACT_ID")) ;//( request.getParameter("ACT_ID")==null ) ? "" : (String)request.getParameter("ACT_ID");
	String act_name = Utility.getTrimString(dataMap.get("ACT_NAME")) ; //( request.getParameter("ACT_NAME")==null ) ? "" : (String)request.getParameter("ACT_NAME");
	//String muser_id = ( request.getParameter("muser_id")==null ) ? "" : (String)request.getParameter("muser_id");

	System.out.println("act="+act);
	System.out.println("nowact="+nowact);
	System.out.println("@@act_id request.getParameter="+act_id);

	if(session.getAttribute("muser_id") == null){
      System.out.println("TC55 login timeout");
	  rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );
      rd.forward(request,response);
    }


	//登入者資訊
	//String lguser_id = ( session.getAttribute("muser_id")==null ) ? "001" : (String)session.getAttribute("muser_id");
	//String lguser_name = ( session.getAttribute("muser_name")==null ) ? "張建偉" : (String)session.getAttribute("muser_name");
	//String lguser_type = ( session.getAttribute("muser_type")==null ) ? "" : (String)session.getAttribute("muser_type");
	//System.out.println("登入者id="+lguser_id);
	//System.out.println("登入者name="+lguser_name);
	//System.out.println("登入者type="+lguser_type);

    //if(!CheckPermission(request)){//無權限時,導向到LoginError.jsp
    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    	System.out.println("@X rquest無權限時,導向到LoginError.jsp");
        rd = application.getRequestDispatcher( LoginErrorPgName );
    }else{
    	//set next jsp
    	if(act.equals("new")){
           rd = application.getRequestDispatcher( EditPgName +"?act=new");
        }else if(act.equals("List")){
        	System.out.println("act = List Start ..");
           rd = application.getRequestDispatcher( ListPgName +"?act=List");
        }else if(act.equals("Qry")){
        	System.out.println("act = Qry Start ..");
        	System.out.println("帶入參數為="+act_id);
    	    List EXACTNOFList = getQryResult(act_id);
    	    request.setAttribute("EXACTNOFList",EXACTNOFList);
    	    rd = application.getRequestDispatcher( ListPgName +"?act=Qry&act_id="+act_id);
    	}else if(act.equals("Edit")){
    		System.out.println("act = Edit Start ..");
            List EXACTNOF = getEXACTNOF(act_id);
            request.setAttribute("EXACTNOF",EXACTNOF);
            if(EXACTNOF.size() != 0){
               act_id = (String)((DataObject)EXACTNOF.get(0)).getValue("act_id");
               System.out.println("@X act=Edit act_id="+act_id);
            }
            //設定異動者資訊======================================================================
			request.setAttribute("maintainInfo","select * from EXACTNOF WHERE act_id='" + act_id+"'");
			//=======================================================================================================================
    	 	rd = application.getRequestDispatcher( EditPgName +"?act=Edit&act_id=");
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

<%
	try {
        //forward to next present jsp
        rd.forward(request, response);
    } catch (NullPointerException npe) {
    }
    }//end of doProcess
%>


<%!
	private final static String report_no = "TC55" ;
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
    private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";

    private boolean CheckPermission(HttpServletRequest request){//檢核權限
    	    boolean CheckOK=false;
    	    HttpSession session = request.getSession();
            Properties permission = ( session.getAttribute("TC55")==null ) ? new Properties() : (Properties)session.getAttribute("TC55");
            
            if(permission == null){
              System.out.println("@@TC55.permission == null");
            }else{
               System.out.println("@@TC55.permission.size ="+permission.size());

            }
            //只要有Query的權限,就可以進入畫面
        	if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){
        	   CheckOK = true;//Query
        	}
        	return CheckOK;
    }

    //取得EXACTNOF該處理意見代碼資料
    private List getEXACTNOF(String act_id){
    		//查詢條件
    		List paramList = new ArrayList() ;
    		paramList.add(act_id) ;
    		String sqlCmd = " select * from EXACTNOF where act_id=? " ;
    					 

            //List dbData = DBManager.QueryDB(sqlCmd,"update_date");
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList ,"update_date") ;
            return dbData;
    }
    //取得查詢結果
    private List getQryResult(String act_id){
    		//查詢條件
    		String sqlCmd = "";
    		List qList = new ArrayList() ;
    		System.out.println("Method \"getQryResult\" Start..");
    		System.out.println("act_id="+act_id);

    		if(act_id.equals("")){
    				System.out.println("act=空白");
    				sqlCmd 	= "select act_id,act_name from EXACTNOF " ;
    						//+ "from EXACTNOF";
    		}else{
				   	System.out.println("act!=空白");
				   	sqlCmd 	= "select act_id,act_name from EXACTNOF where  ACT_ID = ? " ;
				   			//+ "from EXACTNOF where  ACT_ID = '"+act_id+"'";
				   			qList.add(act_id) ;
			}
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,qList,"update_date");
            return dbData;
    }

	public String InsertDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		StringBuffer sql = new StringBuffer() ;
		String errMsg="";
		String act_id=((String)request.getParameter("ACT_ID")==null)?" ":(String)request.getParameter("ACT_ID");
		String act_name=((String)request.getParameter("ACT_NAME")==null)?" ":(String)request.getParameter("ACT_NAME");
		String add_user=lguser_id;
		String add_name=lguser_name;
		List qList = new ArrayList() ;
		List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		System.out.println("@@Method InserDB Start...");
		try {
			    //List updateDBSqlList = new LinkedList();
			    sql.append("SELECT * FROM EXACTNOF WHERE ACT_ID=?  " );
			    qList.add(act_id ) ;
				List data = DBManager.QueryDB_SQLParam(sql.toString(),qList,"update_date");

				System.out.println("@@EXACTNOF:data.size="+data.size());

				if (data.size() != 0){
				    errMsg = errMsg + "此筆處理意見代碼資料已存在無法新增<br>";
				}else{
					sql.setLength(0) ;
					qList.clear() ;
					sql.append("INSERT INTO EXACTNOF VALUES ( ?,?,?,?,sysdate) ");
					//sqlCmd = "INSERT INTO EXACTNOF VALUES ('" + act_id + "'"
					//       + ",'" + act_name + "'"
					//       + ",'" + add_user + "'"
					//       + ",'" + add_name +"'"
					//       + ",sysdate)";
   					//updateDBSqlList.add(sqlCmd);
					
				    //if(DBManager.updateDB(updateDBSqlList)){
				    qList.add(act_id) ;
				    qList.add(act_name) ;
				    qList.add(add_user) ;
				    qList.add(add_name) ;
			        
			        updateDBSqlList.add(sql.toString()) ;
				    updateDBDataList.add(qList) ;
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
		StringBuffer sql = new StringBuffer() ;
		String errMsg="";
		String act_id=((String)request.getParameter("ACT_ID")==null)?" ":(String)request.getParameter("ACT_ID");
		String act_name=((String)request.getParameter("ACT_NAME")==null)?" ":(String)request.getParameter("ACT_NAME");
		String add_user=lguser_id;
		String add_name=lguser_name;

		System.out.println("@@Method UpdateDB Start...");
		List qList = new ArrayList() ;
		List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		try {
				//List updateDBSqlList = new LinkedList();

				//sqlCmd = "SELECT * FROM EXACTNOF WHERE ACT_ID='" + act_id + "'";
				sql.append(" SELECT * FROM EXACTNOF WHERE ACT_ID= ? ");
				qList.add(act_id) ;
			    List data = DBManager.QueryDB_SQLParam(sql.toString(),qList,"update_date");
				System.out.println("@@EXACTNOF data.size="+data.size());

				if (data.size() == 0){
				    errMsg = errMsg + "此筆資料不存在無法修改<br>";
				}else{
					sql.setLength(0) ;
					qList.clear() ;
					//=========================================================================
				    //sqlCmd = "UPDATE EXACTNOF SET "
				    //	   + " ACT_NAME='"+act_name+"'"
					//       + ",USER_ID='" + add_user +"'"
					//       + ",USER_NAME='" + add_name + "'"
					//       + ",UPDATE_DATE=sysdate"
					//	   + " where ACT_ID='"+act_id+"'";
		            //updateDBSqlList.add(sqlCmd);

					//if(DBManager.updateDB(updateDBSqlList)){
					sql.append( "UPDATE EXACTNOF SET  ACT_NAME=? ,USER_ID=?" ) ;
					sql.append(",USER_NAME=? ,UPDATE_DATE=sysdate where ACT_ID=? ");
					qList.add(act_name) ;
				    qList.add(add_user) ;
				    qList.add(act_name) ;
				    qList.add(act_id) ;
		            
				    updateDBSqlList.add(sql.toString()) ;
				    updateDBDataList.add(qList) ;
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
		StringBuffer sql = new StringBuffer() ;
		String errMsg="";
		String act_id=((String)request.getParameter("ACT_ID")==null)?" ":(String)request.getParameter("ACT_ID");
		String act_name=((String)request.getParameter("ACT_NAME")==null)?" ":(String)request.getParameter("ACT_NAME");
		String add_user=lguser_id;
		String add_name=lguser_name;

		System.out.println("@@Method DeleteDB Start...");
		System.out.println("act_id="+act_id);
		List qList = new ArrayList() ;
		List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		try {
				//List updateDBSqlList = new LinkedList();
				sql.append("SELECT * FROM EXACTNOF WHERE ACT_ID=? ") ;
				qList.add(act_id) ;
			    List data = DBManager.QueryDB_SQLParam(sql.toString(),qList,"update_date");

				System.out.println("@@EXACTNOF:data.size="+data.size());

				if (data.size() == 0){
					errMsg = errMsg + "此筆資料不存在無法刪除<br>";
				}else{
				 	//delete EXACTNOF處理意見代碼檔
				 	sql.setLength(0) ;
				 	qList.clear() ;
				 	
				 	sql.append(" DELETE from EXACTNOF where ACT_ID =? ");
				 	qList.add(act_id) ;
		         	//updateDBSqlList.add(sqlCmd);
					//if(DBManager.updateDB(updateDBSqlList)){
					updateDBSqlList.add(sql.toString()) ;
				    updateDBDataList.add(qList) ;
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
<%System.out.println("@@TC55.jsp End...");%>