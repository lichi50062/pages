<%
// 94.01.20 create by 2295 
// 94.01.31 add 權限 by 2295
// 94.03.23 add 營運中/已裁撤 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.BufferedOutputStream" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.PrintStream" %>
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
      System.out.println("FR0066WA login timeout");   
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
	}
    if(!CheckPermission(request)){//無權限時,導向到LoginError.jsp
        rd = application.getRequestDispatcher( LoginErrorPgName );        
    }else{            
    	//set next jsp 	
    	//將選取的縣市別,金融機構代碼,報表欄位,排序的報表欄位寫到session=======================================    
    	if(request.getParameter("BankList")	!= null && !((String)request.getParameter("BankList")).equals("")){
    	   session.setAttribute("BankList",(String)request.getParameter("BankList"));    	
    	}   
    	if(request.getParameter("btnFieldList")	!= null && !((String)request.getParameter("btnFieldList")).equals("")){
    	   session.setAttribute("btnFieldList",(String)request.getParameter("btnFieldList"));	
    	}
    	if(request.getParameter("SortList")	!= null && !((String)request.getParameter("SortList")).equals("")){
    	   System.out.println("FR0066WA.SortList="+(String)request.getParameter("SortList"));
           session.setAttribute("SortList",(String)request.getParameter("SortList"));   
        }
        //94.03.23 add 營運中/已裁撤=============================================================
        if(request.getParameter("CANCEL_NO") != null && !((String)request.getParameter("CANCEL_NO")).equals("")){
           session.setAttribute("CANCEL_NO",(String)request.getParameter("CANCEL_NO"));   
        }
        //=======================================================================================
        if(request.getParameter("HSIEN_ID")	!= null && !((String)request.getParameter("HSIEN_ID")).equals("")){
           session.setAttribute("HSIEN_ID",(String)request.getParameter("HSIEN_ID"));   
        }
        if(request.getParameter("SortBy")	!= null && !((String)request.getParameter("SortBy")).equals("")){
           session.setAttribute("SortBy",(String)request.getParameter("SortBy"));   
        }
        if(request.getParameter("excelaction")	!= null && !((String)request.getParameter("excelaction")).equals("")){
           session.setAttribute("excelaction",(String)request.getParameter("excelaction"));   
        }        
        if(request.getParameter("bank_type") != null && !((String)request.getParameter("bank_type")).equals("")){
           session.setAttribute("nowbank_type",(String)request.getParameter("bank_type"));   
        }
        //=================================================================================================
        if(act.equals("RptColumn")){//報表欄位              
			List FieldList = Utility.getFileData(Utility.getProperties("schemaDir")+System.getProperty("file.separator")+"FR0066WA.TXT");						
			String FieldListString = "";			
			for(int i=0;i<FieldList.size();i++){			    			    
			    FieldListString += Utility.ISOtoBig5((String)FieldList.get(i));
			    if(i < FieldList.size() - 1) FieldListString +=",";   
			}
			request.setAttribute("FieldList",FieldListString); 		
			System.out.println("FR0066WA.FieldList="+FieldListString);	
        	rd = application.getRequestDispatcher( RptColumnPgName );        
        }else if(act.equals("BankList")){//金融機構
            System.out.println("btnFieldList="+(String)request.getParameter("btnFieldList"));            
            rd = application.getRequestDispatcher( BankListPgName );        
    	}else if(act.equals("RptOrder")){//排序欄位       	     	       	        	    
        	rd = application.getRequestDispatcher( RptOrderPgName );         
        }else if(act.equals("RptStyle")){//報表格式            
        	rd = application.getRequestDispatcher( RptStylePgName );         
        }else if(act.equals("SaveRpt") || act.equals("ReadRpt")){//儲存格式檔|讀取格式檔        
            if(act.equals("SaveRpt")){//儲存格式檔
               actMsg = saveReport(request,lguser_id);            
               alertMsg = "儲存";
            }   
            if(act.equals("ReadRpt")){//讀取格式檔   
               actMsg = readReport(request,lguser_id);            
               alertMsg = "讀取";
            } 
			if(actMsg.equals("")){
				alertMsg += "報表格式成功";    	           	       	    	       	    
    	    }else{    	        
    	       	alertMsg += "報表格式失敗:"+actMsg;    	           	       	
    	       	actMsg = "";
    	    }
    	    webURL_Y = "/pages/FR0066WA.jsp?act=RptStyle";    	       	    	       	   	   			       
        	rd = application.getRequestDispatcher( nextPgName );         
        }else if(act.equals("createRpt")){//產生Excel報表
            String excelAction = (String)session.getAttribute("excelaction");
            rd = application.getRequestDispatcher( RptCreatePgName +"?act="+excelAction);         
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
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String BankListPgName = "/pages/FR0066WA_BankList.jsp";    
    private final static String RptColumnPgName = "/pages/FR0066WA_RptColumn.jsp";        
    private final static String RptOrderPgName = "/pages/FR0066WA_RptOrder.jsp";        
    private final static String RptStylePgName = "/pages/FR0066WA_RptStyle.jsp";        
    private final static String RptCreatePgName = "/pages/FR0066WA_Excel.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    private boolean CheckPermission(HttpServletRequest request){//檢核權限    	    
    		
    	    boolean CheckOK=false;
    	    HttpSession session = request.getSession();            
            Properties permission = ( session.getAttribute("AS002W")==null ) ? new Properties() : (Properties)session.getAttribute("AS002W");				                
            if(permission == null){
              System.out.println("FR0066WA.permission == null");
            }else{
               System.out.println("FR0066WA.permission.size ="+permission.size());
               
            }
            //只要有Query的權限,就可以進入畫面
        	if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){            
        	   CheckOK = true;//Query
        	}
        	System.out.println("CheckOk="+CheckOK);        	
        	return CheckOK;
    }   
    //儲存報表格式檔========================================================
    private String saveReport(HttpServletRequest request,String lguser_id){
    	HttpSession session = request.getSession();      
    	String actMsg = "";
    	try{
          		File profileDir = new File(Utility.getProperties("profileDir"));        
        		if(!profileDir.exists()){
        			if(!Utility.mkdirs(Utility.getProperties("profileDir"))){
        	   			actMsg = actMsg + Utility.getProperties("profileDir")+"目錄新增失敗";
         			}    
        		}
        		File savefile = new File(Utility.getProperties("profileDir")+System.getProperty("file.separator")+ lguser_id+"_FR0066WA.txt");
        		if(savefile.exists()) savefile.delete();
            	FileOutputStream fos = new FileOutputStream(Utility.getProperties("profileDir")+System.getProperty("file.separator")+ lguser_id+"_FR0066WA.txt");
				BufferedOutputStream bos = new BufferedOutputStream(fos);
				PrintStream ps = new PrintStream(bos);
				String cancel_no_data = "CANCEL_NO="+(String)session.getAttribute("CANCEL_NO");
				String hsien_id_data = "HSIEN_ID="+(String)session.getAttribute("HSIEN_ID");
				String BankList_data = "BankList="+(String)session.getAttribute("BankList");
				String SortList_data = "SortList="+(String)session.getAttribute("SortList");
				String SortBy_data = "SortBy="+(String)session.getAttribute("SortBy");
				String btnFieldList_data = "btnFieldList="+(String)session.getAttribute("btnFieldList");
				ps.println(cancel_no_data);
				ps.println(hsien_id_data);
				ps.println(BankList_data);
				ps.println(btnFieldList_data);
				ps.println(SortList_data);
				ps.println(SortBy_data);
				ps.close();
				bos.close();		
				fos.close();						
		}catch(Exception e){
				System.out.println("SaveReport Error:"+e+e.getMessage());
				actMsg += "SaveReport Error:"+e+e.getMessage();
		}
		return actMsg;
    } 
    //讀取報表格式檔========================================================
    private String readReport(HttpServletRequest request,String lguser_id){
    	String sztemp="";
    	String CANCEL_NO_file = "";
        String HSIEN_ID_file = "";
        String BankList_file = "";
        String btnFieldList_file = "";
        String SortList_file = "";
        String SortBy_file = "";
        
        String actMsg = "";
        HttpSession session = request.getSession();      
    	try{
    		File WorkFile = new File(Utility.getProperties("profileDir")+System.getProperty("file.separator")+ lguser_id+"_FR0066WA.txt");	        	
			if(WorkFile.exists()){			
				FileInputStream fis = new FileInputStream(Utility.getProperties("profileDir")+System.getProperty("file.separator")+ lguser_id+"_FR0066WA.txt");	
				BufferedInputStream bis = new BufferedInputStream(fis);
				DataInputStream dis = new DataInputStream(fis);							
				while((sztemp = dis.readLine()) != null){
				    sztemp = Utility.ISOtoBig5(sztemp);
				    if(sztemp.indexOf("CANCEL_NO=") != -1){
				       CANCEL_NO_file = sztemp.substring(sztemp.indexOf("CANCEL_NO=")+10,sztemp.length());				       
				    }
				    if(sztemp.indexOf("HSIEN_ID=") != -1){
				       HSIEN_ID_file = sztemp.substring(sztemp.indexOf("HSIEN_ID=")+9,sztemp.length());				       
				    }
				    if(sztemp.indexOf("BankList=") != -1){
				       BankList_file = sztemp.substring(sztemp.indexOf("BankList=")+9,sztemp.length());				       
				    }
				    if(sztemp.indexOf("btnFieldList=") != -1){
				       btnFieldList_file = sztemp.substring(sztemp.indexOf("btnFieldList=")+13,sztemp.length());				       
				    }	
				    if(sztemp.indexOf("SortList=") != -1){
				       SortList_file = sztemp.substring(sztemp.indexOf("SortList=")+9,sztemp.length());				       
				    }
				    if(sztemp.indexOf("SortBy=") != -1){
				       SortBy_file = sztemp.substring(sztemp.indexOf("SortBy=")+7,sztemp.length());				       
				    }
				    				
				}//end of while	
				System.out.println("CANCEL_NO_file="+CANCEL_NO_file);
				System.out.println("HSIEN_ID_file="+HSIEN_ID_file);
				System.out.println("BankList_file="+BankList_file);
				System.out.println("btnFieldList_file="+btnFieldList_file);
				System.out.println("SortList_file="+SortList_file);
				System.out.println("SortBy_file="+SortBy_file);
				
				session.setAttribute("CANCEL_NO",CANCEL_NO_file);
				session.setAttribute("HSIEN_ID",HSIEN_ID_file);
				session.setAttribute("BankList",BankList_file);
				session.setAttribute("btnFieldList",btnFieldList_file);		
				session.setAttribute("SortList",SortList_file);
				session.setAttribute("SortBy",SortBy_file);
				
			}else{//end of workfile exist
			   actMsg = "無已存之報表格式檔";
			}
		}catch(Exception e){
			System.out.println("readReport Error:"+e+e.getMessage());
			actMsg = "readReport Error:"+e+e.getMessage();			
		}	
		return actMsg;
    } 
%>    