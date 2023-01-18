<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>
<%
	String pgId = "FL003W";
	String docType = Utility.getTrimString(request.getParameter("docType"));
	String auditType = Utility.getTrimString(request.getParameter("auditType"));
	String auditId = Utility.getTrimString(request.getParameter("auditId"));
	String auditCase = Utility.getTrimString(request.getParameter("auditCase"));
	
	System.out.println("###### docType : " + docType + " , auditType : " + auditType);
	if(!Utility.CheckPermission(request,report_no)){
		rd = application.getRequestDispatcher( LoginErrorPgName ); 
	} else {
		if("List".equals(act)) {
			request.setAttribute("docTypes", getDocTypes());
			request.setAttribute("frmAuditItems", getFrmAuditItems(""));
			rd = application.getRequestDispatcher(ListPgName +"?act=List");
		} else if("showInsert".equals(act)) {
			request.setAttribute("docTypes", getDocTypes());
			request.setAttribute("auditTypes", getAuditTypes());
			
			rd = application.getRequestDispatcher(EditPgName +"?act=showEditPage");
		} else if("showEditPage".equals(act)) {
			request.setAttribute("docTypes", getDocTypes());
			request.setAttribute("auditTypes", getAuditTypes());
			
			request.setAttribute("docType", docType);
			request.setAttribute("auditType", auditType);
			request.setAttribute("auditId", auditId);
			request.setAttribute("auditCase", auditCase);
			rd = application.getRequestDispatcher(EditPgName +"?act=showEditPage");
		} else if("query".equals(act)) {
			request.setAttribute("docTypes", getDocTypes());
			request.setAttribute("frmAuditItems", getFrmAuditItems(docType));
			rd = application.getRequestDispatcher(ListPgName +"?act=List");
		} else if("insert".equals(act)) {
			boolean insSuc = insertFrmAuditItem(request);
			if(insSuc) {
				actMsg = "新增成功";
			} else {
				actMsg = "新增失敗";
			}
			request.setAttribute("docTypes", getDocTypes());
			request.setAttribute("frmAuditItems", getFrmAuditItems(""));
			rd = application.getRequestDispatcher(ListPgName +"?act=List");
		} else if("update".equals(act)) {
			boolean updSuc = updateFrmAuditItem(request);
			if(updSuc) {
				actMsg = "修改成功";
			} else {
				actMsg = "修改失敗";
			}
			request.setAttribute("docTypes", getDocTypes());
			request.setAttribute("frmAuditItems", getFrmAuditItems(""));
			rd = application.getRequestDispatcher(ListPgName +"?act=List");
		} else if("delete".equals(act)) {
			boolean delSuc = deleteFrmAuditItem(request);
			if(delSuc) {
				actMsg = "刪除成功";
			} else {
				actMsg = "刪除失敗";
			}
			request.setAttribute("docTypes", getDocTypes());
			request.setAttribute("frmAuditItems", getFrmAuditItems(""));
			rd = application.getRequestDispatcher(ListPgName +"?act=List");
		} else if("cancel".equals(act)) {
			request.setAttribute("docTypes", getDocTypes());
			request.setAttribute("frmAuditItems", getFrmAuditItems(""));
			rd = application.getRequestDispatcher(ListPgName +"?act=List");
		} else if("back".equals(act)) {
			request.setAttribute("docTypes", getDocTypes());
			request.setAttribute("frmAuditItems", getFrmAuditItems(""));
			rd = application.getRequestDispatcher(ListPgName +"?act=List");
		}
	}
	
	
	request.setAttribute("act" , act);
	request.setAttribute("actMsg" , actMsg);
%>
<%@include file="./include/Tail.include" %>
<%!
	private final static String report_no = "FL003W" ;
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";
	private final static String ListPgName = "/pages/" + report_no + "_List.jsp";
	private final static String EditPgName = "/pages/" + report_no + "_Edit.jsp";
	
	private List getDocTypes() {
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT cmuse_id,cmuse_name FROM cdshareno WHERE cmuse_div = '048' ");
		List paramList = new ArrayList();
		List dbData = DBManager.QueryDB_SQLParam(sql.toString() , paramList , "");
		return dbData;
	}
	
	private List getAuditTypes() {
		StringBuffer sql = new StringBuffer();
		sql.append(" select cmuse_id , cmuse_name from cdshareno where cmuse_div = '049' ");
		
		List paramList = new ArrayList();
		List dbData = DBManager.QueryDB_SQLParam(sql.toString() , paramList , "");
		return dbData;
	}
	
	private List getFrmAuditItems(String docType) {
		StringBuffer sql = new StringBuffer();
		sql.append(" select                                                                 ");
		sql.append(" doc_type,                                                              ");
		sql.append(" cdshareno.cmuse_name as doc_type_name,                                 ");
		sql.append(" audit_type,                                                            ");
		sql.append(" cdshareno1.cmuse_name as audit_type_name,                              ");
		sql.append(" audit_id,                                                              ");
		sql.append(" audit_case                                                             ");
		sql.append(" from frm_audit_item                                                    ");
		sql.append(" left join (select * from cdshareno where cmuse_div='048') cdshareno on  ");
		sql.append("  frm_audit_item.doc_type = cdshareno.cmuse_id                          ");
		sql.append(" left join (select * from cdshareno where cmuse_div='049') cdshareno1 on ");
		sql.append("  frm_audit_item.audit_type = cdshareno1.cmuse_id                       ");
		sql.append(" where 1 = 1                                                            ");
		List paramList = new ArrayList();
		if(!"".equals(docType)) {
			sql.append(" and doc_type = ?                                                   ");
			paramList.add(docType);
		}
		sql.append(" order by doc_type,audit_type,audit_id                                  ");
		List dbData = DBManager.QueryDB_SQLParam(sql.toString() , paramList , "");
		return dbData;
	}
	
	private boolean insertFrmAuditItem(HttpServletRequest request) {
		String docType = Utility.getTrimString(request.getParameter("docType"));
		String auditType = Utility.getTrimString(request.getParameter("auditType"));
		String auditCase = Utility.getTrimString(request.getParameter("auditCase"));
		
		StringBuffer sql = new StringBuffer();
		sql.append(" Insert into FRM_AUDIT_ITEM (DOC_TYPE,AUDIT_TYPE,AUDIT_ID,          ");
		sql.append(" AUDIT_CASE,INPUT_ORDER,OUTPUT_ORDER,USER_ID,USER_NAME,UPDATE_DATE) ");
		sql.append(" values(? , ? , ? , ? , ? , ? , ? , ? , sysdate)                    ");

		List paramList = new ArrayList();
		paramList.add(docType);
		paramList.add(auditType);
		paramList.add(getMaxAuditId(docType , auditType));
		paramList.add(auditCase);
		paramList.add("");
		paramList.add("");
		paramList.add(Utility.getTrimString(request.getSession().getAttribute("muser_id")));
		paramList.add(Utility.getTrimString(request.getSession().getAttribute("muser_name")));
		
		return doUpdate(sql.toString() , paramList);
	}
	
	private boolean updateFrmAuditItem(HttpServletRequest request) {
		String docType = Utility.getTrimString(request.getParameter("docType"));
		String auditType = Utility.getTrimString(request.getParameter("auditType"));
		String auditId = Utility.getTrimString(request.getParameter("auditId"));
		String auditCase = Utility.getTrimString(request.getParameter("auditCase"));
		String auditTypeHidden = Utility.getTrimString(request.getParameter("auditTypeHidden"));
		String auditIdHidden = Utility.getTrimString(request.getParameter("auditIdHidden"));
		
		StringBuffer sql = new StringBuffer();
		sql.append(" update FRM_AUDIT_ITEM set AUDIT_TYPE = ? , AUDIT_ID = ? , AUDIT_CASE = ? , ");
		sql.append(" USER_ID = ? , USER_NAME = ? , UPDATE_DATE = sysdate                        ");
		sql.append(" where DOC_TYPE = ? and AUDIT_TYPE = ? and AUDIT_ID = ?                     ");

		List paramList = new ArrayList();
		paramList.add(auditType);
		paramList.add(auditId);
		paramList.add(auditCase);
		paramList.add(Utility.getTrimString(request.getSession().getAttribute("muser_id")));
		paramList.add(Utility.getTrimString(request.getSession().getAttribute("muser_name")));
		paramList.add(docType);
		paramList.add(auditTypeHidden);
		paramList.add(auditIdHidden);
		
		return doUpdate(sql.toString() , paramList);
	}
	
	private boolean deleteFrmAuditItem(HttpServletRequest request) {
		StringBuffer sql = new StringBuffer();
		sql.append(" delete FRM_AUDIT_ITEM where DOC_TYPE = ? ");
		
		List paramList = new ArrayList();
		paramList.add(Utility.getTrimString(request.getParameter("docType")));
		
		String auditType = Utility.getTrimString(request.getParameter("auditType"));
		if(!"".equals(auditType)) {
			sql.append(" and AUDIT_TYPE = ? ");
			paramList.add(Utility.getTrimString(request.getParameter("auditType")));
		}
		String auditId = Utility.getTrimString(request.getParameter("auditId"));
		if(!"".equals(auditId)) {
			sql.append(" and AUDIT_ID = ? ");
			paramList.add(Utility.getTrimString(request.getParameter("auditId")));
		}
		
		return doUpdate(sql.toString() , paramList);
	}
	
	private String getMaxAuditId(String docType , String auditType) {
		String maxAuditId = "";
		StringBuffer sql = new StringBuffer();
		sql.append(" select audit_type ||                                                        ");
		sql.append("  to_char(max(to_number(substr(audit_id,2,length(audit_id))))+1) as audit_id "); 
		sql.append(" from frm_audit_item                                                         ");
		sql.append(" where doc_type = ?                                                          ");
		sql.append(" and audit_type = ?                                                          ");
		sql.append(" group by audit_type                                                         ");
		
		List paramList = new ArrayList();
		paramList.add(docType);
		paramList.add(auditType);
		
		List dbData = DBManager.QueryDB_SQLParam(sql.toString() , paramList , "");
		if(!dbData.isEmpty()) {
			DataObject bean = (DataObject) dbData.get(0);
			maxAuditId = Utility.getTrimString(bean.getValue("audit_id"));
		}
		return maxAuditId;
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
%>