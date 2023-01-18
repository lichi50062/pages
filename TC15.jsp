<%
//93.12.26 create by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>

<%
	System.out.println("date ="+request.getParameter("LAST_CHK_DATE"));
	System.out.println("year ="+request.getParameter("LAST_CHK_DATE_Y"));
	System.out.println("month ="+request.getParameter("LAST_CHK_DATE_M"));
	System.out.println("day ="+request.getParameter("LAST_CHK_DATE_D"));
	
	
	
	System.out.println("@@TC15.jsp Start...");
	RequestDispatcher rd = null;
	String actMsg = "";	
	String alertMsg = "";	
	String webURL = "";	
	//test for true deault is false
	boolean doProcess = true;	
	
	/*mark for test
	//取得session資料,取得成功時,才繼續往下執行===================================================
	if(session.getAttribute("muser_id") == null){//session timeout	
      System.out.println("TC15 login timeout");   
	   rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );         	   
	   try{
          rd.forward(request,response);
       }catch(Exception e){
          System.out.println("forward Error:"+e+e.getMessage());
       }
    }else{
      doProcess = true;
    }    */
	if(doProcess){//若muser_id資料時,表示登入成功====================================================================	

	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");			
	String nowact = ( request.getParameter("nowact")==null ) ? "" : (String)request.getParameter("nowact");			
	String bank_type = ( request.getParameter("BANK_TYPE")==null ) ? "" : (String)request.getParameter("BANK_TYPE");					
	String bank_kind = ( request.getParameter("BANK_KIND")==null ) ? "" : (String)request.getParameter("BANK_KIND");
	String bank_no = ( request.getParameter("BANK_NO")==null ) ? "" : (String)request.getParameter("BANK_NO");					
	String muser_id = ( request.getParameter("muser_id")==null ) ? "" : (String)request.getParameter("muser_id");
	String last_chk_date = ( request.getParameter("LAST_CHK_DATE")==null ) ? "" : (String)request.getParameter("LAST_CHK_DATE");
	
	System.out.println("act="+act);			
	System.out.println("nowact="+nowact);	
	System.out.println("bank_type="+bank_type);
	System.out.println("bank_kind="+bank_kind);
	System.out.println("bank_no="+bank_no);
	System.out.println("last_chk_date="+last_chk_date);
	
	/*
	String LAST_CHK_DATE_Y="";
	String LAST_CHK_DATE_M="";
	String LAST_CHK_DATE_D="";
	String LAST_CHK_DATE="";
	*/
			
	/*mark for test
	if(session.getAttribute("muser_id") == null){	
      System.out.println("TC15 login timeout");   
	  rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );         	   
      rd.forward(request,response);
    }*/
   
	//登入者資訊
	String lguser_id = ( session.getAttribute("muser_id")==null ) ? "001" : (String)session.getAttribute("muser_id");		
	String lguser_name = ( session.getAttribute("muser_name")==null ) ? "張建偉" : (String)session.getAttribute("muser_name");		
	String lguser_type = ( session.getAttribute("muser_type")==null ) ? "" : (String)session.getAttribute("muser_type");				
	
    if(!CheckPermission(request)){//無權限時,導向到LoginError.jsp
    	System.out.println("@@無權限時,導向到LoginError.jsp");
        //rd = application.getRequestDispatcher( LoginErrorPgName );        
    }else{            
    	//set next jsp 	    	
    	if(act.equals("new")){
           rd = application.getRequestDispatcher( EditPgName +"?act=new");                	
        }else if(act.equals("List")){
           rd = application.getRequestDispatcher( ListPgName +"?act=List");                	
        }else if(act.equals("Qry")){    	    	    
    	    List BA01List = getQryResult(bank_type,bank_no,bank_kind);    	    
    	    request.setAttribute("BA01List",BA01List);
    	    rd = application.getRequestDispatcher( ListPgName +"?act=Qry&bank_type="+bank_type+"&bank_no="+bank_no);            	        	        	    	    
    	}else if(act.equals("Edit")){
    		System.out.println("@@act equals Edit");    		
            List BA01 = getBA01(bank_no);
            System.out.println("@X tracert..1");
            request.setAttribute("BA01",BA01);
            System.out.println("@X tracert..2");
            if(BA01.size() != 0){    	       
               bank_type 				= (String)((DataObject)BA01.get(0)).getValue("bank_type");
               bank_no 					= (String)((DataObject)BA01.get(0)).getValue("bank_no");
               bank_kind 				= (String)((DataObject)BA01.get(0)).getValue("bank_kind");
               
               /*
               String bank_name 		= (String)((DataObject)BA01.get(0)).getValue("bank_name");
               String pbank_no 			= (String)((DataObject)BA01.get(0)).getValue("pbank_no");
               String exgrade 			= (String)((DataObject)BA01.get(0)).getValue("exgrade");
               String exrecent_date 	= (((DataObject)BA01.get(0)).getValue("exrecent_date")).toString();               
               System.out.println("getBA01取得bank_no="+bank_no);
               System.out.println("getBA01取得bank_name="+bank_name);
               System.out.println("getBA01取得bank_type="+bank_type);
               System.out.println("getBA01取得BANK_KIND="+bank_kind);
               System.out.println("getBA01取得PBANK_NO="+pbank_no);
               System.out.println("getBA01取得EXGRADE="+exgrade);
               System.out.println("getBA01取得EXRECENT_DATE="+exrecent_date);
               */
            }
            System.out.println("@X tracert..3");    
            //設定異動者資訊======================================================================
			request.setAttribute("maintainInfo","select * from BA01 WHERE bank_no='" + bank_no+"'");								       
			//=======================================================================================================================		   	    
    	 	rd = application.getRequestDispatcher( EditPgName +"?act=Edit&bank_type="+bank_type+"&bank_no="+bank_no);        
    	/*}else if(act.equals("Insert")){
    	    actMsg = InsertDB(request,lguser_id,lguser_name);    	    	        	    
        	rd = application.getRequestDispatcher( nextPgName );
        */      
        }else if(act.equals("Update")){
    	    actMsg = UpdateDB(request,lguser_id,lguser_name);    	    	        	    
        	rd = application.getRequestDispatcher( nextPgName );         
        /*}else if(act.equals("Delete")){
    	    actMsg = DeleteDB(request,lguser_id,lguser_name);    	    	        	    
        	rd = application.getRequestDispatcher( nextPgName );                 
        */
        }
    	request.setAttribute("actMsg",actMsg);    
    }        
     
%>

<%
	try {
        //forward to next present jsp
        rd.forward(request, response);
    } catch (NullPointerException npe) {
    }
    }//end of doProcess
    
    System.out.println("@@TC15 End...");
%>


<%!
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String EditPgName = "/pages/TC15_Edit.jsp";    
    private final static String ListPgName = "/pages/TC15_List.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    private boolean CheckPermission(HttpServletRequest request){//檢核權限    	    
    	    boolean CheckOK=true;
    	    /*
    	    HttpSession session = request.getSession();            
            Properties permission = ( session.getAttribute("TC15")==null ) ? new Properties() : (Properties)session.getAttribute("TC15");				                
            if(permission == null){
              System.out.println("TC15.permission == null");
            }else{
               System.out.println("TC15.permission.size ="+permission.size());
            }
            //只要有Query的權限,就可以進入畫面
        	if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){            
        	   CheckOK = true;//Query
        	}*/
        	return CheckOK;
    }           
    
    //取得BA01該總機構代號資料
    private List getBA01(String bank_no){
    		//查詢條件
    		System.out.println("@@Method getBA01 Start...");
    		List paramList = new ArrayList();
    		String sqlCmd = " select * from BA01 "
    					  + " where bank_no=?";  
    		paramList.add(bank_no);
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"exrecent_date,update_date");
            
            System.out.println("@@Method getBA01 End...");        
            return dbData;
    } 
    //取得查詢結果
    private List getQryResult(String bank_type,String bank_no,String bank_kind){
    		
    		System.out.println("@@Method getQryResult Start...");
    		System.out.println("@@帶入金融機構類別(bank_type)="+bank_type);
    		System.out.println("@@帶入金融機構代號(bank_no)="+bank_no);
    		System.out.println("@@帶入機構總類(bank_kind)="+bank_kind);
    		String sqlCmd = "";
    		
    		//查詢條件
    		sqlCmd = "select bank_no,bank_name,bank_kind,exgrade,exrecent_date "
				   + "from ba01 LEFT JOIN cdshareno on bank_type = cmuse_id and cmuse_div='020' ";				   
			if(!bank_no.equals("")){
			    sqlCmd = sqlCmd + "where ba01.bank_no like '"+bank_no+"%'";
			}else{	   
			  if(!bank_kind.equals("2")){//不為全部類別
			    sqlCmd = sqlCmd + "where bank_type='"+bank_type+"'" + " and bank_kind='"+bank_kind+"'";
			  }else {
			  	sqlCmd = sqlCmd + "where bank_type='"+bank_type+"'";
			  }
			} 
			sqlCmd = sqlCmd + "order by bank_type,bank_no ";
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,null,"");
            
            System.out.println("@@Method getQryResult End...");        
            return dbData;
    }
	
	private String UpdateDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{    	
		String sqlCmd = "";		
		String errMsg="";	
		String bank_type=((String)request.getParameter("BANK_TYPE")==null)?"":(String)request.getParameter("BANK_TYPE");
		String bank_no=((String)request.getParameter("BANK_NO")==null)?" ":(String)request.getParameter("BANK_NO");
		String bank_name=((String)request.getParameter("BANK_NAME")==null)?" ":(String)request.getParameter("BANK_NAME");
		String exGrade=((String)request.getParameter("EXGRADE")==null)?" ":(String)request.getParameter("EXGRADE");
		String last_chk_date=(String)request.getParameter("LAST_CHK_DATE");
		String add_user=lguser_id;
		String add_name=lguser_name;				
		String setup_date="";
		
		System.out.println("== UpdateDB Start ... ==");
		System.out.println("取得last_chk_date="+last_chk_date);
		
		try {
				List updateDBSqlList = new LinkedList();
				List paramList = new ArrayList();
				sqlCmd = "SELECT * FROM BA01 WHERE BANK_NO=?";					 
				paramList.add(bank_no); 
			    List data = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"exrecent_date,update_date");		 			    
				System.out.println("data.size="+data.size());
				
				if (data.size() == 0){
				    errMsg = errMsg + "此筆資料不存在無法修改<br>";
				}else{  
				    //=========================================================================
				    sqlCmd = "UPDATE BA01 SET "
						   + "EXGRADE='" + exGrade + "'" 
						   + ",EXRECENT_DATE= to_date('"+last_chk_date+"','YYYY/MM/DD')"
					       + ",USER_ID='" + add_user +"'"
					       + ",USER_NAME='" + add_name + "'"
					       + ",UPDATE_DATE=sysdate" 		            		 						       
						   + " where bank_no='"+bank_no+"'";				    	   
						   
		            updateDBSqlList.add(sqlCmd); 		  
						   
					if(DBManager.updateDB(updateDBSqlList)){					 
						errMsg = errMsg + "相關資料寫入資料庫成功";					
					}else{
				   		errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
					}
    	   		}
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗<br>[Exception Error]:<br>";						
		}	
		System.out.println("== UpdateDB End ... ==");
		return errMsg;
	} 
/*    
	public String InsertDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{	
		String sqlCmd = "";		
		String errMsg="";	
		String bank_type=((String)request.getParameter("BANK_TYPE")==null)?"":(String)request.getParameter("BANK_TYPE");
		String bank_no=((String)request.getParameter("BANK_NO")==null)?" ":(String)request.getParameter("BANK_NO");
		String bank_name=((String)request.getParameter("BANK_NAME")==null)?" ":(String)request.getParameter("BANK_NAME");
		String exGarde=((String)request.getParameter("EXGRADE")==null)?" ":(String)request.getParameter("EXGRADE");
		String last_chk_date=(String)request.getParameter("LASTCHK_DATE");
		
		String add_user=lguser_id;
		String add_name=lguser_name;				
		String setup_date="";
		
		System.out.println("@@Method InsertDB Start..");
		
		System.out.println("@@--------------------------------------");
		System.out.println("@@Inpute bank_type="+bank_type);
		System.out.println("@@Inpute bank_no="+bank_no);
		System.out.println("@@Inpute bank_name="+bank_name);
		System.out.println("@@Inpute exGarde="+exGarde);
		System.out.println("@@Inpute lastchk_date="+lastchk_date);
		System.out.println("@@Inpute add_user="+add_name);
		System.out.println("@@Inpute add_name="+add_name);
		System.out.println("@@--------------------------------------");
		
		try {
			    
			    List updateDBSqlList = new LinkedList();
			    
				sqlCmd = "SELECT * FROM EXGRADEF WHERE BANK_NO='" + bank_no + "'";					 
					 
			    List data = DBManager.QueryDB(sqlCmd,"setup_date,last_chk_date");		 			    
				System.out.println("data.size="+data.size());
				
				if (data.size() != 0){
				    errMsg = errMsg + "此筆總機構資料已存在無法新增<br>";
				}else{    			        
			        sqlCmd = "INSERT INTO EXGRADEF VALUES ('" + bank_no + "'"
					       + ",'" + exGarde + "'" 
					       + ",'" + setup_date + "'"
					       + ",'" + last_chk_date + "'" 
					       + ",'" + add_user + "'" 
					       + ",'" + add_name + "'"
					       + ",sysdate)";  		            		 						
   					updateDBSqlList.add(sqlCmd); 		            	
	            	
				    if(DBManager.updateDB(updateDBSqlList)){					 
					   errMsg = errMsg + "相關資料寫入資料庫成功";					
				    }else{
				 	   errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
				    }
				}    
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗<br>[Exception Error]:<br>";							
		}	
		System.out.println("@@Method InsertDB End..");
		return errMsg;
	} 
*/	

/*    
    private String DeleteDB(HttpServletRequest request,String lguser_id,String lguser_name) throws Exception{    	
		String sqlCmd = "";		
		String errMsg="";		
		String bank_no=((String)request.getParameter("BANK_NO")==null)?" ":(String)request.getParameter("BANK_NO");
		String user_id=lguser_id;
	    String user_name=lguser_name;
	    
		
		try {
				List updateDBSqlList = new LinkedList();
				//檢查是否有建立分支機構
				sqlCmd = "SELECT * FROM BA01 WHERE pbank_no='" + bank_no + "' and bank_kind='1'";					 					 
			    List data = DBManager.QueryDB(sqlCmd,"");		 			    
				System.out.println("BA01.size="+data.size());				
				if(data.size () != 0 ){
				   errMsg = errMsg + "已有分支機構,不可刪除<br>";
				}else{
				   sqlCmd = "SELECT * FROM BA01 WHERE bank_no='" + bank_no + "'";					 					 
			       data = DBManager.QueryDB(sqlCmd,"");		 			    
				   System.out.println("BA01.size="+data.size());				  
				   if (data.size() == 0){
				      errMsg = errMsg + "此筆資料不存在無法刪除<br>";
				   }else{    				   
				      //insert BN04_LOG===================================================		    				    
				      sqlCmd = " INSERT INTO BN04_LOG " 
						   + " select bank_no,bank_no,bank_name,bn_type,bank_type,"
						   + " add_user,add_name,add_date,bank_b_name,kind_1,kind_2,"
						   + " bn_type2,exchange_no,"
						   + " user_id,user_name,update_date"
						   + ",'"+user_id+"','"+user_name+"',sysdate"
						   + ",'0','D'"
						   + " from BA01"						  
						   + " WHERE bank_no='" + bank_no + "'"; 						   
					updateDBSqlList.add(sqlCmd);						
				    //=========================================================================
				    sqlCmd = "DELETE from BA01 where bank_no = '"+bank_no+"'";				    	 					       
		            updateDBSqlList.add(sqlCmd); 		            			    	   						   		            
		            sqlCmd = "DELETE from BA01 where bank_no = '"+bank_no+"'";				    	 					       
		            updateDBSqlList.add(sqlCmd); 
	            		
					if(DBManager.updateDB(updateDBSqlList)){					 
						errMsg = errMsg + "相關資料寫入資料庫成功";					
					}else{
				   		errMsg = errMsg + "相關資料寫入資料庫失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
					}
    	   		   }
    	   		}//end of 無分支機構
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗<br>[Exception Error]:<br>";							
		}	

		return errMsg;
	}
*/
%>    