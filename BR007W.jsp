<%
//94.01.26 create by 2295 
//94.01.31 add 權限 by 2295
//94.03.24 add 營運中/已裁撤 by 2295
//102.06.27 add 操作歷程寫入log by2968
//108.05.31 add 報表格式轉換 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<%
	RequestDispatcher rd = null;
	String actMsg = "";	
	String alertMsg = "";	
	String webURL_Y = "";	
	String webURL_N = "";		
	boolean doProcess = false;	
	//取得session資料,取得成功時,才繼續往下執行===================================================
	if(session.getAttribute("muser_id") == null){//session timeout		
      System.out.println("FX001W login timeout");   
	   rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );         	   
	   try{
          rd.forward(request,response);
       }catch(Exception e){
          System.out.println("forward Error:"+e+e.getMessage());
       }
    }else{
      doProcess = true;
    }    
	if(doProcess){//若muser_id資料時,表示登入成功====================================================================	
	
	//登入者資訊	
	String lguser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");		
	String lguser_name = ( session.getAttribute("muser_name")==null ) ? "" : (String)session.getAttribute("muser_name");		
	String lguser_type = ( session.getAttribute("muser_type")==null ) ? "" : (String)session.getAttribute("muser_type");						
	//======================================================================================================================
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");			    	
	String hsien_id = ( request.getParameter("HSIEN_ID")==null ) ? "" : (String)request.getParameter("HSIEN_ID");			    	
	//94.03.24 add 營運中/已裁撤==================================================================
	String cancel_no = ( request.getParameter("CANCEL_NO")==null ) ? "N" : (String)request.getParameter("CANCEL_NO");	
	//====================================================================================================	
	String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");			    	
	String firstStatus = ( request.getParameter("firstStatus")==null ) ? "" : (String)request.getParameter("firstStatus");			    	
	System.out.println("act="+act);
	if(firstStatus.equals("true")){//若從Menu點選時,先清空session裡的資料
	   session.setAttribute("CANCEL_NO",null);   
	   session.setAttribute("HSIEN_ID",null);   
	   session.setAttribute("BankList",null);    	
	   session.setAttribute("btnFieldList",null);	
	   session.setAttribute("SortList",null);   	   
	   session.setAttribute("SortBy",null);   
	   session.setAttribute("excelaction",null);   
	   session.setAttribute("nowbank_type",null);   
	   session.setAttribute("position_code",null);
	   session.setAttribute("printStyle",null); //108.05.31 add
	}
    if(!CheckPermission(request)){//無權限時,導向到LoginError.jsp
        rd = application.getRequestDispatcher( LoginErrorPgName );        
    }else{            
    	//set next jsp 	    	            	
    	if(request.getParameter("bank_type") != null && !((String)request.getParameter("bank_type")).equals("")){
           session.setAttribute("nowbank_type",(String)request.getParameter("bank_type"));   
        }
    	//輸出格式 108.05.31 add
    	if(request.getParameter("printStyle") != null && !((String)request.getParameter("printStyle")).equals("")){
            session.setAttribute("printStyle",(String)request.getParameter("printStyle"));   
         }
        //=================================================================================================        
        if(act.equals("Qry")){//報表查詢條件
        	rd = application.getRequestDispatcher( RptQryPgName );         
        }else if(act.equals("createRpt")){//產生Excel報表            
            String excelAction = ( request.getParameter("excelaction")==null ) ? "" : (String)request.getParameter("excelaction");			    	
            this.InsertWlXOPERATE_LOG(request,lguser_id,report_no,"P");
        	rd = application.getRequestDispatcher( RptCreatePgName +"?act="+excelAction+"&hsien_id="+hsien_id+"&cancel_no="+cancel_no);         
        }        
    	request.setAttribute("actMsg",actMsg);    
    	request.setAttribute("alertMsg",alertMsg);
    	request.setAttribute("webURL_Y",webURL_Y);
    	request.setAttribute("webURL_N",webURL_N);   
    }        
     
%>

<%
	try {
        //forward to next present jsp
        rd.forward(request, response);
    } catch (NullPointerException npe) {
    }
    }//end of doProcess
%>


<%!
	private final static String report_no = "BR007W";
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";        
    private final static String RptQryPgName = "/pages/"+report_no+"_Qry.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    private boolean CheckPermission(HttpServletRequest request){//檢核權限    	        		
    	    boolean CheckOK=false;
    	    HttpSession session = request.getSession();            
            Properties permission = ( session.getAttribute("BR007W")==null ) ? new Properties() : (Properties)session.getAttribute("BR007W");				                
            if(permission == null){
              System.out.println("BR007W.permission == null");
            }else{
               System.out.println("BR007W.permission.size ="+permission.size());
               
            }
            //只要有Query的權限,就可以進入畫面
        	if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){            
        	   CheckOK = true;//Query
        	}
        	System.out.println("CheckOk="+CheckOK);        	
        	return CheckOK;    
    }
    public String InsertWlXOPERATE_LOG(HttpServletRequest request,String lguser_id,String program_id,String update_type) throws Exception{    	
		StringBuffer sqlCmd = new StringBuffer();
		List paramList = new ArrayList() ;
		String errMsg="";
	    try {
	        sqlCmd.append(" INSERT INTO WlXOPERATE_LOG(muser_id,use_Date,program_id,ip_address,update_type)");
	        sqlCmd.append("                     VALUES(?,sysdate,?,?,?) ");
	        paramList.add(lguser_id);
	        paramList.add(program_id);
	        paramList.add(request.getRemoteAddr());//ipAddress
	        paramList.add(update_type);//操作類別 I-新增，U-異動，D-刪除，Q-明細，P-列印
	        if(this.updDbUsesPreparedStatement(sqlCmd.toString(),paramList)){
				errMsg = errMsg + "相關資料寫入資料庫成功";					
			}else{
			    errMsg = errMsg + "相關資料寫入log失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
			}
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入log失敗";						
		}	

		return errMsg;
	}
    private boolean updDbUsesPreparedStatement(String sql ,List paramList) throws Exception{
		List updateDBList = new ArrayList();//0:sql 1:data
	    List updateDBSqlList = new ArrayList();//欲執行updatedb的sql list
		List updateDBDataList = new ArrayList();//儲存參數的List
		
		updateDBDataList.add(paramList);
		updateDBSqlList.add(sql);
		updateDBSqlList.add(updateDBDataList);
		updateDBList.add(updateDBSqlList);
		return DBManager.updateDB_ps(updateDBList) ;
	}
%>    