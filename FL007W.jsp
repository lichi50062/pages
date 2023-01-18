<%
//105.10.25 create by 2968
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
	
	System.out.println("Page: FL007W.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );
		

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
	            String ag_Rt_DocNo = request.getParameter("ag_Rt_DocNo") != null ? request.getParameter("ag_Rt_DocNo") : "";
    	        if(act.equals("New")) {
    	            rd = application.getRequestDispatcher( EditPgName +"?act=New&bank_No="+bank_no+"&ex_Type="+ex_type+"&ex_No="+ex_no+"&ag_Rt_DocNo="+ag_Rt_DocNo);
    	        }else{
    	            request.setAttribute("EditInfo",this.getEditInfo(bank_no,ex_no,ag_Rt_DocNo));    	               	           
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit&bank_No="+bank_no+"&ex_Type="+ex_type+"&ex_No="+ex_no+"&ag_Rt_DocNo="+ag_Rt_DocNo);
    	        }
    	    } else if(act.equals("List")||act.equals("RtnList")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName +"?act=List");
    	    }
    	} else if(act.equals("RateList")){
    		String item = Utility.getTrimString(request.getParameter("item"));
    		String item_Name = Utility.getTrimString(request.getParameter("item_name"));
    		request.setAttribute("RateList",getRateList(item));
	        rd = application.getRequestDispatcher("/pages/FL007W_RateList.jsp?item_Name="+item_Name);
        } else if(act.equals("Insert")||act.equals("Update")){
        	String bank_no = request.getParameter("bank_No") != null ? request.getParameter("bank_No") : request.getParameter("tbank"); 
	        String ex_no = Utility.getTrimString(request.getParameter("ex_No")) ;
	        String ag_rt_docno = Utility.getTrimString(request.getParameter("ag_Rt_DocNo")) ;
            actMsg = updateDataToDB(request,userId,userName);
            rd = application.getRequestDispatcher( nextPgName+"?goPages=FL007W.jsp&act=List&bank_No="+bank_no+"&ex_No="+ex_no+"&ag_Rt_DocNo="+ag_rt_docno);
        } else if(act.equals("Delete")){
        	String bank_no = request.getParameter("bank_No") != null ? request.getParameter("bank_No") : request.getParameter("tbank");  
	        String ex_type = Utility.getTrimString(request.getParameter("ex_Type")) ;
	        String ex_no = Utility.getTrimString(request.getParameter("ex_No")) ;
	        String docno = Utility.getTrimString(request.getParameter("docNo")) ;
    	    actMsg = deleteDataToDB(request);
    	    rd = application.getRequestDispatcher( nextPgName +"?goPages=FL007W.jsp&act=List&bank_No="+bank_no+"&ex_Type"+ex_type+"&ex_No="+ex_no+"&docNo="+docno);
        }        
    	request.setAttribute("actMsg",actMsg);
      }
    
	

%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "FL007W" ;
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
    //對應的查核報告編號、辦理依據、缺失個案明細
  	private List getDetailList(){
  		StringBuffer sql = new StringBuffer() ;
  		List paramList = new ArrayList() ;
  		sql.append(" select distinct frm_exdef.bank_no,");//受檢單位
  		sql.append(" 		ex_type,");//查核類別 FEB:金管會檢查報告 AGRI:農業金庫查核 BOAF:農金局訪查
  		sql.append("        frm_exdef.ex_no,");//查核報告編號
  		sql.append("        decode(ex_type,'FEB',frm_exmaster.ex_no,'AGRI',substr(frm_exmaster.ex_no,0,3)||'年第'||substr(frm_exmaster.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_exmaster.ex_no,'yyyymmdd')),'') as ex_no_list,");
  		sql.append("        decode(doc_date,null,'','','',F_TRANSCHINESEDATE(doc_date)) as doc_date,");//辦理依據.發文日期
  		sql.append("        docno,");//辦理依據.發文文號
  		sql.append("        frm_exdef.def_seq,");//缺失序號
  		sql.append("        loan_name,");//借款人名稱 
  		sql.append("        F_TRANSCHINESEDATE(loan_date) as loan_date,");//貸款日期
  		sql.append("        frm_exdef.loan_item,");
  		sql.append("        loan_item_name,");//貸款種類名稱
  		sql.append("        loan_amt,");//貸款金額
  		sql.append("        frm_exdef.def_type,");
  		sql.append("        frm_exdef.def_case,case_name,");//缺失情節
  		sql.append("        frm_snrtdoc.non_loan_amt,");//需繳款的補貼息金額
  		sql.append("        decode(frm_snrtdoc.audit_id,'A2','不符規定金額:'||frm_snrtdoc.non_loan_amt||'元','A3','應調整貸款金額:'||frm_snrtdoc.non_loan_amt||'元<br>原貸款期限'||frm_snrtdoc.loan_year||'年<br>'||'調整後貸款期限'||frm_snrtdoc.change_loan_year||'年','') as non_loan_status ");//不符規定情形
  		sql.append(" from frm_exdef ");
  		sql.append(" left join frm_loan_item on frm_exdef.loan_item = frm_loan_item.loan_item ");
  		sql.append(" left join frm_exmaster on frm_exdef.ex_no=frm_exmaster.ex_no and frm_exdef.bank_no=frm_exmaster.bank_no ");
  		sql.append(" left join frm_def_item on frm_exdef.def_type = frm_def_item.def_type and frm_exdef.def_case = frm_def_item.def_case ");
  		sql.append(" left join frm_snrtdoc on frm_exdef.ex_no=frm_snrtdoc.ex_no and frm_exdef.bank_no=frm_snrtdoc.bank_no and frm_exdef.def_seq=frm_snrtdoc.def_seq ");
  		sql.append(" where frm_snrtdoc.audit_id in ('A2','A3') ");//核處情形為A2:繳還補貼息 A3:調整貸款期限
  		//sql.append(" and frm_exmaster.case_status != '0' ");//未結案
  		//sql.append(" order by ex_type asc,ex_no asc,doc_date desc ,def_seq ");
  		sql.append(" order by frm_exdef.bank_no,frm_exdef.ex_no, doc_date desc ,docno,loan_name,loan_date,frm_exdef.loan_item,loan_amt,def_seq ");
  	    List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,"bank_no,ex_type,ex_no,ex_no_list,doc_date,docno,def_seq,loan_name,loan_date,loan_item,loan_item_name,loan_amt,def_type,def_case,case_name,non_loan_amt,non_loan_status");
  	    return dbData;
    }
  	//該貸款大類及貸款子目別實施利率清單
  	private List getRateList(String loan_Item){
  		StringBuffer sql = new StringBuffer() ;
  		List paramList = new ArrayList() ;
  		sql.append(" select subitem,");//--序號
  		sql.append(" 		loan_item_name,");//--貸款種類名稱
  		sql.append(" 		subitem_name,");//--貸款子目別名稱 
  		sql.append(" 		F_TRANSCHINESEDATE(start_date) as start_date,");//--實施日期
  		sql.append(" 		loan_rate,");//--貸款利率
  		sql.append(" 		base_rate,");//--補貼基準
  		sql.append(" 		agbase_rate ");//--農業金庫基準利率加一成利率
  		sql.append(" from frm_loan_subitem ");
  		sql.append(" left join frm_loan_item on frm_loan_subitem.loan_item =frm_loan_item.loan_item ");
  		sql.append(" where frm_loan_subitem.loan_item=? ");//--缺失個案明細.貸款種類代碼
  		sql.append(" order by subitem asc,start_date desc ");
		paramList.add(loan_Item);
  	    List dbData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"loan_rate,base_rate,agbase_rate");
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
        String ag_Rt_DocNo = Utility.getTrimString(request.getParameter("ag_Rt_DocNo")) ;
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
    	request.setAttribute("ag_Rt_DocNo",ag_Rt_DocNo);
    	//查詢條件 
    	StringBuffer sb=new StringBuffer();
    	List paramList = new ArrayList() ;
    	sb.append(" select frm_snrtdoc.bank_no,bank_name,frm_snrtdoc.ex_no,ex_type,decode(ex_type,'FEB',frm_snrtdoc.ex_no,'AGRI',substr(frm_snrtdoc.ex_no,0,3)||'年第'||substr(frm_snrtdoc.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_snrtdoc.ex_no,'yyyymmdd')),'') as ex_no_list,");
    	sb.append("        F_TRANSCHINESEDATE(ag_rt_doc_date) as ag_rt_doc_date,ag_rt_docno,F_TRANSCHINESEDATE(doc_date) as doc_date,docno,F_TRANSCHINESEDATE(pay_date) as pay_date,pay_amt_sum ");
    	sb.append(" from frm_snrtdoc ");
    	sb.append(" left join (select * from bn01 where m_year=?)bn01 on frm_snrtdoc.bank_no=bn01.bank_no ");
    	sb.append(" left join frm_exmaster on frm_snrtdoc.ex_no=frm_exmaster.ex_no and frm_snrtdoc.bank_no=frm_exmaster.bank_no ");
    	paramList.add(u_year) ;
		sb.append(" where ag_rt_docno is not null and ex_type=? ");
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
			sb.append("and TO_CHAR(ag_rt_doc_date,'yyyymmdd') BETWEEN ? AND ? ");
			paramList.add(String.valueOf(Integer.parseInt(docBegDate)+19110000)) ;
			paramList.add(String.valueOf(Integer.parseInt(docEndDate)+19110000)) ;
		}
		if(!"".equals(ag_Rt_DocNo)){
			sb.append(" and ag_rt_docno like ? ");
			paramList.add(ag_Rt_DocNo+"%") ;
		}
		sb.append(" group by "); 
		sb.append(" frm_snrtdoc.bank_no,bank_name,frm_snrtdoc.ex_no,ex_type,decode(ex_type,'FEB',frm_snrtdoc.ex_no,'AGRI',substr(frm_snrtdoc.ex_no,0,3)||'年第'||substr(frm_snrtdoc.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_snrtdoc.ex_no,'yyyymmdd')),''), ");
		sb.append(" ag_rt_doc_date,ag_rt_docno,doc_date,docno,pay_date,pay_amt_sum ");
		sb.append(" order by bank_no asc,ex_no asc,doc_date desc,ag_rt_doc_date desc ");
		
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"pay_amt_sum");
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
        sb.append(" select distinct frm_exmaster.ex_type,decode(frm_exmaster.ex_type,'FEB','金管會檢查報告','AGRI','農業金庫查核','BOAF','農金局訪查','') as ex_type_name,frm_snrtdoc.bank_no,bank_name,");
        sb.append(" 	   frm_snrtdoc.ex_no,decode(frm_exmaster.ex_type,'FEB',frm_snrtdoc.ex_no,'AGRI',substr(frm_snrtdoc.ex_no,0,3)||'年第'||substr(frm_snrtdoc.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_snrtdoc.ex_no,'yyyymmdd')),'') as ex_no_list,");
        sb.append(" 	   to_char(ag_rt_doc_date,'yyyymmdd')ag_rt_doc_date,ag_rt_docno, F_TRANSCHINESEDATE (doc_date) doc_date,docno,to_char(frm_snrtdoc.pay_date,'yyyymmdd') pay_date,pay_amt_sum,frm_exmaster.case_status,frm_exdef.def_seq,loan_name,");
        sb.append(" 	   to_char(loan_date,'yyyymmdd') as loan_date,frm_exdef.loan_item,loan_item_name,loan_amt,frm_exdef.def_type,frm_exdef.def_case,case_name,");
        sb.append(" 	   decode(frm_snrtdoc.audit_id,'A2','不符規定金額:'||frm_snrtdoc.non_loan_amt||'元','A3','應調整貸款金額:'||frm_snrtdoc.non_loan_amt||'元<br>原貸款期限'||frm_snrtdoc.loan_year||'年<br>'||'調整後貸款期限'||frm_snrtdoc.change_loan_year||'年','') as non_loan_status,");
        sb.append(" 	   frm_snrtdoc.pay_amt,frm_snrtdoc.ag_flag ");
        sb.append(" from frm_exdef ");
        sb.append(" left join frm_loan_item on frm_exdef.loan_item = frm_loan_item.loan_item ");
        sb.append(" left join frm_exmaster on frm_exdef.ex_no=frm_exmaster.ex_no and frm_exdef.bank_no=frm_exmaster.bank_no ");
        sb.append(" left join frm_def_item on frm_exdef.def_type = frm_def_item.def_type and frm_exdef.def_case = frm_def_item.def_case ");
        sb.append(" left join frm_snrtdoc on frm_exdef.ex_no=frm_snrtdoc.ex_no and frm_exdef.bank_no=frm_snrtdoc.bank_no and frm_exdef.def_seq=frm_snrtdoc.def_seq ");
        sb.append(" left join (select * from bn01 where m_year=?)bn01 on frm_snrtdoc.bank_no=bn01.bank_no ");
        sb.append(" left join frm_exmaster on frm_snrtdoc.ex_no=frm_exmaster.ex_no ");
        sb.append(" where frm_snrtdoc.ex_no=? and frm_exmaster.bank_no=? and ag_rt_docno=? ");
        sb.append(" order by frm_exmaster.ex_type asc,frm_snrtdoc.ex_no asc,doc_date desc ,docno,def_seq ");
        paramList.add(u_year) ;
        paramList.add(ex_no) ;
		paramList.add(bank_no) ;
		paramList.add(ag_rt_docno) ;
		
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"pay_amt_sum,def_seq,loan_amt,pay_amt");
        return dbData;

    }
    
    //新增、異動資料
    private String updateDataToDB(HttpServletRequest request, String loginID, String loginName) {
      String actMsg = "";
      String errMsg = "";
      String ex_Type =  Utility.getTrimString(request.getParameter("ex_Type"));
      String ex_No =  Utility.getTrimString(request.getParameter("ex_No"));
      String bank_No =  Utility.getTrimString(request.getParameter("tbank"));
      String docNo = Utility.getTrimString(request.getParameter("docNo"));
      String ag_Rt_DocNo =  Utility.getTrimString(request.getParameter("ag_Rt_DocNo"));
      String ag_Rt_Doc_Date =  Utility.getTrimString(request.getParameter("ag_Rt_Doc_Date"));
      String pay_Date =  Utility.getTrimString(request.getParameter("pay_Date"));
      String pay_Amt_Sum =  Utility.getTrimString(request.getParameter("pay_Amt_Sum"));
      String case_Status =  Utility.getTrimString(request.getParameter("case_Status"));
      String def_Seq =  Utility.getTrimString(request.getParameter("def_Seq"));
      String pay_Amt =  Utility.getTrimString(request.getParameter("pay_Amt"));
      String ag_Flag =  Utility.getTrimString(request.getParameter("ag_Flag"));
      List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
      List updateDBSqlList = new ArrayList();
      List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
      StringBuffer sqlCmd=new StringBuffer();
      StringBuffer sqlCmd1=new StringBuffer();
  	  List paramList = new ArrayList() ; 
        try {
        	//依缺失個案明細中的缺失序號def_seq,更新多筆資料
        	//更新frm_snrtdoc
        	sqlCmd.append("update frm_SnRtDoc ");
        	sqlCmd.append("   set AG_Rt_DOCNO=?,AG_Rt_DOC_DATE=to_date(?,'YYYY/MM/DD'),");
        	sqlCmd.append("       PAY_DATE=to_date(?,'YYYY/MM/DD'),PAY_AMT=?,PAY_AMT_SUM=?,AG_FLAG=?,UPDATE_DATE=sysdate ");
        	sqlCmd.append(" where ex_no=? and bank_no=? and docno=? and def_seq=? ");
        	//補貼息計算檢核,更新frm_exdef
        	sqlCmd1.append("update frm_exdef ");
        	sqlCmd1.append("   set CASE_STATUS=?,UPDATE_DATE=sysdate ");
        	sqlCmd1.append(" where ex_no=? and bank_no=? and def_seq=? ");
        	
        	String[] seqSet = def_Seq.split(";");
        	String[] amtSet = pay_Amt.split(";");
			String[] flgSet = ag_Flag.split(";");
			for (int i=0;i<seqSet.length;i++) {
				String[] seqArr = seqSet[i].split(",");
				for (String seq:seqArr) {
					updateDBSqlList = new LinkedList();
					updateDBDataList = new LinkedList();
					paramList = new ArrayList();
		        	paramList.add(ag_Rt_DocNo);
					paramList.add(ag_Rt_Doc_Date);
					paramList.add(pay_Date);
					paramList.add(amtSet[i]);
					paramList.add(pay_Amt_Sum);
					paramList.add(flgSet[i]);
		        	paramList.add(ex_No);
					paramList.add(bank_No);
					paramList.add(docNo);
					paramList.add(seq);
					updateDBSqlList.add(sqlCmd.toString()) ;
					updateDBDataList.add(paramList) ;
					updateDBSqlList.add(updateDBDataList) ;
					updateDBList.add(updateDBSqlList) ;
					
					updateDBSqlList = new LinkedList();
					updateDBDataList = new LinkedList();
					paramList = new ArrayList();
					paramList.add(flgSet[i]);
					paramList.add(ex_No);
					paramList.add(bank_No);
					paramList.add(seq);
					updateDBSqlList.add(sqlCmd1.toString()) ;
					updateDBDataList.add(paramList) ;
					updateDBSqlList.add(updateDBDataList) ;
					updateDBList.add(updateDBSqlList) ;
				}
			}
			
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
        String docNo = Utility.getTrimString(request.getParameter("docNo"));
        String ex_Type = Utility.getTrimString(request.getParameter("ex_Type"));
        String def_Seq = Utility.getTrimString(request.getParameter("def_Seq"));
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
        StringBuffer sqlCmd = new StringBuffer() ;
        List paramList = new ArrayList() ;
	    try {
	    	//清空原農業金庫來文記錄
	    	sqlCmd.append("update frm_snrtdoc ");
	    	sqlCmd.append("   set ag_rt_docno = null,ag_rt_doc_date = null,pay_date = null,pay_amt=null,pay_amt_sum=null,ag_flag=null,update_date=sysdate ");
	    	sqlCmd.append(" where ex_no=? and bank_no=? and docno=? ");
	    	paramList.add(ex_No);
			paramList.add(bank_No);
			paramList.add(docNo);
		    updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
		    //依缺失個案明細中的缺失序號def_seq,更新多筆資料
		    sqlCmd.setLength(0);
		    sqlCmd.append("update frm_exdef ");
	    	sqlCmd.append("   set case_status ='1',update_date=sysdate ");
	    	sqlCmd.append(" where ex_no=? and bank_no=? and def_seq=?  ");
		    String[] tokens = def_Seq.split(",");
			for (String token:tokens) {
				updateDBSqlList = new LinkedList();
				updateDBDataList = new LinkedList();
				paramList = new ArrayList();
				paramList.add(ex_No);
				paramList.add(bank_No);
				paramList.add(token);
			    updateDBSqlList.add(sqlCmd.toString()) ;
			    updateDBDataList.add(paramList) ;
			    updateDBSqlList.add(updateDBDataList) ;
			    updateDBList.add(updateDBSqlList) ;
			}
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
