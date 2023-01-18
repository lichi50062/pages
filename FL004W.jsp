<%
//105.10.06 create by 2968
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
	
	System.out.println("Page: FL004W.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );
		

    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
           rd = application.getRequestDispatcher( LoginErrorPgName );
    } else {
    	if(act.equals("List") ||act.equals("DetailList") ||act.equals("RtnList") ||  act.equals("New") || act.equals("Edit") || act.equals("New1")) {    	    
    		request.setAttribute("TBank", getTatolBankType());           
    	    request.setAttribute("City", Utility.getCity());
    	    if(act.equals("Edit") || act.equals("New") || act.equals("New1")) {
    	    	request.setAttribute("LoanItemList",getLoanItemList());
    			request.setAttribute("DefCaseList",getDefCaseList());
    	        if(act.equals("New1") || act.equals("New")) {
    	        	String bankType = request.getParameter("bankType") != null ? request.getParameter("bankType") : "";
    	        	String bank_no = request.getParameter("bank_no") != null ? request.getParameter("bank_no") : request.getParameter("tbank");
     	            String ex_no = request.getParameter("ex_no") != null ? request.getParameter("ex_no") : "";
     	            String ex_type = request.getParameter("ex_type") != null ? request.getParameter("ex_type") : "";
    	        	request.setAttribute("bankType",bankType);
    	        	request.setAttribute("bank_No",bank_no);
    	            request.setAttribute("ex_No",ex_no);
    	            request.setAttribute("ex_Type",ex_type);
    	            rd = application.getRequestDispatcher( EditPgName +"?act=New&bankType="+bankType+"&bank_No="+bank_no+"&ex_Type="+ex_type);
    	        }else{
    	            String bank_no = request.getParameter("bank_No") != null ? request.getParameter("bank_No") : request.getParameter("tbank");
    	            String ex_no = request.getParameter("ex_No") != null ? request.getParameter("ex_No") : "";
    	            String def_seq = request.getParameter("def_Seq") != null ? request.getParameter("def_Seq") : "";
    	            String ex_kind = Utility.getTrimString(request.getParameter("ex_Kind")) ;
    	            request.setAttribute("bank_No",bank_no);
    	            request.setAttribute("ex_No",ex_no);
    	            request.setAttribute("def_Seq",def_seq);
    	            request.setAttribute("EditInfo",this.getEditInfo(bank_no,ex_no,def_seq,ex_kind));    	               	           
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit");
    	        }
    	    } else if(act.equals("List")||act.equals("RtnList")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName +"?act=List");
    	    } else if(act.equals("DetailList")) {
    	    	String bank_no = request.getParameter("bank_No") != null ? request.getParameter("bank_No") : request.getParameter("tbank");
    	        String ex_type = Utility.getTrimString(request.getParameter("ex_Type")) ;
    	        String ex_no = request.getParameter("ex_No") != null ? request.getParameter("ex_No") : "";
    	        if("".equals(ex_no)) ex_no = Utility.getTrimString(request.getParameter("insEx_No")) ;
    	        String ex_no_list = "";
    	        String bank_name = "";
    	        String banktype="";
    	        List qList = getMixInfo(ex_type,ex_no,bank_no);
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
    	     	
    	        request.setAttribute("DetailResult_C", this.getDetailResult(request,"C",bank_no,ex_no));//個案查核
    	        request.setAttribute("DetailResult_AR", this.getDetailResult(request,"",bank_no,ex_no));//整體性
    	        rd = application.getRequestDispatcher( DetailListPgName +"?act=DetailList");
    	    }     	    
        } else if(act.equals("Insert")){
        	String bank_no = request.getParameter("tbank") != null ? request.getParameter("tbank") : "";
	        String ex_no = request.getParameter("insEx_No") != null ? request.getParameter("insEx_No") : "";
	        String ex_type = Utility.getTrimString(request.getParameter("ex_Type")) ;
	        String newDefSeq = getMaxDefSeq(ex_no,bank_no); 
	        actMsg = insertDataToDB(request,userId,userName,newDefSeq);
    	    request.setAttribute("actMsg",actMsg); 
    	    rd = application.getRequestDispatcher( nextPgName+"?goPages=FL004W.jsp&act=DetailList&bank_No="+bank_no+"&ex_Type"+ex_type+"&ex_No="+ex_no);        	
        } else if(act.equals("Update")){
        	String bank_no = request.getParameter("bank_No") != null ? request.getParameter("bank_No") : "";
	        String ex_no = request.getParameter("ex_No") != null ? request.getParameter("ex_No") : "";
	        String ex_type = Utility.getTrimString(request.getParameter("ex_Type")) ;
	        String def_seq = request.getParameter("def_Seq") != null ? request.getParameter("def_Seq") : "";
            actMsg = updateDataToDB(request,userId,userName);
            rd = application.getRequestDispatcher( nextPgName+"?goPages=FL004W.jsp&act=DetailList&bank_No="+bank_no+"&ex_Type"+ex_type+"&ex_No="+ex_no);
        } else if(act.equals("Delete")){
        	String bank_no = Utility.getTrimString(request.getParameter("bank_No")) ;  
	        String ex_type = Utility.getTrimString(request.getParameter("ex_Type")) ;
	        String ex_no = Utility.getTrimString(request.getParameter("ex_No")) ;
	        
    	    actMsg = deleteDataToDB(request,userId,userName);
    	    rd = application.getRequestDispatcher( nextPgName +"?goPages=FL004W.jsp&act=DetailList&bank_No="+bank_no+"&ex_Type"+ex_type+"&ex_No="+ex_no);
        }        
    	request.setAttribute("actMsg",actMsg);
      }
    
	

%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "FL004W" ;
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
	//貸款種類
    private List getLoanItemList(){
		StringBuffer sql = new StringBuffer() ;
		sql.append(" select loan_item,loan_item_name ");
		sql.append(" from frm_loan_item ");
		sql.append(" order by input_order ");
	    List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,"loan_item,loan_item_name");
	    return dbData;
    }
	//缺失內容
	private List getDefCaseList(){
		StringBuffer sql = new StringBuffer() ;
		sql.append(" select distinct def_kind,decode(def_kind,'A','整體性缺失','C','個案缺失','') as def_kindname, ");
		sql.append("        def_type,cmuse_name,def_case,case_name ");
		sql.append(" from frm_def_item ");
		sql.append(" left join (select * from cdshareno where cmuse_div='047')cdshareno on frm_def_item.def_type=cdshareno.cmuse_id ");
		sql.append(" order by def_type,def_case ");
	    List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,"def_kind,def_kindname,def_type,cmuse_name,def_case,case_name");
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

    	//查詢條件 
    	StringBuffer sb=new StringBuffer();
    	List paramList = new ArrayList() ;
    	sb.append(" select distinct ex_type,ex_no,decode(ex_type,'FEB',ex_no,'AGRI',substr(ex_no,0,3)||'年第'||substr(ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(ex_no,'yyyymmdd')),'') as ex_no_list,");
    	sb.append("        frm_exmaster.bank_no,bank_name ");
    	sb.append(" from frm_exmaster left join (select * from bn01 where m_year=?)bn01 on frm_exmaster.bank_no=bn01.bank_no ");
    	paramList.add(u_year) ;
		sb.append(" where ex_type=? ");
		paramList.add(ex_Type) ;
		if(!"".equals(ex_No)){
			sb.append("and ex_no like ? ");
			paramList.add(ex_No+"%") ;
		}
		if(!"".equals(begSeason)){
			sb.append("and ( to_number(ex_no) >= ? and to_number(ex_no) <= ? ) ");
			paramList.add(begSeason) ;
			paramList.add(endSeason) ;
		}
		if(!"".equals(begDate)){
			sb.append("and ( to_number(ex_no) >= ? and to_number(ex_no) <= ? ) ");
			paramList.add(Integer.parseInt(begDate)+19110000) ;
			paramList.add(Integer.parseInt(endDate)+19110000) ;
		}
		if(!"".equals(tbank)){
		sb.append(" and frm_exmaster.bank_no= ? ");
		paramList.add(tbank) ;
		}
		sb.append(" order by ex_no asc,bank_no asc ");
		
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"ex_type,ex_no,ex_no_list,bank_no,bank_name");
        System.out.println("getQueryResult.size="+dbData.size());
        return dbData;
    }

    private List getDetailResult(HttpServletRequest request,String ex_kind,String bank_no,String ex_no){
    	//查詢條件 
    	StringBuffer sb=new StringBuffer();
    	List paramList = new ArrayList() ;
    	sb.append(" select distinct frm_exdef.ex_no,frm_exdef.bank_no,def_seq,ex_kind,");
    	sb.append("        loan_name,to_char(loan_date,'YYYY/MM/DD')loan_date,frm_exdef.loan_item,loan_item_name,loan_amt,");
    	sb.append("        decode(ex_result,'0','尚無不妥','1','核有缺失','') as ex_result,frm_exdef.def_type,frm_exdef.def_case,case_name ");
    	sb.append(" from frm_exdef ");
    	sb.append(" left join frm_loan_item on frm_exdef.loan_item = frm_loan_item.loan_item ");
    	sb.append(" left join frm_exmaster on frm_exdef.ex_no=frm_exmaster.ex_no ");
    	sb.append(" left join frm_def_item on frm_exdef.def_type = frm_def_item.def_type and frm_exdef.def_case = frm_def_item.def_case ");
		sb.append(" where frm_exdef.ex_no=? and  frm_exdef.bank_no=? ");
		paramList.add(ex_no) ;
		paramList.add(bank_no) ;
		if("C".equals(ex_kind)){
			sb.append("and ex_kind ='C' ");//個案查核
		}else{
			sb.append("and ex_kind !='C' ");//整体性查核
		}
		sb.append(" order by loan_name,loan_date,frm_exdef.loan_item,loan_amt,def_seq ");
		
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"ex_no,bank_no,def_seq,ex_kind,loan_name,loan_date,loan_item,"+
        								"loan_item_name,loan_amt,ex_result,def_type,def_case,case_name");
        System.out.println("getDetailResult.size="+dbData.size());
        return dbData;
    }
    
    // 取得單筆資料
    private List getEditInfo(String bank_no,String ex_no,String def_seq,String ex_kind){ 
        DataObject ob = null;
        StringBuffer sb=new StringBuffer();
        List paramList = new ArrayList() ;
        String u_year = "99" ;
        if(Integer.parseInt(Utility.getYear()) > 99 ){
    		u_year = "100" ;
    	}
        sb.append(" select distinct ex_type,decode(ex_type,'FEB','金管會檢查報告','AGRI','農業金庫查核','BOAF','農金局訪查','') as ex_type_name,");
        sb.append(" frm_exmaster.ex_no,decode(ex_type,'FEB',frm_exmaster.ex_no,'AGRI',substr(frm_exmaster.ex_no,0,3)||'年第'||substr(frm_exmaster.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_exmaster.ex_no,'yyyymmdd')),'') as ex_no_list,");
        sb.append(" frm_exmaster.bank_no,bank_name,to_char(def_seq)def_seq,loan_name,to_char(loan_date,'YYYYMMDD')loan_date,loan_item,to_char(loan_amt)loan_amt,ex_result,frm_exdef.def_type,frm_exdef.def_case,memo,ex_kind ");
        sb.append(" from frm_exmaster ");  
        sb.append(" left join frm_exdef on frm_exmaster.ex_no=frm_exdef.ex_no ");
        sb.append(" left join (select * from bn01 where m_year=?)bn01 on frm_exmaster.bank_no=bn01.bank_no ");
        sb.append(" where frm_exmaster.ex_no=? and  frm_exmaster.bank_no=? and def_seq=? "); 
        paramList.add(u_year) ;
        paramList.add(ex_no) ;
		paramList.add(bank_no) ;
		paramList.add(def_seq) ;
		if(!"".equals(ex_kind)){
        	sb.append(" and ex_kind = ? ");
        	paramList.add(ex_kind);
        }
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"");
        return dbData;

    }
    
    private String insertDataToDB(HttpServletRequest request, String loginID, String loginName,String newDefSeq) {
    	System.out.println("action is insertDataToDB===");
      String actMsg = "";
      String errMsg = "";
      String ex_Type =  Utility.getTrimString(request.getParameter("ex_Type"));
      String bank_No =  Utility.getTrimString(request.getParameter("tbank"));
      String ex_Kind =  Utility.getTrimString(request.getParameter("ex_Kind"));
      String ex_Result =  Utility.getTrimString(request.getParameter("ex_Result"));
      String loan_Name =  Utility.getTrimString(request.getParameter("loan_Name"));
      String loan_Date =  Utility.getTrimString(request.getParameter("loanDate"));
      String loan_Item =  Utility.getTrimString(request.getParameter("loan_Item"));
      String loan_Amt =  Utility.getTrimString(request.getParameter("loan_Amt"));
      String def_Type =  Utility.getTrimString(request.getParameter("def_Type"));
      String def_Case =  Utility.getTrimString(request.getParameter("def_Case"));
      String memo =  Utility.getTrimString(request.getParameter("memo"));
      String insEx_No = Utility.getTrimString(request.getParameter("insEx_No"));
      
      
      List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
      List updateDBSqlList = new ArrayList();
      List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
        
        try {
        	StringBuffer sb=new StringBuffer();
        	List paramList = new ArrayList() ;
            sb.append( "select bank_no from frm_exmaster where ex_no=? and bank_no=? " );
            paramList.add(insEx_No) ; 
            paramList.add(bank_No) ;
            List data = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"bank_no");
			if(data==null || data.size() ==0){//無資料時,才寫入frm_exMaster
				sb=new StringBuffer();
				 paramList = new ArrayList();
				 sb.append("Insert into frm_exMaster (EX_TYPE,EX_NO,BANK_NO,CASE_STATUS,USER_ID,USER_NAME,UPDATE_DATE) ");
				 sb.append(" values(?,?,?,?,?,?,sysdate)");
	             paramList.add(ex_Type) ;
	             paramList.add(insEx_No) ;
	             paramList.add(bank_No) ;
	             paramList.add(ex_Result) ;
	             paramList.add(loginID) ;
	             paramList.add(loginName);
	             updateDBSqlList.add(sb.toString());
	             updateDBDataList.add(paramList);
			     updateDBSqlList.add(updateDBDataList);
			     updateDBList.add(updateDBSqlList);
			}
			//新增frm_exdef
			sb=new StringBuffer();
			paramList = new ArrayList();
			updateDBSqlList = new LinkedList();
			updateDBDataList = new LinkedList();
			sb.append("Insert into frm_exdef(EX_NO,BANK_NO,DEF_SEQ,EX_KIND,EX_RESULT,LOAN_NAME,LOAN_DATE,LOAN_ITEM,LOAN_AMT,DEF_TYPE,DEF_CASE,CASE_STATUS,MEMO,USER_ID,USER_NAME,UPDATE_DATE) ");
			sb.append(" values(?,?,?,?,?,?,TO_DATE(?,'YYYY/MM/DD'),?,?,?,?,?,?,?,?,sysdate)");
			paramList.add(insEx_No) ;
			paramList.add(bank_No);
			paramList.add(newDefSeq) ;
			paramList.add(ex_Kind);
			paramList.add(ex_Result);
			paramList.add(loan_Name);
			paramList.add(loan_Date);
			paramList.add(loan_Item);
			paramList.add(loan_Amt);
			paramList.add(def_Type);
			paramList.add(def_Case);
			paramList.add(ex_Result);
			paramList.add(memo);
			paramList.add(loginID) ;
            paramList.add(loginName);
			updateDBSqlList.add(sb.toString());
            updateDBDataList.add(paramList);
		    updateDBSqlList.add(updateDBDataList);
		    updateDBList.add(updateDBSqlList);
		    
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
    public static String getMaxDefSeq(String ex_no,String bank_no){
    	String maxSeq ="";
    	StringBuffer sql = new StringBuffer() ;
    	List paramList = new ArrayList() ;
    	sql.append("select nvl(max(def_seq),0)+1 as def_seq from frm_exdef where ex_no=? and bank_no=? ") ;
    	paramList.add(ex_no);
    	paramList.add(bank_no);
    	List data = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"def_seq");
    	if(data != null && data.size() > 0 ){
    		maxSeq = ((DataObject)data.get(0)).getValue("def_seq").toString() ;
    	}
    	return maxSeq ;
    }
    public static List getMixInfo(String ex_Type,String ex_no,String bank_no){
    	String maxSeq ="";
    	String u_year = "99" ;
        if(Integer.parseInt(Utility.getYear()) > 99 ){
    		u_year = "100" ;
    	}
    	StringBuffer sb = new StringBuffer() ;
    	List paramList = new ArrayList() ;
    	sb.append(" select distinct bank_type,bank_name,decode(ex_type,'FEB',frm_exmaster.ex_no,'AGRI',substr(frm_exmaster.ex_no,0,3)||'年第'||substr(frm_exmaster.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_exmaster.ex_no,'yyyymmdd')),'') as ex_no_list ");
    	sb.append(" from frm_exmaster left join (select * from bn01 where m_year=?)bn01 on frm_exmaster.bank_no=bn01.bank_no ");
    	paramList.add(u_year) ;
		sb.append(" where ex_type=? ");
		paramList.add(ex_Type) ;
		sb.append("and ex_no = ? and frm_exmaster.bank_no = ? ");
    	paramList.add(ex_no);
    	paramList.add(bank_no);
    	List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"");
        return dbData;
    }
    
	private String updateDataToDB(HttpServletRequest request, String loginID, String loginName) {
	    String actMsg = "";
        String errMsg = "";
        String ex_Type =  Utility.getTrimString(request.getParameter("ex_Type"));
        String bank_No =  Utility.getTrimString(request.getParameter("tbank"));
        String def_Seq =  Utility.getTrimString(request.getParameter("def_Seq"));
        String ex_Kind =  Utility.getTrimString(request.getParameter("ex_Kind"));
        String ex_Result =  Utility.getTrimString(request.getParameter("ex_Result"));
        String loan_Name =  Utility.getTrimString(request.getParameter("loan_Name"));
        String loan_Date =  Utility.getTrimString(request.getParameter("loanDate"));
        String loan_Item =  Utility.getTrimString(request.getParameter("loan_Item"));
        String loan_Amt =  Utility.getTrimString(request.getParameter("loan_Amt"));
        String def_Type =  Utility.getTrimString(request.getParameter("def_Type"));
        String def_Case =  Utility.getTrimString(request.getParameter("def_Case"));
        String memo =  Utility.getTrimString(request.getParameter("memo"));
        String insEx_No = Utility.getTrimString(request.getParameter("insEx_No"));
        
        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;

	    try {
            // 檢查是否存在
            StringBuffer sqlCmd = new StringBuffer() ;
            sqlCmd.append("select count(*) as count from frm_exdef where ex_no=? and bank_no=? and def_seq=? ");
            paramList.add(insEx_No) ;
            paramList.add(bank_No) ;
            paramList.add(def_Seq) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");
		    System.out.println("frm_exdef.size="+data.size());
			if(data.size() < 1) {
     	        errMsg = errMsg + "此筆資料不存在無法修改<br>";
                return errMsg;
            }
			sqlCmd.setLength(0) ;
			paramList.clear() ;
			sqlCmd.append(" UPDATE frm_exdef SET ");
        	sqlCmd.append(" EX_KIND = ?,EX_RESULT=?,LOAN_NAME=?,LOAN_DATE=to_date(?,'YYYY/MM/DD'),LOAN_ITEM =?");
        	sqlCmd.append(" ,LOAN_AMT=?,DEF_TYPE=?,DEF_CASE=?,CASE_STATUS=?,MEMO=?,UPDATE_DATE=sysdate ");
        	sqlCmd.append(" where ex_no=? and bank_no=? and def_seq=? ");
        	paramList.add(ex_Kind) ;
        	paramList.add(ex_Result) ;
        	paramList.add(loan_Name) ;
        	paramList.add(loan_Date) ;
        	paramList.add(loan_Item) ;
        	paramList.add(loan_Amt) ;
        	paramList.add(def_Type) ;
        	paramList.add(def_Case) ;
        	paramList.add(ex_Result) ;
        	paramList.add(memo) ;
        	paramList.add(insEx_No) ;
            paramList.add(bank_No) ;
            paramList.add(def_Seq) ;
            
            updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;

            
            if(DBManager.updateDB_ps(updateDBList)){
				errMsg = errMsg + "相關資料寫入資料庫成功";
			}else{
				errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
			}
        } catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				return "相關資料寫入資料庫失敗 <br>[Exception Error]<br> ";
		}
		return errMsg;
	}

	// 刪除資料
	private String deleteDataToDB(HttpServletRequest request, String loginID, String loginName) {
	    String actMsg = "";
        String errMsg = "";        
        String ex_Type =  Utility.getTrimString(request.getParameter("ex_Type"));
        String bank_No =  Utility.getTrimString(request.getParameter("tbank"));
        String def_Seq =  Utility.getTrimString(request.getParameter("def_Seq"));
        String insEx_No = Utility.getTrimString(request.getParameter("insEx_No"));
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
        StringBuffer sqlCmd = new StringBuffer() ;
        List paramList = new ArrayList() ;
	    try {
	    	//1.刪除查核明細資料(frm_exdef)
	    	sqlCmd.append("delete frm_exdef where ex_no=? and bank_no=? and def_seq=? ");
            paramList.add(insEx_No) ;
            paramList.add(bank_No) ;
            paramList.add(def_Seq) ;
            updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
		    if(DBManager.updateDB_ps(updateDBList)){
				errMsg = "相關資料刪除成功";
			}else{
				errMsg = errMsg + "相關明細資料刪除失敗<br>[DBManager.getErrMsg()]<br>" + DBManager.getErrMsg();
			}
	    	//2.若已無缺失明細frm_exdef資料時,一併刪除主檔資料(frm_exmaster)
			sqlCmd.setLength(0);
			paramList.clear();
            sqlCmd.append( "select ex_no from frm_exdef where ex_no=? and bank_no=? ");
            paramList.add(insEx_No) ;
            paramList.add(bank_No) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"ex_no");
			if(data.size()==0) {//表示已無缺失明細資料
				sqlCmd.setLength(0);
				paramList.clear();
	            sqlCmd.append("select ex_no from frm_exmaster where ex_type=? and ex_no=? and bank_no=? ");
	            paramList.add(ex_Type) ;
	            paramList.add(insEx_No) ;
	            paramList.add(bank_No) ;
	            data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"ex_no");
	            if(data.size() >0 ){//表示有主檔資料,將主檔刪除
	            	updateDBSqlList = new LinkedList();
	    			updateDBDataList = new LinkedList();
	    			sqlCmd.setLength(0) ;
	    			paramList.clear() ;
	    			sqlCmd.append(" delete frm_exmaster where ex_type=? and ex_no=? and bank_no=? " );
	    			paramList.add(ex_Type) ;
		            paramList.add(insEx_No) ;
		            paramList.add(bank_No) ;
	                updateDBSqlList.add(sqlCmd.toString()) ;
	    		    updateDBDataList.add(paramList) ;
	    		    updateDBSqlList.add(updateDBDataList) ;
	    		    updateDBList.add(updateDBSqlList) ;
	    		    if(DBManager.updateDB_ps(updateDBList)){
	    				 errMsg = "相關資料刪除成功";
	    			}else{
	    				 errMsg = errMsg + "相關主檔資料刪除失敗<br>[DBManager.getErrMsg()]<br>" + DBManager.getErrMsg();
	    			}
	            }
            }

            

        } catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				return "相關資料刪除失敗<br>[Exception Error]<br>";
		}
		return errMsg;


	}
	
%>
