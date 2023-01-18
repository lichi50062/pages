<%
/* 94.1.26 createed

   檢查缺失處理系統 - 缺失改善情形登錄及查詢 主控制頁面
   99.06.01 fix 套用Header.include & sql injection by 2808
   101.07.13 add 追蹤歷程紀錄查詢log by 2968 
   101.09.21 add 修改(長度超過2000時,轉base64,分割長度寫入DB)/查詢(若有多筆時,合併後解base64顯示) by 2295
   103.01.02 fix 有多筆資料時,第1筆以後,無法顯示 by 2295
   104.06.03 fix 處理UTF-8編號後,超過2000時,資料顯示亂碼及寫入資料為亂碼問題 by 2295
   109.05.15 fix 若機構代碼在系統查無對應的機構名稱時A111111111可修改檢查報告的機構代碼及機構類別 by 2295
   111.06.10 add 新增檢查報告編號 by 2295 
   111.08.11 調整新增/修改/刪除檢查意見後,回上一頁為回檢查意見清單頁 by 2295
 */
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="com.tradevan.base64.*" %> 
<%@include file="./include/Header.include" %>
<%
    String pgId = "TC33";
	String userId = session.getAttribute("muser_id") != null ? (String) session.getAttribute("muser_id") : "" ;
	String userName = session.getAttribute("muser_name") != null ? (String) session.getAttribute("muser_name") : "" ;
	System.out.println("Page: TC33.jsp    Action:"+act+"    LoginID:"+userId+"    UserName:"+userName );
	String begY = Utility.getTrimString(dataMap.get("begY")) ;
	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
            rd = application.getRequestDispatcher( LoginErrorPgName );
    } else {
	    
    	if(act.equals("List") || act.equals("Qry") || act.equals("Edit") ||  act.equals("New") || act.equals("NewReportNo") || act.equals("Qry2")) {
    		 System.out.println("test1090515-1");
    	    request.setAttribute("Bank_Type", getCDShareNOWith(BANK_TYPE));
            request.setAttribute("TBank", getTatolBankType());
            request.setAttribute("Bank_No",getBankNo());
    	    request.setAttribute("City",Utility.getCity());
    	    request.setAttribute("chTypeList",getCDShareNOWith(CH_TYPE));//111.06.09 add 
    	    if(act.equals("List")) {
    	        rd = application.getRequestDispatcher( ListPgName1 +"?act=List");
		    } else if(act.equals("NewReportNo")) {
		    	rd = application.getRequestDispatcher( EditNewPgName +"?act=NewReportNo");
    	    } else if(act.equals("Edit") || act.equals("New")) {
    	        String reportno = request.getParameter("reportno") != null ? request.getParameter("reportno") : "";
    	        String reportno_seq = request.getParameter("reportno_seq") != null ? request.getParameter("reportno_seq") : "";
    	        String item_no = request.getParameter("item_no") != null ? request.getParameter("item_no") : "";
    	        request.setAttribute("actNo",getExActNOData());
    	        request.setAttribute("exFault",getExFaultData());
    	        request.setAttribute("auditList",getCDShareNOWith(AUDIT_RESULT));
    	        request.setAttribute("exFaultda",getExFaultdaData());
    	        request.setAttribute("item_no",item_no);
    	        request.setAttribute("reportno",reportno);
    	        request.setAttribute("reportno_seq",reportno_seq);
    	        if(act.equals("New")) {
    	            reportno_seq = request.getParameter("reportno_seq") != null ? request.getParameter("reportno_seq") : "";
    	            rd = application.getRequestDispatcher( EditPgName +"?act=New");
    	        }else{
    	            reportno_seq = request.getParameter("reportno_seq") != null ? request.getParameter("reportno_seq") : "";    	            
    	            request.setAttribute("DETAIL",getDetail(reportno,reportno_seq));    	           
    	            request.setAttribute("RTDATA", getFirstRtData(reportno));
    	            rd = application.getRequestDispatcher( EditPgName +"?act=Edit");
    	            actMsg = Utility.insertDataToLog(request, userId, pgId);
    	        }
    	        
    	        
    	        
    	    } else if(act.equals("Qry")) {
    	        request.setAttribute("QueryResult",getQueryResult(request));
    	        rd = application.getRequestDispatcher( ListPgName1 +"?act=Qry");
    	    } else if(act.equals("Qry2")) {    	    	
    	        String reportno = request.getParameter("reportno") != null ? request.getParameter("reportno") : "";
    	        String flag = request.getParameter("flag") != null ? request.getParameter("flag") : "";
    	        System.out.println("Qry2="+reportno+":flag="+flag);
    	        request.setAttribute("flag",flag);
    	        if("1".equals(flag)){
    	            actMsg = Utility.insertDataToLog(request, userId, pgId);
    	        	flag = "0";
    	        }
    	        request.setAttribute("HEAD",getQueryList(reportno,"100"));
    	        request.setAttribute("BODY",getExDefGoodFData(reportno));
    	        rd = application.getRequestDispatcher( ListPgName2 +"?act=Qry2");
    	    }
        } else if(act.equals("Insert")){        	
    	    actMsg = insertDataToDB(request,userId,userName);
    	    String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
    	    /*111.08.10 fix
    	    String reportno_seq = request.getParameter("reportno_seq" )== null  ? "" : (String)request.getParameter("reportno_seq");
    	    request.setAttribute("reportno_seq",reportno_seq);
    	    request.setAttribute("actMsg",actMsg);
    	    request.setAttribute("actNo",getExActNOData());
    	    request.setAttribute("exFault",getExFaultData());
    	    request.setAttribute("exFaultda",getExFaultdaData());
        	rd = application.getRequestDispatcher( EditPgName +"?act=New" );
        	*/
        	//111.08.11 調整新增檢查意見後,回上一頁,回檢查意見清單頁 
        	request.setAttribute("prePageURL","TC33.jsp?act=Qry2&reportno="+reportno);
        	rd = application.getRequestDispatcher( nextPgName );    	    
        } else if(act.equals("Update")){        	
        	actMsg = Utility.insertDataToLog(request, userId, pgId);
            actMsg = updateDataToDB(request,userId,userName);
            String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
            String item_no = request.getParameter("item_no" )== null  ? "" : (String)request.getParameter("item_no");
            String reportno_seq = request.getParameter("reportno_seq" )== null  ? "" : (String)request.getParameter("reportno_seq");            
            //111.08.11 調整修改檢查意見後,回上一頁,回檢查意見清單頁 
            System.out.println("Update.reportno="+reportno);        	
            request.setAttribute("prePageURL","TC33.jsp?act=Qry2&reportno="+reportno);
        	rd = application.getRequestDispatcher( nextPgName );
        } else if(act.equals("Delete")){        	
            actMsg = Utility.insertDataToLog(request, userId, pgId);
    	    actMsg = deleteDataToDB(request,userId,userName);
    	    String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
            String item_no = request.getParameter("item_no" )== null  ? "" : (String)request.getParameter("item_no");
            String reportno_seq = request.getParameter("reportno_seq" )== null  ? "" : (String)request.getParameter("reportno_seq");
            if(actMsg.equals("")) {
              actMsg = "相關資料已刪除";
              //111.08.10 調整刪除檢查意見後,回上一頁,回檢查意見清單頁 
               System.out.println("Delete.reportno="+reportno);
        	   request.setAttribute("prePageURL","TC33.jsp?act=Qry2&reportno="+reportno);
            }
        	rd = application.getRequestDispatcher( nextPgName );
        } else if(act.equals("updbankno")){//109.05.15 add 更改檢查報告機構代碼
        	System.out.println("updbankno begin");
            actMsg = updateBankNo(request,userId,userName);
            System.out.println("updbankno end"); 
            if(actMsg.equals("")) {
              actMsg = "機構代碼已更新";
              request.setAttribute("prePageURL","TC33.jsp?act=List");
            }
        	rd = application.getRequestDispatcher( nextPgName );
        } else if(act.equals("InsertNew")){//111.06.09 add 新增檢查報告
        	System.out.println("insertnew begin");
            actMsg = insertReportNo(request,userId,userName);
            System.out.println("insertnew end"); 
            if(actMsg.equals("")) {
              actMsg = "檢查報告已新增";              
              request.setAttribute("prePageURL","TC33.jsp?act=List");
            }
        	rd = application.getRequestDispatcher( nextPgName );	
        }
        request.setAttribute("queryURL","TC33.jsp?act=List");
    	request.setAttribute("actMsg",actMsg);
      }

%>
<%@include file="./include/Tail.include" %>
<%!
private final static String report_no = "TC33" ;
private final static String nextPgName = "/pages/message.jsp";
private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
private final static String EditNewPgName = "/pages/"+report_no+"_EditNew.jsp";//111.06.09 add
private final static String ListPgName1 = "/pages/"+report_no+"_List1.jsp";
private final static String ListPgName2 = "/pages/"+report_no+"_List2.jsp";
private final static String LoginErrorPgName = "/pages/LoginError.jsp";

private final static String BANK_TYPE = "020"; //金融機構代碼
private final static String EXAM_DIV = "022";  //檢查評等
private final static String CH_TYPE = "023"; //檢查性質
private final static String ORIGINUNT_ID = "024";   //檢查報告單位
private final static String DOCTYPE = "025";   //公文類別
private final static String AUDIT_RESULT = "026";   //審核結果


    //取得所有總機構資料
    private List getTatolBankType(){
    	List paramList = new ArrayList () ;
    	//查詢條件
		//fix 增加縣市合併判斷用m_year by 2808
		StringBuffer sql = new StringBuffer() ;
		sql.append(" select bn01.bn_type,HSIEN_id, BN01.BANK_NO , BANK_NAME, BANK_TYPE,bn01.m_year  ");
		sql.append(" from  BN01, WLX01 ");
		sql.append(" where BN01.BANK_NO = WLX01.BANK_NO(+) ");
		sql.append(" and wlx01.m_year = bn01.m_year ");    	
		//111.06.09 add 增加共用中心	
		sql.append(" union ");
		sql.append(" select bn01.bn_type,'',bank_no,bank_name,bank_type,m_year ");
		sql.append(" from bn01 ");
		sql.append(" where bank_type=? ");
		sql.append(" order by BANK_NO  "); 
		paramList.add("8") ; 
	    List dbData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"m_year");
	    return dbData;
    }



//取得所有受檢單位資料
private List getBankNo(){
	//查詢條件
	StringBuffer sqlCmd = new StringBuffer() ;
	List paramList = new ArrayList () ;
	sqlCmd.append( " Select BANK_NO , BANK_NAME , TBANK_NO  from  BN02 WHERE bank_type in ( select cmuse_id from cdshareno where cmuse_div =? )  order by BANK_NO ");
	paramList.add("020") ;
	
    List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");            
    return dbData;
}

    //取得CDShareNO, 欄位cmuse_div為id的所有內容
    private List getCDShareNOWith(String id){
    	//查詢條件    
		StringBuffer sqlCmd = new StringBuffer() ;
		List paramList = new ArrayList () ;
		sqlCmd.append( " select cmuse_id, cmuse_name from cdshareno where cmuse_div = ? order by cmuse_id " );  
		paramList.add(id) ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");            
        return dbData;
    }
	
	
    //取得查詢資料
    private List getQueryResult(HttpServletRequest request){
        String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
        String ex_content = request.getParameter("ex_content" )== null  ? "" : (String)request.getParameter("ex_content");
        String begDate = request.getParameter("begDate" )== null  ? "" : (String)request.getParameter("begDate");
        String endDate = request.getParameter("endDate" )== null  ? "" : (String)request.getParameter("endDate");
        String bankType = request.getParameter("bankType" )== null    ? "" : (String)request.getParameter("bankType");
        String tbank_no = request.getParameter("tbank" )== null    ? "" : (String)request.getParameter("tbank");
        String examine = request.getParameter("examine" )== null  ? "" : (String)request.getParameter("examine");
        String cityType = request.getParameter("cityType" )== null  ? "" : (String)request.getParameter("cityType");
        String u_year = "99" ;
    	if(!"".equals(begDate) && Integer.parseInt(begDate.substring(0,4))>2010 ) {
    		u_year = "100" ;
    	}
    	if(bankType.equals("0")) {
    	    bankType = "";
    	}
        request.setAttribute("cityType",cityType);
        request.setAttribute("reportno",reportno);
    	request.setAttribute("ex_content",ex_content);
    	request.setAttribute("bankType",bankType);
    	request.setAttribute("examine",examine);
    	request.setAttribute("begDate",begDate);
    	request.setAttribute("endDate",endDate);


    	//查詢條件
    	StringBuffer sqlCmd = new StringBuffer() ;
    	List paramList = new ArrayList() ;
    	/*111.06.10 fix
    	sqlCmd.append( "SELECT distinct b.bank_no, c.bank_name, b.reportno, ((TO_CHAR(b.base_date,'yyyy')-1911)||'/'|| TO_CHAR(b.base_date,'mm/dd'))  base_date, d.cmuse_name as ch_type "+
    		    " FROM ExDefGoodF a, ExReportF b  "+
    		    " left join  (select * from ba01 where m_year=? ) c on b.bank_no=c.bank_no, CDShareNO d " + //109.05.14 fix
    		    " WHERE a.reportno = b.reportno AND (b.ch_type = d.cmuse_id AND cmuse_div = ?) " +
    		    " AND TO_CHAR(b.base_date, 'yyyymmdd') BETWEEN ? AND ? " );
    	*/
    	sqlCmd.append( "SELECT distinct b.bank_no, c.bank_name, b.reportno, ((TO_CHAR(b.base_date,'yyyy')-1911)||'/'|| TO_CHAR(b.base_date,'mm/dd'))  base_date, d.cmuse_name as ch_type "+
    		    " FROM ExReportF b  "+//111.06.10 fix
    		    " left join  (select * from ba01 where m_year=? ) c on b.bank_no=c.bank_no, CDShareNO d " + //109.05.14 fix
    		    " WHERE (b.ch_type = d.cmuse_id AND cmuse_div = ?) " +
    		    " AND TO_CHAR(b.base_date, 'yyyymmdd') BETWEEN ? AND ? " );
    		    
		paramList.add(u_year) ;
		paramList.add("023");
		paramList.add(begDate) ;
		paramList.add(endDate) ;
		
    	if(!reportno.equals("")) {
    	    sqlCmd.append( "  AND b.reportno = ? " );
    	    paramList.add(reportno) ;
    	}
    	if(!ex_content.equals("")) {
    	    sqlCmd.append( "  AND a.ex_content like ? " );
    	    paramList.add("%"+ex_content+"%") ;
    	}
        if(!bankType.equals("") && !bankType.equals("0")) {
    	    sqlCmd.append( "  AND b.bank_type = ? " );
    	    paramList.add(bankType) ;
    	}
    	if(!tbank_no.equals("")) {
    	    sqlCmd.append( "  AND b.tbank_no = ? " );
    	    paramList.add(tbank_no ) ;
    	}
    	if(!examine.equals("")) {
    	    sqlCmd.append( "  AND b.bank_no = ? " );
    	    paramList.add(examine) ;
    	}
    	if(!cityType.equals("")) {
    		   sqlCmd.append( " and TBANK_NO in (select BANK_NO  from WLX01  where HSIEN_ID =  ?  and m_year= ? ) " );
    		   paramList.add(cityType) ;
    		   paramList.add(u_year) ;
    	}
    	sqlCmd.append( " ORDER BY b.bank_no, b.reportno" );

        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
        System.out.println("dbData= "+dbData.size());
        return dbData;
    }

    // 取得查詢資料列表
    private DataObject getQueryList(String reportno,String begY) {
        DataObject ob = null;
        String u_year = "99" ;
        if(!"".equals(begY) && Integer.parseInt(begY) > 99) {
        	u_year = "100" ;
        }
        StringBuffer sqlCmd = new StringBuffer() ;
        List paramList = new ArrayList() ;
        
        sqlCmd.append( " SELECT distinct  b.reportno, b.bank_no, c.bank_name, ((TO_CHAR(b.base_date,'yyyy')-1911)||'/'|| TO_CHAR(b.base_date,'mm/dd'))  base_date, ");
        sqlCmd.append(" d.cmuse_name as ch_type ");
        sqlCmd.append(" FROM ExDefGoodF a, ExReportF b, (select * from ba01 where m_year=?) c, CDShareNO d ");
        sqlCmd.append(" WHERE b.reportno = ? AND a.reportno(+) = b.reportno AND b.bank_no = c.bank_no AND (b.ch_type = d.cmuse_id AND d.cmuse_div =?)" );
        paramList.add(u_year) ;
        paramList.add(reportno) ;
        paramList.add("023") ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
        if(dbData.size() > 0) {
            ob = (DataObject)dbData.get(0);
        }
        return ob;
    }

    // 取得單筆資料
    //101.09.21 fix 有多筆時,合成一筆,並做解base64 by 2295
    private DataObject getDetail(String reportno, String reportno_seq) {
        DataObject ob = null;
        StringBuffer sqlCmd = new StringBuffer() ;
        List paramList = new ArrayList(); 
        sqlCmd.append( " SELECT a.reportno, a.reportno_seq, a.item_no,a.serial, a.ex_content, a.commentt, substr(a.fault_id,1,1) faultda_id ,");
        sqlCmd.append(" a.fault_id, a.audit_oppinion, a.act_id,  a.audit_result, b.digest, b.rt_docno,");
        sqlCmd.append(" TO_CHAR(b.rt_date,'yyyy') as rt_dateY, TO_CHAR(b.rt_date,'mm') as rt_dateM, TO_CHAR(b.rt_date,'dd') as rt_dateD,");
        sqlCmd.append(" TO_CHAR(b.rt_date,'yyyymmdd') as rt_date   ");
        sqlCmd.append(" from exdefgoodF a, ExDG_HistoryF b ");
        sqlCmd.append(" WHERE a.reportno = b.reportno AND a.reportno_seq = b.reportno_seq AND a.reportno = ? and a.reportno_seq =? " );
        paramList.add(reportno) ;
        paramList.add(reportno_seq) ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"reportno_seq,serial");
        if(dbData.size() > 1) {
           String strSource = "";
    	   System.out.println("dbData.size()="+dbData.size());
    	   //101.09.21 fix 有多筆時,合成一筆,並做解base64=========================================
    	   for(int i=0;i<dbData.size();i++){
    	   	   ob = (DataObject)dbData.get(i);	
    	       strSource += (ob.getValue("ex_content") != null ? (String)ob.getValue("ex_content") : "");
    	   }//end of dbData
    	   System.out.println("strSource="+strSource);
    	   try{    	   
    	   String data = new String(Base64.decode(strSource.getBytes("UTF-8")),"UTF-8");//104.06.03 fix  
    	   System.out.println("ex_content="+data);    	   
    	   ob.setValue("ex_content", data);
    	   }catch(Exception e){System.out.println("TC33.getDetail Error:"+e+e.getMessage());}
        }else{
        	ob = (DataObject)dbData.get(0);	
        }	
        return ob;
    }

    //  取得前一筆
    private DataObject getFirstRtData(String reportno) {
        DataObject ob = null;
        StringBuffer sqlCmd  = new StringBuffer() ;
        List paramList = new ArrayList() ;
        sqlCmd.append(" SELECT rt_docno, TO_CHAR(rt_date,'yyyy') as rt_dateY, TO_CHAR(rt_date,'mm') as rt_dateM, TO_CHAR(rt_date,'dd') as rt_dateD, TO_CHAR(rt_date,'yyyymmdd') as rt_date   ");
        sqlCmd.append(" from ExDG_HistoryF where reportno = ? and rt_date is not null order by  UPDATE_DATE DESC " );
        paramList.add(reportno) ;
        
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
        if(dbData.size() > 0) {        	
            ob = (DataObject)dbData.get(0);
        }
        return ob;
    }

    // 取得缺失改善查詢資料
    //101.09.21 fix 有多筆時,合成一筆,並做解base64 by 2295
    private List getExDefGoodFData(String reportno) {
    	StringBuffer sqlCmd = new StringBuffer() ;
    	List paramList = new ArrayList() ;
        sqlCmd.append(" SELECT distinct a.reportno_seq, a.item_no, a.serial, a.ex_content, e.digest, a.commentt,");
        sqlCmd.append(" (select cmuse_name from CDShareNo WHERE a.audit_result = cmuse_id AND cmuse_div =? )  cmuse_name ");
        sqlCmd.append(" from exdefgoodF a, CDShareNo d, ExDG_HistoryF e WHERE a.reportno = e.reportno and a.reportno_seq = e.reportno_seq(+) ");
        sqlCmd.append(" and a.reportno =?  ORDER BY a.item_no" );
        paramList.add("026") ;
        paramList.add(reportno) ;
        
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"reportno_seq,cmuse_name,item_no");
        List trans_dbData = new LinkedList();
        sqlCmd.delete(0,sqlCmd.length());
        DataObject bean_dbData = null;
        DataObject bean_dbData1 = null;
        DataObject bean_trans_dbData = null;
        boolean haveAdd=false;
        for(int i=0;i<dbData.size();i++){
        	bean_dbData = (DataObject) dbData.get(i);
    	    sqlCmd.delete(0,sqlCmd.length());
    	    paramList = new ArrayList() ;
    	    sqlCmd.append(" select ex_content from exdefgoodf where reportno=? and reportno_seq=? order by serial");
    	    System.out.println("reportno_seq="+bean_dbData.getValue("reportno_seq"));
    	    paramList.add(reportno);
    	    paramList.add(bean_dbData.getValue("reportno_seq"));
    	    List dbData1 = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"ex_content");
    	    String strSource = "";
    	    System.out.println("dbData1.size()="+dbData1.size());
    	    //101.09.21 fix 有多筆時,合成一筆,並做解base64=========================================
    	    if(dbData1.size() > 1){
    	    	haveAdd=false;//103.01.02 fix 
    	    	for(int j=0;j<dbData1.size();j++){
    	    	   bean_dbData1 = (DataObject) dbData1.get(j);
    	           strSource += (bean_dbData1.getValue("ex_content") != null ? bean_dbData1.getValue("ex_content") : "");
    	        }//end of dbData1
    	        try{
    	        String data = new String(Base64.decode(strSource.getBytes("UTF-8")),"UTF-8");//104.06.03 fix    	      
    	        for(int k=0;k<trans_dbData.size();k++){
    	    	   bean_trans_dbData = (DataObject) trans_dbData.get(k);
    	    	   if(((bean_dbData.getValue("reportno_seq")).toString()).equals((bean_trans_dbData.getValue("reportno_seq")).toString())){    	    	   
    	    	   	haveAdd = true;
    	    	   }	
    	    	}
    	    	//System.out.println("haveAdd="+haveAdd);
    	    	if(!haveAdd){    	    		
    	            bean_dbData.setValue("ex_content", data);
    	            trans_dbData.add(bean_dbData);
    	        }	  
    	        }catch(Exception e){System.out.println("TC33.getExDefGoodFData Error:"+e+e.getMessage());}  	        	
    	    }else{ 	
    	       trans_dbData.add(bean_dbData);
    	    }
    	    
    	}	
        return trans_dbData;
    }

    // 取得檢查意見代號
    private List getExFaultData() {
        String sqlCmd = " SELECT substr(fault_id,1,1) fault_type, fault_id, fault_name FROM ExFaultF order by fault_id ";
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"");
        return dbData;
    }

    private List getExFaultdaData() {
        String sqlCmd = " SELECT faultda_id, faultda_name FROM exfault_daf order by output_order ";
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"");
        return dbData;
    }

    // 取得處理代號
    private List getExActNOData() {
        String sqlCmd = " SELECT act_id, act_name FROM ExActNOF order by act_id ";
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"");
        return dbData;
    }

    // 取得Report NO的資料
    private DataObject getReportDataObject(String sn_docno) {
        DataObject ob = null;
        StringBuffer sqlCmd = new StringBuffer() ;
        List paramList = new ArrayList () ;
        sqlCmd.append( "SELECT reportno, TO_CHAR(sn_date, 'yyyymmdd') as sn_date FROM ExSnDocF WHERE sn_docno = ? " );
        paramList.add(sn_docno) ;
        List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
        if(dbData.size() > 0) {
            ob = (DataObject)dbData.get(0);
        }
        return ob;
    }

    // 新增資料到資料庫
    private String insertDataToDB(HttpServletRequest request, String loginID, String loginName) {
        String actMsg = "";
        String errMsg = "";
        String sn_docno = request.getParameter("sn_docno" )== null  ? "" : (String)request.getParameter("sn_docno");
        String rt_docno = request.getParameter("rt_docno" )== null  ? "" : (String)request.getParameter("rt_docno");
        String item_no = request.getParameter("item_no" )== null  ? "" : (String)request.getParameter("item_no");
        String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
        String reportno_req = request.getParameter("reportno_req" )== null  ? "" : (String)request.getParameter("reportno_req");
        String ex_content = request.getParameter("ex_content" )== null  ? "" : (String)request.getParameter("ex_content");
        String commentt = request.getParameter("commentt" )== null  ? "" : (String)request.getParameter("commentt");
        String fault_id = request.getParameter("fault_id" )== null  ? "" : (String)request.getParameter("fault_id");
        String audit_oppinion = request.getParameter("audit_oppinion" )== null  ? "" : (String)request.getParameter("audit_oppinion");
        String act_id = request.getParameter("act_id" )== null  ? "" : (String)request.getParameter("act_id");
        String reportno_seq = getReportNo_Seq(reportno);
        request.setAttribute("reportno",reportno);
        request.setAttribute("reportno_req",reportno_req);
        request.setAttribute("item_no",item_no);
        request.setAttribute("ex_content",ex_content);
        request.setAttribute("commentt",commentt);

        List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
        try {
            StringBuffer sqlCmd = new StringBuffer() ;
            // 檢查是否有這一筆資料, 如果沒有就新增
            sqlCmd.append( "select count(*) as count from ExDefGoodF where reportno = ? AND item_no = ? " );
            paramList.add(reportno) ;
            paramList.add(item_no ) ;
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"count");
		    System.out.println("ExDefGoodF Size="+data.size());
			if(data != null && data.size() > 0) {
			    DataObject bean = (DataObject)data.get(0);
			    String rs = String.valueOf(bean.getValue("count"));
			    System.out.println("Count ="+rs);
			    if(!rs.equals("0")) {
			        errMsg = "編號 "+item_no+" 已存在資料庫";
                    return errMsg;
			    }
            }
			paramList.clear() ;
			sqlCmd.setLength(0) ;
			
            sqlCmd.append( "insert into ExDefGoodF(reportno, reportno_seq, item_no, ex_content, commentt, fault_id, audit_oppinion, act_id, user_id, user_name, update_date) " +
                " values (?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, ?, sysdate) ");
            paramList.add(reportno ) ;
            paramList.add(reportno_seq) ;
            paramList.add(item_no) ;
            paramList.add(ex_content) ;
            paramList.add(commentt) ;
            paramList.add(fault_id) ;
            paramList.add(audit_oppinion) ;
            paramList.add(act_id) ;
            paramList.add(loginID) ;
            paramList.add(loginName) ;
            
            //insertDBSqlList.add(sqlCmd);
			updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
		    //
		    paramList = new ArrayList () ;
		    updateDBSqlList = new ArrayList() ;
		    updateDBDataList = new ArrayList<List> () ;
		    sqlCmd.setLength(0) ;
		    
            sqlCmd.append( "insert into ExDG_HistoryF(reportno, reportno_seq) values (?,?)" );
            paramList.add(reportno) ;
            paramList.add(reportno_seq) ;
           
            updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;
            
		    
		    
		    paramList = new ArrayList () ;
		    updateDBSqlList = new ArrayList() ;
		    updateDBDataList = new ArrayList<List> () ;
		    sqlCmd.setLength(0) ;
		    String ip = request.getRemoteAddr();
		    sqlCmd.append( "insert into EXOPERATE_LOG(muser_id, use_date, program_id, ip_address, sn_docno, rt_docno, reportno,reportno_seq, update_type) " +
                    " values(?, sysdate, ?, ?, ?, ?, ?, ?, ?) " );
			paramList.add(loginID) ;
			paramList.add("TC33") ;
			paramList.add(ip) ;
			if(!"".equals(sn_docno)){
				paramList.add(sn_docno) ;
			}else{
				paramList.add("") ;
			}
			if(!"".equals(rt_docno)){
				paramList.add(rt_docno) ;
			}else{
				paramList.add("") ;
			}
			if(!"".equals(reportno)){
				paramList.add(reportno) ;
			}else{
				paramList.add("") ;
			}
			if(!"".equals(reportno_seq)){
				paramList.add(reportno_seq) ;
			}else{
				paramList.add("") ;
			}
			paramList.add("I") ;
			
			updateDBSqlList.add(sqlCmd.toString()) ;
			updateDBDataList.add(paramList) ;
			updateDBSqlList.add(updateDBDataList) ;
			updateDBList.add(updateDBSqlList) ;

             if(DBManager.updateDB_ps(updateDBList)){
			       errMsg = "相關資料已寫入資料庫";
		     }else{
				   errMsg = errMsg + "相關資料寫入資料庫失敗\n[DBManager.getErrMsg()]: " + DBManager.getErrMsg();
			  }
        }catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗\n[Exception Error]: ";
		}
		return errMsg;
	}
    //101.09.21 fix 超過2000長度時,做base64再分割長度,寫入db by 2295
	private String updateDataToDB(HttpServletRequest request, String loginID, String loginName) {
	    String actMsg = "";
        String errMsg = "";
        String item_no = request.getParameter("item_no" )== null  ? "" : (String)request.getParameter("item_no");
        String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
        String reportno_seq = request.getParameter("reportno_seq" )== null  ? "" : (String)request.getParameter("reportno_seq");
        String ex_content = request.getParameter("ex_content" )== null  ? "" : (String)request.getParameter("ex_content");
        String commentt = request.getParameter("commentt" )== null  ? "" : (String)request.getParameter("commentt");
        String fault_id = request.getParameter("fault_id" )== null  ? "" : (String)request.getParameter("fault_id");
        String audit_oppinion = request.getParameter("audit_oppinion" )== null  ? "" : (String)request.getParameter("audit_oppinion");
        String act_id = request.getParameter("act_id" )== null  ? "" : (String)request.getParameter("act_id");
	    String audit_result = request.getParameter("audit_result" )== null  ? "" : (String)request.getParameter("audit_result");
	    String digest = request.getParameter("digest" )== null  ? "" : (String)request.getParameter("digest");
	    String rt_docno = request.getParameter("rt_docno" )== null  ? "" : (String)request.getParameter("rt_docno");
	    String rt_date = request.getParameter("rt_date" )== null  ? "" : (String)request.getParameter("rt_date");
	    String changeSec1 = request.getParameter("changeSec1" )== null  ? "" : (String)request.getParameter("changeSec1");
	    String changeSec2 = request.getParameter("changeSec2" )== null  ? "" : (String)request.getParameter("changeSec2");
	    
	    
	    List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {
			StringBuffer sqlCmd = new StringBuffer() ;
            // 檢查檢查編號是否存在
            sqlCmd.append("SELECT reportno FROM ExDefGoodF WHERE reportno = ? and reportno_seq = ?" );
            paramList.add(reportno) ;
            paramList.add(reportno_seq);
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
		    System.out.println("ExReportF Size="+data.size());
			if(data.size() < 1) {
     	        errMsg = "檢查編號"+reportno+" 不存在";
                return errMsg;
            }
			paramList.clear() ;
			sqlCmd.setLength(0) ;
			
            if("U".equals(changeSec1)) {
                sqlCmd.append(" Insert into ExDefGoodF_log(reportno, reportno_seq, item_no, ex_content, commentt, fault_id, audit_oppinion, act_id, audit_result, user_id_c, user_name_c, update_date_c, update_type_c) "+
                 " values (?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, ?, sysdate, ?) " );
                paramList.add(reportno) ;
                paramList.add(reportno_seq) ;
                paramList.add(item_no) ;
                paramList.add(ex_content) ;
                paramList.add(commentt) ;
                paramList.add(fault_id) ;
                paramList.add(audit_oppinion) ;
                paramList.add(act_id) ;
                paramList.add(audit_result) ;
                paramList.add(loginID) ;
                paramList.add(loginName) ;
                paramList.add("U") ;
                //updateDBSqlList.add(sqlCmd);
                updateDBSqlList.add(sqlCmd.toString()) ;
    		    updateDBDataList.add(paramList) ;
    		    updateDBSqlList.add(updateDBDataList) ;
    		    updateDBList.add(updateDBSqlList) ;
    		    
    		    paramList = new ArrayList () ;
    		    updateDBSqlList = new ArrayList () ;
    		    updateDBDataList = new ArrayList<List> () ;
    		    sqlCmd.setLength(0) ;
            }
			
			//101.09.21 fix 超過2000長度時,做base64再分割長度,寫入db by 2295
			int parseLen = 2000;
            int iLen = ex_content.getBytes("UTF-8").length;//104.06.03 fix
            List content_list = null;
            if(ex_content.getBytes("UTF-8").length> parseLen){//104.06.03 fix
               System.out.println("over 2000"+ex_content.getBytes("UTF-8").length);//104.06.03 fix
               System.out.println("reportno="+reportno);
               System.out.println("item_no="+item_no);
               System.out.println("ex_content="+ex_content);
                    
                if(iLen > parseLen){
                    content_list = Utility.parseLenBase64encode(ex_content,parseLen);
                }
                paramList = new ArrayList() ;
				sqlCmd.setLength(0) ; 
                sqlCmd.append(" delete exdefgoodf where reportno = ? and reportno_seq = ?");
                paramList.add(reportno) ;
            	paramList.add(reportno_seq);
                updateDBSqlList.add(sqlCmd.toString()) ;
		    	updateDBDataList.add(paramList) ;
		    	updateDBSqlList.add(updateDBDataList) ;
		   		updateDBList.add(updateDBSqlList) ;
                     
                
				sqlCmd.setLength(0) ;
				updateDBSqlList = new ArrayList () ;
    		    updateDBDataList = new ArrayList<List> () ;
            	sqlCmd.append( "insert into ExDefGoodF(reportno, reportno_seq, item_no, ex_content, commentt, fault_id, audit_oppinion, act_id, user_id, user_name, update_date,serial) " +
                " values (?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, "
                +" ?, ?, sysdate,?) ");
                String tmp="";
                for(int idx=0;idx<content_list.size();idx++){
                	paramList = new ArrayList() ;
                    paramList.add(reportno ) ;
                    paramList.add(reportno_seq) ;
                    paramList.add(item_no) ;
                    paramList.add((String)content_list.get(idx)) ;
                    tmp=(String)content_list.get(idx);
                    try{
                    	
                    	//String data = new String(Base64.decode(strSource.getBytes()),"UTF-8");//103.03.13 add    	
                    System.out.println(idx+".contenet_list1"+(String)content_list.get(idx));	
                    //System.out.println(idx+".content_list="+new String(Base64.decode(tmp.getBytes()),"UTF-8"));//103.03.13 add    
                	}catch(Exception e){}
                    paramList.add(commentt) ;
                    paramList.add(fault_id) ;
                    paramList.add(audit_oppinion) ;
                    paramList.add(act_id) ;
                    paramList.add(loginID) ;
                    paramList.add(loginName) ;
                    paramList.add(String.valueOf(idx));  
                    updateDBDataList.add(paramList) ;
                }   
                
                //insertDBSqlList.add(sqlCmd);
			    updateDBSqlList.add(sqlCmd.toString()) ;		        
		        updateDBSqlList.add(updateDBDataList) ;
		        updateDBList.add(updateDBSqlList) ;                
        	}else{  
        		System.out.println("non over 2000"+ex_content.getBytes("UTF-8").length);//104.06.03 fix
                sqlCmd.append( " UPDATE ExDefGoodF SET "
                    +" reportno = ?, "
                    +" reportno_seq = ").append(reportno_seq).append(", "
                    +" item_no = ?, "
                    +" ex_content = ?, "
                    +" commentt = ?, "
                    +" fault_id = ?, "
                    +" audit_oppinion = ?, "
                    +" act_id = ?, "
                    +" audit_result =?, "
                    +" user_id = ?, user_name = ?, update_date = sysdate  WHERE reportno = ? AND reportno_seq = ").append(reportno_seq);
                paramList.add(reportno) ;
                //paramList.add(reportno_seq) ;
                paramList.add(item_no) ;
                paramList.add(ex_content) ;
                paramList.add(commentt) ;
                paramList.add(fault_id) ;
                paramList.add(audit_oppinion) ;
                paramList.add(act_id) ;
                paramList.add(audit_result) ;
                paramList.add(loginID) ;
                paramList.add(loginName) ;                
                paramList.add(reportno) ;
                //paramList.add(reportno_seq) ;
                
                updateDBSqlList.add(sqlCmd.toString()) ;
		        updateDBDataList.add(paramList) ;
		        updateDBSqlList.add(updateDBDataList) ;
		        updateDBList.add(updateDBSqlList) ;
			}
		    paramList = new ArrayList () ;
		    updateDBSqlList = new ArrayList () ;
		    updateDBDataList = new ArrayList<List> () ;
		    sqlCmd.setLength(0) ;
		    
            if("U".equals(changeSec2)) {
                sqlCmd.append(" Insert into ExDG_HistoryF_log(reportno, reportno_seq, digest, rt_docno, rt_date, audit_result, user_id_c, user_name_c, update_date_c, update_type_c) "+
                 " values (?, "
                +" ").append(reportno_seq).append(", "
                +" ?, "
                +" ?, "
                +" TO_DATE(?,'yyyymmdd'), "
                +" ?, "
                +" ?, ?, sysdate,?) " );
                paramList.add(reportno)  ;
                //paramList.add(reportno_seq) ;
                paramList.add(digest) ;
                paramList.add(rt_docno) ;
                paramList.add(rt_date) ;
                paramList.add(audit_result) ;
                paramList.add(loginID) ;
                paramList.add(loginName) ;
                paramList.add("U") ;
                
                updateDBSqlList.add(sqlCmd.toString()) ;
    		    updateDBDataList.add(paramList) ;
    		    updateDBSqlList.add(updateDBDataList) ;
    		    updateDBList.add(updateDBSqlList) ;

    		    paramList = new ArrayList () ;
    		    updateDBSqlList = new ArrayList () ;
    		    updateDBDataList = new ArrayList<List> () ;
    		    sqlCmd.setLength(0) ;
            }

            sqlCmd.append(" UPDATE ExDG_HistoryF SET "
                +" reportno = ?, "
                +" reportno_seq = ").append(reportno_seq).append(", "
                +" digest =?, "
                +" rt_docno = ?, "
                +" rt_date = TO_DATE(?,'yyyymmdd'), "
                +" audit_result =?, "
                +" user_id = ?, user_name =?, update_date = sysdate " +
                "Where reportno = ? AND reportno_seq = ").append(reportno_seq);
            paramList.add(reportno) ;
            //paramList.add(reportno_seq) ;
            paramList.add(digest) ;
            paramList.add(rt_docno) ;
            paramList.add(rt_date) ;
            paramList.add(audit_result) ;
            paramList.add(loginID) ;
            paramList.add(loginName) ;
            paramList.add(reportno) ;
            //paramList.add(reportno_seq) ;
            
            updateDBSqlList.add(sqlCmd.toString()) ;
		    updateDBDataList.add(paramList) ;
		    updateDBSqlList.add(updateDBDataList) ;
		    updateDBList.add(updateDBSqlList) ;

            if(DBManager.updateDB_ps(updateDBList)){
			       errMsg = "相關資料已寫入資料庫";
		     }else{
				   errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]<br>" + DBManager.getErrMsg();
			  }

        } catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				return "相關資料寫入資料庫失敗 <br>[Exception Error]<br> ";
		}
		return errMsg;
	}

    //109.05.15 add 修改機構代碼 by 2295
	private String updateBankNo(HttpServletRequest request, String loginID, String loginName) {
	    String actMsg = "";
        String errMsg = "";
        String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
        String upd_bank_no = request.getParameter("upd_bank_no" )== null  ? "" : (String)request.getParameter("upd_bank_no");
        String upd_bank_type = request.getParameter("upd_bank_type" )== null  ? "" : (String)request.getParameter("upd_bank_type");
	    System.out.println("reportno="+reportno);
	    System.out.println("upd_bank_no="+upd_bank_no);
	    System.out.println("upd_bank_type="+upd_bank_type);
	    
	    List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {
			StringBuffer sqlCmd = new StringBuffer() ;
            // 檢查檢查編號是否存在
            sqlCmd.append("SELECT reportno FROM exreportf WHERE reportno = ? " );
            paramList.add(reportno) ;
            
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
		    System.out.println("exreportf Size="+data.size());
			if(data.size() < 1) {
     	        errMsg = "檢查報告編號"+reportno+" 不存在";
                return errMsg;
            }else{
				paramList.clear() ;
				sqlCmd.setLength(0) ;
			
				sqlCmd.append(" update exreportf set bank_no = ?,tbank_no = ?,bank_type = ?  where reportno = ? ");
            	paramList.add(upd_bank_no) ;
            	paramList.add(upd_bank_no);
            	paramList.add(upd_bank_type) ;
            	paramList.add(reportno);
            	updateDBSqlList.add(sqlCmd.toString()) ;
		    	updateDBDataList.add(paramList) ;
		    	updateDBSqlList.add(updateDBDataList) ;
		   		updateDBList.add(updateDBSqlList) ;            
            }
            
            if(DBManager.updateDB_ps(updateDBList)){
			   errMsg = "相關資料已寫入資料庫";
		    }else{
			   errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]<br>" + DBManager.getErrMsg();
			}

        } catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				return "相關資料寫入資料庫失敗 <br>[Exception Error]<br> ";
		}
		return errMsg;
	}


    //111.06.09 add 新增檢查報告 by 2295
	private String insertReportNo(HttpServletRequest request, String loginID, String loginName) {
	    String actMsg = "";
        String errMsg = "";
        String reportno = request.getParameter("reportno" )== null  ? "" : (String)request.getParameter("reportno");
        String tbank = request.getParameter("tbank" )== null  ? "" : (String)request.getParameter("tbank");
        String examine = request.getParameter("examine" )== null  ? "" : (String)request.getParameter("examine");
        String chType = request.getParameter("chType" )== null  ? "" : (String)request.getParameter("chType");
        String bankType = request.getParameter("bankType" )== null  ? "" : (String)request.getParameter("bankType");
        String begDate = request.getParameter("begDate" )== null  ? "" : (String)request.getParameter("begDate");
	    System.out.print("reportno="+reportno);
	    System.out.print(":tbank="+tbank);
	    System.out.print(":examine="+examine);
	    System.out.print(":chType="+chType);
	    System.out.print(":bankType="+bankType);
	    System.out.println(":begDate="+begDate);
	    
	    List paramList = new ArrayList() ;
        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
        List updateDBSqlList = new ArrayList();
        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
	    try {
			StringBuffer sqlCmd = new StringBuffer() ;
            // 檢查檢查編號是否存在
            sqlCmd.append("SELECT reportno FROM exreportf WHERE reportno = ? " );
            paramList.add(reportno) ;
            
            List data = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");
		    System.out.println("exreportf Size="+data.size());
			if(data.size() >= 1) {
     	        errMsg = "檢查報告編號"+reportno+"已存在無法新增";
                return errMsg;
            }else{
				paramList.clear() ;
				sqlCmd.setLength(0) ;
			    
			    sqlCmd.append("insert into exreportf(");
                sqlCmd.append("reportno,base_date,ch_type,bank_type,tbank_no,bank_no,user_name,update_date");
                sqlCmd.append(")values(?,To_date(?,'yyyymmdd'),?,?,?,?,?,sysdate)");
			
			
            	paramList.add(reportno) ;
            	paramList.add(begDate);
            	paramList.add(chType) ;
            	paramList.add(bankType);
            	paramList.add(tbank);
            	paramList.add(examine);
            	paramList.add(loginName);
            	updateDBSqlList.add(sqlCmd.toString()) ;
		    	updateDBDataList.add(paramList) ;
		    	updateDBSqlList.add(updateDBDataList) ;
		   		updateDBList.add(updateDBSqlList) ;            
            }
            
            if(DBManager.updateDB_ps(updateDBList)){
			   errMsg = "檢查報告"+reportno+"已寫入資料庫,請點選[回查詢頁]重新查詢後,登錄相關檢查及處理意見";
		    }else{
			   errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]<br>" + DBManager.getErrMsg();
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
        List paramList = new ArrayList();
        String reportno = request.getParameter("reportno" ) == null  ? "" : (String)request.getParameter("reportno");
	    String reportno_seq = request.getParameter("reportno_seq" )== null  ? "" : (String)request.getParameter("reportno_seq");

	    try {

            List DBSqlList = new LinkedList();

            // 檢查檢查編號是否存在
            String sqlCmd = "SELECT reportno FROM ExDefGoodF WHERE reportno = ? ";
            paramList.add(reportno);
            List data = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");
		    System.out.println("ExReportF Size="+data.size());
			if(data.size() < 1) {
     	        errMsg = "檢查編號"+reportno+" 不存在";
                return errMsg;
            }

            sqlCmd = " Insert into ExDefGoodF_log(reportno, reportno_seq, item_no, ex_content, commentt, fault_id, audit_oppinion, act_id, audit_result, user_id_c, user_name_c, update_date_c, update_type_c) " +
                            " SELECT reportno, reportno_seq, item_no, ex_content, commentt, fault_id, audit_oppinion, act_id, audit_result, '"+loginID+"', '"+loginName+"', sysdate, 'D' FROM ExDefGoodF WHERE "+
                            " reportno = '"+reportno+"' AND reportno_seq = "+reportno_seq;
            DBSqlList.add(sqlCmd);

            sqlCmd = " DELETE FROM ExDefGoodF WHERE reportno = '"+reportno+"' AND reportno_seq = "+reportno_seq;
            DBSqlList.add(sqlCmd);

            sqlCmd = " Insert into ExDG_HistoryF_log(reportno, reportno_seq, digest, rt_docno, rt_date, audit_result, user_id_c, user_name_c, update_date_c, update_type_c) " +
                     " SELECT reportno, reportno_seq, digest, rt_docno, rt_date, audit_result, '"+loginID+"', '"+loginName+"', sysdate, 'D' FROM ExDG_HistoryF WHERE "+
                     " reportno = '"+reportno+"' AND reportno_seq = "+reportno_seq;
            DBSqlList.add(sqlCmd);

            sqlCmd = " DELETE FROM ExDG_HistoryF WHERE reportno = '"+reportno+"' AND reportno_seq = "+reportno_seq;
            DBSqlList.add(sqlCmd);


            if(DBManager.updateDB(DBSqlList)){
			       errMsg = "";
		     }else{
				   errMsg = errMsg + "相關資料刪除失敗<br>[DBManager.getErrMsg()]<br>" + DBManager.getErrMsg();
			  }

        } catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				return "相關資料刪除失敗<br>[Exception Error]<br>";
		}
		return errMsg;


	}

	// 自動產生編號
    private String getReportNo_Seq(String reportno){
    		//查詢條件
    		String no = "";
    		List paramList = new ArrayList();
    		String sqlCmd = " select nvl(max(reportno_seq),'0')+1 as max_seq from ExDEfGoodF WHERE reportno = ? ";
    		paramList.add(reportno);
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"max_seq");
            if(dbData != null && dbData.size()>0) {
                DataObject bean =(DataObject)dbData.get(0);
                no = String.valueOf(bean.getValue("max_seq"));
                System.out.println("System create serial number is "+no);
            }else{
                System.out.println(" Error !!!  Can't create serial number !!!");
            }
            return no;
    }
    
%>
