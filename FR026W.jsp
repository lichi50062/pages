<%
// FR026W 在台無住所之外國人新台幣存款表
// 94.11.18 created by lilic0c0 4183
// 99.04.09 修改部分程式改為共用元 by 2808
//100.06.24 fix 機構排列順序,按照直轄市在前.其他縣市在後排序 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@include file="./include/Header.include" %>
<%
	String bank_type = Utility.getTrimString(dataMap.get("bank_type"));
	String userId = session.getAttribute("muser_id") == null ? " ":session.getAttribute("muser_id").toString();
	String userName = session.getAttribute("muser_name") == null ? " ":(String) session.getAttribute("muser_name").toString();

	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
			rd = application.getRequestDispatcher( LoginErrorPgName );
	}
	//create Excel檔
	else if(act.equals("Creatrpt")){
			//取得使用者所選的年月以及農漁會編號
			String S_Bank_Name = dataMap.get("S_Bank_Name")==null ? " " :Utility.getTrimString(dataMap.get("S_Bank_Name"));
			String S_YEAR = dataMap.get("S_YEAR")==null ? " " :Utility.getTrimString(dataMap.get("S_YEAR"));
   			String S_MONTH = dataMap.get("S_MONTH")==null ? " " :Utility.getTrimString(dataMap.get("S_MONTH"));
			String ExcelAction = dataMap.get("ExcelAction")==null ? " " :Utility.getTrimString(dataMap.get("S_MONTH"));
			String Unit = dataMap.get("Unit")==null ? " " :Utility.getTrimString(dataMap.get("Unit"));

			//傳送參數
			request.setAttribute("S_Bank_Name",S_Bank_Name);
			request.setAttribute("S_YEAR",S_YEAR);
			request.setAttribute("S_MONTH",S_MONTH);
			request.setAttribute("ExcelAction",ExcelAction);
			request.setAttribute("bank_type",bank_type);
			request.setAttribute("Unit",Unit);
		    System.out.println("CreatePgName:"+CreatePgName) ;
			rd = application.getRequestDispatcher( CreatePgName );
		}
		else if(act.equals("Qry")){
		    session.setAttribute("nowbank_type",bank_type);//100.06.24
		    request.setAttribute("TBank",Utility.getBankList(request) );//100.06.24按照直轄市在前.其他縣市在後排序.
			//request.setAttribute("TBank", Utility.getALLTBank(bank_type));
	    	request.setAttribute("City", Utility.getCity());
			//request.setAttribute("Bank_Type", getCDShareNOWith(BANK_TYPE,bank_type));
        	//request.setAttribute("TBank", getTatolBankType());
			//request.setAttribute("Bank_No",getTatolBankType());
			//request.setAttribute("City_No", getCity());
		
			rd = application.getRequestDispatcher( ListPgName+"?bank_type="+bank_type );
		}
%>
<%@include file="./include/Tail.include" %>
<%!
    private final static String report_no = "FR026W" ;
	private final static String ListPgName = "/pages/"+report_no+"_Qry.jsp";
	private final static String CreatePgName = "/pages/"+report_no+"_Excel.jsp";
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";
	private final static String BANK_TYPE = "020";		//金融機構代碼

    //取得所有總機構資料===================================================
    private List getTatolBankType(){
    
    	//查詢條件
    	String sqlCmd = " Select HSIEN_id, BN01.BANK_NO , BANK_NAME, BANK_TYPE  from  BN01, WLX01  WHERE BN01.BANK_NO = WLX01.BANK_NO(+) AND bank_type in ( select cmuse_id from cdshareno where cmuse_div = '020' ) order by BANK_NO ";
    	List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"");
    	
    	return dbData;
	}
	
	//取得所有縣市=========================================================
    private List getCity(){
    	
    	//查詢條件
    	String sqlCmd = " SELECT HSIEN_id, HSIEN_name from cd01 order by input_order, hsien_id ";
    	List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"");
    	
    	return dbData;
	}

    //取得CDShareNO, 欄位cmuse_div為id的所有內容============================
    private List getCDShareNOWith(String id,String bankType){
        List paramList = new ArrayList();
    	//查詢條件
    	String sqlCmd = " select cmuse_id, cmuse_name from cdshareno where cmuse_div = ? AND CMUSE_ID = ?  order by cmuse_id";
    	paramList.add(id);
    	paramList.add(bankType);
    	List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");

        return dbData;
	}

%>
