<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>
<%
	String pgId = "FL002W";
	String defKind = Utility.getTrimString(request.getParameter("defKind"));
	String defType = Utility.getTrimString(request.getParameter("defType"));
	String defCase = Utility.getTrimString(request.getParameter("defCase"));
	String caseName = Utility.getTrimString(request.getParameter("caseName"));
	
	request.setAttribute("defKind", defKind);
	request.setAttribute("defType", defType);
	request.setAttribute("defCase", defCase);
	request.setAttribute("caseName", caseName);
	
	if(!Utility.CheckPermission(request,report_no)){
		rd = application.getRequestDispatcher( LoginErrorPgName ); 
	} else {
		if("List".equals(act)) {
			request.setAttribute("defTypes", getDefTypes());
			request.setAttribute("frmDefItems", getFrmDefItems(defKind , defType , caseName));
			rd = application.getRequestDispatcher(ListPgName +"?act=List");
		} else if("query".equals(act)) {
			request.setAttribute("defTypes", getDefTypes());
			request.setAttribute("frmDefItems", getFrmDefItems(defKind , defType , caseName));
			rd = application.getRequestDispatcher(ListPgName +"?act=List");
		} else if("showInsert".equals(act)) {
			request.setAttribute("defKind", "");
			request.setAttribute("defType", "");
			request.setAttribute("defCase", "");
			request.setAttribute("caseName", "");
			
			request.setAttribute("defTypes", getDefTypes());
			rd = application.getRequestDispatcher(EditPgName +"?act=showInsert");
		} else if("goEditPage".equals(act)) {
			request.setAttribute("defKind", defKind);
			request.setAttribute("defType", defType);
			request.setAttribute("defCase", defCase);
			request.setAttribute("caseName", caseName);
			
			request.setAttribute("defTypes", getDefTypes());
			rd = application.getRequestDispatcher(EditPgName +"?act=List");
		} else if("insert".equals(act)) {
			boolean insSuc = insertFrmDefItem(request);
			if(insSuc) {
				actMsg = "新增成功";
			} else {
				actMsg = "新增失敗";
			}
			request.setAttribute("defTypes", getDefTypes());
			request.setAttribute("frmDefItems", getFrmDefItems("" , "" , ""));
			rd = application.getRequestDispatcher(ListPgName +"?act=List");
		} else if("update".equals(act)) {
			boolean updSuc = updateFrmDefItem(request);
			if(updSuc) {
				actMsg = "修改成功";
			} else {
				actMsg = "修改失敗";
			}
			request.setAttribute("defKind", "");
			request.setAttribute("defType", "");
			request.setAttribute("defCase", "");
			request.setAttribute("caseName", "");
			
			request.setAttribute("defTypes", getDefTypes());
			request.setAttribute("frmDefItems", getFrmDefItems("" , "" , ""));
			rd = application.getRequestDispatcher(ListPgName +"?act=List");
		} else if("delete".equals(act)) {
			boolean delSuc = deleteFrmDefItem(request);
			if(delSuc) {
				actMsg = "刪除成功";
			} else {
				actMsg = "刪除失敗";
			}
			request.setAttribute("defKind", "");
			request.setAttribute("defType", "");
			request.setAttribute("defCase", "");
			request.setAttribute("caseName", "");
			
			request.setAttribute("defTypes", getDefTypes());
			request.setAttribute("frmDefItems", getFrmDefItems("" , "" , ""));
			rd = application.getRequestDispatcher(ListPgName +"?act=List");
		} else if("cancel".equals(act)) {
			request.setAttribute("defTypes", getDefTypes());
			request.setAttribute("frmDefItems", getFrmDefItems("" , "" , ""));
			rd = application.getRequestDispatcher(ListPgName +"?act=List");
		} else if("back".equals(act)) {
			request.setAttribute("defTypes", getDefTypes());
			request.setAttribute("frmDefItems", getFrmDefItems("" , "" , ""));
			rd = application.getRequestDispatcher(ListPgName +"?act=List");
		}
	}
	
	request.setAttribute("act" , act);
	request.setAttribute("actMsg" , actMsg);
%>
<%@include file="./include/Tail.include" %>
<%!
	private final static String report_no = "FL002W" ;
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";
	private final static String ListPgName = "/pages/" + report_no + "_List.jsp";
	private final static String EditPgName = "/pages/" + report_no + "_Edit.jsp";
	
	private List getDefTypes() {
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT cmuse_id , cmuse_name FROM cdshareno WHERE cmuse_div = '047' ");
		List paramList = new ArrayList();
		List dbData = DBManager.QueryDB_SQLParam(sql.toString() , paramList , "");
		return dbData;
	}
	
	private List getFrmDefItems(String defKind , String defType , String caseName) {
		List paramList = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append(" select                                                                 ");
		sql.append(" def_kind ,                                                             ");
		sql.append(" decode(def_kind,'A','整體性缺失','C','個案缺失','') as def_kindname ,      ");
		sql.append(" def_type ,                                                             ");
		sql.append(" cmuse_name ,                                                           ");
		sql.append(" def_case ,                                                             ");
		sql.append(" def_type||'-'||def_case as def_case_id ,                               ");
		sql.append(" case_name                                                              ");
		sql.append(" from frm_def_item                                                      ");
		sql.append(" left join (select * from cdshareno where cmuse_div='047') cdshareno on ");
		sql.append(" frm_def_item.def_type=cdshareno.cmuse_id                               ");
		sql.append(" where 1 = 1                                                            ");
		if(!"".equals(Utility.getTrimString(defKind))) {
			sql.append(" and def_kind = ?                                                   ");
			paramList.add(defKind);
		}
		if(!"".equals(Utility.getTrimString(defType))) {
			sql.append(" and def_type = ?                                                   ");
			paramList.add(defType);
		}
		if(!"".equals(Utility.getTrimString(caseName))) {
			sql.append(" and case_name like ?                                               ");
			paramList.add("%" + caseName + "%");
		}
		sql.append(" order by def_type , to_number(def_case)                                ");
		
		List dbData = DBManager.QueryDB_SQLParam(sql.toString() , paramList , "");
		return dbData;
	}
	
	private boolean insertFrmDefItem(HttpServletRequest request) {
		StringBuffer sql = new StringBuffer();
		sql.append(" insert into frm_def_item(DEF_KIND , DEF_TYPE , DEF_CASE , CASE_NAME , USER_ID , USER_NAME , UPDATE_DATE ) ");
		sql.append(" values ( ? , ? , ? , ? , ? , ? , sysdate)                                                                 ");
		
		String defKind = Utility.getTrimString(request.getParameter("defKind"));
		String defType = Utility.getTrimString(request.getParameter("defType"));
		
		List paramList = new ArrayList();
		paramList.add(defKind);
		paramList.add(defType);
		String maxDefCase = Utility.getTrimString(getMaxDefCase(defKind , defType));
		System.out.print("#######@@@@ maxDefCase : " + maxDefCase);
		paramList.add(maxDefCase);
		paramList.add(Utility.getTrimString(request.getParameter("caseName")));
		paramList.add(Utility.getTrimString(request.getSession().getAttribute("muser_id")));
		paramList.add(Utility.getTrimString(request.getSession().getAttribute("muser_name")));
		
		return doUpdate(sql.toString() , paramList);
	}
	
	private boolean updateFrmDefItem(HttpServletRequest request) {
		StringBuffer sql = new StringBuffer();
		sql.append(" UPDATE frm_def_item      ");
		sql.append(" SET DEF_KIND   = ? ,     ");
		sql.append("   DEF_TYPE     = ? ,     ");
		sql.append("   CASE_NAME    = ? ,     ");
		sql.append("   USER_ID      = ? ,     ");
		sql.append("   USER_NAME    = ? ,     ");
		sql.append("   UPDATE_DATE  = sysdate ");
		sql.append(" WHERE DEF_KIND = ?       ");
		sql.append(" AND DEF_TYPE   = ?       ");
		sql.append(" AND DEF_CASE   = ?       ");
		
		List paramList = new ArrayList();
		paramList.add(Utility.getTrimString(request.getParameter("defKind")));
		paramList.add(Utility.getTrimString(request.getParameter("defType")));
		paramList.add(Utility.getTrimString(request.getParameter("caseName")));
		paramList.add(Utility.getTrimString(request.getSession().getAttribute("muser_id")));
		paramList.add(Utility.getTrimString(request.getSession().getAttribute("muser_name")));
		paramList.add(Utility.getTrimString(request.getParameter("defKindHidden")));
		paramList.add(Utility.getTrimString(request.getParameter("defTypeHidden")));
		paramList.add(Utility.getTrimString(request.getParameter("defCase")));
		
		return doUpdate(sql.toString() , paramList);
	}
	
	private boolean deleteFrmDefItem(HttpServletRequest request) {
		StringBuffer sql = new StringBuffer();
		sql.append(" DELETE frm_def_item      ");
		sql.append(" WHERE DEF_KIND = ?       ");
		sql.append(" AND DEF_TYPE   = ?       ");
		sql.append(" AND DEF_CASE   = ?       ");
		
		List paramList = new ArrayList();
		paramList.add(Utility.getTrimString(request.getParameter("defKind")));
		paramList.add(Utility.getTrimString(request.getParameter("defType")));
		paramList.add(Utility.getTrimString(request.getParameter("defCase")));
		
		return doUpdate(sql.toString() , paramList);
	}
	
	private boolean doUpdate(String sql , List paramList) {
		List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
		List updateDBSqlList = new ArrayList();
		List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List;
		
		updateDBSqlList.add(sql.toString()) ;
		updateDBDataList.add(paramList) ;
		updateDBSqlList.add(updateDBDataList) ;
		updateDBList.add(updateDBSqlList) ;
		
		return DBManager.updateDB_ps(updateDBList);
	}
	
	private String getMaxDefCase(String defKind , String defType) {
		String maxDefCase = "";
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT TO_CHAR(NVL(max(to_number(def_case))+1 , 1)) AS def_cases ");
		sql.append(" FROM frm_def_item                                      ");
		sql.append(" WHERE def_kind=?                                       ");
		sql.append(" AND def_type  =?                                       ");
		
		List paramList = new ArrayList();
		paramList.add(defKind);
		paramList.add(defType);
		
		List dbData = DBManager.QueryDB_SQLParam(sql.toString() , paramList , "");
		if(!dbData.isEmpty()) {
			DataObject bean = (DataObject) dbData.get(0);
			maxDefCase = Utility.getTrimString(bean.getValue("def_cases"));
		}
		return maxDefCase;
	}
	
%>