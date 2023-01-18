<%
//94.01.12 create by egg
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
	System.out.println("@@TC51.jsp Start...");
	

	
	String nowact = Utility.getTrimString(dataMap.get("nowact"));
	String bank_no = Utility.getTrimString(dataMap.get("BANK_NO")) ;
	String subdep_id = Utility.getTrimString(dataMap.get("SUBDEP_ID")) ;
	String js_muser_id =  Utility.getTrimString(dataMap.get("muser_id")) ;
	String js_expertno_id =  Utility.getTrimString(dataMap.get("expertno_id")) ;

	System.out.println("act="+act);
	System.out.println("nowact="+nowact);
	System.out.println("bank_no="+bank_no);
	System.out.println("subdep_id="+subdep_id);
	System.out.println("muser_id="+muser_id);
	System.out.println("js_muser_id="+js_muser_id);

	if(session.getAttribute("muser_id") == null){
      System.out.println("TC51 login timeout");
	  rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );
      rd.forward(request,response);
    }
	

	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    	System.out.println("@X rquest無權限時,導向到LoginError.jsp");
        rd = application.getRequestDispatcher( LoginErrorPgName );
    }else{
    	//set next jsp
    	if(act.equals("new") || act.equals("getData") || act.equals("List") || act.equals("Qry")){
    		System.out.println("TC51.act=new or getData or List Start ....");
    	    System.out.println("TC51.act=new or getData or List.bank_no="+bank_no);
        	System.out.println("TC51.act=new or getData or List.subdep_id="+subdep_id);

    		List muser_id_list = getMuser_Id(bank_no,subdep_id);
    		if(muser_id.equals("") && (muser_id_list.size() != 0)){
               muser_id= (String)((DataObject)muser_id_list.get(0)).getValue("muser_id");
            }
    	    request.setAttribute("muser_id",muser_id_list);

    	    if(act.equals("new")){
    	    	System.out.println("act=new.muser_id="+muser_id);
    	    	//List EXPERSONF = getEXPERSONF(muser_id);
            	//request.setAttribute("EXPERSONF",EXPERSONF);
           		rd = application.getRequestDispatcher( EditPgName +"?act=new");
           	}
        	if(act.equals("List")){
           		rd = application.getRequestDispatcher( ListPgName +"?act=List");
           	}
        	if(act.equals("Qry")){
        		System.out.println("act=Qry...");
    	    	List EXPERSONFList = getQryResult(bank_no,subdep_id,muser_id);
    	    	request.setAttribute("EXPERSONFList",EXPERSONFList);
    	    	rd = application.getRequestDispatcher( ListPgName +"?act=Qry&bank_no="+bank_no+"&subdep_id="+subdep_id+"&muser_id="+muser_id);
    		}
    		if(act.equals("getData")){
        		System.out.println("TC51_act=getData Start ....");
        		System.out.println("TC51_act=getData.bank_no="+bank_no);
        		System.out.println("TC51_act=getData.subdep_id="+subdep_id);
        	    if(nowact.equals("new") || nowact.equals("Edit")){
        	    	System.out.println("act=getData,nowact=new or edit");
        	    	List EXPERSONF = getEXPERSONF(muser_id);
            		request.setAttribute("EXPERSONF",EXPERSONF);
        	       	rd = application.getRequestDispatcher( EditPgName +"?act="+nowact+"&bank_no="+bank_no+"&subdep_id="+subdep_id+"&muser_id="+muser_id);
        	    }
        	    if(nowact.equals("List") || nowact.equals("Qry")){
        	       	System.out.println("act=getData,nowact=List or Qry");
        	        rd = application.getRequestDispatcher( ListPgName +"?act="+nowact+"&bank_no="+bank_no+"&subdep_id="+subdep_id+"&muser_id="+muser_id);
        	    }
        	}
    	}else if(act.equals("Edit")){
    		System.out.println("TC51.jsp act=Edit Start ..");
    		System.out.println("TC51.jsp bank_no="+bank_no);
    		System.out.println("TC51.jsp subdep_id="+subdep_id);
			System.out.println("TC51.jsp js_muser_id="+js_muser_id);
			System.out.println("TC51.jsp js_expertno_id="+js_expertno_id);

			List muser_id_list = getMuser_Id(bank_no,subdep_id);
    	    request.setAttribute("muser_id",muser_id_list);
            List EXPERSONF = getEXPERSONF(js_muser_id);
            request.setAttribute("EXPERSONF",EXPERSONF);
            if(EXPERSONF.size() != 0){
               muser_id = (String)((DataObject)EXPERSONF.get(0)).getValue("muser_id");
            }
            //設定異動者資訊======================================================================
			request.setAttribute("maintainInfo","select * from EXPERSONF WHERE muser_id=''");
			//=======================================================================================================================
    	 	rd = application.getRequestDispatcher( EditPgName +"?act=Edit&bank_no="+bank_no+"&subdep_id="+subdep_id+"&muser_id="+js_muser_id);
    	}else if(act.equals("Insert")){
    		System.out.println("@@act=Insert...");
    	    actMsg = InsertDB(request,lguser_id,lguser_name);
        	rd = application.getRequestDispatcher( nextPgName );
        }else if(act.equals("Update")){
        	System.out.println("TC51.jsp act=Update");
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
	private final static String report_no = "TC51" ;
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String EditPgName = "/pages/TC51_Edit.jsp";
    private final static String ListPgName = "/pages/TC51_List.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    

    //取得員工代碼
    private List getMuser_Id(String bank_no,String subdep_id){
    		System.out.println("TC51.Method getMuser_Id Start..");
    		System.out.println("Inpute bank_no="+bank_no);
    		System.out.println("Inpute subdep_id="+subdep_id);
    		//查詢條件bank_type=2:農業金融局
    		StringBuffer sqlCmd = new StringBuffer() ;
    		List paramList = new ArrayList() ;
    		
    		sqlCmd.append(" select muser_id,muser_name from wtt01  where bank_type = ? ");
    		sqlCmd.append(" and bank_no=? " );
			sqlCmd.append(" and subdep_id=? " );
    		sqlCmd.append(" order by muser_id" );
    		paramList.add("2") ;
    		paramList.add(bank_no) ;
    		paramList.add(subdep_id) ;
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");

            System.out.println("TC51.Method getMuser_Id End..");
            return dbData;
    }

    //取得EXPERSONF專長代號資料
    private List getEXPERSONF(String muser_id){
    		//查詢條件
    		System.out.println("getEXPERSONF Start..");
    		StringBuffer sqlCmd = new StringBuffer () ;
    		List paramList = new ArrayList() ;
    		
    		sqlCmd.append(" select * from EXPERSONF  where muser_id=? ");
    		paramList.add(muser_id) ;
    		
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"update_date");
            return dbData;
    }
    //取得查詢結果
    private List getQryResult(String bank_no,String subdep_id,String muser_id){
    		//查詢條件
    		Calendar now = Calendar.getInstance();
       		String YEAR  = String.valueOf(now.get(Calendar.YEAR)-1911);
       		String u_year = "99" ;
       		if(Integer.parseInt(YEAR) > 99) {
       			u_year = "100" ;
       		}
    		StringBuffer sqlCmd = new StringBuffer() ;
    		List paramList = new ArrayList() ;
    		System.out.println("TC51_Method_getQryResult Start..");
    		System.out.println("input bank_no="+bank_no);
    		System.out.println("input subdep_id="+subdep_id);
    		System.out.println("input muser_id="+muser_id);

    		sqlCmd.append( 	"select	b.bank_name,a.bank_no,a.subdep_id,c.cmuse_name,a.muser_id,a.muser_name,e1.EXPERTNO_ID,e2.EXPERTNO_NAME "
    				+	"from 	wtt01 a "
    				+	"left join (select * from ba01 where m_year=?) b on bank_no = a.bank_no and bank_type=? and a.tbank_no = b.pbank_no "
    				+ 	"left join cdshareno c on cmuse_div = ? and cmuse_id = a.SUBDEP_ID "
    				+	", expersonF e1,expertnof e2 ");
    		paramList.add(u_year);
    		paramList.add("2") ;
    		paramList.add("010") ;
    		if(bank_no.equals("")){
    			System.out.println("bank_no 全部組室");
    			sqlCmd.append( "where a.BANK_TYPE=? and a.TBANK_NO=? "
    				+	"and   	e1.muser_id = a.muser_id "
    				+	"and 	e1.EXPERTNO_ID = e2.EXPERTNO_ID ");
    			paramList.add("2") ;
    			paramList.add("BOAF000") ;
    		}else if(!bank_no.equals("")){//不為全部組室
    			System.out.println("bank_no 不為全部組室");
    			sqlCmd.append(" where a.BANK_TYPE=?  and a.TBANK_NO=? "
    				+	"and   	e1.muser_id = a.muser_id "
    				+	"and 	e1.EXPERTNO_ID = e2.EXPERTNO_ID ");
    			paramList.add("2") ;
    			paramList.add("BOAF000") ;
    			sqlCmd.append("and a.bank_no =?  " );
				paramList.add(bank_no) ;
    			if(!subdep_id.equals("")){
    				System.out.println("subdep_id 單一科別");
    				sqlCmd.append( "and a.subdep_id =?  " );
    				paramList.add(subdep_id) ;
    			}
    			if(!muser_id.equals("")){
    				System.out.println("muser_id !=空白");
    				sqlCmd.append( "and e1.muser_id =?  " );
    				paramList.add(muser_id) ;
    			}
			}
			sqlCmd.append( "order by a.bank_no,a.muser_id,e1.EXPERTNO_ID " );
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
            System.out.println("TC51_Method_getQryResult End..");
            return dbData;
    }

	public String InsertDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		StringBuffer sqlCmd = new StringBuffer() ;
		
		String errMsg="";
		String muser_id		=((String)request.getParameter("MUSER_ID")==null)?"":(String)request.getParameter("MUSER_ID");
		String expert_id[] 	=request.getParameterValues("EXPERT_ID");

		String add_user=lguser_id;
		String add_name=lguser_name;

		System.out.println("@@Method InserDB Start...");
		System.out.println("input muser_id="+muser_id);
		System.out.println("inpute expert_id="+expert_id);
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		try {
			 	//刪除異動前資料
				sqlCmd.append("SELECT MUSER_ID FROM EXPERSONF WHERE MUSER_ID=? " );
			    paramList.add(muser_id) ;
				List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
				paramList.clear() ;
				sqlCmd.setLength(0) ;
				System.out.println("DATA = "+data.size());
				if (data != null && data.size() != 0){
				    sqlCmd.append("DELETE from EXPERSONF where MUSER_ID = ? " );
		        	paramList.add(muser_id) ;
		        	
		        	updateDBSqlList.add(sqlCmd.toString()) ;
				    updateDBDataList.add(paramList) ;
				    updateDBSqlList.add(updateDBDataList) ;
				    updateDBList.add(updateDBSqlList) ;
				   
		        }

			     
			        errMsg =  "員工代碼："+ muser_id +" 相關資料寫入資料庫成功<br>";
				    if(expert_id != null) { 
				      for(int i=0; i < expert_id.length; i++ ) {
				    	  sqlCmd.setLength(0 ) ;
	   					  paramList = new ArrayList() ;
	   					  updateDBSqlList = new ArrayList () ;
	   					  updateDBDataList = new ArrayList <List> () ;
	   					  
				    	   sqlCmd.append("INSERT INTO EXPERSONF VALUES (?"
					       + ",?"
					       + ",?"
					       + ",?"
					       + ",sysdate)");
   					       paramList.add(muser_id) ;
   					       paramList.add(expert_id[i]) ;
   					       paramList.add(add_user) ;
   					       paramList.add(add_name) ;
   					       
   					       updateDBSqlList.add(sqlCmd.toString()) ;
   					       updateDBDataList.add(paramList) ;
   					       updateDBSqlList.add(updateDBDataList) ;
   					       updateDBList.add(updateDBSqlList) ;
   					   
   					    
   					  }
   					  if(!DBManager.updateDB_ps(updateDBList)){
					     errMsg =  "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg() ;
					  }
   					}

				
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = "相關資料寫入資料庫失敗<br>[Exception Error]:<br>";
		}
		System.out.println("@@Method InserDB End...");
		return errMsg;
	}

	private String UpdateDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		StringBuffer sqlCmd = new StringBuffer() ;
		String errMsg="";
		String muser_id = Utility.getTrimString(request.getParameter("MUSER_ID"));
		String expert_id[] 	=request.getParameterValues("EXPERT_ID");
		String bef_expert_id 	=Utility.getTrimString(request.getParameter("BEF_EXPERT_ID"));
		String add_user=lguser_id;
		String add_name=lguser_name;

		System.out.println("@@Method UpdateDB Start...");
		System.out.println("input muser_id="+muser_id);
		System.out.println("inpute expert_id="+expert_id);
		System.out.println("input bef_expert_id="+bef_expert_id);
		
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		try {
				//刪除異動前資料
				sqlCmd.append( "SELECT MUSER_ID FROM EXPERSONF WHERE MUSER_ID=? " );
				paramList.add(muser_id) ;
				List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
				System.out.println("DATA = "+data.size());
				if (data != null && data.size() != 0){
				    sqlCmd.setLength(0) ;
				    paramList.clear() ;
					sqlCmd.append( "DELETE from EXPERSONF where MUSER_ID = ? " );
					paramList.add(muser_id) ;
					updateDBSqlList.add(sqlCmd.toString()) ;
				    updateDBDataList.add(paramList) ;
				    updateDBSqlList.add(updateDBDataList) ;
				    updateDBList.add(updateDBSqlList) ;
		        }
					errMsg =  "員工代碼："+ muser_id +" 相關資料寫入資料庫成功<br>";
				    if(expert_id != null) { 
				      for(int i=0; i < expert_id.length; i++ ) {
				    	  sqlCmd.setLength(0 ) ;
	   					  paramList = new ArrayList() ;
	   					  updateDBSqlList = new ArrayList () ;
	   					  updateDBDataList = new ArrayList <List> () ;
	   					  
			            sqlCmd.append( "INSERT INTO EXPERSONF VALUES (?"
					       + ",?"
					       + ",?"
					       + ",?"
					       + ",sysdate)");
   					    paramList.add(muser_id) ;
   					 	paramList.add(expert_id[i]) ;
   						paramList.add(add_user) ;
   						paramList.add(add_name) ;
   						
   						updateDBSqlList.add(sqlCmd.toString()) ;
   					    updateDBDataList.add(paramList) ;
   					    updateDBSqlList.add(updateDBDataList) ;
   					    updateDBList.add(updateDBSqlList) ;
   					  }
   					  if(!DBManager.updateDB_ps(updateDBList)){
					     errMsg =  "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg() ;
					  }
   					}

				
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg =  "相關資料寫入資料庫失敗<br>[Exception Error]:<br>";
		}
		System.out.println("@@Method UpdateDB End...");
		return errMsg;
	}

    private String DeleteDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		StringBuffer sqlCmd = new StringBuffer() ;
		String errMsg="";
		String muser_id		= Utility.getTrimString(request.getParameter("MUSER_ID"));
		String expert_id 	= Utility.getTrimString(request.getParameter("EXPERT_ID")) ;
		String add_user=lguser_id;
		String add_name=lguser_name;
		
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		System.out.println("@@Method DeleteDB Start...");

		try {
				sqlCmd.append( "SELECT * FROM EXPERSONF WHERE MUSER_ID=? " );
				paramList.add(muser_id) ;
			    List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"update_date");
				if (data.size() == 0){
					errMsg = errMsg + "此筆資料不存在無法刪除<br>";
				}else{
					sqlCmd.setLength(0) ;
					paramList.clear() ;
				 	sqlCmd.append("DELETE from EXPERSONF where MUSER_ID = ? " );
				 	paramList.add(muser_id) ;
				 	
				 	updateDBSqlList.add(sqlCmd.toString()) ;
					updateDBDataList.add(paramList) ;
					updateDBSqlList.add(updateDBDataList) ;
					updateDBList.add(updateDBSqlList) ;
					//DB批次作業處理
					if(DBManager.updateDB_ps(updateDBList)){
						errMsg = errMsg + "相關資料刪除成功";
					}else{
				   		errMsg = errMsg + "相關資料刪除失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
					}
    	   		}
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料刪除失敗<br>[Exception Error]:<br>";
		}
		System.out.println("@@Method DeleteDB End...");
		return errMsg;
	}
%>
<%System.out.println("@@TC51.jsp End...");%>