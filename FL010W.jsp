<%
//105.11.04 create by 2968
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>
<%
	

	String userId = session.getAttribute("muser_id") != null ? (String) session.getAttribute("muser_id") : "" ;
	String userName = session.getAttribute("muser_name") != null ? (String) session.getAttribute("muser_name") : "" ;
	
	System.out.println("Page: FL010W.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );
		

    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
           rd = application.getRequestDispatcher( LoginErrorPgName );
    } else {
    	if(act.equals("List") ||act.equals("RtnList") ||  act.equals("New") || act.equals("Edit")) {    	    
    		request.setAttribute("TBank", getTatolBankType());           
    	    request.setAttribute("City", Utility.getCity());
    	    if(act.equals("Edit") || act.equals("New")) {
    			request.setAttribute("DetailList",this.getDetailList());
    			String bank_no = request.getParameter("bank_No") != null ? request.getParameter("bank_No") : request.getParameter("tbank");
    			String ex_type = request.getParameter("ex_Type") != null ? request.getParameter("ex_Type") : "";
    			String ex_no = request.getParameter("ex_No") != null ? request.getParameter("ex_No") : "";
	            String docNo = request.getParameter("docNo") != null ? request.getParameter("docNo") : "";
    	        if(act.equals("New")) {
    	            rd = application.getRequestDispatcher( EditPgName +"?act=New&bank_No="+bank_no+"&ex_Type="+ex_type+"&ex_No="+ex_no+"&docNo="+docNo);
    	        }else{
    	            request.setAttribute("EditInfo",this.getEditInfo(bank_no,ex_no,docNo));    	               	           
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit&bank_No="+bank_no+"&ex_Type="+ex_type+"&ex_No="+ex_no+"&docNo="+docNo);
    	        }
    	    } else if(act.equals("List")||act.equals("RtnList")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName +"?act=List");
    	    }
        } else if(act.equals("Insert")||act.equals("Update")){
        	String bank_no = request.getParameter("bank_No") != null ? request.getParameter("bank_No") : request.getParameter("tbank"); 
	        String ex_no = Utility.getTrimString(request.getParameter("ex_No")) ;
	        String docno = Utility.getTrimString(request.getParameter("docNo")) ;
            actMsg = updateDataToDB(request,userId,userName);
            rd = application.getRequestDispatcher( nextPgName+"?goPages=FL010W.jsp&act=List&bank_No="+bank_no+"&ex_No="+ex_no+"&docNo="+docno);
        } else if(act.equals("Delete")){
        	String bank_no = request.getParameter("bank_No") != null ? request.getParameter("bank_No") : request.getParameter("tbank");  
	        String ex_type = Utility.getTrimString(request.getParameter("ex_Type")) ;
	        String ex_no = Utility.getTrimString(request.getParameter("ex_No")) ;
	        String docno = Utility.getTrimString(request.getParameter("docNo")) ;
    	    actMsg = deleteDataToDB(request);
    	    rd = application.getRequestDispatcher( nextPgName +"?goPages=FL010W.jsp&act=List&bank_No="+bank_no+"&ex_Type"+ex_type+"&ex_No="+ex_no+"&docNo="+docno);
        }        
    	request.setAttribute("actMsg",actMsg);
      }
    
	

%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "FL010W" ;
private final static String nextPgName = "/pages/ActMsg.jsp";
private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
private final static String LoginErrorPgName = "/pages/LoginError.jsp";

    //取得所有總機構資料
    private List getTatolBankType(){//查詢條件
		//fix 增加縣市合併判斷用m_year by 2808
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
    //依查核類別所對應的查核報告編號、查核報告編號所對應需退還補貼息個案明細
  	private List getDetailList(){
  		StringBuffer sql = new StringBuffer() ;
  		List paramList = new ArrayList() ;
  		sql.append(" select distinct frm_exdef.bank_no,");//受檢單位
  		sql.append(" 		ex_type,");//查核類別 FEB:金管會檢查報告 AGRI:農業金庫查核 BOAF:農金局訪查
  		sql.append("        frm_exdef.ex_no,");//查核報告編號
  		sql.append("        decode(ex_type,'FEB',frm_exmaster.ex_no,'AGRI',substr(frm_exmaster.ex_no,0,3)||'年第'||substr(frm_exmaster.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_exmaster.ex_no,'yyyymmdd')),'') as ex_no_list,");
  		sql.append("        frm_exdef.def_seq,");//缺失序號
  		sql.append("        loan_name,");//借款人名稱 
  		sql.append("        F_TRANSCHINESEDATE(loan_date) as loan_date,");//貸款日期
  		sql.append("        frm_exdef.loan_item,");
  		sql.append("        loan_item_name,");//貸款種類名稱
  		sql.append("        loan_amt,");//貸款金額
  		sql.append("        case_name,");//缺失情節
  		sql.append("        frm_snrtdoc.non_loan_amt,");//--不符規定金額
  		sql.append("        frm_snrtdoc.pay_amt,");//--繳還補貼息金額
  		sql.append("        frm_agsncorrdoc.over_amt ");//--溢繳金額
  		sql.append(" from frm_exdef ");
  		sql.append(" left join frm_loan_item on frm_exdef.loan_item = frm_loan_item.loan_item ");
  		sql.append(" left join frm_exmaster on frm_exdef.ex_no=frm_exmaster.ex_no and frm_exdef.bank_no=frm_exmaster.bank_no ");
  		sql.append(" left join frm_def_item on frm_exdef.def_type = frm_def_item.def_type and frm_exdef.def_case = frm_def_item.def_case ");
  		sql.append(" left join frm_snrtdoc on frm_exdef.ex_no=frm_snrtdoc.ex_no and frm_exdef.bank_no=frm_snrtdoc.bank_no and frm_exdef.def_seq=frm_snrtdoc.def_seq ");
  		sql.append(" left join frm_agsncorrdoc on frm_exdef.ex_no=frm_agsncorrdoc.ex_no and frm_exdef.bank_no=frm_agsncorrdoc.bank_no and frm_exdef.def_seq=frm_agsncorrdoc.def_seq ");
  		sql.append(" where frm_snrtdoc.ag_flag='1' ");//補貼息計算檢核.尚有疑義
  		sql.append("   and frm_agsncorrdoc.agcorr_flag='2' ");//金庫回覆結果2:溢繳,需退還
  		sql.append(" order by bank_no,ex_type,ex_no,loan_name,loan_date,loan_item,loan_amt,def_seq ");//排列順序,避免同一個借款人其缺失情節不會放在一起
  	    List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,"def_seq,loan_amt,non_loan_amt,pay_amt,over_amt");
  	    return dbData;
    }
  	
    //取得查詢資料
    private List getQueryResult(HttpServletRequest request){
        String bankType = Utility.getTrimString(request.getParameter("bankType")) ;//農漁會別    
        String tbank = Utility.getTrimString(request.getParameter("tbank")) ;//受檢單位
        String cityType = Utility.getTrimString(request.getParameter("cityType")) ; //縣市別
        String ex_Type = Utility.getTrimString(request.getParameter("ex_Type")) ;//查核類別
        String begDate = Utility.getTrimString(request.getParameter("begDate")) ;//訪查日期-起始
        String endDate = Utility.getTrimString(request.getParameter("endDate")) ;//訪查日期-結束
        String ex_No = Utility.getTrimString(request.getParameter("ex_No")) ;//檢查報告編號
        String begSeason = Utility.getTrimString(request.getParameter("begSeason")) ;//查核季別-起始
        String endSeason = Utility.getTrimString(request.getParameter("endSeason")) ;//查核季別-結束
        String docBegDate = Utility.getTrimString(request.getParameter("docBegDate")) ;
        String docEndDate = Utility.getTrimString(request.getParameter("docEndDate")) ;
        String docNo = Utility.getTrimString(request.getParameter("docNo")) ;
        String u_year = "99" ;
        if(Integer.parseInt(Utility.getYear()) > 99 ){
    		u_year = "100" ;
    	}
        //設定屬性以利後續存取
    	request.setAttribute("bankType",bankType);
    	request.setAttribute("cityType",cityType);        
    	request.setAttribute("tbank",tbank);
    	request.setAttribute("begDate",begDate);
    	request.setAttribute("endDate",endDate);
    	request.setAttribute("ex_Type",ex_Type);
    	request.setAttribute("ex_No",ex_No);
    	request.setAttribute("begSeason",begSeason);
    	request.setAttribute("endSeason",endSeason);
    	request.setAttribute("docBegDate",docBegDate);
    	request.setAttribute("docEndDate",docEndDate);
    	request.setAttribute("docNo",docNo);
    	//查詢條件 
    	StringBuffer sb=new StringBuffer();
    	List paramList = new ArrayList() ;
    	sb.append("select bank_no,bank_name,ex_no,ex_no_list,doc_date,docno,sum(refund_amt) refund_amt from ( ");
    	sb.append(" select frm_refunddoc.bank_no,bank_name,frm_refunddoc.ex_no,ex_type,decode(ex_type,'FEB',frm_refunddoc.ex_no,'AGRI',substr(frm_refunddoc.ex_no,0,3)||'年第'||substr(frm_refunddoc.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_refunddoc.ex_no,'yyyymmdd')),'') as ex_no_list,");
    	sb.append("        F_TRANSCHINESEDATE(doc_date) as doc_date,docno,refund_amt ");
    	sb.append(" from frm_refunddoc ");
    	sb.append(" left join (select * from bn01 where m_year=?)bn01 on frm_refunddoc.bank_no=bn01.bank_no ");
    	sb.append(" left join frm_exmaster on frm_refunddoc.ex_no=frm_exmaster.ex_no and frm_refunddoc.bank_no=frm_exmaster.bank_no ");
    	paramList.add(u_year) ;
		sb.append(" where ex_type=? ");
		paramList.add(ex_Type) ;
		if(!"".equals(ex_No)){
			sb.append("and frm_refunddoc.ex_no like ? ");
			paramList.add(ex_No+"%") ;
		}
		if(!"".equals(begSeason)){
			sb.append("and ( frm_refunddoc.ex_no >= ? and frm_refunddoc.ex_no <= ? ) ");
			paramList.add(begSeason) ;
			paramList.add(endSeason) ;
		}
		if(!"".equals(begDate)){
			sb.append("and ( frm_refunddoc.ex_no >= ? and frm_refunddoc.ex_no <= ? ) ");
			paramList.add(String.valueOf(Integer.parseInt(begDate)+19110000)) ;
			paramList.add(String.valueOf(Integer.parseInt(endDate)+19110000)) ;
		}
		if(!"".equals(tbank)){
			sb.append(" and frm_exmaster.bank_no= ? ");
			paramList.add(tbank) ;
		}
		if(!"".equals(docBegDate)){
			sb.append("and TO_CHAR(doc_date,'yyyymmdd') BETWEEN ? AND ? ");
			paramList.add(String.valueOf(Integer.parseInt(docBegDate)+19110000)) ;
			paramList.add(String.valueOf(Integer.parseInt(docEndDate)+19110000)) ;
		}
		if(!"".equals(docNo)){
			sb.append(" and docno like ? ");
			paramList.add(docNo+"%") ;
		}
		sb.append(" group by "); 
		sb.append(" frm_refunddoc.bank_no,bank_name,frm_refunddoc.ex_no,ex_type,decode(ex_type,'FEB',frm_refunddoc.ex_no,'AGRI',substr(frm_refunddoc.ex_no,0,3)||'年第'||substr(frm_refunddoc.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_refunddoc.ex_no,'yyyymmdd')),'') ");
		sb.append(" ,doc_date,docno,refund_amt ");
		sb.append(" order by bank_no asc,ex_no asc,doc_date desc ");
		sb.append(")a ");
		sb.append("group by bank_no,bank_name,ex_no,ex_no_list,doc_date,docno ");
		sb.append("order by bank_no asc,ex_no asc,doc_date desc ");
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"refund_amt");
        System.out.println("getQueryResult.size="+dbData.size());
        return dbData;
    }
    
    // 取得單筆資料
    private List getEditInfo(String bank_no,String ex_no,String ag_rt_docno){ 
        DataObject ob = null;
        StringBuffer sb=new StringBuffer();
        List paramList = new ArrayList() ;
        String u_year = "99" ;
        if(Integer.parseInt(Utility.getYear()) > 99 ){
    		u_year = "100" ;
    	}
        sb.append(" select distinct frm_exmaster.ex_type,decode(frm_exmaster.ex_type,'FEB','金管會檢查報告','AGRI','農業金庫查核','BOAF','農金局訪查','') as ex_type_name,frm_agsncorrdoc.bank_no,bank_name,");
        sb.append(" 	   frm_agsncorrdoc.ex_no,decode(frm_exmaster.ex_type,'FEB',frm_agsncorrdoc.ex_no,'AGRI',substr(frm_agsncorrdoc.ex_no,0,3)||'年第'||substr(frm_agsncorrdoc.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_agsncorrdoc.ex_no,'yyyymmdd')),'') as ex_no_list,");
        sb.append(" 	   to_char(frm_refunddoc.doc_date,'yyyymmdd') as doc_date, frm_refunddoc.docno, frm_exmaster.case_status,loan_name,");
        sb.append(" 	   to_char(loan_date,'yyyymmdd') as loan_date,frm_exdef.loan_item,loan_item_name,loan_amt,frm_exdef.def_seq,case_name,");
        sb.append(" 	   frm_snrtdoc.non_loan_amt,frm_snrtdoc.pay_amt,frm_refunddoc.refund_amt ");
        sb.append(" from frm_exdef ");
        sb.append(" left join frm_loan_item on frm_exdef.loan_item = frm_loan_item.loan_item ");
        sb.append(" left join frm_exmaster on frm_exdef.ex_no=frm_exmaster.ex_no and frm_exdef.bank_no=frm_exmaster.bank_no ");
        sb.append(" left join frm_def_item on frm_exdef.def_type = frm_def_item.def_type and frm_exdef.def_case = frm_def_item.def_case ");
        sb.append(" left join frm_snrtdoc on frm_exdef.ex_no=frm_snrtdoc.ex_no and frm_exdef.bank_no=frm_snrtdoc.bank_no and frm_exdef.def_seq=frm_snrtdoc.def_seq ");
        sb.append(" left join frm_agsncorrdoc on frm_exdef.ex_no=frm_agsncorrdoc.ex_no and frm_exdef.bank_no=frm_agsncorrdoc.bank_no and frm_exdef.def_seq=frm_agsncorrdoc.def_seq ");
        sb.append(" left join frm_refunddoc on frm_exdef.ex_no=frm_refunddoc.ex_no and frm_exdef.bank_no=frm_refunddoc.bank_no and frm_exdef.def_seq=frm_refunddoc.def_seq ");
        sb.append(" left join (select * from bn01 where m_year=?)bn01 on frm_snrtdoc.bank_no=bn01.bank_no ");
        sb.append(" left join frm_exmaster on frm_snrtdoc.ex_no=frm_exmaster.ex_no ");
        sb.append(" where frm_exdef.ex_no=? and frm_exmaster.bank_no=? ");
        sb.append("   and frm_snrtdoc.ag_flag='1' and frm_agsncorrdoc.agcorr_flag='2' ");
        sb.append("   and frm_refunddoc.docno=? ");
        sb.append(" order by bank_no,ex_type,ex_no,loan_name,loan_date,loan_item,loan_amt,def_seq ");
        paramList.add(u_year) ;
        paramList.add(ex_no) ;
		paramList.add(bank_no) ;
		paramList.add(ag_rt_docno) ;
		
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"loan_amt,def_seq,non_loan_amt,pay_amt,refund_amt");
        return dbData;

    }
    
  	//新增異動資料
    private String updateDataToDB(HttpServletRequest request, String loginID, String loginName) {
      String actMsg = "";
      String errMsg = "";
      String ex_Type =  Utility.getTrimString(request.getParameter("ex_Type"));
      String ex_No =  Utility.getTrimString(request.getParameter("ex_No"));
      String bank_No =  Utility.getTrimString(request.getParameter("tbank"));
      String docNo = Utility.getTrimString(request.getParameter("docNo"));
      String oriDocNo = Utility.getTrimString(request.getParameter("oriDocNo"));
      String doc_Date =  Utility.getTrimString(request.getParameter("doc_Date"));
      String case_Status =  Utility.getTrimString(request.getParameter("case_Status"));
      String def_Seq =  Utility.getTrimString(request.getParameter("def_Seq"));
      String refund_Amt =  Utility.getTrimString(request.getParameter("refund_Amt"));
      
      List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
      List updateDBSqlList = new ArrayList();
      List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
      StringBuffer sqlCmd=new StringBuffer();
      StringBuffer sqlCmd1=new StringBuffer();
  	  List paramList = new ArrayList() ; 
        try {
        	//刪除frm_refunddoc
        	if(!"".equals(oriDocNo)){
	        	sqlCmd.append("delete frm_refunddoc ");
	        	sqlCmd.append(" where ex_no=? and bank_no=? and docno=? ");
	        	paramList.add(ex_No);
				paramList.add(bank_No);
				paramList.add(oriDocNo);
				updateDBSqlList.add(sqlCmd.toString()) ;
				updateDBDataList.add(paramList) ;
				updateDBSqlList.add(updateDBDataList) ;
				updateDBList.add(updateDBSqlList) ;
        	}
			//需退還補貼息個案明細的缺失序號def_seq,寫入多筆資料
        	sqlCmd1.append("insert into frm_refunddoc ");
        	sqlCmd1.append("  (EX_NO,BANK_NO,DEF_SEQ,DOCNO,DOC_DATE,Refund_AMT,USER_ID,USER_NAME,UPDATE_DATE) ");
        	sqlCmd1.append(" values(?,?,?,?,to_date(?,'YYYY/MM/DD'),?,?,?,sysdate) ");
        	
        	String[] seqSet = def_Seq.split(";");
        	String[] amtSet = refund_Amt.split(";");
			for (int i=0;i<seqSet.length;i++) {
				String[] seqArr = seqSet[i].split(",");
				for (String seq:seqArr) {
					updateDBSqlList = new LinkedList();
					updateDBDataList = new LinkedList();
					paramList = new ArrayList();
					paramList.add(ex_No);
					paramList.add(bank_No);
					paramList.add(seq);
					paramList.add(docNo);
					paramList.add(doc_Date);
					paramList.add(amtSet[i]);
					paramList.add(loginID);
					paramList.add(loginName);
					updateDBSqlList.add(sqlCmd1.toString()) ;
					updateDBDataList.add(paramList) ;
					updateDBSqlList.add(updateDBDataList) ;
					updateDBList.add(updateDBSqlList) ;
					
					
				}
			}
			
			//是否已結案,更新frm_exdef
			sqlCmd.setLength(0);
		    sqlCmd.append("update frm_exdef ");
	    	sqlCmd.append("   set case_status =? ,update_date=sysdate ");
	    	sqlCmd.append(" where ex_no=? and bank_no=? ");
	    	updateDBSqlList = new LinkedList();
			updateDBDataList = new LinkedList();
			paramList = new ArrayList();
			paramList.add(case_Status);
			paramList.add(ex_No);
			paramList.add(bank_No);
		    updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
		    
			//是否已結案,更新frm_exmaster
			sqlCmd.setLength(0);
		    sqlCmd.append("update frm_exmaster ");
	    	sqlCmd.append("   set case_status =? ,update_date=sysdate ");
	    	sqlCmd.append(" where ex_type=? and ex_no=? and bank_no=? ");
	    	updateDBSqlList = new LinkedList();
			updateDBDataList = new LinkedList();
			paramList = new ArrayList();
			paramList.add(case_Status);
			paramList.add(ex_Type);
			paramList.add(ex_No);
			paramList.add(bank_No);
		    updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
		  	
            if(DBManager.updateDB_ps(updateDBList)){
			   	errMsg = errMsg + "相關資料寫入資料庫成功";
			}else{
			  	errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
			}
        }catch (Exception e){
			System.out.println(e+":"+e.getMessage());
			errMsg = errMsg + "相關資料寫入資料庫失敗\n[Exception Error]: ";
		}
		return errMsg;
	}
	// 刪除資料
	private String deleteDataToDB(HttpServletRequest request) {
        String errMsg = "";        
        String ex_No =  Utility.getTrimString(request.getParameter("ex_No"));
        String bank_No =  Utility.getTrimString(request.getParameter("bank_No"));
        String docNo = Utility.getTrimString(request.getParameter("oriDocNo"));
        String ex_Type = Utility.getTrimString(request.getParameter("ex_Type"));
        String def_Seq = Utility.getTrimString(request.getParameter("def_Seq"));
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
        StringBuffer sqlCmd = new StringBuffer() ;
        List paramList = new ArrayList() ;
	    try {
	    	//清空原農業金庫來文記錄
	    	sqlCmd.append("delete frm_refunddoc ");
	    	sqlCmd.append(" where ex_no=? and bank_no=? and docno=? ");
	    	paramList.add(ex_No);
			paramList.add(bank_No);
			paramList.add(docNo);
		    updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
		    
		  	//是否結案,更新frm_exdef
			sqlCmd.setLength(0);
		    sqlCmd.append("update frm_exdef ");
	    	sqlCmd.append("   set case_status ='1',update_date=sysdate ");
	    	sqlCmd.append(" where ex_no=? and bank_no=?  ");
	    	updateDBSqlList = new LinkedList();
			updateDBDataList = new LinkedList();
			paramList = new ArrayList();
			paramList.add(ex_No);
			paramList.add(bank_No);
		    updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
		    
			//是否結案,更新frm_exmaster
			sqlCmd.setLength(0);
		    sqlCmd.append("update frm_exmaster ");
	    	sqlCmd.append("   set case_status ='1',update_date=sysdate ");
	    	sqlCmd.append(" where ex_type=? and ex_no=? and bank_no=?  ");
	    	updateDBSqlList = new LinkedList();
			updateDBDataList = new LinkedList();
			paramList = new ArrayList();
			paramList.add(ex_Type);
			paramList.add(ex_No);
			paramList.add(bank_No);
		    updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
		    
	    	
		    if(DBManager.updateDB_ps(updateDBList)){
				errMsg = "相關資料刪除成功";
			}else{
				errMsg = errMsg + "相關明細資料刪除失敗<br>[DBManager.getErrMsg()]<br>" + DBManager.getErrMsg();
			}

        } catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				return "相關資料刪除失敗<br>[Exception Error]<br>";
		}
		return errMsg;


	}
	
%>
