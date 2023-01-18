<%
//94.01.25 create by 2295 
//94.01.31 add 權限 by 2295
//94.03.24 add 營運中/已裁撤 by 2295
//99.01.08 add 增加卸任與否 by 2295
//99.12.29 add 查詢日期for100年以後取得新縣市別.100年以前取得舊縣市別 by 2295
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
<%@include file="./include/Header.include" %>

<%
	String bank_type = Utility.getTrimString(dataMap.get("bank_type"));    
    String firstStatus = Utility.getTrimString(dataMap.get("firstStatus"));
	if(firstStatus.equals("true")){//若從Menu點選時,先清空session裡的資料
	   session.setAttribute("S_YEAR",null);//99.12.29 add
	   session.setAttribute("S_MONTH",null);//99.12.29 add
	   session.setAttribute("CANCEL_NO",null);   
	   session.setAttribute("HSIEN_ID",null);   
	   session.setAttribute("BankList",null);    	
	   session.setAttribute("btnFieldList",null);	
	   session.setAttribute("SortList",null);   	   
	   session.setAttribute("SortBy",null);   
	   session.setAttribute("excelaction",null);   
	   session.setAttribute("nowbank_type",null);   
	   session.setAttribute("position_code",null);  
	   session.setAttribute("abdicate_code",null);
	   session.setAttribute("printStyle",null); //108.05.31 add
	}
    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp//95.11.03 fix 使用Utility.CheckPermission檢核權限 by 2295
        rd = application.getRequestDispatcher( LoginErrorPgName );        
    }else{            
    	//set next jsp 	
    	//將選取的縣市別,金融機構代碼,報表欄位,排序的報表欄位寫到session=======================================    
    	if(!Utility.getTrimString(dataMap.get("BankList")).equals("")){
    	   session.setAttribute("BankList",(String)request.getParameter("BankList"));    	
    	}   
    	if(!Utility.getTrimString(dataMap.get("btnFieldList")).equals("")){
    	   session.setAttribute("btnFieldList",(String)request.getParameter("btnFieldList"));	
    	}
    	if(!Utility.getTrimString(dataMap.get("SortList")).equals("")){
    	   System.out.println(report_no+".SortList="+(String)request.getParameter("SortList"));
           session.setAttribute("SortList",(String)request.getParameter("SortList"));   
        }
        //94.03.24 add 營運中/已裁撤=============================================================
        if(!Utility.getTrimString(dataMap.get("CANCEL_NO")).equals("")){
           session.setAttribute("CANCEL_NO",(String)request.getParameter("CANCEL_NO"));   
        }
        //=======================================================================================
        //99.12.29 add 查詢日期====================================================================
        if(!Utility.getTrimString(dataMap.get("S_YEAR")).equals("")){
           session.setAttribute("S_YEAR",(String)request.getParameter("S_YEAR"));   
        }
        if(!Utility.getTrimString(dataMap.get("S_MONTH")).equals("")){
           session.setAttribute("S_MONTH",(String)request.getParameter("S_MONTH"));   
        }    
        //========================================================================================
        if(!Utility.getTrimString(dataMap.get("HSIEN_ID")).equals("")){
           session.setAttribute("HSIEN_ID",(String)request.getParameter("HSIEN_ID"));   
        }
        if(!Utility.getTrimString(dataMap.get("POSITION_CODE")).equals("")){        
           session.setAttribute("position_code",(String)request.getParameter("POSITION_CODE"));   
        }
        //99.01.08 add 增加卸任與否        
        if(!Utility.getTrimString(dataMap.get("ABDICATE_CODE")).equals("")){
           session.setAttribute("abdicate_code",(String)request.getParameter("ABDICATE_CODE"));   
        }
        if(!Utility.getTrimString(dataMap.get("SortBy")).equals("")){
           session.setAttribute("SortBy",(String)request.getParameter("SortBy"));   
        }
        if(!Utility.getTrimString(dataMap.get("excelaction")).equals("")){
           session.setAttribute("excelaction",(String)request.getParameter("excelaction"));   
        }        
        if(!Utility.getTrimString(dataMap.get("bank_type")).equals("")){
           session.setAttribute("nowbank_type",(String)request.getParameter("bank_type"));   
        }
        //輸出格式 108.05.31 add
        if(!Utility.getTrimString(dataMap.get("printStyle")).equals("")){
          session.setAttribute("printStyle",(String)request.getParameter("printStyle"));   
        }
        //=================================================================================================
        if(act.equals("RptColumn")){//報表欄位              
			List FieldList = Utility.getFileData(Utility.getProperties("schemaDir")+System.getProperty("file.separator")+"WLX04.TXT");						
			String FieldListString = "";			
			for(int i=0;i<FieldList.size();i++){			    			    
			    FieldListString += Utility.ISOtoUTF8((String)FieldList.get(i));
			    if(i < FieldList.size() - 1) FieldListString +=",";   
			}
			FieldListString = FieldListString.substring(1,FieldListString.length());//104.03.09 add 去掉第一個字元?
			request.setAttribute("FieldList",FieldListString); 		
			System.out.println(report_no+".FieldList="+FieldListString);	
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
    	    webURL_Y = "/pages/"+report_no+".jsp?act=RptStyle";    	       	    	       	   	   			       
        	rd = application.getRequestDispatcher( nextPgName );         
        }else if(act.equals("createRpt")){//產生Excel報表
            String excelAction = (String)session.getAttribute("excelaction");
            this.InsertWlXOPERATE_LOG(request,lguser_id,report_no,"P");
            rd = application.getRequestDispatcher( RptCreatePgName +"?act="+excelAction);         
        }
        
    	request.setAttribute("actMsg",actMsg);    
    	request.setAttribute("alertMsg",alertMsg);
    	request.setAttribute("webURL_Y",webURL_Y);
    	request.setAttribute("webURL_N",webURL_N);   
    }        
     
%>

<%@include file="./include/Tail.include" %>


<%!
    private final static String report_no = "BR008W";
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String BankListPgName = "/pages/"+report_no+"_BankList.jsp";    
    private final static String RptColumnPgName = "/pages/"+report_no+"_RptColumn.jsp";        
    private final static String RptOrderPgName = "/pages/"+report_no+"_RptOrder.jsp";        
    private final static String RptStylePgName = "/pages/"+report_no+"_RptStyle.jsp";        
    private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    
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
        		File savefile = new File(Utility.getProperties("profileDir")+System.getProperty("file.separator")+ lguser_id+"_BR008W.txt");
        		if(savefile.exists()) savefile.delete();
            	FileOutputStream fos = new FileOutputStream(Utility.getProperties("profileDir")+System.getProperty("file.separator")+ lguser_id+"_BR008W.txt");
				BufferedOutputStream bos = new BufferedOutputStream(fos);
				PrintStream ps = new PrintStream(bos,false,"UTF-8");//104.03.11 add
				String s_year_data = "S_YEAR="+(String)session.getAttribute("S_YEAR");//99.12.29 add
				String s_month_data = "S_MONTH="+(String)session.getAttribute("S_MONTH");//99.12.29 add			
				String cancel_no_data = "CANCEL_NO="+(String)session.getAttribute("CANCEL_NO");
				String hsien_id_data = "HSIEN_ID="+(String)session.getAttribute("HSIEN_ID");				
				String BankList_data = "BankList="+(String)session.getAttribute("BankList");
				String SortList_data = "SortList="+(String)session.getAttribute("SortList");
				String SortBy_data = "SortBy="+(String)session.getAttribute("SortBy");
				String btnFieldList_data = "btnFieldList="+(String)session.getAttribute("btnFieldList");
				String position_code_data = "POSITION_CODE="+(String)session.getAttribute("position_code");
				//99.01.08 add 增加卸任與否
				String abdicate_code_data = "ABDICATE_CODE="+(String)session.getAttribute("abdicate_code");
				
				ps.println(s_year_data);//99.12.29 add
				ps.println(s_month_data);//99.12.29 add
				ps.println(cancel_no_data);
				ps.println(hsien_id_data);
				ps.println(BankList_data);
				ps.println(btnFieldList_data);
				ps.println(SortList_data);
				ps.println(position_code_data);
				ps.println(abdicate_code_data);
				ps.println(SortBy_data);
				ps.close();
				bos.close();		
				fos.close();						
		}catch(Exception e){
				System.out.println("SaveReport Error:"+e+e.getMessage());
				actMsg += "SaveReport Error";
		}
		return actMsg;
    } 
    //讀取報表格式檔========================================================
    private String readReport(HttpServletRequest request,String lguser_id){
    	String sztemp="";
    	String S_YEAR_file = "";//99.12.29 add
    	String S_MONTH_file = "";//99.12.29 add
    	String CANCEL_NO_file = "";
        String HSIEN_ID_file = "";
        String BankList_file = "";
        String btnFieldList_file = "";
        String POSITION_CODE_file = "";
        String ABDICATE_CODE_file = "";
        String SortList_file = "";
        String SortBy_file = "";
        
        String actMsg = "";
        HttpSession session = request.getSession();      
    	try{
    		File WorkFile = new File(Utility.getProperties("profileDir")+System.getProperty("file.separator")+ lguser_id+"_BR008W.txt");	        	
			if(WorkFile.exists()){			
				FileInputStream fis = new FileInputStream(Utility.getProperties("profileDir")+System.getProperty("file.separator")+ lguser_id+"_BR008W.txt");	
				BufferedInputStream bis = new BufferedInputStream(fis);
				DataInputStream dis = new DataInputStream(fis);							
				while((sztemp = dis.readLine()) != null){
				    //sztemp = Utility.ISOtoBig5(sztemp);
				    if(sztemp.indexOf("S_YEAR=") != -1){//99.12.29 add
				       S_YEAR_file = sztemp.substring(sztemp.indexOf("S_YEAR=")+7,sztemp.length());				       
				    }
				    if(sztemp.indexOf("S_MONTH=") != -1){//99.12.29 add
				       S_MONTH_file = sztemp.substring(sztemp.indexOf("S_MONTH=")+8,sztemp.length());				       
				    }
				    if(sztemp.indexOf("CANCEL_NO=") != -1){
				       CANCEL_NO_file = sztemp.substring(sztemp.indexOf("CANCEL_NO=")+10,sztemp.length());				       
				    }
				    if(sztemp.indexOf("HSIEN_ID=") != -1){
				       HSIEN_ID_file = sztemp.substring(sztemp.indexOf("HSIEN_ID=")+9,sztemp.length());				       
				    }
				    if(sztemp.indexOf("BankList=") != -1){
				       BankList_file = sztemp.substring(sztemp.indexOf("BankList=")+9,sztemp.length());		
				       BankList_file = Utility.ISOtoUTF8(BankList_file);//104.03.11 add			       
				    }
				    if(sztemp.indexOf("btnFieldList=") != -1){
				       btnFieldList_file = sztemp.substring(sztemp.indexOf("btnFieldList=")+13,sztemp.length());		
				       btnFieldList_file = Utility.ISOtoUTF8(btnFieldList_file);//104.03.11 add				       
				    }	
				    if(sztemp.indexOf("POSITION_CODE=") != -1){
				       POSITION_CODE_file = sztemp.substring(sztemp.indexOf("POSITION_CODE=")+14,sztemp.length());				
				       POSITION_CODE_file = Utility.ISOtoUTF8(POSITION_CODE_file);//104.03.11 add				              
				    }
				    //99.01.08 add 增加卸任與否
				    if(sztemp.indexOf("ABDICATE_CODE=") != -1){
				       ABDICATE_CODE_file = sztemp.substring(sztemp.indexOf("ABDICATE_CODE=")+14,sztemp.length());		
				       ABDICATE_CODE_file = Utility.ISOtoUTF8(ABDICATE_CODE_file);//104.03.11 add				              		       
				    }
				    if(sztemp.indexOf("SortList=") != -1){
				       SortList_file = sztemp.substring(sztemp.indexOf("SortList=")+9,sztemp.length());		
				       SortList_file = Utility.ISOtoUTF8(SortList_file);//104.03.11 add				              		       		       
				    }
				    if(sztemp.indexOf("SortBy=") != -1){
				       SortBy_file = sztemp.substring(sztemp.indexOf("SortBy=")+7,sztemp.length());				       
				    }
				    				
				}//end of while	
				System.out.println("S_YEAR_file="+S_YEAR_file);//99.12.29 add
				System.out.println("S_MONTH_file="+S_MONTH_file);//99.12.29 add
				System.out.println("CANCEL_NO_file="+CANCEL_NO_file);
				System.out.println("HSIEN_ID_file="+HSIEN_ID_file);
				System.out.println("BankList_file="+BankList_file);
				System.out.println("btnFieldList_file="+btnFieldList_file);
				System.out.println("POSITION_CODE_file="+POSITION_CODE_file);
				System.out.println("ABDICATE_CODE_file="+ABDICATE_CODE_file);
				System.out.println("SortList_file="+SortList_file);
				System.out.println("SortBy_file="+SortBy_file);
				
				session.setAttribute("S_YEAR",S_YEAR_file);//99.12.29 add
				session.setAttribute("S_MONTH",S_MONTH_file);//99.12.29 add
				session.setAttribute("CANCEL_NO",CANCEL_NO_file);
				session.setAttribute("HSIEN_ID",HSIEN_ID_file);
				session.setAttribute("BankList",BankList_file);
				session.setAttribute("btnFieldList",btnFieldList_file);		
				session.setAttribute("position_code",POSITION_CODE_file);
				session.setAttribute("abdicate_code",ABDICATE_CODE_file);
				session.setAttribute("SortList",SortList_file);
				session.setAttribute("SortBy",SortBy_file);
				
			}else{//end of workfile exist
			   actMsg = "無已存之報表格式檔";
			}
		}catch(Exception e){
			System.out.println("readReport Error:"+e+e.getMessage());
			actMsg = "readReport Error";			
		}	
		return actMsg;
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