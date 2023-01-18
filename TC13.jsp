<%
//94.01.21 create by egg
//99.05.31 fix 套用Header.include & sql injection by 2808
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>

<%

	//初值宣告
	//String muser_id = ( request.getParameter("muser_id")==null ) ? "" : (String)request.getParameter("muser_id");
	
	String nowact = Utility.getTrimString(dataMap.get("nowact"));
	
	String base_date_beg = Utility.getTrimString(dataMap.get("BASE_DATE_BEG"));
	String base_date_end = Utility.getTrimString(dataMap.get("BASE_DATE_END"));


	if(session.getAttribute("muser_id") == null){
      System.out.println("TC13 login timeout");
	  rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );
      rd.forward(request,response);
    }

	
	if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    	System.out.println("@X rquest無權限時,導向到LoginError.jsp");
        rd = application.getRequestDispatcher( LoginErrorPgName );
    }else{
    	//set next jsp
    	if(act.equals("new") || act.equals("List") || act.equals("Qry")){
    	    System.out.println("TC13.act=new or getData or List.muser_id="+muser_id);

    		if(act.equals("new")){
        	   	rd = application.getRequestDispatcher( EditPgName +"?act=new");
        	}
        	if(act.equals("List")){
        		System.out.println("act.equals(List)");
        	   	rd = application.getRequestDispatcher( ListPgName +"?act=List");
        	}
        	if(act.equals("Qry")){
        		System.out.println("Qry.muser_id="+muser_id);
    		    List EXDISTRIPFList = getQryResult(muser_id,base_date_beg,base_date_end);
    		    request.setAttribute("EXDISTRIPFList",EXDISTRIPFList);
    			rd = application.getRequestDispatcher( ListPgName +"?act=Qry&SZMUSER_ID="+muser_id);
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
	private final static String report_no = "TC13" ;
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String EditPgName = "/pages/"+report_no+"_Edit.jsp";
    private final static String ListPgName = "/pages/"+report_no+"_List.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    

    //取得查詢結果
    private List getQryResult(String muser_id,String base_date_beg,String base_date_end){
    		//查詢條件
    		StringBuffer sqlCmd = new StringBuffer() ;
    		List paramList = new ArrayList() ;
    		//日期型態轉換處理
    		base_date_beg =Utility.getDatetoString(base_date_beg);
    		base_date_end =Utility.getDatetoString(base_date_end);

    		System.out.println("Method getQryResult Start ..");
    		System.out.println("Input var muser_id="+muser_id);
    		System.out.println("Input var base_date_beg="+base_date_beg);
    		System.out.println("Input var base_date_end="+base_date_end);
			String u_year = "99" ;
			if(!"".equals(base_date_beg) && (Integer.parseInt(base_date_beg) > 2010)) {
				u_year = "100" ;
			}
			/*
				1.讀取檢查派差檔(EXDISTRIPF)取得派差資料
				2.依派差通知單編號關聯檢查派差_助檢人員負責項目檔取得助檢人員資料
				3.讀取BA01取得金融機構名稱及CDSHARENO取得檢查性質名稱
			*/
			sqlCmd.append(	"SELECT B.MUSER_ID,C.MUSER_NAME,A.BANK_NO,D.BANK_NAME,A.CH_TYPE,E.CMUSE_NAME,F.ST_DATE,F.EN_DATE,B.EXAM_ITEM,A.PRJ_ITEM,G.EXPERTNO_NAME "
					+	"FROM	EXDISTRIPF A,EXHELPITEMF B,WTT01 C,(SELECT * FROM BA01 WHERE M_YEAR=? ) D,CDSHARENO E,EXSCHEDULEF F ,EXPERTNOF G "
					+	"WHERE	A.DISP_ID = B.DISP_ID "
					+	"AND	B.DISP_ID = F.DISP_ID "
					+	"AND 	B.MUSER_ID = C.MUSER_ID "
					+	"AND	A.BANK_NO = D.BANK_NO "
					+	"AND	B.EXAM_ITEM = G.EXPERTNO_ID "
					+	"AND 	( F.ST_DATE BETWEEN TO_DATE(?,'yyyymmddhh24miss') "+ "AND TO_DATE(?,'yyyymmddhh24miss') ) "
					+	"AND 	( F.EN_DATE BETWEEN TO_DATE(?,'yyyymmddhh24miss') "+ "AND TO_DATE(?,'yyyymmddhh24miss') ) "
					+	"AND	( A.CH_TYPE = E.CMUSE_ID AND E.CMUSE_DIV = ? ) ");
			paramList.add(u_year) ;
			paramList.add(base_date_beg) ;
			paramList.add(base_date_end) ;
			paramList.add(base_date_beg) ;
			paramList.add(base_date_end) ;
			paramList.add("023") ;
			if(!muser_id.equals("")){
    			System.out.println("員工代號非空白處理");
    			sqlCmd.append("AND B.MUSER_ID = ? " );
    			paramList.add(muser_id) ;
    		}
			sqlCmd.append("ORDER 	BY MUSER_ID" );
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,"st_date,en_date");

            System.out.println("Method getQryResult End ..");
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
<%System.out.println("@@TC13.jsp End...");%>