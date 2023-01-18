<%
//105.10.13 create by 2968
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
	
	System.out.println("Page: FL005W.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );
		

    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
           rd = application.getRequestDispatcher( LoginErrorPgName );
    } else {
    	if(act.equals("List") ||act.equals("DetailList") ||act.equals("RtnList") ||  act.equals("New") || act.equals("Edit")) {    	    
    		request.setAttribute("TBank", getTatolBankType());           
    	    request.setAttribute("City", Utility.getCity());
    	    if(act.equals("Edit") || act.equals("New")) {
    	    	request.setAttribute("DocTypeList",this.getDocTypeList());
    			request.setAttribute("AuditTypeList",this.getAuditTypeList());
    			request.setAttribute("AuditIdList",this.getAuditIdList());
    			request.setAttribute("DefDetailList",this.getDefDetailList());
    	        if(act.equals("New")) {
    	        	String bank_no = request.getParameter("tbank") != null ? request.getParameter("tbank") : "";
        	    	String ex_type = request.getParameter("ex_Type") != null ? request.getParameter("ex_Type") : "";
     	            String ex_no = request.getParameter("ex_No") != null ? request.getParameter("ex_No") : "";
     	            String ex_kind = request.getParameter("ex_Kind") != null ? request.getParameter("ex_Kind") : "";
    	        	request.setAttribute("bank_No",bank_no);
    	            request.setAttribute("ex_No",ex_no);
    	            request.setAttribute("ex_Type",ex_type);
    	            rd = application.getRequestDispatcher( EditPgName +"?act=New");
    	        }else{
    	            String bank_no = request.getParameter("bank_No") != null ? request.getParameter("bank_No") : "";
    	            String ex_no = request.getParameter("ex_No") != null ? request.getParameter("ex_No") : "";
    	            String docno = request.getParameter("docNo") != null ? request.getParameter("docNo") : "";
    	            String def_seq = request.getParameter("def_Seq") != null ? request.getParameter("def_Seq") : "";
    	            request.setAttribute("bank_No",bank_no);
    	            request.setAttribute("ex_No",ex_no);
    	            request.setAttribute("docNo",docno);
    	            request.setAttribute("def_Seq",def_seq);
    	            request.setAttribute("EditInfo",this.getEditInfo(bank_no,ex_no,docno,def_seq));    	               	           
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit");
    	        }
    	    } else if(act.equals("List")||act.equals("RtnList")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName +"?act=List");
    	    } else if(act.equals("DetailList")) {
    	    	String bank_no = Utility.getTrimString(request.getParameter("bank_No")) ;  
    	        String ex_type = Utility.getTrimString(request.getParameter("ex_Type")) ;
    	        String ex_no = Utility.getTrimString(request.getParameter("ex_No")) ;
    	        String docno = Utility.getTrimString(request.getParameter("docNo")) ;
    	        String ex_no_list = "";
    	        String bank_name = "";
    	        String banktype = "";
    	        List qList = getMixInfo(ex_type,ex_no,bank_no,docno);
    	        if(qList!=null && qList.size()>0){
    	        	for(int i=0;i<qList.size();i++){
    	        		ex_no_list=(String)((DataObject)qList.get(i)).getValue("ex_no_list");
    	    			bank_name=(String)((DataObject)qList.get(i)).getValue("bank_name");
    	    			banktype=(String)((DataObject)qList.get(i)).getValue("bank_type");
    	        	}
    	        }
    	        //設定屬性以利後續存取
    	     	request.setAttribute("bankType",banktype);
    	     	request.setAttribute("bank_no",bank_no);
    	     	request.setAttribute("bank_name",bank_name);        
    	     	request.setAttribute("ex_type",ex_type);
    	     	request.setAttribute("ex_no",ex_no);
    	     	request.setAttribute("ex_no_list",ex_no_list);
    	     	
    	        request.setAttribute("DetailResult", this.getDetailResult(request,bank_no,ex_no,docno));
    	        rd = application.getRequestDispatcher( DetailListPgName +"?act=DetailList");
    	    }     	    
        } else if(act.equals("Insert")){
        	String bank_no = request.getParameter("tbank") != null ? request.getParameter("tbank") : "";
	        String ex_no = request.getParameter("ex_No") != null ? request.getParameter("ex_No") : "";
	        String ex_type = Utility.getTrimString(request.getParameter("ex_Type")) ;
	        String docno = Utility.getTrimString(request.getParameter("docNo")) ;
	        actMsg = insertDataToDB(request,userId,userName);
    	    request.setAttribute("actMsg",actMsg); 
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=FL005W.jsp&act=List&bank_No="+bank_no+"&ex_Type"+ex_type+"&ex_No="+ex_no+"&docNo="+docno);        	
        } else if(act.equals("Update")){
        	String bank_no = request.getParameter("bank_No") != null ? request.getParameter("bank_No") : "";
	        String ex_no = request.getParameter("ex_No") != null ? request.getParameter("ex_No") : "";
	        String ex_type = Utility.getTrimString(request.getParameter("ex_Type")) ;
	        String docno = Utility.getTrimString(request.getParameter("docNo")) ;
            actMsg = updateDataToDB(request,userId,userName);
            rd = application.getRequestDispatcher( nextPgName+"?goPages=FL005W.jsp&act=List&bank_No="+bank_no+"&ex_No="+ex_no+"&docNo="+docno);
        } else if(act.equals("Delete")){
        	String bank_no = Utility.getTrimString(request.getParameter("bank_No")) ;  
	        String ex_type = Utility.getTrimString(request.getParameter("ex_Type")) ;
	        String ex_no = Utility.getTrimString(request.getParameter("ex_No")) ;
	        String docno = Utility.getTrimString(request.getParameter("docNo")) ;
    	    actMsg = deleteDataToDB(request);
    	    rd = application.getRequestDispatcher( nextPgName +"?goPages=FL005W.jsp&act=List&bank_No="+bank_no+"&ex_Type"+ex_type+"&ex_No="+ex_no+"&docNo="+docno);
        }        
    	request.setAttribute("actMsg",actMsg);
      }
    
	

%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "FL005W" ;
private final static String nextPgName = "/pages/ActMsg.jsp";
private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
private final static String DetailListPgName = "/pages/"+report_no+"_DetailList.jsp";
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
    //發文性質
    private List getDocTypeList(){
		StringBuffer sql = new StringBuffer() ;
		sql.append(" select cmuse_id,cmuse_name ");
		sql.append(" from cdshareno where cmuse_div='048' and cmuse_id not in ('D','E') ");
	    List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,"cmuse_id,cmuse_name");
	    return dbData;
    }
    //核處類別
    private List getAuditTypeList(){
		StringBuffer sql = new StringBuffer() ;
		sql.append(" select cmuse_id,cmuse_name ");
		sql.append(" from cdshareno where cmuse_div='049' ");
	    List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,"cmuse_id,cmuse_name");
	    return dbData;
    }
    //核處情形
    private List getAuditIdList(){
		StringBuffer sql = new StringBuffer() ;
		sql.append(" select audit_type,audit_id,audit_case ");
		sql.append(" from frm_audit_item where doc_type='B' ");
		sql.append(" order by audit_id ");
	    List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,"audit_type,audit_id,audit_case");
	    return dbData;
    }
    //缺失明細
  	private List getDefDetailList(){
  		StringBuffer sql = new StringBuffer() ;
  		List paramList = new ArrayList() ;
  		sql.append(" select frm_exdef.bank_no,ex_type,frm_exdef.ex_no,");
  		sql.append(" 		decode(ex_type,'FEB',frm_exdef.ex_no,'AGRI',substr(frm_exdef.ex_no,0,3)||'年第'||substr(frm_exdef.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_exdef.ex_no,'yyyymmdd')),'') as ex_no_list,");
  		sql.append("        ex_kind,def_seq,loan_name,lpad(to_char(loan_date,'yyyymmdd')-'19110000',7,'0') as loan_date,frm_exdef.loan_item,loan_item_name,to_char(loan_amt, 'FM999,999,999,999,999')loan_amt,frm_exdef.def_type,frm_exdef.def_case,case_name ");
  		sql.append(" from frm_exdef ");
  		sql.append(" left join frm_loan_item on frm_exdef.loan_item = frm_loan_item.loan_item ");
  		sql.append(" left join frm_exmaster on frm_exdef.ex_no=frm_exmaster.ex_no and frm_exdef.bank_no = frm_exmaster.bank_no ");
  		sql.append(" left join frm_def_item on frm_exdef.def_type = frm_def_item.def_type and frm_exdef.def_case = frm_def_item.def_case ");
  		//sql.append(" where frm_exmaster.case_status != '0' ");
  		sql.append(" order by frm_exdef.bank_no,frm_exdef.ex_no,ex_kind,loan_name,loan_date,frm_exdef.loan_item,loan_amt,def_seq ");
  	    List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,"bank_no,ex_type,ex_no,ex_no_list,ex_kind,def_seq,loan_name,loan_date,loan_item,loan_item_name,loan_amt,def_type,def_case,case_name");
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
    	sb.append(" select frm_snrtdoc.bank_no,bank_name,frm_snrtdoc.ex_no,decode(ex_type,'FEB',frm_snrtdoc.ex_no,'AGRI',substr(frm_snrtdoc.ex_no,0,3)||'年第'||substr(frm_snrtdoc.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_snrtdoc.ex_no,'yyyymmdd')),'') as ex_no_list,");
    	sb.append("        F_TRANSCHINESEDATE(doc_date) as doc_date,docno,doc_type,cmuse_name as doc_type_name,frm_exmaster.ex_type ");
    	sb.append(" from frm_snrtdoc ");
    	sb.append(" left join (select * from bn01 where m_year=?)bn01 on frm_snrtdoc.bank_no=bn01.bank_no ");
    	sb.append(" left join (select * from cdshareno where cmuse_div='048')cdshareno on frm_snrtdoc.doc_type=cdshareno.cmuse_id ");
    	sb.append(" left join frm_exmaster on frm_snrtdoc.ex_no=frm_exmaster.ex_no and frm_snrtdoc.bank_no=frm_exmaster.bank_no ");
    	paramList.add(u_year) ;
		sb.append(" where ex_type=? ");
		paramList.add(ex_Type) ;
		if(!"".equals(ex_No)){
			sb.append("and frm_snrtdoc.ex_no like ? ");
			paramList.add(ex_No+"%") ;
		}
		if(!"".equals(begSeason)){
			sb.append("and ( frm_snrtdoc.ex_no >= ? and frm_snrtdoc.ex_no <= ? ) ");
			paramList.add(begSeason) ;
			paramList.add(endSeason) ;
		}
		if(!"".equals(begDate)){
			sb.append("and ( frm_snrtdoc.ex_no >= ? and frm_snrtdoc.ex_no <= ? ) ");
			paramList.add(String.valueOf(Integer.parseInt(begDate)+19110000)) ;
			paramList.add(String.valueOf(Integer.parseInt(endDate)+19110000)) ;
		}
		if(!"".equals(tbank)){
			sb.append(" and frm_exmaster.bank_no= ? ");
			paramList.add(tbank) ;
		}
		if(!"".equals(docBegDate)){
			sb.append("and TO_CHAR(doc_date ,'yyyymmdd') BETWEEN ? AND ? ");
			paramList.add(String.valueOf(Integer.parseInt(docBegDate)+19110000)) ;
			paramList.add(String.valueOf(Integer.parseInt(docEndDate)+19110000)) ;
		}
		if(!"".equals(docNo)){
			sb.append(" and docno like ? ");
			paramList.add(docNo+"%") ;
		}
		sb.append(" group by "); 
		sb.append(" frm_snrtdoc.bank_no,bank_name,frm_snrtdoc.ex_no,decode(ex_type,'FEB',frm_snrtdoc.ex_no,'AGRI',substr(frm_snrtdoc.ex_no,0,3)||'年第'||substr(frm_snrtdoc.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_snrtdoc.ex_no,'yyyymmdd')),'') ");
		sb.append(" ,doc_date,docno,doc_type,cmuse_name,ex_type ");
		sb.append(" order by bank_no asc,ex_no asc,doc_date desc ");
		
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"");
        System.out.println("getQueryResult.size="+dbData.size());
        return dbData;
    }

    private List getDetailResult(HttpServletRequest request,String bank_no,String ex_no,String docno){
    	//查詢條件 
    	StringBuffer sb=new StringBuffer();
    	List paramList = new ArrayList() ;
    	sb.append(" select frm_snrtdoc.ex_no,frm_snrtdoc.bank_no,frm_snrtdoc.def_seq,");
    	sb.append("        decode(frm_snrtdoc.def_seq,998,'A',ex_kind) as ex_kind,docno,loan_name,to_char(loan_date,'YYYY/MM/DD')loan_date,frm_exdef.loan_item,loan_item_name,loan_amt,audit_case,frm_exdef.def_type,frm_exdef.def_case,case_name  ");
    	sb.append(" from frm_snrtdoc ");
    	sb.append(" left join (select frm_exdef.*, loan_item_name,case_name from frm_exdef ");
    	sb.append("              left join frm_loan_item on frm_exdef.loan_item = frm_loan_item.loan_item ");
    	sb.append("              left join frm_def_item on frm_exdef.def_type = frm_def_item.def_type and frm_exdef.def_case = frm_def_item.def_case)frm_exdef ");
    	sb.append("              on frm_exdef.ex_no = frm_snrtdoc.ex_no and frm_exdef.bank_no = frm_snrtdoc.bank_no and frm_exdef.def_seq = frm_snrtdoc.def_seq ");
    	sb.append(" left join frm_audit_item on frm_snrtdoc.audit_id = frm_audit_item.audit_id ");
		sb.append(" where frm_snrtdoc.ex_no=? and frm_snrtdoc.bank_no=? and docno=? ");
		paramList.add(ex_no) ;
		paramList.add(bank_no) ;
		paramList.add(docno) ;
		sb.append(" order by ex_kind,loan_name,loan_date,frm_exdef.loan_item,loan_amt,def_seq ");
		
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"ex_no,bank_no,def_seq,docno,loan_name,loan_date,loan_item,"+
        								"loan_item_name,loan_amt,audit_case,def_type,def_case,case_name");
        System.out.println("getDetailResult.size="+dbData.size());
        return dbData;
    }
    
    // 取得單筆資料
    private List getEditInfo(String bank_no,String ex_no,String docno,String seqs){ 
        DataObject ob = null;
        StringBuffer sb=new StringBuffer();
        List paramList = new ArrayList() ;
        String u_year = "99" ;
        if(Integer.parseInt(Utility.getYear()) > 99 ){
    		u_year = "100" ;
    	}
        sb.append(" select to_char(doc_date,'yyyymmdd') doc_date,docno,frm_snrtdoc.bank_no,bank_name,ex_type,decode(ex_type,'FEB','金管會檢查報告','AGRI','農業金庫查核','BOAF','農金局訪查','') as ex_type_name,");
        sb.append(" 	   frm_snrtdoc.ex_no,decode(ex_type,'FEB',frm_snrtdoc.ex_no,'AGRI',substr(frm_snrtdoc.ex_no,0,3)||'年第'||substr(frm_snrtdoc.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_snrtdoc.ex_no,'yyyymmdd')),'') as ex_no_list,");
        sb.append(" 	   def_seq,doc_type,audit_type,audit_id,to_char(limitdate,'yyyymmdd') limitdate,non_loan_amt,loan_year,change_loan_year,audit_id_c1,audit_id_c2,fine_amt,bank_rt_docno,ag_rt_docno ");
        sb.append(" from frm_snrtdoc ");  
        sb.append(" left join frm_exmaster on frm_snrtdoc.ex_no=frm_exmaster.ex_no and frm_snrtdoc.bank_no=frm_exmaster.bank_no ");
        sb.append(" left join (select * from bn01 where m_year=?)bn01 on frm_snrtdoc.bank_no=bn01.bank_no ");
        sb.append(" where frm_snrtdoc.ex_no=? and frm_snrtdoc.bank_no=? and docno =? ");
        paramList.add(u_year) ;
        paramList.add(ex_no) ;
		paramList.add(bank_no) ;
		paramList.add(docno) ;
        if(!"".equals(seqs)){
        	sb.append(" and frm_snrtdoc.def_seq in ( ");
        	String[] tokens = seqs.split(",");
        	int c = 0;
			for (String token:tokens) {
				if(c>0)sb.append(",");
				sb.append("?");
        		paramList.add(token) ;
        		c++;
			}
			sb.append(" ) ");
        }
        sb.append(" order by def_seq ");
		
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"doc_date,docno,bank_no,bank_name,ex_type_name,ex_no,ex_no_list,def_seq,doc_type,audit_type,audit_id,"+
        		"limitdate,non_loan_amt,loan_year,change_loan_year,audit_id_c1,audit_id_c2,fine_amt,bank_rt_docno,ag_rt_docno");
        return dbData;

    }
    
    
    public static List getMixInfo(String ex_Type,String ex_no,String bank_no,String docno){
    	String maxSeq ="";
    	String u_year = "99" ;
        if(Integer.parseInt(Utility.getYear()) > 99 ){
    		u_year = "100" ;
    	}
    	StringBuffer sb = new StringBuffer() ;
    	List paramList = new ArrayList() ;
    	sb.append(" select distinct bn01.bank_type,bank_name,decode(ex_type,'FEB',frm_exmaster.ex_no,'AGRI',substr(frm_exmaster.ex_no,0,3)||'年第'||substr(frm_exmaster.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_exmaster.ex_no,'yyyymmdd')),'') as ex_no_list ");
    	sb.append(" from frm_snrtdoc left join (select * from bn01 where m_year=?)bn01 on frm_snrtdoc.bank_no=bn01.bank_no ");
    	sb.append(" left join frm_exmaster on frm_snrtdoc.ex_no=frm_exmaster.ex_no ");
    	paramList.add(u_year) ;
		sb.append(" where ex_type=? ");
		paramList.add(ex_Type) ;
		sb.append("and frm_snrtdoc.ex_no = ? and frm_snrtdoc.bank_no = ? and docno=? ");
    	paramList.add(ex_no);
    	paramList.add(bank_no);
    	paramList.add(docno);
    	List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"");
        return dbData;
    }
    private String insertDataToDB(HttpServletRequest request, String loginID, String loginName) {
      String actMsg = "";
      String errMsg = "";
      String ex_Type =  Utility.getTrimString(request.getParameter("ex_Type"));
      String ex_No =  Utility.getTrimString(request.getParameter("ex_No"));
      String bank_No =  Utility.getTrimString(request.getParameter("tbank"));
      String def_Seq =  Utility.getTrimString(request.getParameter("def_Seq"));
      String docNo = Utility.getTrimString(request.getParameter("docNo"));
      String doc_Date = Utility.getTrimString(request.getParameter("doc_Date"));
      String doc_Type = Utility.getTrimString(request.getParameter("doc_Type"));
      String audit_Type = Utility.getTrimString(request.getParameter("audit_Type"));
      String audit_Id = Utility.getTrimString(request.getParameter("audit_Id"));
      String limitDate =  Utility.getTrimString(request.getParameter("limitDate"));
      String non_Loan_Amt =  Utility.getTrimString(request.getParameter("non_Loan_Amt"));
      String loan_Year =  Utility.getTrimString(request.getParameter("loan_Year"));
      String change_Loan_Year =  Utility.getTrimString(request.getParameter("change_Loan_Year"));
      String audit_Id_C1 =  Utility.getTrimString(request.getParameter("audit_Id_C1"));
      String audit_Id_C2 =  Utility.getTrimString(request.getParameter("audit_Id_C2"));
      String fine_Amt =  Utility.getTrimString(request.getParameter("fine_Amt"));
      
      
      List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
      List updateDBSqlList = new ArrayList();
      List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
        
        try {
        	StringBuffer sqlCmd=new StringBuffer();
        	List paramList = new ArrayList() ;
        	sqlCmd.append("insert into frm_SnRtDoc");
        	sqlCmd.append("(EX_NO,BANK_NO,DEF_SEQ,DOCNO,DOC_DATE,DOC_TYPE,AUDIT_TYPE,AUDIT_ID,limitdate,NON_LOAN_AMT,");
        	sqlCmd.append(" LOAN_YEAR,CHANGE_LOAN_YEAR,AUDIT_ID_C1,AUDIT_ID_C2,FINE_AMT,USER_ID,USER_NAME,UPDATE_DATE)");
        	sqlCmd.append(" values (?,?,?,?,to_date(?,'YYYY/MM/DD'),?,?,?,to_date(?,'YYYY/MM/DD'),?,");
        	sqlCmd.append("         ?,?,?,?,?,?,?,sysdate)");
        	String[] tokens = def_Seq.split(",");
			for (String token:tokens) {
				paramList = new ArrayList();
				updateDBSqlList = new LinkedList();
				updateDBDataList = new LinkedList();
				paramList.add(ex_No);
				paramList.add(bank_No);
				paramList.add(token);
				paramList.add(docNo);
				paramList.add(doc_Date);
				paramList.add(doc_Type);
				paramList.add(audit_Type);
				paramList.add(audit_Id);
				paramList.add(limitDate);
				paramList.add(non_Loan_Amt);
				paramList.add(loan_Year);
				paramList.add(change_Loan_Year);
				paramList.add(audit_Id_C1);
				paramList.add(audit_Id_C2);
				paramList.add(fine_Amt);
				paramList.add(loginID);
				paramList.add(loginName);
			    updateDBSqlList.add(sqlCmd.toString()) ;
			    updateDBDataList.add(paramList) ;
			    updateDBSqlList.add(updateDBDataList) ;
			    updateDBList.add(updateDBSqlList) ;
			}
			if("C".equals(doc_Type)){
				updateDBSqlList = new LinkedList();
				updateDBDataList = new LinkedList();
				sqlCmd.setLength(0);
				sqlCmd.append("update frm_exdef ");
	        	sqlCmd.append("   set case_status='0',update_date=sysdate ");
	        	sqlCmd.append(" where ex_no=? and bank_no=? ");
	        	paramList = new ArrayList();
	        	paramList.add(ex_No);
				paramList.add(bank_No);
			    updateDBSqlList.add(sqlCmd.toString()) ;
			    updateDBDataList.add(paramList) ;
			    updateDBSqlList.add(updateDBDataList) ;
			    updateDBList.add(updateDBSqlList) ;
			    
			    updateDBSqlList = new LinkedList();
				updateDBDataList = new LinkedList();
				sqlCmd.setLength(0);
				sqlCmd.append("update frm_exmaster ");
	        	sqlCmd.append("   set case_status='0',update_date=sysdate ");
	        	sqlCmd.append(" where ex_type=? and ex_no=? and bank_no=? ");
	        	paramList = new ArrayList();
	        	paramList.add(ex_Type);
	        	paramList.add(ex_No);
				paramList.add(bank_No);
			    updateDBSqlList.add(sqlCmd.toString()) ;
			    updateDBDataList.add(paramList) ;
			    updateDBSqlList.add(updateDBDataList) ;
			    updateDBList.add(updateDBSqlList) ;
			}
			
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
	private String updateDataToDB(HttpServletRequest request, String loginID, String loginName) {
	    String actMsg = "";
        String errMsg = "";
        
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;

	    try {
            errMsg = deleteDataToDB(request);
            if("相關資料刪除成功".equals(errMsg)){
            	errMsg = insertDataToDB(request,loginID,loginName);
            	if("相關資料寫入資料庫成功".equals(errMsg)){
            		errMsg = "相關資料寫入資料庫成功";
            	}
            }
        } catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				return "相關資料寫入資料庫失敗 <br>[Exception Error]<br> ";
		}
		return errMsg;
	}

	// 刪除資料
	private String deleteDataToDB(HttpServletRequest request) {
	    String actMsg = "";
        String errMsg = "";   
        String ex_Type =  Utility.getTrimString(request.getParameter("ex_Type"));
        String ex_No =  Utility.getTrimString(request.getParameter("ex_No"));
        String bank_No =  Utility.getTrimString(request.getParameter("bank_No"));
        String oriDef_Seq =  Utility.getTrimString(request.getParameter("oriDef_Seq"));
        String oriDocNo = Utility.getTrimString(request.getParameter("oriDocNo"));
        String oriDocType = Utility.getTrimString(request.getParameter("oriDocType"));
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
        StringBuffer sqlCmd = new StringBuffer() ;
        List paramList = new ArrayList() ;
	    try {
	    	//1.刪除查核明細資料(frm_exdef)
	    	sqlCmd.append("delete frm_snrtdoc where ex_no=? and bank_no=? and def_seq=? and docno=? ");
			String[] tokens = oriDef_Seq.split(",");
			for (String token:tokens) {
				paramList = new ArrayList();
				updateDBSqlList = new LinkedList();
				updateDBDataList = new LinkedList();
				paramList.add(ex_No);
				paramList.add(bank_No);
				paramList.add(token);
				paramList.add(oriDocNo);
			    updateDBSqlList.add(sqlCmd.toString()) ;
			    updateDBDataList.add(paramList) ;
			    updateDBSqlList.add(updateDBDataList) ;
			    updateDBList.add(updateDBSqlList) ;
			}
			if("C".equals(oriDocType)){
				updateDBSqlList = new LinkedList();
				updateDBDataList = new LinkedList();
				sqlCmd.setLength(0);
				sqlCmd.append("update frm_exdef ");
	        	sqlCmd.append("   set case_status='1',update_date=sysdate ");
	        	sqlCmd.append(" where ex_no=? and bank_no=? ");
	        	paramList = new ArrayList();
	        	paramList.add(ex_No);
				paramList.add(bank_No);
			    updateDBSqlList.add(sqlCmd.toString()) ;
			    updateDBDataList.add(paramList) ;
			    updateDBSqlList.add(updateDBDataList) ;
			    updateDBList.add(updateDBSqlList) ;
			    
			    updateDBSqlList = new LinkedList();
				updateDBDataList = new LinkedList();
				sqlCmd.setLength(0);
				sqlCmd.append("update frm_exmaster ");
	        	sqlCmd.append("   set case_status='1',update_date=sysdate ");
	        	sqlCmd.append(" where ex_type=? and ex_no=? and bank_no=? ");
	        	paramList = new ArrayList();
	        	paramList.add(ex_Type);
	        	paramList.add(ex_No);
				paramList.add(bank_No);
			    updateDBSqlList.add(sqlCmd.toString()) ;
			    updateDBDataList.add(paramList) ;
			    updateDBSqlList.add(updateDBDataList) ;
			    updateDBList.add(updateDBSqlList) ;
			}
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
