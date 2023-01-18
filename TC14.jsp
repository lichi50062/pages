<%
//94.01.21 create by egg
//94.03.04 fix 金融機構類別預設為全部類別及下拉選單全部產品查詢受檢單位僅需輸出全部調整
//99.06.01 fix 套用Header.include & sql injection by 2808
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>

<%
	System.out.println("@@TC14.jsp Start...");

	String nowact = Utility.getTrimString(dataMap.get("nowact"));
	String bank_type = Utility.getTrimString(dataMap.get("BANK_TYPE"));
	String bank_no = Utility.getTrimString(dataMap.get("BANK_NO"));
	String ch_type = Utility.getTrimString(dataMap.get("CH_TYPE"));
	String chk_no = Utility.getTrimString(dataMap.get("CHK_NO"));
	String base_date_beg = Utility.getTrimString(dataMap.get("BASE_DATE_BEG"));
	String base_date_end = Utility.getTrimString(dataMap.get("BASE_DATE_END"));
    String BASE_DATE_BEG_Y = Utility.getTrimString(dataMap.get("BASE_DATE_BEG_Y")) ;
	String u_year = "99" ;
	if(!"".equals(BASE_DATE_BEG_Y) && Integer.parseInt(BASE_DATE_BEG_Y) > 99) {
		u_year = "100" ;
	}
	System.out.println("u_year="+u_year) ;
	// 2005.4.21 取得縣市
	String cityType = Utility.getTrimString(dataMap.get("cityType"));
	request.setAttribute("cityType",cityType) ;
	System.out.println("act="+act);
	System.out.println("nowact="+nowact);
	System.out.println("bank_type="+bank_type);
	System.out.println("bank_no="+bank_no);
	System.out.println("cityType="+cityType);
	System.out.println("TC41.jsp BASE_DATE_BEG="+base_date_beg);
	System.out.println("TC41.jsp BASE_DATE_END="+base_date_end);

	if(session.getAttribute("muser_id") == null){
      System.out.println("TC14 login timeout");
	  rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );
      rd.forward(request,response);
    }

	//登入者資訊
	System.out.println("登入者id="+lguser_id);
	System.out.println("登入者name="+lguser_name);
	System.out.println("登入者type="+lguser_type);

	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    	System.out.println("@X rquest無權限時,導向到LoginError.jsp");
        rd = application.getRequestDispatcher( LoginErrorPgName );
    }else{
    	//set next jsp
    	if(act.equals("new") || act.equals("getData") || act.equals("List") || act.equals("Qry")){
    	    System.out.println("TC14.act=new or getData or List.bank_type="+bank_type);

			//List時先預設機構類別為0:全部類別
			if(bank_type.equals("")){
				bank_type="0";
				System.out.println("bank_type空白設定bank_type="+bank_type);
			}
			// 2005.4.21 取得所有縣市
    		request.setAttribute("City", Utility.getCity());
    		List bank_no_list = GetBank_No(bank_type, cityType,u_year);
    		//if(bank_no.equals("") && (bank_no_list.size() != 0)){
            //   	bank_no= (String)((DataObject)bank_no_list.get(0)).getValue("bank_no");
            //}
    	    request.setAttribute("bank_no",bank_no_list);

    		if(act.equals("new")){
        	   	rd = application.getRequestDispatcher( EditPgName +"?act=new");
        	}
        	if(act.equals("List")){
        		System.out.println("act.equals(List)");
        	   	rd = application.getRequestDispatcher( ListPgName +"?act=List&SZBANK_TYPE="+bank_type);
        	}
        	if(act.equals("Qry")){
        		System.out.println("Qry.bank_type="+bank_type);
        		System.out.println("Qry.bank_no="+bank_no);
    		    List EXDEFGOODFList = getQryResult(bank_type,bank_no,ch_type,chk_no,base_date_beg,base_date_end,cityType);
    		    request.setAttribute("EXDEFGOODFList",EXDEFGOODFList);
    		    
    			rd = application.getRequestDispatcher( ListPgName +"?act=Qry&SZBANK_TYPE="+bank_type+"&SZBANK_NO="+bank_no+"&SZCH_TYPE="+ch_type+"&SZCHK_NO="+chk_no);
    		}
    		if(act.equals("getData")){
        		System.out.println("TC14_act=getData Start ....");
        		System.out.println("TC14_act=getData.bank_type="+bank_type);
        	    if(nowact.equals("new") || nowact.equals("Edit")){
        	    	System.out.println("act=getData,nowact=new or edit");
        	       	rd = application.getRequestDispatcher( EditPgName +"?act="+nowact+"&bank_type="+bank_type);
        	    }
        	    if(nowact.equals("List") || nowact.equals("Qry")){
        	       	System.out.println("act=getData,nowact=List or Qry");
        	        rd = application.getRequestDispatcher( ListPgName +"?act="+nowact+"&SZBANK_TYPE="+bank_type+"&SZBANK_NO="+bank_no);
        	    }
        	}
    	}else if(act.equals("Edit")){//編輯(新增or修改)作業處理
			System.out.println("@@act=Edit...");
    	}else if(act.equals("Insert")){//新增資料處理
    		System.out.println("@@act=Insert...");
    	    actMsg = InsertDB(request,lguser_id,lguser_name);
        	//rd = application.getRequestDispatcher( nextPgName );
        }else if(act.equals("Update")){//更新資料處理
    	    actMsg = UpdateDB(request,lguser_id,lguser_name);
        	//rd = application.getRequestDispatcher( nextPgName );
        }else if(act.equals("Delete")){//刪除資料處理
    	    actMsg = DeleteDB(request,lguser_id,lguser_name);
        	//rd = application.getRequestDispatcher( nextPgName );
        }
		//設定頁面移轉輸出(錯誤)訊息
    	request.setAttribute("actMsg",actMsg);
	}
%>
<%@include file="./include/Tail.include" %>


<%!
    private final static String report_no = "TC14" ;
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
    private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    

    //取得機構代號
    private List GetBank_No(String bank_type, String cityType,String u_year){
    		System.out.println("TC14.Method GetBank_No Start..");
    		System.out.println("Inpute bank_type="+bank_type);

    		//查詢條件
    		StringBuffer sqlCmd = new StringBuffer() ;
    		List paramList = new ArrayList() ;
    		sqlCmd.append( " SELECT BANK_NO,BANK_NAME  " );
    		if(bank_type.equals("0")) {
    			System.out.println("全部機構類別(1,6,7,8)查詢");
    			sqlCmd.append(" FROM BA01 WHERE BANK_TYPE IN (?,?,?,?) and m_year = ? ORDER BY BANK_NO" );
    			paramList.add("1") ;
    			paramList.add("6") ;
    			paramList.add("7") ;
    			paramList.add("8") ;
    			paramList.add(u_year) ;
    		} else if(!cityType.equals("") && (bank_type.equals("6") || bank_type.equals("7"))) {
    		    System.out.println("農漁會縣市別查詢");
    		    sqlCmd.append(
    		     " , TBANK_NO From (( select a.BANK_NO as TBANK_NO,a.BANK_NO as BANK_NO,  a.BANK_NAME as BANK_NAME " +
                 " from (select * from bn01 where m_year=? ) a, (select * from wlx01 where m_year=? ) b where a.bank_type = ? and a.bank_no = b.bank_no AND " +
                 " b.hsien_id = ?) union ALL (select d.TBANK_NO as TBANK_NO, "+
                 " d.BANK_NO as BANK_NO, a.BANK_NAME as BANK_NAME from (select * from ba01 where m_year=? ) a, (select * from wlx01 where m_year=? ) b, (select * from wlx02 where m_year=? )  d " +
                 " where a.bank_type = ? and a.BANK_KIND = ? and " +
                 " a.bank_no = d.bank_no and a.pbank_no = d.Tbank_no  and d.Tbank_no = b.bank_no   and "+
                 " b.hsien_id = ? )) order by  TBANK_NO, BANK_NO, BANK_NAME"); 
    		     paramList.add(u_year) ;
    		     paramList.add(u_year) ;
    		     paramList.add(bank_type) ;
    		     paramList.add(cityType) ;
    		     paramList.add(u_year) ;
    		     paramList.add(u_year) ;
    		     paramList.add(u_year) ;
    		     paramList.add(bank_type) ;
    		     paramList.add("1") ;
    		     paramList.add(cityType) ;
    		}else {
    			System.out.println("單一機構類別查詢");
    			sqlCmd.append(" FROM (select * from ba01 where m_year=?) BA01 WHERE BANK_TYPE=?  ORDER BY BANK_NO" );
    			paramList.add(u_year) ;
    			paramList.add(bank_type) ;
    		} 
    		
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"");

            System.out.println("TC14.Method GetBank_No End..");
            return dbData;
    }
    
    

    //取得查詢結果
    private List getQryResult(String bank_type,String bank_no,String ch_type,String chk_no,String base_date_beg,String base_date_end,   String cityType){
    		//查詢條件
    		StringBuffer sqlCmd = new StringBuffer();
    		List paramList = new ArrayList() ;
    		//日期型態轉換處理
    		base_date_beg =Utility.getDatetoString(base_date_beg);
    		base_date_end =Utility.getDatetoString(base_date_end);

    		System.out.println("Method getQryResult Start ..");
    		System.out.println("Input var bank_no="+bank_no);
    		System.out.println("Input var bank_type="+bank_type);
    		System.out.println("Input var ch_type="+ch_type);
    		System.out.println("Input var chk_no="+chk_no);
    		System.out.println("Input var base_date_beg="+base_date_beg);
    		System.out.println("Input var base_date_end="+base_date_end);

			/*
				1.讀取檢查報告檔取得局內(農金局(2))及局外(1)檢查歷史資料union
				2.讀取ba01取得金融機構名稱及cdshareno取得檢查性質及檢查單位名稱
			*/
	String u_year = "99" ;
	if(!"".equals(base_date_beg) && Integer.parseInt(base_date_beg.substring(0,4)) >2010) {
		u_year = "100" ;
	}
	//BEGIN
	if (chk_no.equals("")) { 
	   sqlCmd.append(	"SELECT * FROM ( " );
	}
	//先執行 農金局
		if (chk_no.equals("2") || chk_no.equals("")) { //農金局_2_起
			sqlCmd.append(              " SELECT A.BANK_NO 		AS BANK_NO, "
					+	"        D.BANK_NAME		AS BANK_NAME, "
					+	" 	 A.CH_TYPE 		AS CH_TYPE, "
					+	"        E.CMUSE_NAME    	AS CMUSE_NAME, "
					+	"  	 B.BASE_DATE 	        AS BASE_DATE, "
					+	"  	 '2'             	AS ORIGINUNT_ID "
					+	"    FROM EXDISTRIPF A, (select * from BA01 where m_year=?) D,  CDSHARENO E, EXSCHEDULEF B"
					+	"    WHERE A.DISP_ID = B.DISP_ID "
					+	"    	AND A.BANK_NO = D.BANK_NO "
					+	"	AND ( A.CH_TYPE = E.CMUSE_ID AND E.CMUSE_DIV = ? )	"
					+	"	AND   B.BASE_DATE BETWEEN TO_DATE(?,'yyyymmddhh24miss') "+ "AND TO_DATE(?,'yyyymmddhh24miss') " );
		    paramList.add(u_year) ;
		    paramList.add("023") ;
		    paramList.add(base_date_beg) ;
		    paramList.add(base_date_end) ;
			if(!bank_type.equals("") && !bank_type.equals("0")){
    			    sqlCmd.append(  " AND  A.BANK_TYPE = ?   ");
    			    paramList.add(bank_type) ;
    		}
			if(!bank_no.equals("")){
    			    //System.out.println("機構代號非空白處理");
    			    sqlCmd.append( " AND A.BANK_NO = ? ");
    			    paramList.add(bank_no) ;
    		}
    		if(!ch_type.equals("")){
    			    //System.out.println("檢查性質非空白處理");
    			    sqlCmd.append(   " AND A.CH_TYPE = ? " );
    			    paramList.add(ch_type) ;
    		} 
    		if(!cityType.equals("")) {
    		            sqlCmd.append( " and A.TBANK_NO in (select BANK_NO  from WLX01  where HSIEN_ID = ?) " );
    		            paramList.add(cityType) ;
    		}

        } //農金局_2_ 止
    		  
    	//MIDDLE  
    	if (chk_no.equals("")) { 
	     sqlCmd.append(	"  UNION ALL  " );
	    } 
	       
	//再執行 金管會...等
	if (!(chk_no.equals("2"))) { //金管會_1_起
		sqlCmd.append(              " SELECT A.BANK_NO 		AS BANK_NO, "
				+	"        D.BANK_NAME		AS BANK_NAME, "
				+	" 	 A.CH_TYPE 		AS CH_TYPE, "
				+	"        E.CMUSE_NAME    	AS CMUSE_NAME, "
				+	"  	 A.BASE_DATE 	        AS BASE_DATE, "
				+	"  	 A.ORIGINUNT_ID      	AS ORIGINUNT_ID "
				+	"    FROM  EXREPORTF A, (select * from ba01 where m_year=? ) D, CDSHARENO E "
				+	"    WHERE   A.BANK_NO = D.BANK_NO          "
				+	" 	AND A.ORIGINUNT_ID <> ? "
				+	"	AND ( A.CH_TYPE = E.CMUSE_ID AND E.CMUSE_DIV = ?)	"
				+	"	AND   A.BASE_DATE BETWEEN TO_DATE(?,'yyyymmddhh24miss') "+ "AND TO_DATE(?,'yyyymmddhh24miss') ");
	    paramList.add(u_year) ;
	    paramList.add("2") ;
	    paramList.add("023") ;
	    paramList.add(base_date_beg) ;
	    paramList.add(base_date_end) ;
		if(!bank_type.equals("") && !bank_type.equals("0")){
		    sqlCmd.append(  " AND  A.BANK_TYPE = ?   ");
		    paramList.add(bank_type) ;
	    }
		if(!bank_no.equals("")){
		    //System.out.println("機構代號非空白處理");
		    sqlCmd.append( " AND A.BANK_NO = ? ");
		    paramList.add(bank_no) ;
	    }
	    if(!ch_type.equals("")){
		    //System.out.println("檢查性質非空白處理");
		    sqlCmd.append(   " AND A.CH_TYPE =? ");
		    paramList.add(ch_type) ;
	    }
	    if(!cityType.equals("")) {
	            sqlCmd.append(" and A.TBANK_NO in (select BANK_NO  from WLX01  where HSIEN_ID =  ? and m_year=? ) ");
	   			paramList.add(cityType) ;
	   			paramList.add(u_year) ;
	    }
    } //金管會_1_ 止
	  
    	//END 
    	if (chk_no.equals("")) { 
	      sqlCmd.append	("  )  ");
	    }       	  	
       //LAST
	sqlCmd.append( "  ORDER BY SUBSTR(TO_CHAR(base_date,'yyyymmdd'),1,6), CH_TYPE, ORIGINUNT_ID , BANK_NO ");

            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"base_date");

            System.out.println("Method getQryResult End ..dbData.size()+"+dbData.size());
            return dbData;
    }
    
	//新增
	public String InsertDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		String errMsg="";

		System.out.println("Method InserDB Start...");

		System.out.println("Method InserDB End...");
		return errMsg;
	}
	//修改
	private String UpdateDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{
		String errMsg="";

		System.out.println("@@Method UpdateDB Start...");

		System.out.println("@@Method UpdateDB End...");
		return errMsg;
	}
	//刪除
    private String DeleteDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{

		String errMsg="";

		System.out.println("@@Method DeleteDB Start...");

		System.out.println("@@Method DeleteDB End...");
		return errMsg;
	}
%>
<%System.out.println("@@TC14.jsp End...");%>