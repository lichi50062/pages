<%
//95.11.24 create by 2495
//95.12.15 完成檢查追蹤管理維護作業 by 2295
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
    String nowact = Utility.getTrimString(dataMap.get("nowact"));
	String bank_no = Utility.getTrimString(dataMap.get("BANK_NO"));
	String subdep_id = Utility.getTrimString(dataMap.get("SUBDEP_ID"));	
	muser_id = Utility.getTrimString(dataMap.get("MUSER_ID"));

	if(session.getAttribute("muser_id") == null){
	    rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );
      rd.forward(request,response);
    }

	String BankTypeList = "";    	   	  
    String HsienIdList = "";
    String TBankNoList = "";
    String ExamineList = "";

    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
        rd = application.getRequestDispatcher( LoginErrorPgName );
    }else{
    	//set next jsp
    	if(act.equals("new") || act.equals("List") || act.equals("Qry")){
    		List muser_id_list = getMuser_Id(bank_no,subdep_id,act,nowact);
    	    request.setAttribute("muser_id",muser_id_list);
    	    if(act.equals("new")){
           	   rd = application.getRequestDispatcher( EditPgName +"?act=new");
           	}
        	if(act.equals("List")){
           		rd = application.getRequestDispatcher( ListPgName +"?act=List");
           	}
        	if(act.equals("Qry")){
    	    	List wtt08List = getQryResult(bank_no,subdep_id,muser_id);
    	    	request.setAttribute("wtt08List",wtt08List);
    	    	rd = application.getRequestDispatcher( ListPgName +"?act=Qry&bank_no="+bank_no+"&subdep_id="+subdep_id+"&muser_id="+muser_id);
    		}
    	}else if(act.equals("Copy")){
    	    List muser_id_list = getCopyMuser_ID(request);
    	    if(muser_id_list != null && muser_id_list.size() != 0){
    	       System.out.println("Copy.muser_id="+(String)muser_id_list.get(0));
    	       muser_id = (String)muser_id_list.get(0);
    	   	   System.out.println("Edit.muser_id="+muser_id);    	      
    	   	   BankTypeList = getBankTypeList(muser_id);    	   	  
    	   	   HsienIdList = getHsienIdList(muser_id);
    	       TBankNoList = getTBankNoList(muser_id);
    	       ExamineList = getExamineList(muser_id);
    	       System.out.println("BankTypeList="+BankTypeList);
    	       System.out.println("HsienIdList="+HsienIdList);
    	       System.out.println("TBankNoList="+TBankNoList);
    	       System.out.println("ExamineList="+ExamineList);
    	       session.setAttribute("BankTypeList",BankTypeList);
    	       session.setAttribute("HsienIdList",HsienIdList);
    	       session.setAttribute("TBankNoList",TBankNoList);
    	       session.setAttribute("ExamineList",ExamineList);
    	 	   rd = application.getRequestDispatcher( EditPgName +"?act=Copy&bank_no="+bank_no+"&subdep_id="+subdep_id+"&muser_id="+muser_id);
    	    }    	    
    	}else if(act.equals("Edit")){    	        	    
    	      System.out.println("Edit.muser_id="+muser_id);    	      
    	   	  BankTypeList = getBankTypeList(muser_id);    	   	  
    	   	  HsienIdList = getHsienIdList(muser_id);
    	      TBankNoList = getTBankNoList(muser_id);
    	      ExamineList = getExamineList(muser_id);
    	      System.out.println("BankTypeList="+BankTypeList);
    	      System.out.println("HsienIdList="+HsienIdList);
    	      System.out.println("TBankNoList="+TBankNoList);
    	      System.out.println("ExamineList="+ExamineList);
    	      session.setAttribute("BankTypeList",BankTypeList);
    	      session.setAttribute("HsienIdList",HsienIdList);
    	      session.setAttribute("TBankNoList",TBankNoList);
    	      session.setAttribute("ExamineList",ExamineList);
    	 	  rd = application.getRequestDispatcher( EditPgName +"?act=Edit&bank_no="+bank_no+"&subdep_id="+subdep_id+"&muser_id="+muser_id);
    	}else if(act.equals("Insert")){
    	    actMsg = InsertDB(request,lguser_id,lguser_name);
    	    List wtt08List = getQryResult("","","");
    	   	session.setAttribute("wtt08List",wtt08List);
        	rd = application.getRequestDispatcher( nextPgName +"?goPages=TC57_List.jsp&act=Qry&bank_no="+bank_no+"&subdep_id="+subdep_id+"&muser_id="+muser_id);
        }else if(act.equals("Update")){
    	    actMsg = UpdateDB(request,lguser_id,lguser_name);
    	    List wtt08List = getQryResult("","","");    	   	
    	   	session.setAttribute("wtt08List",wtt08List);
        	rd = application.getRequestDispatcher( nextPgName +"?goPages=TC57_List.jsp&act=Qry&bank_no="+bank_no+"&subdep_id="+subdep_id+"&muser_id="+muser_id);
        }else if(act.equals("Delete")){
    	    actMsg = DeleteDB(request,lguser_id,lguser_name);
    	    List wtt08List = getQryResult("","","");
    	   	request.setAttribute("wtt08List",wtt08List);
    	   	session.setAttribute("wtt08List",wtt08List);
        	rd = application.getRequestDispatcher( nextPgName+"?goPages=TC57_List.jsp&act=Qry&bank_no="+bank_no+"&subdep_id="+subdep_id+"&muser_id="+muser_id );
        }
    	request.setAttribute("actMsg",actMsg);
    }

%>
<%@include file="./include/Tail.include" %>

<%!
	private final static String report_no = "TC57" ;
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
    private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
   
    //取得員工代碼
    private List getMuser_Id(String bank_no,String subdep_id,String act,String nowact){
            System.out.println("getMuser_Id.act="+act);
            System.out.println("bank_no="+bank_no);
            System.out.println("subdep_id="+subdep_id);
    		//查詢條件bank_type=2:農業金融局
    		StringBuffer sqlCmd = new StringBuffer() ;
    		List paramList = new ArrayList() ;
    		sqlCmd.append( " select muser_id,muser_name from wtt01  where bank_type =? ");
    		paramList.add("2") ;
			if(!bank_no.equals("")){
    		    sqlCmd.append( " and bank_no=? " );
    		    paramList.add(bank_no ) ;
    		}
    		if(!subdep_id.equals("")){
    			sqlCmd.append(" and subdep_id=? " );
    			paramList.add(subdep_id) ;
    		}
    		if((act.equals("new") || act.equals("getData")) && !nowact.equals("List")){
    		   sqlCmd.append( " and muser_id not in (select distinct muser_id from wtt08)" );

    		}
    		sqlCmd.append( " order by muser_id" );
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
            return dbData;
    }

    //取得查詢結果
    private List getQryResult(String bank_no,String subdep_id,String muser_id){
    		System.out.println("getQryResult.bank_no="+bank_no);
    		System.out.println("getQryResult.subdep_id="+subdep_id);
    		System.out.println("getQryResult.muser_id="+muser_id);
    		Calendar now = Calendar.getInstance();
           	String YEAR  = String.valueOf(now.get(Calendar.YEAR)-1911);
           	String u_year = "99" ;
           	if(Integer.parseInt(YEAR) > 99) {
           		u_year = "100" ;
           	}
    		//查詢條件
    		/*只查詢唯一的muser_id
            select distinct wtt08.muser_id,wtt01.muser_name,wtt01.bank_no,wtt01_data.bank_name,
            	   wtt01.subdep_id,subdep_id_name.cmuse_name as subdep_id_name
            from wtt08 left join wtt01 on wtt08.muser_id = wtt01.muser_id
            left join (select bank_no,bank_name
            	 	   from ba01
            		   where bank_type='2'
            		   and bank_kind = '1'
            		   and pbank_no = 'BOAF000'
            		   order by bank_no)wtt01_data on wtt01_data.bank_no = wtt01.bank_no
            left join (select cmuse_id,cmuse_name
            	       from cdshareno
            		   where cmuse_div='010'
            		   order by input_order)subdep_id_name on subdep_id_name.cmuse_id = wtt01.subdep_id
            --where wtt08.muser_id in ('BOAF000001')
            order by wtt08.muser_id,wtt01.bank_no,wtt01.subdep_id

    		*/
    		/*
    		select wtt08.muser_id,wtt01.bank_no,wtt01_data.bank_name,
            	   wtt01.subdep_id,subdep_id_name.cmuse_name as subdep_id_name,
                   wtt08.bank_type,bank_type_data.cmuse_name as bank_type_name,
                   wtt08.hsien_id,cd01.HSIEN_NAME,
            	   wtt08.tbank_no,bn01.bank_name as tbank_no_name,
            	   wtt08.examine,bn02.bank_name as examine_name
            from wtt08 left join wtt01 on wtt08.muser_id = wtt01.muser_id
            left join (select bank_no,bank_name
            	 	   from ba01
            		   where bank_type='2'
            		   and bank_kind = '1'
            		   and pbank_no = 'BOAF000'
            		   order by bank_no)wtt01_data on wtt01_data.bank_no = wtt01.bank_no --組室名稱
            left join (select cmuse_id,cmuse_name
            	       from cdshareno
            		   where cmuse_div='010'
            		   order by input_order)subdep_id_name on subdep_id_name.cmuse_id = wtt01.subdep_id --科別代號
            left join  (select cmuse_id,cmuse_name
            	       from cdshareno
            		   where cmuse_div='001'
            		   order by input_order)bank_type_data on bank_type_data.cmuse_id = wtt08.bank_type --金融機構類別
            left join cd01 on wtt08.hsien_id = cd01.HSIEN_ID --縣市別
            left join bn01 on bank_no = wtt08.tbank_no --總機構單位
            left join bn02 on bank_no = wtt08.examine --受檢單位
            where wtt08.muser_id='BOAF000001'
 			*/
    		StringBuffer sqlCmd = new StringBuffer();
    		List sqlList = new ArrayList() ;
    		StringBuffer condition = new StringBuffer() ;
    		
    		sqlCmd.append( " select distinct wtt08.muser_id,wtt01.muser_name,wtt01.bank_no,wtt01_data.bank_name,"
	   				+ "        wtt01.subdep_id,subdep_id_name.cmuse_name as subdep_id_name"
				    + "	from wtt08 left join wtt01 on wtt08.muser_id = wtt01.muser_id"
			        + " left join (select bank_no,bank_name"
	 	   		    + "			   from ba01"
		   		    + "			   where m_year = ? and bank_type= ? "
		   		    + "			   and bank_kind = ?"
		   		    + "			   and pbank_no = ? "
		   		    + "			   order by bank_no)wtt01_data on wtt01_data.bank_no = wtt01.bank_no"
				    + "	left join (select cmuse_id,cmuse_name"
	       			+ "			   from cdshareno "
		   		    + "			   where cmuse_div=?"
		   		    + "			   order by input_order)subdep_id_name on subdep_id_name.cmuse_id = wtt01.subdep_id");
    		
			sqlList.add(u_year) ;
			sqlList.add("2") ;
			sqlList.add("1") ;
			sqlList.add("BOAF000") ;
			sqlList.add("010") ;
			
    		if(!bank_no.equals("")){//組室代號不為空白
    			condition.append( " wtt01_data.bank_no = ? " );
    			sqlList.add(bank_no) ;
    		}
    		if(!subdep_id.equals("")){//科別代號不為空白
    		   condition.append( " and subdep_id_name.cmuse_id=?" );
    		   sqlList.add(subdep_id) ;
    		}
    		if(!muser_id.equals("")){//員工代碼不為空白
    		   condition.append( " and wtt08.muser_id=? " );
    		   sqlList.add(muser_id) ;
    		}
    		if(condition.length() > 0){
    		  sqlCmd.append( " where ").append(condition );
    		  
    		}
			sqlCmd.append(" order by wtt08.muser_id,wtt01.bank_no,wtt01.subdep_id" );
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),sqlList,"");
            return dbData;
    }

	private List getCopyMuser_ID(HttpServletRequest request){
	    List muser_id=new LinkedList();
	    try{
	         //取出form裡的所有變數===================================
		  	 Enumeration ep = request.getParameterNames();
		  	 Enumeration ea = request.getAttributeNames();
		  	 Hashtable t = new Hashtable();
		  	 String name = "";

		  	 for ( ; ep.hasMoreElements() ; ) {
			   		name = (String)ep.nextElement();
			   		t.put( name, request.getParameter(name) );
		  	 }
		  	 int row =Integer.parseInt((String)t.get("row"));
		  	 System.out.println("row="+row);
		  	 for ( int i = 0; i < row; i++) {
				if ( t.get("isModify_" + (i+1)) != null ) {
				    muser_id.add((String)t.get("isModify_"+(i+1)));
				}
		  	}
	    }catch(Exception e){
	        System.out.println("getCopyMuser_ID Error:"+e.getMessage());
	    }
	    return muser_id;
	}


	public String InsertDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		StringBuffer sqlCmd = new StringBuffer() ;
		String errMsg="";
		String muser_id	= Utility.getTrimString(request.getParameter("MUSER_ID")) ;
		String DataList	= Utility.getTrimString(request.getParameter("DataList")) ; 
		String bank_type="";
		String hsien_id="";
		String tbank_no="";
		String examine="";
		
		List examine_detail = null;
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		try {
		        List examine_List = Utility.getStringTokenizerData(DataList,",");

			    //List updateDBSqlList = new LinkedList();
			    System.out.println("examine_List.size()="+examine_List.size());
			    for(int i=0;i<examine_List.size();i++){
					examine_detail = Utility.getStringTokenizerData((String)examine_List.get(i),":");
					bank_type=(String)examine_detail.get(0);
					hsien_id=(String)examine_detail.get(1);
					/*
					if(hsien_id.equals("--")){
					   hsien_id=" ";
					}*/
					tbank_no=(String)examine_detail.get(2);
					examine=(String)examine_detail.get(3);
					sqlCmd.append( "INSERT INTO WTT08 VALUES (?"
					       + ",?"
					       + ",?"
					       + ",?"
					       + ",?"
					       + ",?"
					       + ",?"
					       + ",sysdate)" );
					paramList.add(muser_id) ;
					paramList.add(bank_type) ;
					paramList.add(hsien_id) ;
					paramList.add(tbank_no) ;
					paramList.add(examine) ;
					paramList.add(lguser_id) ;
					paramList.add(lguser_name) ;
				    //System.out.println(sqlCmd);
   					//updateDBSqlList.add(sqlCmd);
					updateDBSqlList.add(sqlCmd.toString()) ;
				    updateDBDataList.add(paramList) ;
				    updateDBSqlList.add(updateDBDataList) ;
				    updateDBList.add(updateDBSqlList) ;
				    
				    paramList = new ArrayList () ;
				    sqlCmd.setLength(0) ;
				    updateDBSqlList = new ArrayList() ;
				    updateDBDataList = new ArrayList<List> () ;
				    
			    }

			    if(DBManager.updateDB_ps(updateDBList)){
				   errMsg = errMsg + "相關資料寫入資料庫成功";
				}else{
				   errMsg = errMsg + "相關資料寫入資料庫失敗";
				}

		}catch (Exception e){
				System.out.println("InsertDB Error:"+e.getMessage());
				errMsg = "相關資料寫入資料庫失敗";
		}
		return errMsg;
	}

	private String UpdateDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		StringBuffer sqlCmd = new StringBuffer() ;
		String errMsg="";
		String muser_id	=((String)request.getParameter("MUSER_ID")==null)?"":(String)request.getParameter("MUSER_ID");
		String DataList	=((String)request.getParameter("DataList")==null)?"":(String)request.getParameter("DataList");
		System.out.println("Update_muser_id:"+muser_id);
		System.out.println("DataList="+DataList);
		String bank_type="";
		String hsien_id="";
		String tbank_no="";
		String examine="";
		List examine_detail = null;
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		try {
			 //List updateDBSqlList = new LinkedList();
			 //先刪除資料.再新增
			 sqlCmd.append( "SELECT * FROM WTT08 WHERE MUSER_ID=?  " );
			 paramList.add(muser_id) ;
			 errMsg += muser_id+"<br>";
			 List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
			 sqlCmd.setLength(0) ;
			 paramList.clear(); 
			 if(data.size() == 0){
				errMsg += "此筆資料不存在無法刪除<br>";
			 }else{
			    //insert WTT08_LOG===================================================
				 sqlCmd.append(" INSERT INTO WTT08_LOG "
				        + " select muser_id,bank_type,hsien_id,tbank_no,examine,"
					    + " user_id,user_name,update_date"
					    + ",?,?,sysdate"
					    + ",?"
					    + " from WTT08"
					    + " WHERE muser_id=? " );
			     paramList.add(lguser_id) ;
			     paramList.add(lguser_name) ;
			     paramList.add("U") ;
			     paramList.add(muser_id) ;
			     
			     updateDBSqlList.add(sqlCmd.toString()) ;
				 updateDBDataList.add(paramList) ;
				 updateDBSqlList.add(updateDBDataList) ;
				 updateDBList.add(updateDBSqlList) ;
				 //updateDBSqlList.add(sqlCmd);
				 paramList = new ArrayList () ;
				 sqlCmd.setLength(0) ;
				 updateDBSqlList = new ArrayList() ;
				 updateDBDataList = new ArrayList<List> () ;
				 //=========================================================================
				 sqlCmd.append( "DELETE from WTT08 where MUSER_ID = ? " );
				 paramList.add(muser_id) ;
				 
				 updateDBSqlList.add(sqlCmd.toString()) ;
				 updateDBDataList.add(paramList) ;
				 updateDBSqlList.add(updateDBDataList) ;
				 updateDBList.add(updateDBSqlList) ;
			 }
    	   		
			 List examine_List = Utility.getStringTokenizerData(DataList,",");
			 System.out.println("examine_List.size()="+examine_List.size());
			 //新增資料
			 for(int i=0;i<examine_List.size();i++){
				 examine_detail = Utility.getStringTokenizerData((String)examine_List.get(i),":");
				 bank_type=(String)examine_detail.get(0);
				 hsien_id=(String)examine_detail.get(1);
				 /*
				 if(hsien_id.equals("--")){
				   hsien_id=" ";
				 }*/
				 tbank_no=(String)examine_detail.get(2);
				 examine=(String)examine_detail.get(3);
				 
				 paramList = new ArrayList () ;
				 sqlCmd.setLength(0) ;
				 updateDBSqlList = new ArrayList() ;
				 updateDBDataList = new ArrayList<List> () ;
				 
				 sqlCmd.append( "INSERT INTO WTT08 VALUES (?"
				        + ",?"
					    + ",?"
					    + ",?"
					    + ",?"
					    + ",?"
					    + ",?"
					    + ",sysdate)" );
				paramList.add(muser_id) ;
				paramList.add(bank_type) ;
				paramList.add(hsien_id) ;
				paramList.add(tbank_no) ;
				paramList.add(examine) ;
				paramList.add(lguser_id) ;
				paramList.add(lguser_name) ;
   				//updateDBSqlList.add(sqlCmd);
				updateDBSqlList.add(sqlCmd.toString()) ;
				updateDBDataList.add(paramList) ;
				updateDBSqlList.add(updateDBDataList) ;
				updateDBList.add(updateDBSqlList) ;
			 }
    	     
			 if(DBManager.updateDB_ps(updateDBList)){
					errMsg += "相關資料更改成功";
			 }else{
				 	errMsg += "相關資料更改失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
			 }    	   	
		}catch (Exception e){
				System.out.println("UpdateDB Error:"+e.getMessage());
				errMsg = errMsg + "相關資料更改失敗";
		}
		return errMsg;
	}

    private String DeleteDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		StringBuffer sqlCmd = new StringBuffer() ;
		String errMsg="";
		List muser_id_list = getCopyMuser_ID(request);
		List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
		try {
			 //List updateDBSqlList = new LinkedList();
			 if(muser_id_list != null && muser_id_list.size() != 0){
				for(int i=0;i<muser_id_list.size();i++){
					 sqlCmd.setLength(0) ;
					 paramList = new ArrayList() ;
			         sqlCmd.append( "SELECT * FROM WTT08 WHERE MUSER_ID=?  " );
			         paramList.add(muser_id_list.get(i)) ;
			         errMsg += (String)muser_id_list.get(i)+"<br>";
			    	 List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
					 if(data.size() == 0){
						errMsg += "此筆資料不存在無法刪除<br>";
					 }else{
						 paramList = new ArrayList () ;
						 sqlCmd.setLength(0) ;
						 updateDBSqlList = new ArrayList() ;
						 updateDBDataList = new ArrayList<List> () ;
				        //insert WTT08_LOG===================================================
				        sqlCmd.append(" INSERT INTO WTT08_LOG "
						       + " select muser_id,bank_type,hsien_id,tbank_no,examine,"
						       + " user_id,user_name,update_date"
						       + ",?,?,sysdate"
						       + ", ?"
						       + " from WTT08"
						       + " WHERE muser_id=? " );
				        paramList.add(lguser_id) ;
				        paramList.add(lguser_name) ;
				        paramList.add("D") ;
				        paramList.add((String)muser_id_list.get(i) ) ;
				        
					    //updateDBSqlList.add(sqlCmd);
					    updateDBSqlList.add(sqlCmd.toString()) ;
						updateDBDataList.add(paramList) ;
						updateDBSqlList.add(updateDBDataList) ;
						updateDBList.add(updateDBSqlList) ;
				        //=========================================================================
				         paramList = new ArrayList () ;
						 sqlCmd.setLength(0) ;
						 updateDBSqlList = new ArrayList() ;
						 updateDBDataList = new ArrayList<List> () ;
						 
				 	     sqlCmd.append( "DELETE from WTT08 where MUSER_ID = ? " );
				 	     paramList.add(muser_id_list.get(i)) ;
				 	     
		         	     //updateDBSqlList.add(sqlCmd);
				 	    updateDBSqlList.add(sqlCmd.toString()) ;
						updateDBDataList.add(paramList) ;
						updateDBSqlList.add(updateDBDataList) ;
						updateDBList.add(updateDBSqlList) ;
					 }
    	   		}//end of for

    	   		//DB批次作業處理
				if(DBManager.updateDB_ps(updateDBList)){
					errMsg += "相關資料刪除成功";
				}else{
				 	errMsg += "相關資料刪除失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
				}
    	   	}else{
    	   	    errMsg += "無勾選資料可刪除";
    	   	}
		}catch (Exception e){
				System.out.println("DeleteDB Error:"+e.getMessage());
				errMsg = errMsg + "相關資料刪除失敗";
		}
		return errMsg;
	}
	private String getBankTypeList(String muser_id){		
		StringBuffer sqlCmd = new StringBuffer() ;
		List paramList = new ArrayList() ;
		String bank_type = "";
		try{
           sqlCmd.append( " select distinct bank_type,bank_type_name from"
			      + " (select wtt08.muser_id,"
       			  + " wtt08.bank_type,bank_type_data.cmuse_name as bank_type_name"
				  + " from wtt08 left join (select cmuse_id,cmuse_name "
	       		  + " 					  from cdshareno "
				  + " 					  where cmuse_div=? "
				  + " order by input_order)bank_type_data on bank_type_data.cmuse_id = wtt08.bank_type"
				  + " where wtt08.muser_id in (? )"
				  + " order by wtt08.bank_type) where muser_id = ? " );
           paramList.add("001") ; 
           paramList.add(muser_id) ;
           paramList.add(muser_id) ;
		  List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
		  if(dbData != null && dbData.size() != 0){
		     for(int i=0;i<dbData.size();i++){		       
			   //6230012+6230012台北市北投區農會信用部,		     		     
		       bank_type += ((String)((DataObject)dbData.get(i)).getValue("bank_type"))
		       			 + "+"
		       			 + ((String)((DataObject)dbData.get(i)).getValue("bank_type_name"));
		       if(i != dbData.size()-1){
		         bank_type += ",";
		       }
		     }
		  }
       }catch(Exception e){
          System.out.println("getBankTypeList Error:"+e.getMessage());
       }
       return bank_type;
    }
    private String getHsienIdList(String muser_id){
		String hsien_id = "";
		StringBuffer sqlCmd = new StringBuffer() ;
		List paramList = new ArrayList() ;
		Calendar now = Calendar.getInstance();
       	String YEAR  = String.valueOf(now.get(Calendar.YEAR)-1911);
       	String u_year = "99" ;
       	String cd01Table = "cd01_99" ;
       	if(Integer.parseInt(YEAR) > 99) {
       		u_year = "100" ;
       		cd01Table = "cd01" ;
       	}
		try{
           sqlCmd.append( " select distinct hsien_id,hsien_name from"
				  + " (select wtt08.muser_id,wtt08.hsien_id,cd01.HSIEN_NAME"
				  + " from wtt08 left join ").append(cd01Table).append(" cd01 on wtt08.hsien_id = cd01.HSIEN_ID "
				  + " where wtt08.muser_id in (? )"
				  + " and wtt08.hsien_id <> '-'"//95.12.18 fix 若wtt08.hsien_id="-"表示,為全國農業金庫/共用中心
				  + " order by wtt08.muser_id,wtt08.hsien_id)");
           paramList.add(muser_id) ;
		  List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
		  if(dbData != null && dbData.size() != 0){
		     for(int i=0;i<dbData.size();i++){
		       //6230012+6230012台北市北投區農會信用部,		     
		       hsien_id += ((String)((DataObject)dbData.get(i)).getValue("hsien_id"))
		       		    + "+"
		       		    + ((String)((DataObject)dbData.get(i)).getValue("hsien_id"))
		       		    + ((String)((DataObject)dbData.get(i)).getValue("hsien_name"));		       
		       if(i != dbData.size()-1){
		         hsien_id += ",";
		       }
		     }
		  }
       }catch(Exception e){
          System.out.println("getHsienIdList Error:"+e.getMessage());
       }
       return hsien_id;
    }

	private String getTBankNoList(String muser_id){
		String tbank_no = "";
		StringBuffer sqlCmd = new StringBuffer() ;
		List paramList = new ArrayList() ;
		Calendar now = Calendar.getInstance();
       	String YEAR  = String.valueOf(now.get(Calendar.YEAR)-1911);
       	String u_year = "99" ;
       	String cd01Table = "cd01_99" ;
       	if(Integer.parseInt(YEAR) > 99) {
       		u_year = "100" ;
       		cd01Table = "cd01" ;
       	}
		try{
          sqlCmd.append( " select wtt08.muser_id,"
	   			 + " wtt08.tbank_no,bn01.bank_name as tbank_no_name"
				 + " from wtt08 left join (select * from bn01 where m_year=? )bn01 on bank_no = wtt08.tbank_no"
				 + " where wtt08.muser_id in (?)"
				 + " group by muser_id,tbank_no,bn01.bank_name"
				 + " order by wtt08.muser_id,wtt08.tbank_no" );
          paramList.add(u_year) ;
          paramList.add(muser_id) ;
		  List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
		  if(dbData != null && dbData.size() != 0){
		     for(int i=0;i<dbData.size();i++){
			   //6230012+6230012台北市北投區農會信用部,		     
		       tbank_no += ((String)((DataObject)dbData.get(i)).getValue("tbank_no"))
		       		    + "+"
		       		    + ((String)((DataObject)dbData.get(i)).getValue("tbank_no"))
		       		    + ((String)((DataObject)dbData.get(i)).getValue("tbank_no_name"));
		       if(i != dbData.size()-1){
		         tbank_no += ",";
		       }
		     }
		  }
       }catch(Exception e){
          System.out.println("getTBankNoList Error:"+e.getMessage());
       }
       return tbank_no;
    }

	private String getExamineList(String muser_id){
	    
		String examine = "";
		StringBuffer  sqlCmd = new StringBuffer() ;
		List paramList = new ArrayList() ;
		Calendar now = Calendar.getInstance();
       	String YEAR  = String.valueOf(now.get(Calendar.YEAR)-1911);
       	String u_year = "99" ;
       	String cd01Table = "cd01_99" ;
       	if(Integer.parseInt(YEAR) > 99) {
       		u_year = "100" ;
       		cd01Table = "cd01" ;
       	}
		try{
		   sqlCmd.append( " select wtt08.bank_type,wtt08.hsien_id,wtt08.tbank_no,"
		   		  + " 		 wtt08.examine,ba01.bank_name as examine_name"
				  + " from wtt08 left join (select * from ba01 where m_year=?)ba01 on bank_no = wtt08.examine"
				  + " where wtt08.muser_id in (? )"
				  + " group by wtt08.bank_type,wtt08.hsien_id,wtt08.tbank_no,wtt08.examine,ba01.bank_name"
				  + " order by wtt08.examine" );		   
		  paramList.add(u_year)  ;
		  paramList.add(muser_id)  ;
		  List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
		  if(dbData != null && dbData.size() != 0){
		     for(int i=0;i<dbData.size();i++){
		       //6230012+6230012台北市北投區農會信用部,
		       examine += ((String)((DataObject)dbData.get(i)).getValue("bank_type"))+":"
		       		   +  ((String)((DataObject)dbData.get(i)).getValue("hsien_id"))+":"
		       		   +  ((String)((DataObject)dbData.get(i)).getValue("tbank_no"))+":"
		       		   +  ((String)((DataObject)dbData.get(i)).getValue("examine"))
		       	       + "+"
		               + ((String)((DataObject)dbData.get(i)).getValue("examine"))
		       		   + ((String)((DataObject)dbData.get(i)).getValue("examine_name"));
		       if(i != dbData.size()-1){
		         examine += ",";
		       }
		     }
		  }
       }catch(Exception e){
          System.out.println("getExamineList Error:"+e.getMessage());
       }
       return examine;
    }

%>



