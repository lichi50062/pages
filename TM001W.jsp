<%
//105.9.7 create by 2968
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@include file="./include/Header.include" %>
<%
   	String loan_Item = Utility.getTrimString(dataMap.get("loan_Item"));
	String subItem = Utility.getTrimString(dataMap.get("subItem"));
	String loan_Item_Name = Utility.getTrimString(dataMap.get("loan_Item_Name"));
	System.out.println("*** s loan_Item="+loan_Item);
	System.out.println("*** s subItem="+subItem);
	System.out.println("*** s loan_Item_Name="+loan_Item_Name);
	//fix 93.12.17 從 session取出登入者資訊=======================================================================================
	String userid = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");
	String username = ( session.getAttribute("muser_name")==null ) ? "" : (String)session.getAttribute("muser_name");
	//======================================================================================================================
	//fix 93.12.18 若有已點選的tbank_no,則以已點選的tbank_no為主============================================================
	String bank_code = ( session.getAttribute("tbank_no")==null ) ? "" : (String)session.getAttribute("tbank_no");
	String nowtbank_no = Utility.getTrimString(dataMap.get("tbank_no"));
	if(!nowtbank_no.equals("")){
	   session.setAttribute("nowtbank_no",nowtbank_no);//將已點選的tbank_no寫入session
	}
	bank_code = ( session.getAttribute("nowtbank_no")==null ) ? bank_code : (String)session.getAttribute("nowtbank_no");
	//=======================================================================================================================
	//fix 93.12.20 若有已點選的bank_type,則以已點選的bank_type為主============================================================
	String bank_type = Utility.getTrimString(dataMap.get("bank_type"));
	bank_type = ( session.getAttribute("nowbank_type")==null ) ? bank_type : (String)session.getAttribute("nowbank_type");
	//=======================================================================================================================
	if(session.getAttribute("nowbank_type") == null)
	   System.out.println("nowbank_type == null");
	else  System.out.println((String)session.getAttribute("nowbank_type"));


  	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
        rd = application.getRequestDispatcher( LoginErrorPgName );
    }else{
    	//set next jsp
    	if(act.equals("List")){
        	rd = application.getRequestDispatcher( ListPgName+"?act=List&test=nothing" );
        }else if(act.equals("subList")){
        	rd = application.getRequestDispatcher( SubListPgName+"?loan_Item="+loan_Item+"&loan_Item_Name="+loan_Item_Name+"&test=nothing" );
        }else if(act.equals("new")){
        	request.setAttribute("loan_Item", loan_Item);
        	request.setAttribute("loan_Item_Name", loan_Item_Name);
     	    rd = application.getRequestDispatcher( EditPgName+"?act="+act+"&loan_Item="+loan_Item+"&subItem="+subItem+"&test=nothing");
    	}else if(act.equals("Edit")){
    		List data_div01=getData(loan_Item,subItem);
    		request.setAttribute("loan_Item", loan_Item);
    		request.setAttribute("loan_Item_Name", loan_Item_Name);
	    	request.setAttribute("dataList",data_div01);
	    	rd = application.getRequestDispatcher( EditPgName+"?act="+act+"&loan_Item="+loan_Item+"&subItem="+subItem+"&test=nothing");
    	}else if(act.equals("Insert")){
    		actMsg = doInsert(request,userid,username);
    	    request.setAttribute("actMsg",actMsg);
        	rd = application.getRequestDispatcher( nextPgName +"?goPages=TM001W_subList.jsp&act=subList&loan_Item="+request.getParameter("loan_Item")+"&loan_Item_Name="+request.getParameter("loan_Item_Name"));
        	
    	}else if(act.equals("Update")){
    	    actMsg = doUpdate(request,userid,username);
	   	    request.setAttribute("actMsg",actMsg);
        	rd = application.getRequestDispatcher( nextPgName +"?goPages=TM001W_subList.jsp&act=subList&loan_Item="+request.getParameter("loan_Item")+"&loan_Item_Name="+request.getParameter("loan_Item_Name"));
    	}else if(act.equals("Delete")){
    		actMsg = doDelete(request);
    	    request.setAttribute("actMsg",actMsg);
        	rd = application.getRequestDispatcher( nextPgName +"?goPages=TM001W_subList.jsp&act=subList&loan_Item="+request.getParameter("loan_Item")+"&loan_Item_Name="+request.getParameter("loan_Item_Name"));
    	}
    }
%>

<%@include file="./include/Tail.include" %>

<%!
    private final static String report_no = "TM001W";
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private String EditPgName = "/pages/"+report_no+"_Edit.jsp";
    private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
    private final static String SubListPgName = "/pages/"+report_no+"_subList.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";

    private List getData(String loan_Item,String subItem){
   		//查詢條件
   	    List dbData =null;
    	StringBuffer sqlCmd = new StringBuffer();
		List paramList = new ArrayList();	
		
		sqlCmd.append("select LOAN_ITEM,SUBITEM,SUBITEM_NAME,Loan_Rate,Base_Rate ");
		sqlCmd.append("  from loan_subitem ");
		sqlCmd.append(" where LOAN_ITEM = ? and SUBITEM = ? ");
		paramList.add(loan_Item);    
		paramList.add(subItem);
		dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"loan_item,subitem,subitem_name,loan_rate,base_rate");

		return dbData;
    }
    
    public String doInsert(HttpServletRequest request,String userid,String username) throws Exception{
    	String loan_Item = request.getParameter("loan_Item");
    	String subItem_Name = request.getParameter("subItem_Name");
    	double loan_Rate = Double.valueOf(request.getParameter("loan_Rate").toString());
    	double base_Rate = Double.valueOf(request.getParameter("base_Rate").toString());
		String sqlCmd = "";
		String errMsg="";
		try {
				List updateDBList = new LinkedList();//0:sql 1:data
				List updateDBSqlList = new LinkedList();
				List updateDBDataList = new LinkedList();//儲存參數的List
				List dataList = new LinkedList();//儲存參數的data
					sqlCmd = "INSERT INTO loan_subitem(loan_item,subitem,subitem_name,loan_rate,base_rate,user_id,user_name,update_date) ";
					sqlCmd += "VALUES(?,(select nvl(LPAD(to_number(max(subitem))+1, 4, 0),?||'01') from loan_subitem where loan_item=?),?,?,?,?,?,sysdate)";
					updateDBSqlList.add(sqlCmd);

				    dataList.add(loan_Item);
				    dataList.add(loan_Item);
				    dataList.add(loan_Item);
				    dataList.add(subItem_Name);
				    dataList.add(loan_Rate);
				    dataList.add(base_Rate);
				    dataList.add(userid);
				    dataList.add(username);
					updateDBDataList.add(dataList);
	            	updateDBSqlList.add(updateDBDataList);
	            	updateDBList.add(updateDBSqlList);
	            	System.out.println("updateDBDataList add");
	            	if(DBManager.updateDB_ps(updateDBList)){
	            	   System.out.println(" TM001W Insert ok");
					   errMsg = errMsg + "相關資料寫入資料庫成功";
					}else{
				   		errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
					}
    	   		//}
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗";
		}

		return errMsg;
	}
    
    public String doUpdate(HttpServletRequest request,String userid,String username) throws Exception{
    	String loan_Item = request.getParameter("loan_Item");
    	String subItem = request.getParameter("subItem");
    	String subItem_Name = request.getParameter("subItem_Name");
    	double loan_Rate = Double.valueOf(request.getParameter("loan_Rate").toString());
    	double base_Rate = Double.valueOf(request.getParameter("base_Rate").toString());
		String sqlCmd = "";
		String errMsg="";
		try {
				List updateDBList = new LinkedList();//0:sql 1:data
				List updateDBSqlList = new LinkedList();
				List updateDBDataList = new LinkedList();//儲存參數的List
				List dataList = new LinkedList();//儲存參數的data
				if(!"".equals(subItem)){
					sqlCmd = "UPDATE loan_subitem SET subitem_name=?,loan_rate=?,base_rate=?,user_id=?,user_name=?,update_date=SYSDATE  ";
					sqlCmd += "WHERE loan_item=? AND subItem=? ";
					updateDBSqlList.add(sqlCmd);
				    
				    dataList.add(subItem_Name);
				    dataList.add(loan_Rate);
				    dataList.add(base_Rate);
				    dataList.add(userid);
				    dataList.add(username);
				    dataList.add(loan_Item);
				    dataList.add(subItem);
				}else{
					sqlCmd = "INSERT INTO loan_subitem(loan_item,subitem,subitem_name,loan_rate,base_rate,user_id,user_name,update_date) ";
					sqlCmd += "VALUES(?,(select nvl(LPAD(to_number(max(subitem))+1, 4, 0),?||'01') from loan_subitem where loan_item=?),?,?,?,?,?,sysdate)";
					updateDBSqlList.add(sqlCmd);
					
					dataList.add(loan_Item);
				    dataList.add(loan_Item);
				    dataList.add(loan_Item);
				    dataList.add(subItem_Name);
				    dataList.add(loan_Rate);
				    dataList.add(base_Rate);
				    dataList.add(userid);
				    dataList.add(username);
				}
				updateDBDataList.add(dataList);
            	updateDBSqlList.add(updateDBDataList);
            	updateDBList.add(updateDBSqlList);
            	System.out.println("updateDBDataList add");
	            	if(DBManager.updateDB_ps(updateDBList)){
					   errMsg = errMsg + "相關資料寫入資料庫成功";
					}else{
				   		errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
					}
    	   		//}
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗";
		}

		return errMsg;
	}
	
	public String doDelete(HttpServletRequest request) throws Exception{		
		String errMsg="";
		String loan_Item = request.getParameter("loan_Item");
    	String subItem = request.getParameter("subItem");
		StringBuffer sqlCmd = new StringBuffer();
		List paramList = new ArrayList();	
		List updateDBList = new LinkedList();//0:sql 1:data
		List updateDBSqlList = new LinkedList();
		List updateDBDataList = new LinkedList();//儲存參數的List
		List dataList = new LinkedList();//儲存參數的data	
		
		try {
			    sqlCmd.append("SELECT * FROM loan_subitem WHERE LOAN_ITEM=? AND SUBITEM=? ");
			    paramList.add(loan_Item);
				paramList.add(subItem);
			    List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"subitem");
				System.out.println("loan_subitem.size="+data.size());
				if (data.size() == 0){
					errMsg = errMsg + "無資料可刪除(loan_subitem)<br>";
				}else{
					updateDBDataList = new ArrayList();//儲存參數的List
					updateDBSqlList = new ArrayList();//儲存參數的List	
					dataList = new LinkedList();//儲存參數的data								
					sqlCmd.delete(0,sqlCmd.length());
				    sqlCmd.append("DELETE FROM loan_subitem WHERE LOAN_ITEM=? AND SUBITEM=? ");
				    dataList.add(loan_Item);
				    dataList.add(subItem);
					updateDBDataList.add(dataList);
					updateDBSqlList.add(sqlCmd.toString());//0:欲執行的sql
	            	updateDBSqlList.add(updateDBDataList);
	            	updateDBList.add(updateDBSqlList);	
					if(DBManager.updateDB_ps(updateDBList)){
						errMsg = errMsg + "相關資料刪除成功";
					}else{
				   		errMsg = errMsg + "相關資料刪除失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
					}
					
				}
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料刪除失敗";
		}
		
		return errMsg;
	}	



	
	

%>
