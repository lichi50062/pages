<%
//106.12.04 add 增加以機構代號轉換日期排序 by 2295
//106.12.04 add 增加下載全部清單報表 by 2295
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


//System.out.println("Page: AS003W.jsp    Action:"+act+"    LoginID:"+lguser_id+"    UserName:"+lguser_name );
if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    rd = application.getRequestDispatcher( LoginErrorPgName );
} else {
	
	if("List".equals(act)) {    	    
		setQueryCodition(request) ;
		keepQueryCondition(request) ;
		request.setAttribute("act" ,act) ;
	    rd = application.getRequestDispatcher( ListPgName );
	} else if("Query".equals(act)) {
		request.setAttribute("dataList" , getQueryList(request)) ;
		request.setAttribute("qtbank",Utility.getTrimString(request.getParameter("tbank"))) ;
		setQueryCodition(request) ;
		keepQueryCondition(request) ;
		request.setAttribute("act" ,act) ;
		rd = application.getRequestDispatcher( ListPgName );
	} else if("New".equals(act)) {
		request.setAttribute("TBank", getEditPageTatolBankType());           
	    request.setAttribute("City", Utility.getCity());
	    request.setAttribute("errMsg","") ;
		rd = application.getRequestDispatcher( EditPgName );
	} else if("INS".equals(act)) {
	    doInsert(request);
	    request.setAttribute("dataList" , getQueryList(request)) ;
		request.setAttribute("qtbank",Utility.getTrimString(request.getParameter("tbank"))) ;
		setQueryCodition(request) ;
		keepQueryCondition(request) ;
		request.setAttribute("act" ,act) ;
	    rd = application.getRequestDispatcher( ListPgName );
	} else if("Mtn".equals(act)) {
		String qTbankNo = Utility.getTrimString(request.getParameter("qTbankNo")) ;
		request.setAttribute("TBank", getMtnPageTbank(qTbankNo));       
		request.setAttribute("TBankList", getMtnPageList(qTbankNo));   
	    request.setAttribute("qTbankNo", request.getParameter("qTbankNo"));
	    keepQueryCondition(request) ;
	    request.setAttribute("errMsg","") ;
		rd = application.getRequestDispatcher( MtnPgName );
	}  else if("UPD".equals(act)) {
		String qTbankNo = Utility.getTrimString(request.getParameter("tbank")) ;
		doUpdate(request);
		request.setAttribute("dataList" , getQueryList(request)) ;
		request.setAttribute("qtbank",Utility.getTrimString(request.getParameter("tbank"))) ;
		setQueryCodition(request) ;
		keepQueryCondition(request) ;
		request.setAttribute("act" ,act) ;
	    
	    rd = application.getRequestDispatcher( ListPgName );
	} else if("DEL".equals(act)) {
		
		doDelSelItem(request) ;
		request.setAttribute("dataList" , getQueryList(request)) ;
		request.setAttribute("qtbank",Utility.getTrimString(request.getParameter("tbank"))) ;
		setQueryCodition(request) ;
		keepQueryCondition(request) ;
		request.setAttribute("act" ,act) ;
		rd = application.getRequestDispatcher( ListPgName );
	} /* else if("MTN_DEL".equals(act)){
		doDelSelItem(request) ;
		String qTbankNo = Utility.getTrimString(request.getParameter("tbank")) ;
		request.setAttribute("TBank", getMtnPageTbank(qTbankNo));       
		request.setAttribute("TBankList", getMtnPageList(qTbankNo));   
		request.setAttribute("qTbankNo", qTbankNo);
		rd = application.getRequestDispatcher( MtnPgName );
	}  */else if("goDetailPg".equals(act)) {
		goDetailPageStep1(request) ;
		goDetailPageStep2(request) ;
		goDetailPageStep3(request) ;
		rd = application.getRequestDispatcher( DetailPgName );
		
	} else if("Print".equals(act)) {		
		rd = application.getRequestDispatcher( RptCreatePgName+"?act=download&bank_no="+ Utility.getTrimString(request.getParameter("tbank")));
	} else if("Download".equals(act)) {		
		rd = application.getRequestDispatcher( RptCreatePgName1+"?act=download");
	}
	
	request.setAttribute("actMsg",actMsg);
}

%>
<%@include file="./include/Tail.include" %>
<%!

private final static String report_no = "AS003W" ;
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

private void setQueryCodition(HttpServletRequest req ) {
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

	sql.append(" Select ba01_trans.bank_no ") ;
	sql.append(",ba01_trans.src_bank_no ") ;
	sql.append(",bank_name ");
	sql.append(",to_char(trunc(ba01_trans.trans_date),'YYYY/MM/DD')trans_date");//MIS系統轉換日期
	sql.append(",to_char(trunc(ba01_trans.online_date),'YYYY/MM/DD')online_date");//106.11.22 add 機構代號轉換日期
	sql.append(",ba01_trans.pbank_no") ;
	sql.append(" from ba01_trans left join ( ");
	sql.append(" Select * from bn01 Where m_year=100 ) bn01 ")  ;
	sql.append(" on ba01_trans.src_bank_no = bn01.ori_bank_no ") ;
	sql.append(" Where bank_kind = '0' ") ;
	if(!"".equals(bank_type)) {
		sql.append(" and ba01_trans.bank_type = ? ") ;
		p.add(bank_type) ;
	}
	if(!"".equals(bank_no)) {
		sql.append(" and src_bank_no = ? ") ;
		p.add(bank_no);
	}
    sql.append(" order by online_date desc,bank_name asc");//106.12.04 add
	return DBManager.QueryDB_SQLParam(sql.toString(),p,"trans_date,online_date");
	
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
private List getMtnPageList(String tbank) {
	StringBuffer sql = new StringBuffer();
	List p = new ArrayList ();
	sql.append(" Select src_bank_no ") ;
	sql.append(",ba01_trans.bank_no ") ;
	sql.append(",ba01_trans.pbank_no ") ;
	sql.append(",bank_name ") ;
	sql.append(",to_char(trunc(ba01_trans.online_date),'YYYY/MM/DD')online_date");//106.11.22 add 機構代號轉換日期
	sql.append(" from ba01_trans Left join ( Select * from ba01 where m_year=100) ba01 ") ;
	sql.append(" on  ba01_trans.src_bank_no = ba01.bank_no ");
	sql.append(" Where ba01_trans.pbank_no = ? ") ;
	sql.append(" order by ba01_trans.bank_kind,src_bank_no ");
	p.add(tbank) ;
	return DBManager.QueryDB_SQLParam(sql.toString(),p,"online_date");
}
private String doInsBa01Table (String bankInfo,String onlineDate) throws Exception {
	StringBuffer sql =new StringBuffer();
	ArrayList<String> p = new ArrayList<String>();
	

	Connection con = null ; 
	PreparedStatement  stmt = null;
	String errMsg = "";
	try {
		con = (new RdbCommonDao("")).newConnection();
		
		JSONObject jObj = new JSONObject(bankInfo) ;
		JSONArray b = jObj.getJSONArray("data") ;
		for(int i=0 ; i< b.length(); i++) {
			JSONObject data = (JSONObject)b.getJSONObject(i) ;
			sql.setLength(0) ;
			p.clear();
			sql.append(" insert into ba01_trans ( ") ;
			sql.append(" bank_no , src_bank_no , bank_type , bank_kind, pbank_no ") ;
			sql.append(",online_date,update_date ) ") ;
			sql.append(" values ( ") ;
			sql.append(" ? , ?, ? ,? , ?,to_date(?,'YYYYMMDD') ") ;
			sql.append(",sysdate ) ") ;
			stmt = con.prepareStatement(sql.toString()) ; 
			stmt.setString(1, data.getString("bankNo")) ;
			stmt.setString(2, data.getString("srcBankNo")) ;
			stmt.setString(3, data.getString("btype")) ;
			stmt.setString(4, data.getString("bkind")) ;
			stmt.setString(5, data.getString("tbank")) ;
			stmt.setString(6, String.valueOf(Integer.parseInt(onlineDate)+19110000)) ;
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
private void doInsert(HttpServletRequest req ) throws Exception {
	StringBuffer sql = new StringBuffer();
	List<String> p = new ArrayList<String>();
	
	String errMsg="";	
	
	try {
		String jData = Utility.getTrimString(req.getParameter("jData")).replaceAll("&quot;", "\"") ;
		String onlineDate = Utility.getTrimString(req.getParameter("onlineDate")) ;
		JSONObject jObj = new JSONObject(jData) ;
		JSONArray b = jObj.getJSONArray("data") ;
		for(int i=0 ; i< b.length(); i++) {
			JSONObject data = (JSONObject)b.getJSONObject(i) ;
			sql.setLength(0) ;
			p.clear();
			sql.append(" Select bank_no from ba01_trans where bank_no = ? ") ;
			p.add(data.getString("bankNo")) ;
			List<DataObject> dbData = DBManager.QueryDB_SQLParam(sql.toString(),p,"");
			if(dbData.size() > 0 ) {
				errMsg = errMsg + "該配賦代號("+data.getString("bankNo")+")已建檔,無法新增。<br>";
			}
		}

		if(!errMsg.equals("")) {
			errMsg += "此次新增發生錯誤，請重新確認。";
			req.setAttribute("errMsg" , errMsg) ;
		} else { //檢核正確,執行新增
			errMsg = doInsBa01Table(jData,onlineDate) ;
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
	
	String errMsg="";	
	
	try {
		String jData = Utility.getTrimString(req.getParameter("jData")).replaceAll("&quot;", "\"") ;
		String onlineDate = Utility.getTrimString(req.getParameter("onlineDate")) ;
		JSONObject jObj = new JSONObject(jData) ;
		JSONArray b = jObj.getJSONArray("data") ;
		for(int i=0 ; i< b.length(); i++) {
			JSONObject data = (JSONObject)b.getJSONObject(i) ;
			sql.setLength(0) ;
			p.clear();
			sql.append(" Select bank_no from ba01_trans where pbank_no = ? ") ;
			p.add(data.getString("tbank")) ;
			System.out.println("tbank="+data.getString("tbank"));
			List<DataObject> dbData = DBManager.QueryDB_SQLParam(sql.toString(),p,"");
			if(dbData.size() <= 0 ) {
				errMsg = errMsg + "無該配賦代號資料可提供修改。";
			}
		}

		if(!errMsg.equals("")) {
			errMsg += "此次新增發生錯誤，請重新確認。";
			req.setAttribute("errMsg" , errMsg) ;
		} else { //檢核正確,執行新增
			errMsg = doUpdBa01Table(jData,onlineDate) ;
		}
		
	}catch(Exception e) {
		System.out.println(e+":"+e.getMessage());
		errMsg = errMsg + "相關資料寫入資料庫失敗";		
	} finally {
		req.setAttribute("errMsg",errMsg) ;
	}
	
}
private String doUpdBa01Table (String bankInfo,String onlineDate) throws Exception {
	StringBuffer sql =new StringBuffer();
	ArrayList<String> p = new ArrayList<String>();

	Connection con = null ; 
	PreparedStatement  stmt = null;
	String errMsg = "";
	try {
		con = (new RdbCommonDao("")).newConnection();
		
		JSONObject jObj = new JSONObject(bankInfo) ;
		JSONArray b = jObj.getJSONArray("data") ;
		for(int i=0 ; i< b.length(); i++) {
			JSONObject data = (JSONObject)b.getJSONObject(i) ;
			sql.setLength(0) ;
			p.clear();
			sql.append(" update ba01_trans set Bank_no = ? , update_date= sysdate,online_date=to_date(?,'YYYYMMDD')") ;
			sql.append(" Where pbank_no = ? and src_bank_no = ? ") ;
			stmt = con.prepareStatement(sql.toString()) ; 
			stmt.setString(1, data.getString("bankNo")) ;
			stmt.setString(2, String.valueOf(Integer.parseInt(onlineDate)+19110000)) ;
			stmt.setString(3, data.getString("tbank")) ;
			stmt.setString(4, data.getString("srcBankNo")) ;
			
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
	List p = new ArrayList ();
	Connection con = null ; 
	PreparedStatement  stmt = null;
	
	String errMsg = ""; 
	
	String delBox = Utility.getTrimString(req.getParameter("delItem")) ;
	String [] tmp = delBox.split(";") ;
	
	for(String s : tmp ) {
		sql.setLength(0) ;
		p.clear();
		sql.append(" Select pbank_no from ba01_trans Where pBank_no = ? ") ;
		p.add(s) ;
		List<DataObject> dbData = DBManager.QueryDB_SQLParam(sql.toString(),p,"");
		if(dbData.size() <= 0 ) {
			errMsg = errMsg + "無該配賦代號["+s+"]資料可提供刪除。";
		}
	}
	try {
		con = (new RdbCommonDao("")).newConnection(); 
		
		if(errMsg.equals("")) {
			for(String s : tmp ) {
				sql.setLength(0) ;
				
				sql.append(" Delete from ba01_trans Where pbank_no  = ? ") ;
				
				stmt = con.prepareStatement(sql.toString()) ; 
				stmt.setString(1, s) ;
				stmt.execute() ;
				stmt.clearParameters() ;
			}
			errMsg = "刪除配賦代號資料成功。";
		}
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

private void goDetailPageStep1(HttpServletRequest req ) throws Exception {
	StringBuffer sql = new StringBuffer();
	List p = new ArrayList();
	sql.append(" select src_bank_no") ;
	sql.append(" ,ba01_trans.bank_no") ;
	sql.append(" ,bank_name");
    sql.append(" ,to_char(trunc(ba01_trans.online_date),'YYYY/MM/DD')online_date");
	sql.append(" ,substr( to_char(ba01_trans.trans_date,'YYYYMMDD')-19110000 ,1,3)||'/'||") ;
	sql.append(" substr( to_char(ba01_trans.trans_date,'YYYYMMDD')-19110000 ,4,2)||'/'||");
	sql.append(" substr( to_char(ba01_trans.trans_date,'YYYYMMDD')-19110000 ,6,2)||' '||  to_char(ba01_trans.trans_date,'hh24:mi:ss' ) as trans_date ") ;
	sql.append(" from ba01_trans Left Join ( ") ;
	sql.append(" Select * from ba01 Where m_year=100 ) ba01 on ba01_trans.bank_no = ba01.bank_no ") ;
	sql.append(" Where ba01_trans.pbank_no = ? ") ;
	p.add(Utility.getTrimString(req.getParameter("src_bank_no"))) ;
	req.setAttribute("detailList1",DBManager.QueryDB_SQLParam(sql.toString(),p,"online_date"));
}
private void goDetailPageStep2(HttpServletRequest req ) throws Exception {
	StringBuffer sql = new StringBuffer();
	List p = new ArrayList();
	sql.append(" Select trans_type") ;
	sql.append(" , '0' as sub_item ") ;
	sql.append(" , trans_type as fun_id ") ;
	sql.append(" , item_name ");
	sql.append(" , to_char(trans_cnt)trans_cnt ");
	sql.append(" , output_order ") ;
	sql.append(" from ba01_trans_master Left join ba01_trans_item on ") ;
	sql.append(" ba01_trans_master.trans_type = ba01_trans_item.item_code ") ;
	sql.append(" Where bank_no = ? ") ;
	sql.append(" union ") ;
	sql.append(" Select fun_type as trans_type,'1' as sub_item,fun_id,item_name");
	sql.append(",to_char(trans_cnt)trans_cnt,output_order ");
	sql.append(" from ba01_trans_detail left join ba01_trans_item on fun_id=ba01_trans_item.item_code ") ;
	sql.append(" Where bank_no = ? ") ;
	sql.append(" order by output_order ");
	p.add(Utility.getTrimString(req.getParameter("bank_no"))) ;
	p.add(Utility.getTrimString(req.getParameter("bank_no"))) ;
	req.setAttribute("detailList2",DBManager.QueryDB_SQLParam(sql.toString(),p,""));	
}
private void goDetailPageStep3(HttpServletRequest req ) throws Exception {
	StringBuffer sql = new StringBuffer();
	List p = new ArrayList();
	sql.append(" Select trans_type , to_char( count(*) ) cnt ") ;
	sql.append(" from ( ") ;
	sql.append(" Select trans_type") ;
	sql.append(" , '0' as sub_item ") ;
	sql.append(" , trans_type as fun_id ") ;
	sql.append(" , item_name ");
	sql.append(" , to_char(trans_cnt)trans_cnt ");
	sql.append(" , output_order ") ;
	sql.append(" from ba01_trans_master Left join ba01_trans_item on ") ;
	sql.append(" ba01_trans_master.trans_type = ba01_trans_item.item_code ") ;
	sql.append(" Where bank_no = ? ") ;
	sql.append(" union ") ;
	sql.append(" Select fun_type as trans_type,'1' as sub_item,fun_id,item_name");
	sql.append(",to_char(trans_cnt)trans_cnt,output_order ");
	sql.append(" from ba01_trans_detail left join ba01_trans_item on fun_id=ba01_trans_item.item_code ") ;
	sql.append(" Where bank_no = ? ") ;
	sql.append(" ) group by trans_Type  ");
	p.add(Utility.getTrimString(req.getParameter("bank_no"))) ;
	p.add(Utility.getTrimString(req.getParameter("bank_no"))) ;
	req.setAttribute("detailList3",DBManager.QueryDB_SQLParam(sql.toString(),p,""));	
}
%>