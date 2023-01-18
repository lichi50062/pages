<%
//110.03.02 add 新增撤銷核准項目維護作業 by 6493
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="com.tradevan.util.dao.RdbCommonDao" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@include file="./include/Header.include" %>

<%

if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    rd = application.getRequestDispatcher( LoginErrorPgName );
} else {
	
	if("List".equals(act)) {    	    
		setQueryCondition(request) ;
		keepQueryCondition(request) ;
		request.setAttribute("act" ,act) ;
	    rd = application.getRequestDispatcher( ListPgName );
	} else if("Query".equals(act)) {
		request.setAttribute("dataList" , getQueryList(request)) ;
		request.setAttribute("qtbank",Utility.getTrimString(request.getParameter("tbank"))) ;
		setQueryCondition(request) ;
		keepQueryCondition(request) ;
		request.setAttribute("act" ,act) ;
		rd = application.getRequestDispatcher( ListPgName );
	} else if("New".equals(act)) {
		request.setAttribute("TBank", getEditPageTatolBankType());           
	    request.setAttribute("City", Utility.getCity());
	    request.setAttribute("Revoke", getRevokeItems());
	    request.setAttribute("errMsg","") ;
		rd = application.getRequestDispatcher( EditPgName );
	} else if("INS".equals(act)) {
	    doInsert(request);
	    request.setAttribute("dataList" , getQueryList(request)) ;
		request.setAttribute("qtbank",Utility.getTrimString(request.getParameter("tbank"))) ;
		setQueryCondition(request) ;
		keepQueryCondition(request) ;
		request.setAttribute("act" ,act) ;
	    rd = application.getRequestDispatcher( ListPgName );
	} else if("Mtn".equals(act)) {
		String qTbankNo = Utility.getTrimString(request.getParameter("qTbankNo")) ;
		String qSeqNo = Utility.getTrimString(request.getParameter("qSeqNo")) ;
	    request.setAttribute("qTbankNo", qTbankNo);
	    request.setAttribute("qSeqNo", qSeqNo);
		request.setAttribute("TBank", getMtnPageTbank(qTbankNo));           
	    request.setAttribute("City", Utility.getCity());
	    request.setAttribute("Revoke", getRevokeItems());
	    request.setAttribute("dataList", getSelectedRevokeItems(qTbankNo, qSeqNo));
	    keepQueryCondition(request) ;
	    request.setAttribute("errMsg","") ;
		rd = application.getRequestDispatcher( MtnPgName );
	} else if("UPD".equals(act)) {
		String qTbankNo = Utility.getTrimString(request.getParameter("tbank")) ;
		doUpdate(request);
		request.setAttribute("dataList" , getQueryList(request)) ;
		request.setAttribute("qtbank",Utility.getTrimString(request.getParameter("tbank"))) ;
		setQueryCondition(request) ;
		keepQueryCondition(request) ;
		request.setAttribute("act" ,act) ;
	    rd = application.getRequestDispatcher( ListPgName );
	} else if("DEL".equals(act)) {
		
		doDelSelItem(request) ;
		request.setAttribute("dataList" , getQueryList(request)) ;
		request.setAttribute("qtbank",Utility.getTrimString(request.getParameter("tbank"))) ;
		setQueryCondition(request) ;
		keepQueryCondition(request) ;
		request.setAttribute("act" ,act) ;
		rd = application.getRequestDispatcher( ListPgName );
	}
	
	request.setAttribute("actMsg",actMsg);
}

%>
<%@include file="./include/Tail.include" %>
<%!

private final static String report_no = "AS004W" ;
private final static String nextPgName = "/pages/ActMsg.jsp";
private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
private final static String MtnPgName = "/pages/"+report_no+"_Mtn.jsp";
private final static String DetailPgName = "/pages/"+report_no+"_DetailList.jsp";
private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";
private final static String RptCreatePgName1 = "/pages/"+report_no+"_Excel1.jsp";
private final static String LoginErrorPgName = "/pages/LoginError.jsp";

//取得所有總機構資料
private List getTatolBankType(){//查詢條件
	//調整 增加縣市合併判斷用m_year by 2808
	StringBuffer sql = new StringBuffer() ;
	sql.append(" select bn01.bn_type,HSIEN_id, BN01.BANK_NO , BANK_NAME, BANK_TYPE,bn01.m_year  ");
	sql.append(" from  BN01, WLX01 ");
	sql.append(" where BN01.BANK_NO = WLX01.BANK_NO(+) ");
	sql.append(" and wlx01.m_year = bn01.m_year ");    		
	sql.append(" order by BANK_NO  ");  
    List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,"m_year");
    return dbData;
}

//取得所有縣市
private List getCity(){
		//查詢條件
		String sqlCmd = " SELECT HSIEN_id, HSIEN_name from cd01 order by input_order, hsien_id ";
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"");
        return dbData;
}

private void setQueryCondition(HttpServletRequest req ) {
	req.setAttribute("TBank", getTatolBankType());           
    req.setAttribute("City", Utility.getCity());
}
private void keepQueryCondition(HttpServletRequest req ) {
	String bankType = Utility.getTrimString(req.getParameter("bankType"));
	String tbank = Utility.getTrimString(req.getParameter("tbank"));
	String cityType = Utility.getTrimString(req.getParameter("cityType"));
	req.setAttribute("q_bankType" , bankType ) ;
	req.setAttribute("q_tbank" , tbank ) ;
	req.setAttribute("q_cityType" , cityType ) ;
}
private List getQueryList(HttpServletRequest req ) {
	
	String bank_type = Utility.getTrimString(req.getParameter("bankType")) ;
	String bank_no = Utility.getTrimString(req.getParameter("tbank")) ;
	StringBuffer sql  = new StringBuffer();
	List p = new ArrayList();

	sql.append(" Select distinct revoke_doc.bank_code ") ;//總機構代號
	sql.append(",to_char(revoke_doc.seq_no) as seq_no ") ;//序號
	sql.append(",bank_name ");//總機構名稱
	sql.append(",revoke_item ");//撤銷項目
	sql.append(",F_TRANSCHINESEDATE(cancel_date) as cancel_date ");//撤銷日期
	sql.append(",doc_no ") ;//撤銷文號
	sql.append(" from revoke_doc ");
	sql.append(" left join (select * from bn01 where m_year=100)bn01 on revoke_doc.bank_code=bn01.bank_no ")  ;
	
	sql.append(" left join ( ") ;
	sql.append(" select bank_code,seq_no,listagg(cmuse_name,'<br>') within group (order by columnlink) as revoke_item ") ;
	sql.append(" from ( ") ;
	sql.append(" select bank_code,seq_no,acc_code,sub_acc_code,columnlink,cdshareno.cmuse_name ") ;
	sql.append(" from revoke_doc ") ;
	sql.append(" left join  (select * from cdshareno where cmuse_div='051')cdshareno on ") ;
	sql.append(" revoke_doc.acc_code||sub_acc_code = cdshareno.columnlink)revoke_doc ") ;
	sql.append(" group by bank_code,seq_no)a on revoke_doc.bank_code=a.bank_code and revoke_doc.seq_no=a.seq_no ") ;
	sql.append(" where bn01.bank_type = ? ") ;
	p.add(bank_type);
	if(!"".equals(bank_no)) {
		sql.append(" and revoke_doc.bank_code = ? ") ;//總機構單位不為全部時,才加入該查詢條件
		p.add(bank_no);
	}
    sql.append(" order by cancel_date desc,revoke_doc.bank_code asc");
	return DBManager.QueryDB_SQLParam(sql.toString(),p,"");
	
}
private List getEditPageTatolBankType() {
	StringBuffer sql  = new StringBuffer();

	sql.append(" Select bank_type ") ;
	sql.append(", 0 as bank_kind ") ;
	sql.append(",bn01.bank_no as tbank_no ");
	sql.append(",bn01.bank_no as bank_no") ;
	sql.append(",bank_name ");
	sql.append(",wlx01.hsien_id ") ;
	sql.append(",100 as m_year ") ;
	sql.append(" from ( ") ;
	sql.append(" select * from wlx01 where m_year=100 and wlx01.cancel_no<>'Y' or wlx01.cancel_no is null ") ;
	sql.append(")  wlx01 ") ;
	sql.append(" Left join ( ");
	sql.append(" select * from bn01 where m_year=100 and bank_type in ('6','7') and bn_type <> '2'");
	sql.append(") bn01 on") ;
	sql.append(" wlx01.bank_no = bn01.bank_no ") ;
	sql.append(" Where bank_type in ('6','7') ") ;
	sql.append(" union ");
	sql.append(" select bank_type,1 as bank_kind,bn02.tbank_no,bn02.bank_no ") ;
	sql.append(",bank_name ") ;
	sql.append(",wlx02.hsien_id ") ;
	sql.append(",100 as m_year ") ;
	sql.append(" from ( ") ;
	sql.append(" select * from wlx02 where m_year=100  and wlx02.cancel_no <> 'Y' OR wlx02.cancel_no IS NULL ");
	sql.append(" ) wlx02 ") ;
	sql.append(" Left join ( ") ;
	sql.append(" select * from bn02 where m_year=100 and bank_type in ('6','7') and bn_type <> '2' ");
	sql.append(" ) bn02 on wlx02.bank_no = bn02.bank_no ") ;
	sql.append(" Where bank_type in ('6','7') ") ;
	sql.append(" order by tbank_no,bank_kind, bank_no ");
	
	return DBManager.QueryDB_SQLParam(sql.toString(),null,"m_year,bank_kind");
	
}
private List getRevokeItems() {
	StringBuffer sql  = new StringBuffer();

	sql.append(" select columnlink ") ;
	sql.append(", cmuse_name ") ;
	sql.append(" from cdshareno ") ;
	sql.append(" where cmuse_div='051' ") ;
	sql.append(" order by output_order ") ;
	
	return DBManager.QueryDB_SQLParam(sql.toString(),null,"");
	
}
private List getSelectedRevokeItems(String qTbankNo, String qSeqNo) {
	StringBuffer sql  = new StringBuffer();
	List p = new ArrayList ();
	sql.append(" select bank_code,acc_code || sub_acc_code as acc_code ") ;
	sql.append(", to_char(trunc(cancel_date),'YYYY/MM/DD') as cancel_date ") ;
	sql.append(", doc_no ") ;
	sql.append(" from revoke_doc ") ;
	sql.append(" where bank_code = ? ") ;
	sql.append(" and seq_no = ? ") ;
	p.add(qTbankNo) ;
	p.add(qSeqNo) ;
	return DBManager.QueryDB_SQLParam(sql.toString(),p,"");
	
}
private List getMtnPageTbank(String tbank) {
	StringBuffer sql = new StringBuffer();
	List p = new ArrayList ();
	sql.append(" Select * from ( ") ;
	sql.append(" Select bank_type ") ;
	sql.append(", 0 as bank_kind ") ;
	sql.append(",bn01.bank_no as tbank_no ");
	sql.append(",bn01.bank_no as bank_no") ;
	sql.append(",bank_name ");
	sql.append(",wlx01.hsien_id ") ;
	sql.append(",100 as m_year ") ;
	sql.append(" from ( ") ;
	sql.append(" select * from wlx01 where m_year=100 and wlx01.cancel_no<>'Y' or wlx01.cancel_no is null ") ;
	sql.append(")  wlx01 ") ;
	sql.append(" Left join ( ");
	sql.append(" select * from bn01 where m_year=100 and bank_type in ('6','7') and bn_type <> '2'");
	sql.append(") bn01 on") ;
	sql.append(" wlx01.bank_no = bn01.bank_no ") ;
	sql.append(" Where bank_type in ('6','7') ") ;
	sql.append(" ) Where tbank_no = ? ") ;
	p.add(tbank) ;
	return DBManager.QueryDB_SQLParam(sql.toString(),p,"");
}

private String doInsRevokeDocTable (JSONArray revokeArray, String bankCode, String docNo, String revokeDate, HttpSession session) throws Exception {
	StringBuffer sql =new StringBuffer();
	ArrayList<String> p = new ArrayList<String>();
	
	Connection con = null ; 
	PreparedStatement  stmt = null;
	String errMsg = "", seqno = "";
	try {
		sql.append(" select to_char(decode(max(seq_no)+1,null,1,max(seq_no)+1)) as seqno from revoke_doc where bank_code = ? ") ;
		p.add(bankCode) ;
		List<DataObject> dbData = DBManager.QueryDB_SQLParam(sql.toString(),p,"");
		for(DataObject data : dbData){
			seqno = (String)data.getValue("seqno");
		}
		
		con = (new RdbCommonDao("")).newConnection();
		for(int i=0 ; i< revokeArray.length(); i++) {
			String data = revokeArray.getString(i) ;
			sql.setLength(0) ;
			p.clear();
			sql.append(" insert into revoke_doc ( ") ;
			sql.append(" BANK_CODE   , SEQ_NO , ACC_CODE , SUB_ACC_CODE , DOC_NO ") ;
			sql.append(",CANCEL_DATE , MEMO   , USER_ID  , USER_NAME    , UPDATE_DATE ) ") ;
			sql.append(" values ( ") ;
			sql.append(" ?, ?, ? ,? , ? ") ;
			sql.append(", to_date(?,'YYYYMMDD')");
			sql.append(", (select cmuse_name from cdshareno where cmuse_div = '051' and columnlink = ? )");
			sql.append(", ?, ?, sysdate ) ") ;
			stmt = con.prepareStatement(sql.toString()) ; 
			stmt.setString(1, bankCode) ;
			stmt.setString(2, seqno) ;
			stmt.setString(3, data.substring(0, 6)) ;
			stmt.setString(4, data.substring(6)) ;
			stmt.setString(5, "農授金字第"+docNo+"號函") ;
			stmt.setString(6, String.valueOf(Integer.parseInt(revokeDate)+19110000)) ;
			stmt.setString(7, data) ;
			stmt.setString(8, session.getAttribute("muser_id")==null ? "" : (String)session.getAttribute("muser_id")) ;
			stmt.setString(9, session.getAttribute("muser_name")==null ? "" : (String)session.getAttribute("muser_name")) ;
			stmt.execute() ;
			stmt.clearParameters() ;
		}
		stmt.close();
		errMsg = errMsg + "相關資料寫入資料庫成功";	

	}catch(Exception e) {
		errMsg = errMsg + "相關資料寫入資料庫失敗";
		e.printStackTrace();
	}finally {
		try {
			if(stmt!=null) {
				stmt.close();
				stmt=null;
			}
			if(con!=null) {
				con.commit() ;
				con.close();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	return errMsg ;
}
private void doInsert(HttpServletRequest req) throws Exception {
	StringBuffer sql = new StringBuffer();
	List<String> p = new ArrayList<String>();
	String errMsg="", errAccCodeList="";	
	try {
		String bank_code = req.getParameter("tbank");
		String docNo = req.getParameter("doc_no");
		String revokeDate = Utility.getTrimString(req.getParameter("revokeDate")) ;
		String jData = Utility.getTrimString(req.getParameter("jData")).replaceAll("&quot;", "\"") ;
		JSONObject jObj = new JSONObject(jData) ;
		JSONArray revokeArray = jObj.getJSONArray("data") ;
		
		sql.append(" Select acc_code||sub_acc_code as acc_code, memo from revoke_doc where bank_code = ? ") ;
		p.add(bank_code) ;
		List<DataObject> dbData = DBManager.QueryDB_SQLParam(sql.toString(),p,"");
		for(DataObject data : dbData){
			for(int i=0; i<revokeArray.length(); i++){
				if(((String)data.getValue("acc_code")).equals(revokeArray.getString(i))){
					errAccCodeList = errAccCodeList + "「" + data.getValue("memo") + "」";
				}
			}
		}
		
		if(!errAccCodeList.isEmpty()){
			errMsg = "該撤銷項目" + errAccCodeList + "已建檔,無法新增。";
		}
		
		if(!errMsg.equals("")) {
			errMsg += "此次新增發生錯誤，請重新確認。";
			req.setAttribute("errMsg" , errMsg) ;
		} else { //檢核正確,執行新增
			errMsg = doInsRevokeDocTable(revokeArray, bank_code, docNo, revokeDate, req.getSession()) ;
		}
		
	}catch(Exception e) {
		System.out.println(e+":"+e.getMessage());
		errMsg = errMsg + "相關資料寫入資料庫失敗";		
	} finally {
		req.setAttribute("errMsg",errMsg) ;
	}
	
}
private void doUpdate(HttpServletRequest req ) throws Exception {
	StringBuffer sql = new StringBuffer();
	List<String> p = new ArrayList<String>();
	String errMsg="", errAccCodeList="";	
	try {
		String seqNo = req.getParameter("seqNo");
		String bank_code = req.getParameter("tbank");
		String docNo = req.getParameter("doc_no");
		String revokeDate = Utility.getTrimString(req.getParameter("revokeDate")) ;
		String jData = Utility.getTrimString(req.getParameter("jData")).replaceAll("&quot;", "\"") ;
		JSONObject jObj = new JSONObject(jData) ;
		JSONArray revokeArray = jObj.getJSONArray("data") ;
		
		sql.append(" Select acc_code||sub_acc_code as acc_code, memo, to_char(seq_no) as seq_no from revoke_doc where bank_code = ? ") ;
		p.add(bank_code) ;
		List<DataObject> dbData = DBManager.QueryDB_SQLParam(sql.toString(),p,"");
		for(DataObject data : dbData){
			for(int i=0; i<revokeArray.length(); i++){
				if( ((String)data.getValue("acc_code")).equals(revokeArray.getString(i)) 
					&& !((String)data.getValue("seq_no")).equals(seqNo)  ){
					
					errAccCodeList = errAccCodeList + "「" + data.getValue("memo") + "」";
				}
			}
		}
		
		if(!errAccCodeList.isEmpty()){
			errMsg = "該撤銷項目" + errAccCodeList + "已建檔,無法修改。";
		}
		
		if(!errMsg.equals("")) {
			errMsg += "此次修改發生錯誤，請重新確認。";
			req.setAttribute("errMsg" , errMsg) ;
		} else { //檢核正確,執行修改
			errMsg = doUpdRevokeDocTable(revokeArray, bank_code, seqNo, docNo, revokeDate, req.getSession()) ;
		}
		
	}catch(Exception e) {
		System.out.println(e+":"+e.getMessage());
		errMsg = errMsg + "相關資料寫入資料庫失敗";		
	} finally {
		req.setAttribute("errMsg",errMsg) ;
	}
	
}
private String doUpdRevokeDocTable (JSONArray revokeArray, String bankCode, String seqNo, String docNo, String revokeDate, HttpSession session) throws Exception {
	StringBuffer sql =new StringBuffer();
	ArrayList<String> p = new ArrayList<String>();
	
	Connection con = null ; 
	PreparedStatement stmt = null;
	String errMsg = "";
	try {
		con = (new RdbCommonDao("")).newConnection();
		sql.append(" Delete from revoke_doc Where bank_code = ? and seq_no = ? ") ;
		stmt = con.prepareStatement(sql.toString()) ; 
		stmt.setString(1, bankCode) ;
		stmt.setString(2, seqNo) ;
		stmt.execute() ;
		stmt.clearParameters() ;
		
		for(int i=0 ; i< revokeArray.length(); i++) {
			String data = revokeArray.getString(i) ;
			sql.setLength(0) ;
			p.clear();
			sql.append(" insert into revoke_doc ( ") ;
			sql.append(" BANK_CODE   , SEQ_NO , ACC_CODE , SUB_ACC_CODE , DOC_NO ") ;
			sql.append(",CANCEL_DATE , MEMO   , USER_ID  , USER_NAME    , UPDATE_DATE ) ") ;
			sql.append(" values ( ") ;
			sql.append(" ?, ?, ? ,? , ? ") ;
			sql.append(", to_date(?,'YYYYMMDD')");
			sql.append(", (select cmuse_name from cdshareno where cmuse_div = '051' and columnlink = ? )");
			sql.append(", ?, ?, sysdate ) ") ;
			stmt = con.prepareStatement(sql.toString()) ; 
			stmt.setString(1, bankCode) ;
			stmt.setString(2, seqNo) ;
			stmt.setString(3, data.substring(0, 6)) ;
			stmt.setString(4, data.substring(6)) ;
			stmt.setString(5, "農授金字第"+docNo+"號函") ;
			stmt.setString(6, String.valueOf(Integer.parseInt(revokeDate)+19110000)) ;
			stmt.setString(7, data) ;
			stmt.setString(8, session.getAttribute("muser_id")==null ? "" : (String)session.getAttribute("muser_id")) ;
			stmt.setString(9, session.getAttribute("muser_name")==null ? "" : (String)session.getAttribute("muser_name")) ;
			stmt.execute() ;
			stmt.clearParameters() ;
		}
		stmt.close();
		errMsg = errMsg + "相關資料更新資料庫成功";	

	}catch(Exception e) {
		errMsg = errMsg + "相關資料更新資料庫失敗";
		e.printStackTrace();
	}finally {
		try {
			if(stmt!=null) {
				stmt.close();
				stmt=null;
			}
			if(con!=null) {
				con.commit() ;
				con.close();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	return errMsg ;
	
}

private void doDelSelItem(HttpServletRequest req  )throws Exception {
	StringBuffer sql =new StringBuffer();
	Connection con = null ; 
	PreparedStatement  stmt = null;
	String errMsg = ""; 
	
	try {
		String seqNo = "",bank_code = "";
		String delBox = Utility.getTrimString(req.getParameter("delItem")) ;
		String [] tmp = delBox.split(";") ;
		
		con = (new RdbCommonDao("")).newConnection();
		for(String s : tmp ) {			
			bank_code = s.split(",")[0] ;
			seqNo = s.split(",")[1];
			
			sql.setLength(0) ;
			sql.append(" Delete from revoke_doc Where bank_code = ? and seq_no = ? ") ;
			stmt = con.prepareStatement(sql.toString()) ; 
			stmt.setString(1, bank_code) ;
			stmt.setString(2, seqNo) ;
			stmt.execute() ;
			stmt.clearParameters() ;
		}
		errMsg = "刪除撤銷項目資料成功。";
		
	}catch(Exception e) {
		errMsg = errMsg + "相關資料刪除資料庫失敗";
		e.printStackTrace();
	}finally {
		try {
			if(stmt!=null) {
				stmt.clearParameters() ;
				stmt.close();
				stmt=null;
			}
			if(con!=null) {
				con.commit() ;
				con.close();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	req.setAttribute("errMsg", errMsg) ;
}

%>