<%
//105.10.19 create by 2968
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
	
	System.out.println("Page: FL006W.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );
		

    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
           rd = application.getRequestDispatcher( LoginErrorPgName );
    } else {
    	if(act.equals("List") ||act.equals("RtnList") ||  act.equals("New") || act.equals("Edit")) {    	    
    		request.setAttribute("TBank", getTatolBankType());           
    	    request.setAttribute("City", Utility.getCity());
    	    if(act.equals("Edit") || act.equals("New")) {
    			request.setAttribute("ItemList",this.getItemList());
    	        if(act.equals("New")) {
    	            rd = application.getRequestDispatcher( EditPgName +"?act=New");
    	        }else{
    	            String bank_no = request.getParameter("bank_No") != null ? request.getParameter("bank_No") : "";
    	            String ex_no = request.getParameter("ex_No") != null ? request.getParameter("ex_No") : "";
    	            String bank_Rt_DocNo = request.getParameter("bank_Rt_DocNo") != null ? request.getParameter("bank_Rt_DocNo") : "";
    	            request.setAttribute("bank_No",bank_no);
    	            request.setAttribute("ex_No",ex_no);
    	            request.setAttribute("bank_Rt_DocNo",bank_Rt_DocNo);
    	            request.setAttribute("EditInfo",this.getEditInfo(bank_no,ex_no,bank_Rt_DocNo));    	               	           
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit");
    	        }
    	    } else if(act.equals("List")||act.equals("RtnList")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName +"?act=List");
    	    }
        } else if(act.equals("Insert")||act.equals("Update")){
        	String bank_no = Utility.getTrimString(request.getParameter("tbank")) ;  
	        String ex_type = Utility.getTrimString(request.getParameter("ex_Type")) ;
	        String ex_no = Utility.getTrimString(request.getParameter("ex_No")) ;
	        String docno = Utility.getTrimString(request.getParameter("docNo")) ;
            actMsg = updateDataToDB(request,userId,userName);
            rd = application.getRequestDispatcher( nextPgName+"?goPages=FL006W.jsp&act=List&bank_No="+bank_no+"&ex_No="+ex_no+"&docNo="+docno);
        } else if(act.equals("Delete")){
        	String bank_no = Utility.getTrimString(request.getParameter("tbank")) ;  
	        String ex_type = Utility.getTrimString(request.getParameter("ex_Type")) ;
	        String ex_no = Utility.getTrimString(request.getParameter("ex_No")) ;
	        String docno = Utility.getTrimString(request.getParameter("docNo")) ;
    	    actMsg = deleteDataToDB(request);
    	    rd = application.getRequestDispatcher( nextPgName +"?goPages=FL006W.jsp&act=List&bank_No="+bank_no+"&ex_Type"+ex_type+"&ex_No="+ex_no+"&docNo="+docno);
        }        
    	request.setAttribute("actMsg",actMsg);
      }
    
	

%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "FL006W" ;
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
    //對應的查核報告編號及辦理依據
  	private List getItemList(){
  		StringBuffer sql = new StringBuffer() ;
  		List paramList = new ArrayList() ;
  		sql.append(" select frm_exmaster.bank_no,ex_type,frm_exmaster.ex_no,");
  		sql.append(" 		decode(ex_type,'FEB',frm_exmaster.ex_no,'AGRI',substr(frm_exmaster.ex_no,0,3)||'年第'||substr(frm_exmaster.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_exmaster.ex_no,'yyyymmdd')),'') as ex_no_list,");
  		sql.append("        decode(doc_date,null,'','','',F_TRANSCHINESEDATE(doc_date)) as doc_date,docno,audit_id_c1,fine_amt ");
  		sql.append(" from frm_exmaster ");
  		sql.append(" left join frm_snrtdoc on frm_exmaster.ex_no=frm_snrtdoc.ex_no ");
  		sql.append(" where frm_exmaster.case_status != '0' ");//--未結案
  		sql.append(" group by frm_exmaster.bank_no, ex_type,frm_exmaster.ex_no, fine_amt,doc_date,docno,audit_id_c1 ");
  		sql.append(" order by bank_no, ex_type ,ex_no,doc_date,docno ");
  	    List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,"fine_amt");
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
        String bank_Rt_DocNo = Utility.getTrimString(request.getParameter("bank_Rt_DocNo")) ;
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
    	request.setAttribute("bank_Rt_DocNo",bank_Rt_DocNo);
    	//查詢條件 
    	StringBuffer sb=new StringBuffer();
    	List paramList = new ArrayList() ;
    	sb.append(" select frm_snrtdoc.bank_no,bank_name,frm_snrtdoc.ex_no,decode(ex_type,'FEB',frm_snrtdoc.ex_no,'AGRI',substr(frm_snrtdoc.ex_no,0,3)||'年第'||substr(frm_snrtdoc.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_snrtdoc.ex_no,'yyyymmdd')),'') as ex_no_list,");
    	sb.append("        F_TRANSCHINESEDATE(bank_rt_doc_date) as bank_rt_doc_date,bank_rt_docno,decode(doc_date,null,'','','',F_TRANSCHINESEDATE(doc_date)) doc_date,docno,frm_exmaster.ex_type ");
    	sb.append(" from frm_snrtdoc ");
    	sb.append(" left join (select * from bn01 where m_year=?)bn01 on frm_snrtdoc.bank_no=bn01.bank_no ");
    	sb.append(" left join frm_exmaster on frm_snrtdoc.ex_no=frm_exmaster.ex_no ");
    	paramList.add(u_year) ;
		sb.append(" where  bank_rt_docno is not null and ex_type=? ");
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
			sb.append("and TO_CHAR(bank_rt_doc_date,'yyyymmdd') BETWEEN ? AND ? ");
			paramList.add(String.valueOf(Integer.parseInt(docBegDate)+19110000)) ;
			paramList.add(String.valueOf(Integer.parseInt(docEndDate)+19110000)) ;
		}
		if(!"".equals(bank_Rt_DocNo)){
			sb.append(" and bank_rt_docno like ? ");
			paramList.add(bank_Rt_DocNo+"%") ;
		}
		sb.append(" group by "); 
		sb.append(" frm_snrtdoc.bank_no,bank_name,frm_snrtdoc.ex_no,decode(ex_type,'FEB',frm_snrtdoc.ex_no,'AGRI',substr(frm_snrtdoc.ex_no,0,3)||'年第'||substr(frm_snrtdoc.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_snrtdoc.ex_no,'yyyymmdd')),'') ");
		sb.append(" ,bank_rt_doc_date,bank_rt_docno,doc_date,docno,ex_type ");
		sb.append(" order by bank_no asc,ex_no asc,doc_date desc,bank_rt_doc_date desc ");
		
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"");
        System.out.println("getQueryResult.size="+dbData.size());
        return dbData;
    }

    private List getDetailResult(HttpServletRequest request,String ex_kind,String bank_no,String ex_no,String docno){
    	//查詢條件 
    	StringBuffer sb=new StringBuffer();
    	List paramList = new ArrayList() ;
    	sb.append(" select distinct frm_snrtdoc.ex_no,frm_snrtdoc.bank_no,frm_snrtdoc.def_seq,docno,loan_name,to_char(loan_date,'YYYY/MM/DD')loan_date,");
    	sb.append("        frm_exdef.loan_item,loan_item_name,loan_amt,audit_case,frm_exdef.def_type,frm_exdef.def_case,case_name ");
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
		if("C".equals(ex_kind)){
			sb.append("and ex_kind ='C' ");//個案查核
		}else{
			sb.append("and ex_kind !='C' ");//整体性查核
		}
		sb.append(" order by def_seq ");
		
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"ex_no,bank_no,def_seq,docno,loan_name,loan_date,loan_item,"+
        								"loan_item_name,loan_amt,audit_case,def_type,def_case,case_name");
        System.out.println("getDetailResult.size="+dbData.size());
        return dbData;
    }
    
    // 取得單筆資料
    private List getEditInfo(String bank_no,String ex_no,String bank_rt_docno){ 
        DataObject ob = null;
        StringBuffer sb=new StringBuffer();
        List paramList = new ArrayList() ;
        String u_year = "99" ;
        if(Integer.parseInt(Utility.getYear()) > 99 ){
    		u_year = "100" ;
    	}
        sb.append(" select ex_type,decode(ex_type,'FEB','金管會檢查報告','AGRI','農業金庫查核','BOAF','農金局訪查','') as ex_type_name,bn01.bank_type,frm_snrtdoc.bank_no,bank_name,");
        sb.append(" 	   frm_snrtdoc.ex_no,decode(ex_type,'FEB',frm_snrtdoc.ex_no,'AGRI',substr(frm_snrtdoc.ex_no,0,3)||'年第'||substr(frm_snrtdoc.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_snrtdoc.ex_no,'yyyymmdd')),'') as ex_no_list,");
        sb.append(" 	   to_char(bank_rt_doc_date,'yyyymmdd')bank_rt_doc_date,bank_rt_docno,F_TRANSCHINESEDATE (doc_date) as doc_date,docno,audit_id_c1,fine_amt,to_char(fine_date,'yyyymmdd') fine_date,fine_PayAmt ");
        sb.append(" from frm_snrtdoc ");  
        sb.append(" left join (select * from bn01 where m_year=?)bn01 on frm_snrtdoc.bank_no=bn01.bank_no ");
        sb.append(" left join frm_exmaster on frm_snrtdoc.ex_no=frm_exmaster.ex_no  and frm_snrtdoc.bank_no = frm_exmaster.bank_no ");
        sb.append(" where frm_snrtdoc.ex_no=? and frm_exmaster.bank_no=? and bank_rt_docno =? ");
        paramList.add(u_year) ;
        paramList.add(ex_no) ;
		paramList.add(bank_no) ;
		paramList.add(bank_rt_docno) ;
		sb.append(" group by ex_type,decode(ex_type,'FEB','金管會檢查報告','AGRI','農業金庫查核','BOAF','農金局訪查',''),bn01.bank_type,frm_snrtdoc.bank_no,bank_name,frm_snrtdoc.ex_no,decode(ex_type,'FEB',frm_snrtdoc.ex_no,'AGRI',substr(frm_snrtdoc.ex_no,0,3)||'年第'||substr(frm_snrtdoc.ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(frm_snrtdoc.ex_no,'yyyymmdd')),''), ");
		sb.append("          bank_rt_doc_date,bank_rt_docno,doc_date,docno,audit_id_c1,fine_amt,fine_date,fine_PayAmt ");
        sb.append(" order by bank_no asc,ex_no asc,doc_date desc,bank_rt_doc_date desc ");
		
        List dbData = DBManager.QueryDB_SQLParam(sb.toString(),paramList,"audit_id_c1,fine_amt,fine_PayAmt");
        return dbData;

    }
    
    //新增、異動資料
    private String updateDataToDB(HttpServletRequest request, String loginID, String loginName) {
      String actMsg = "";
      String errMsg = "";
      String ex_No =  Utility.getTrimString(request.getParameter("ex_No"));
      String bank_No =  Utility.getTrimString(request.getParameter("tbank"));
      String docNo = Utility.getTrimString(request.getParameter("docNo"));
      String bank_Rt_DocNo =  Utility.getTrimString(request.getParameter("bank_Rt_DocNo"));
      String bank_Rt_Doc_Date =  Utility.getTrimString(request.getParameter("bank_Rt_Doc_Date"));
      String fine_Date =  Utility.getTrimString(request.getParameter("fine_Date"));
      String fine_PayAmt =  Utility.getTrimString(request.getParameter("fine_PayAmt"));
      
      List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
      List updateDBSqlList = new ArrayList();
      List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
        
        try {
        	StringBuffer sqlCmd=new StringBuffer();
        	List paramList = new ArrayList() ;
        	sqlCmd.append("update frm_SnRtDoc");
        	sqlCmd.append("   set BANK_Rt_DOCNO=?,BANK_Rt_DOC_DATE=to_date(?,'YYYY/MM/DD'), ");
        	sqlCmd.append("       FINE_DATE=to_date(?,'YYYY/MM/DD'),FINE_PAYAMT=?,UPDATE_DATE=sysdate ");
        	sqlCmd.append(" where ex_no=? and bank_no=? and docno=? ");
        	paramList.add(bank_Rt_DocNo);
			paramList.add(bank_Rt_Doc_Date);
			paramList.add(fine_Date);
			paramList.add(fine_PayAmt);
        	paramList.add(ex_No);
			paramList.add(bank_No);
			paramList.add(docNo);
			
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
	    String actMsg = "";
        String errMsg = "";        
        String ex_No =  Utility.getTrimString(request.getParameter("ex_No"));
        String bank_No =  Utility.getTrimString(request.getParameter("bank_No"));
        String docNo = Utility.getTrimString(request.getParameter("docNo"));
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
        StringBuffer sqlCmd = new StringBuffer() ;
        List paramList = new ArrayList() ;
	    try {
	    	//清空原農漁會回文記錄
	    	sqlCmd.append("update frm_snrtdoc ");
	    	sqlCmd.append("   set bank_rt_docno = null,bank_rt_doc_date = null,fine_date = null,fine_payamt=null,update_date=sysdate ");
	    	sqlCmd.append(" where ex_no=? and bank_no=? and docno=? ");
	    	paramList.add(ex_No);
			paramList.add(bank_No);
			paramList.add(docNo);
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
