<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>
<%
	String pgId = "FL001W";
	String loanItem = Utility.getTrimString(request.getParameter("loanItem"));
	String loanItemName = Utility.getTrimString(request.getParameter("loanItemName"));
	String subitem = Utility.getTrimString(request.getParameter("subitem"));
	String subitemName = Utility.getTrimString(request.getParameter("subitemName"));
	String startDate = Utility.getTrimString(request.getParameter("startDate"));
	
	//無權限時,導向到LoginError.jsp
	if(!Utility.CheckPermission(request,report_no)){
		rd = application.getRequestDispatcher( LoginErrorPgName ); 
	} else {
// 		actMsg = Utility.getTrimString(request.getAttribute("actMsg"));
		if("List".equals(act)) {
			request.setAttribute("frmLoanItems", getFrmLoanItem());
			rd = application.getRequestDispatcher(ListPgName +"?act=List");
		} else if("SubList".equals(act)) {
			request.setAttribute("loanItem", loanItem);
			request.setAttribute("loanItemName", loanItemName);
			List subFrmLoanItems = getSubFrmLoanItem(loanItem);
			request.setAttribute("subFrmLoanItems", subFrmLoanItems);
			request.setAttribute("detailList", getAllDetailList(subFrmLoanItems));
			
			rd = application.getRequestDispatcher(SubListPgName +"?act=SubList");
		} else if("showDetailList".equals(act)) {
			request.setAttribute("loanItem", loanItem);
			request.setAttribute("loanItemName", loanItemName);
			request.setAttribute("subFrmLoanItems", getSubFrmLoanItem(loanItem));
			request.setAttribute("detailList", getDetailList(loanItem , subitem));
			rd = application.getRequestDispatcher(SubListPgName +"?act=showDetailList");
		} else if("showEditPage".equals(act)) {
			request.setAttribute("loanItem", loanItem);
			request.setAttribute("loanItemName", loanItemName);
			request.setAttribute("subitem", subitem);
			request.setAttribute("frmLoanSubitem", getFrmLoanSubitem(loanItem , subitem , startDate));
			rd = application.getRequestDispatcher(EditPgName +"?act=showEditPage");
		} else if("goInsertPage".equals(act)) {
			request.setAttribute("loanItem", loanItem);
			request.setAttribute("loanItemName", loanItemName);
			rd = application.getRequestDispatcher(EditPgName +"?act=goInsertPage");
		} else if("goInsertRagePage".equals(act)) {
			request.setAttribute("loanItem", loanItem);
			request.setAttribute("loanItemName", loanItemName);
			request.setAttribute("subitem", subitem);
			request.setAttribute("subitemName", subitemName);
			rd = application.getRequestDispatcher(EditPgName +"?act=goInsertRagePage");
		} else if("insert".equals(act)) {
			boolean insSuc = insertFrmLoanSubitem(request);
			if(insSuc) {
				actMsg = "新增成功";
			} else {
				actMsg = "新增失敗";
			}
			String operationVal = Utility.getTrimString(request.getParameter("operation"));
			if("goInsertRagePage".equals(operationVal)) {
				request.setAttribute("loanItem", loanItem);
				request.setAttribute("loanItemName", loanItemName);
				List subFrmLoanItems = getSubFrmLoanItem(loanItem);
				request.setAttribute("subFrmLoanItems", subFrmLoanItems);
				request.setAttribute("detailList", getAllDetailList(subFrmLoanItems));
				rd = application.getRequestDispatcher(SubListPgName +"?act=showDetailList");
			} else {
				request.setAttribute("loanItem", loanItem);
				request.setAttribute("loanItemName", loanItemName);
				List subFrmLoanItems = getSubFrmLoanItem(loanItem);
				request.setAttribute("subFrmLoanItems", subFrmLoanItems);
				request.setAttribute("detailList", getAllDetailList(subFrmLoanItems));
				rd = application.getRequestDispatcher(SubListPgName +"?act=SubList");
			}
		} else if("update".equals(act)) {
			boolean updSuc = updateFrmLoanSubitem(request);
			if(updSuc) {
				actMsg = "修改成功";
			} else {
				actMsg = "修改失敗";
			}
			request.setAttribute("loanItem", loanItem);
			request.setAttribute("loanItemName", loanItemName);
			List subFrmLoanItems = getSubFrmLoanItem(loanItem);
			request.setAttribute("subFrmLoanItems", subFrmLoanItems);
			request.setAttribute("detailList", getAllDetailList(subFrmLoanItems));
			rd = application.getRequestDispatcher(SubListPgName +"?act=showDetailList");
		} else if("delete".equals(act)) {
			boolean updSuc = deleteFrmLoanSubitem(request);
			if(updSuc) {
				actMsg = "刪除成功";
			} else {
				actMsg = "刪除失敗";
			}
			request.setAttribute("loanItem", loanItem);
			request.setAttribute("loanItemName", loanItemName);
			List subFrmLoanItems = getSubFrmLoanItem(loanItem);
			request.setAttribute("subFrmLoanItems", subFrmLoanItems);
			request.setAttribute("detailList", getAllDetailList(subFrmLoanItems));
			rd = application.getRequestDispatcher(SubListPgName +"?act=showDetailList");
		} else if("cancel".equals(act)) {
			request.setAttribute("loanItem", loanItem);
			request.setAttribute("loanItemName", loanItemName);
			List subFrmLoanItems = getSubFrmLoanItem(loanItem);
			request.setAttribute("subFrmLoanItems", subFrmLoanItems);
			request.setAttribute("detailList", getAllDetailList(subFrmLoanItems));
			rd = application.getRequestDispatcher(SubListPgName +"?act=SubList");
		} else if("back".equals(act)) {
			System.out.println("############### loanItem : " + loanItem + " , loanItemName : " + loanItemName);
			request.setAttribute("loanItem", loanItem);
			request.setAttribute("loanItemName", loanItemName);
			List subFrmLoanItems = getSubFrmLoanItem(loanItem);
			request.setAttribute("subFrmLoanItems", subFrmLoanItems);
			request.setAttribute("detailList", getAllDetailList(subFrmLoanItems));
			rd = application.getRequestDispatcher(SubListPgName +"?act=SubList");
		}
	}
	request.setAttribute("act",act);
	request.setAttribute("actMsg",actMsg);
%>
<%@include file="./include/Tail.include" %>
<%!
	private final static String report_no = "FL001W" ;
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";
	private final static String ListPgName = "/pages/" + report_no + "_List.jsp";
	private final static String SubListPgName = "/pages/" + report_no + "_SubList.jsp";
	private final static String EditPgName = "/pages/" + report_no + "_Edit.jsp";
	
	private List getFrmLoanItem() {
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT loan_item , loan_item_name FROM frm_loan_item ");
		List paramList = new ArrayList();
		List dbData = DBManager.QueryDB_SQLParam(sql.toString() , paramList , "");
		return dbData;
	}
	
	private List getSubFrmLoanItem(String loanItem) {
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT A.loan_item ,A.SUBITEM , A.SUBITEM_NAME               ");
		sql.append(" FROM                                                         ");
		sql.append("   (SELECT frm_loan_subitem.loan_item loan_item ,             ");
		sql.append("     subitem,                                                 ");
		sql.append("     loan_item_name,                                          ");
		sql.append("     subitem_name,                                            ");
		sql.append("     start_date,                                              ");
		sql.append("     loan_rate,                                               ");
		sql.append("     base_rate,                                               ");
		sql.append("     agbase_rate                                              ");
		sql.append("   FROM frm_loan_subitem                                      ");
		sql.append("   LEFT JOIN frm_loan_item                                    ");
		sql.append("   ON frm_loan_subitem.loan_item    = frm_loan_item.loan_item ");
		sql.append("   WHERE frm_loan_subitem.loan_item = ?                       ");
		sql.append("   ORDER BY subitem ASC,                                      ");
		sql.append("     start_date DESC                                          ");
		sql.append("   ) A                                                        ");
		sql.append(" GROUP BY A.loan_item , A.subitem , A.subitem_name            ");
		sql.append(" ORDER BY A.subitem ASC                                       ");
		
		List paramList = new ArrayList();
		paramList.add(loanItem);
		
		List dbData = DBManager.QueryDB_SQLParam(sql.toString() , paramList , "");
		return dbData;
	}
	
	private List getAllDetailList(List subFrmLoanItems) {
		List details = new LinkedList();
		if(!subFrmLoanItems.isEmpty()) {
			for(int i = 0 ; i < subFrmLoanItems.size() ; i++ ) {
				DataObject bean = (DataObject) subFrmLoanItems.get(i);
				String loanItem = Utility.getTrimString(bean.getValue("loan_item"));
				String subitem = Utility.getTrimString(bean.getValue("subitem"));
				details.addAll(getDetailList(loanItem , subitem));
			}
		}
		return details;
	}
	
	private List getDetailList(String loanItem , String subitem) {
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT frm_loan_subitem.loan_item loan_item ,              ");
		sql.append("   subitem,                                                 ");
		sql.append("   loan_item_name,                                          ");
		sql.append("   subitem_name,                                            ");
		sql.append("   TO_CHAR(start_date, 'YYYY/MM/DD') start_date ,           ");
		sql.append("   TO_CHAR(loan_rate) loan_rate,                            ");
		sql.append("   TO_CHAR(base_rate) base_rate,                            ");
		sql.append("   TO_CHAR(agbase_rate) agbase_rate                         ");
		sql.append(" FROM frm_loan_subitem                                      ");
		sql.append(" LEFT JOIN frm_loan_item                                    ");
		sql.append(" ON frm_loan_subitem.loan_item    = frm_loan_item.loan_item ");
		sql.append(" WHERE frm_loan_subitem.loan_item = ?                       ");
		sql.append(" AND frm_loan_subitem.subitem     = ?                       ");
		sql.append(" ORDER BY subitem ASC, start_date DESC                      ");
		
		List paramList = new ArrayList();
		paramList.add(loanItem);
		paramList.add(subitem);
		//db欄位是number的還要to_char，不然就是加在第三個參數，如下
// 		DBManager.QueryDB_SQLParam(sql.toString(),paramList,"loan_rate,base_rate,agbase_rate");
		List dbData = DBManager.QueryDB_SQLParam(sql.toString() , paramList , "");
		return dbData;
	}
	
	private Map getFrmLoanSubitem(String loanItem , String subitem , String startDate) {
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT frm_loan_subitem.loan_item loan_item ,              ");
		sql.append("   subitem,                                                 ");
		sql.append("   loan_item_name,                                          ");
		sql.append("   subitem_name,                                            ");
		sql.append("   TO_CHAR(start_date, 'YYYY/MM/DD') start_date ,           ");
// 		sql.append("   loan_rate ,                                              ");
// 		sql.append("   base_rate ,                                              ");
// 		sql.append("   agbase_rate                                              ");
		sql.append("   TO_CHAR(loan_rate) loan_rate,                            ");
		sql.append("   TO_CHAR(base_rate) base_rate,                            ");
		sql.append("   TO_CHAR(agbase_rate) agbase_rate                         ");
		sql.append(" FROM frm_loan_subitem                                      ");
		sql.append(" LEFT JOIN frm_loan_item                                    ");
		sql.append(" ON frm_loan_subitem.loan_item    = frm_loan_item.loan_item ");
		sql.append(" WHERE frm_loan_subitem.loan_item = ?                       ");
		sql.append(" AND frm_loan_subitem.subitem     = ?                       ");
		sql.append(" AND START_DATE  = TO_DATE(? ,'YYYY/MM/DD')                 ");
		sql.append(" ORDER BY subitem ASC, start_date DESC                      ");
		
		List paramList = new ArrayList();
		paramList.add(loanItem);
		paramList.add(subitem);
		paramList.add(startDate);
		
		Map<String , String> frmLoanSubitem = new HashMap<String,String>();
		//db欄位是number的還要to_char，不然就是加在第三個參數，如下
		List dbData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"");
		if(!dbData.isEmpty()) {
			DataObject bean = (DataObject) dbData.get(0);
			frmLoanSubitem.put("loan_item", Utility.getTrimString(bean.getValue("loan_item")));
			frmLoanSubitem.put("subitem", Utility.getTrimString(bean.getValue("subitem")));
			frmLoanSubitem.put("loan_item_name", Utility.getTrimString(bean.getValue("loan_item_name")));
			frmLoanSubitem.put("subitem_name", Utility.getTrimString(bean.getValue("subitem_name")));
			String tempDate = Utility.getTrimString(bean.getValue("start_date"));
			tempDate = Utility.getCHTdate(tempDate, 0);
			frmLoanSubitem.put("start_date", tempDate.replace("/", ""));
			frmLoanSubitem.put("loan_rate", Utility.getTrimString(bean.getValue("loan_rate")));
			frmLoanSubitem.put("base_rate", Utility.getTrimString(bean.getValue("base_rate")));
			frmLoanSubitem.put("agbase_rate", Utility.getTrimString(bean.getValue("agbase_rate")));
		}
		return frmLoanSubitem;
	}
	
	private boolean insertFrmLoanSubitem(HttpServletRequest request ) {
		StringBuffer sql = new StringBuffer();
		sql.append(" insert into                                            ");
		sql.append(" frm_loan_subitem (LOAN_ITEM , SUBITEM , SUBITEM_NAME , "); 
		sql.append("  START_DATE , LOAN_RATE , BASE_RATE , AGBASE_RATE , USER_ID , USER_NAME , UPDATE_DATE )    ");
		sql.append(" values (? , ? , ? , TO_DATE(? ,'YYYYMMDD') , ? , ? , ? , ? , ? , sysdate )              ");
		
		List paramList = new ArrayList();
		String loanItem = Utility.getTrimString(request.getParameter("loanItem"));
		paramList.add(loanItem);
		String operationVal = Utility.getTrimString(request.getParameter("operation"));
		if("goInsertPage".equals(operationVal)) {
			paramList.add(getMaxSubitem(loanItem));
		} else if("goInsertRagePage".equals(operationVal)) {
			paramList.add(Utility.getTrimString(request.getParameter("subitem")));
		}
		paramList.add(Utility.getTrimString(request.getParameter("subitemName")));
// 		paramList.add("TO_DATE(" + Utility.getTrimString(request.getParameter("startDate")) + ",'YYYYMMDD')");
		paramList.add(Utility.getTrimString(request.getParameter("startDate")));
		paramList.add(Utility.getTrimString(request.getParameter("loanRate")));
		paramList.add(Utility.getTrimString(request.getParameter("baseRate")));
		paramList.add(Utility.getTrimString(request.getParameter("agbaseRate")));
		paramList.add(Utility.getTrimString(request.getSession().getAttribute("muser_id")));
		paramList.add(Utility.getTrimString(request.getSession().getAttribute("muser_name")));
		
		
		return doUpdate(sql.toString() , paramList);
	}
	
	private boolean updateFrmLoanSubitem(HttpServletRequest request ) {
		StringBuffer sql = new StringBuffer();
		sql.append(" UPDATE frm_loan_subitem                      ");
		sql.append(" SET LOAN_RATE   = ? ,                        ");
		sql.append("   BASE_RATE     = ? ,                        ");
		sql.append("   AGBASE_RATE   = ? ,                        ");
		sql.append("   START_DATE    = TO_DATE(? ,'YYYYMMDD') ,   ");
		sql.append("   USER_ID       = ? ,                        ");
		sql.append("   USER_NAME     = ? ,                        ");
		sql.append("   UPDATE_DATE   = sysdate                    ");
		sql.append(" WHERE LOAN_ITEM = ?                          ");
		sql.append(" AND SUBITEM     = ?                          ");
		sql.append(" AND START_DATE  = TO_DATE(? ,'YYYYMMDD')     ");
		
		List paramList = new ArrayList();
		paramList.add(Utility.getTrimString(request.getParameter("loanRate")));
		paramList.add(Utility.getTrimString(request.getParameter("baseRate")));
		paramList.add(Utility.getTrimString(request.getParameter("agbaseRate")));
		paramList.add(Utility.getTrimString(request.getParameter("startDate")));
		paramList.add(Utility.getTrimString(request.getSession().getAttribute("muser_id")));
		paramList.add(Utility.getTrimString(request.getSession().getAttribute("muser_name")));
		paramList.add(Utility.getTrimString(request.getParameter("loanItem")));
		paramList.add(Utility.getTrimString(request.getParameter("subitem")));
		paramList.add(Utility.getTrimString(request.getParameter("startDateHidden")));
		
		return doUpdate(sql.toString() , paramList);
	}
	
	private boolean deleteFrmLoanSubitem(HttpServletRequest request ) {
		StringBuffer sql = new StringBuffer();
		sql.append(" DELETE frm_loan_subitem                    ");
		sql.append(" WHERE LOAN_ITEM = ?                        ");
		sql.append(" AND SUBITEM     = ?                        ");
		sql.append(" AND START_DATE  = TO_DATE(? ,'YYYY/MM/DD') ");
		
		List paramList = new ArrayList();
		paramList.add(Utility.getTrimString(request.getParameter("loanItem")));
		paramList.add(Utility.getTrimString(request.getParameter("subitem")));
		paramList.add(Utility.getTrimString(request.getParameter("startDate")));
		
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
	
	private String getMaxSubitem(String loanItem) {
		String maxSubitem = "";
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT TO_CHAR(NVL(LPAD(to_number(MAX(subitem))+1, 4, 0) , 1)) AS subitem ");
		sql.append(" FROM frm_loan_subitem                                            ");
		sql.append(" WHERE loan_item = ?                                              ");
		
		List paramList = new ArrayList();
		paramList.add(loanItem);
		
		List dbData = DBManager.QueryDB_SQLParam(sql.toString() , paramList , "");
		if(!dbData.isEmpty()) {
			DataObject bean = (DataObject) dbData.get(0);
			maxSubitem = Utility.getTrimString(bean.getValue("subitem"));
		}
		return maxSubitem;
	}
%>