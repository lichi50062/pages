﻿<%
// 95.03.9 add 排程發佈報表 by 2295
// 95.03.15 fix FR003W/FR004W_DET/STOT改實際檔名 
// 95.03.21 fix FR028W_STOT -> FR028W_STDET by 2295
// 95.03.22 fix 產生報表後,reportdir不刪除報表檔
// 95.04.21 add 全部報表發佈 by 2295
// 95.10.31 add FR027W報表名稱區分.農.漁會 by 2295
// 96.11.05 fix 96/10月以前為季報.96/10月以後為月報 by 2295
// 98.06.18 add FR001WB_ATOT/全體農漁會信用部主要經營指標總表(農漁會全部) by 2295
//100.01.05 fix 根據查詢年度.100年以後取得新縣市別.100年以前取得舊縣市別            
// 				使用PreparedStatement;並列印轉換後的SQL;套用QueryDB_SQLParam by 2295
//100.05.18 fix 報表發佈無法發佈新北市、臺中市、臺南市、高雄市 增加 upper(cd01.hsien_id) By 2295
//100.06.28 fix FR002WA排除台灣省h,因桃園縣.hsien_id=H,造成桃園縣重覆 by 2295
//102.11.14 fix FR027W增加是否顯示英文名稱/QueryDB改PreparedStatement by 2295
//103.02.26 fix 103/01以後.FR003W/FR004W_DET/STOT漁會套用新檔名 by 2295
//106.10.03 add 查詢條件增加轉檔前bank_no檔名及update rpt_dirf增加更改上傳檔名 by 2295
//107.02.22 add 地方主管機關,增加轉檔前bank_no by 2295
//109.01.14 fix FR024W改檔案名稱全體農會信用部逾放比率超逾百分之5明細表 by 2295
//110.06.29 add 取消使用FTP改用SFTP上傳檔案 by 2295   
%>                                                                                         
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.*" %>
<%@ page import="com.tradevan.util.ftp.MyFTPClient" %>
<%@ page import="com.tradevan.util.sftp.MySFTPClient" %>

<%@ page import="java.lang.Integer" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*,java.io.*" %>
<%
   System.out.println("=============執行報表發佈開始===========");   
   String report_no = ( request.getParameter("report_no")==null ) ? "" : (String)request.getParameter("report_no");		
   String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? "" : (String)request.getParameter("S_YEAR");		
   String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? "" : (String)request.getParameter("S_MONTH");		
   String lguser_id = ( request.getParameter("lguser_id")==null ) ? "" : (String)request.getParameter("lguser_id");		
   String lguser_name = ( request.getParameter("lguser_name")==null ) ? "" : (String)request.getParameter("lguser_name");		
   String szunit = ( request.getParameter("unit")==null ) ? "" : (String)request.getParameter("unit");		   
   String online = ( request.getParameter("online")==null ) ? "" : (String)request.getParameter("online");		   
   
   List rptData = null;
   List reportList = null;
   
   RequestDispatcher rd = null;
   String YEAR  = Utility.getYear();
   String MONTH = Utility.getMonth();
   
   if(!S_YEAR.equals("") && !S_MONTH.equals("")){
      YEAR = S_YEAR;
      MONTH = S_MONTH;
   }
   logDir  = new File(Utility.getProperties("logDir"));
   if(!logDir.exists()){
        if(!Utility.mkdirs(Utility.getProperties("logDir"))){
    	   System.out.println("目錄新增失敗");
        }    
   }
   logfile = new File(logDir + System.getProperty("file.separator") + "ZZ041W."+ logfileformat.format(nowlog));						 
   System.out.println("logfile filename="+logDir + System.getProperty("file.separator") +"ZZ041W."+ logfileformat.format(nowlog));
   logos = new FileOutputStream(logfile,true);  		        	   
   logbos = new BufferedOutputStream(logos);
   logps = new PrintStream(logbos);			    

   MONTH = (MONTH.length() ==1)?"0"+MONTH:MONTH;
   String bank_type_name="";
   String hsien_id="";
   String errMsg = "";
   int j=0;
   for(int i=0;i<rptfilename.length;i++){
       if((!report_no.equals("ALL")) && (!rptfilename[i][0].equals(report_no)) ){
           continue;
       }
       reportList = getQryResult(rptfilename[i][0],"ALL","ALL",YEAR,MONTH);           	       
       System.out.println("i=["+i+"].reportList.size()="+reportList.size());
       j=0;       
       rptData = new LinkedList();
       while(j < reportList.size()){                     		      
          bank_type_name="";
          hsien_id="";
          if( ((DataObject)reportList.get(j)).getValue("bank_type_name") != null ){
           	 bank_type_name = ((String)((DataObject)reportList.get(j)).getValue("bank_type_name"));
             if(bank_type_name.equals("農會")){
                bank_type_name="6";
             }else if(bank_type_name.equals("漁會")){
                bank_type_name="7";
             }else if(bank_type_name.equals("農漁會")){
                bank_type_name="T";
             }   
          } 
          hsien_id=((String)((DataObject)reportList.get(j)).getValue("hsien_id"));
          System.out.println("j=["+j+"]"+bank_type_name+":"+hsien_id+"::"+(String)((DataObject)reportList.get(j)).getValue("s_report_name"));
          rptData.add(bank_type_name+":"+hsien_id+"::"+(String)((DataObject)reportList.get(j)).getValue("s_report_name"));          
          j++;
       }//end of QryData
       
       errMsg += GenerateRpt(rptData,lguser_id,lguser_name,YEAR,MONTH,rptfilename[i][0],"", szunit,hsien_id);    	           			                       
       reportList = null;
       rptData = null;       
   }     
       
   
   System.out.println("errMsg = "+errMsg);   
   System.out.println("=============執行報表發佈結束===========");
   if(online.equals("true")){//95.04.21 add 全部報表發佈
      rd = application.getRequestDispatcher("/pages/ZZ041W.jsp?online=true&act=GenerateRptALL");   
      try {
          //forward to next present jsp
          rd.forward(request, response);
      } catch (NullPointerException npe) {
      }    
   }
%>
<%!

	private File logfile;
	private FileOutputStream logos=null;    	
	private BufferedOutputStream logbos = null;
	private PrintStream logps = null;
	private Date nowlog = new Date();
	private SimpleDateFormat logformat = new SimpleDateFormat("yyyy/MM/dd  HH:mm:ss  ");	     
	private SimpleDateFormat logfileformat = new SimpleDateFormat("yyyyMMddHHmmss");
	private Calendar logcalendar;
	private File logDir = null;
	private final static String[][] rptfilename = {												  
											      {"FR001WB_STDET", "全體農漁會信用部主要經營指標明細表.xls"},
											      {"FR001WB_STOT", "全體農漁會信用部主要經營指標總表.xls"},
											      {"FR001WB_ATOT", "全體農漁會信用部主要經營指標總表.xls"},//98.06.18 add 農漁會總表											    
											      {"FR002WA_STDET", "各縣市各農會信用部各年月經營指標變化表.xls"},
											      {"FR003W_DET", "農業信用部資產負債表.xls"},
												  //{"FR003F_DET", "漁會信用部資產負債表.xls"},
											      {"FR003W_STOT", "農業信用部資產負債表.xls"},
											      //{"FR003F_STOT", "漁會信用部資產負債表.xls"},
											      {"FR004W_DET", "農業信用部損益表.xls"},
											      //{"FR004F_DET", "漁會信用部損益表.xls"},
											      {"FR004W_STOT", "農業信用部損益表.xls"},
											      //{"FR004F_STOT", "漁會信用部損益表.xls"},
											      {"FR023W_ATOT", "農會信用部各類對象存放款比率表.xls"},
											      {"FR024W_STDET", "全體農會信用部逾放比率超逾百分之5明細表.xls"},//109.01.14 調整檔名 by 2295
											      {"FR025WA_STDET", "農漁會信用部ATM裝設台數及異動明細表.xls"},
											      {"FR025W_STOT", "全體農會信用部自動化機器彙計.xls"},
											      {"FR026W_DET", "在台無住所之外國人新台幣存款表-農會.xls"},
											      {"FR027W_STDET", "農會信用部牌告利率彙總表(季報).xls"},//95.10.31 add FR027W報表名稱區分.農.漁會 by 2295
											      {"FR028W_STDET", "台灣地區農會信用部放款餘額表.xls"},
											      {"FR029W_STDET", "全體農會信用部本期損益或淨值為負單位明細表.xls"},
											      {"FR030W_STDET", "台灣區農會信用部支票存款戶數與餘額彙計表.xls"}
											      };

	private String getFileName(String S_YEAR,String S_MONTH,String szrpt_code,String szrpt_output_type){
    	String idxRptCode="";
    	String scSrcFile="";
    	try{
    		 //找出實際產生的報表檔名
         	 filenameLoop:
         	 for (int j = 0; j < rptfilename.length; j++) {
         	       idxRptCode = szrpt_code;         			                    	       
					if (rptfilename[j][0].equals(idxRptCode)){
						scSrcFile = rptfilename[j][1];
						System.out.print("idxRptCode="+idxRptCode);   
						System.out.println(":scSrcFile="+scSrcFile);
						if(szrpt_code.equals("FR002WA_STDET") || szrpt_code.equals("FR023W_ATOT") || szrpt_code.equals("FR024W_STDET") || szrpt_code.equals("FR025W_STOT") 
         			    || szrpt_code.equals("FR026W_DET") || szrpt_code.equals("FR028W_STDET") || szrpt_code.equals("FR029W_STDET") || szrpt_code.equals("FR030W_STDET")
         			    || szrpt_code.equals("FR027W_STDET"))//95.10.31 add FR027W報表名稱區分.農.漁會 by 2295
         			    { 
         			       if(szrpt_output_type.equals("7")){//漁會
         			          scSrcFile = scSrcFile.substring(0,scSrcFile.indexOf("農會"))+"漁"+scSrcFile.substring(scSrcFile.indexOf("農會")+1,scSrcFile.length());
         			          System.out.println("new.scSrcFile="+scSrcFile);
         			       }
         			    }
         			    //95.03.15 fix FR003W/FR004W_DET/STOT改實際檔名 
         			    if(szrpt_code.equals("FR003W_DET") || szrpt_code.equals("FR003W_STOT") || szrpt_code.equals("FR004W_DET") || szrpt_code.equals("FR004W_STOT")){         			        
         			       if(szrpt_output_type.equals("7")){//漁會
         			          scSrcFile = scSrcFile.substring(0,scSrcFile.indexOf("農業"))+"漁會"+scSrcFile.substring(scSrcFile.indexOf("農業")+2,scSrcFile.length());         			          
         		              //103.02.26 fix 103/01以後.漁會套用新檔名
         		              if(Integer.parseInt(S_YEAR) * 100 + Integer.parseInt(S_MONTH) >= 10301){
         		                 scSrcFile = scSrcFile.substring(0,scSrcFile.indexOf("."))+"_10301"+scSrcFile.substring(scSrcFile.indexOf("."),scSrcFile.length());
         		              }	
         			          System.out.println("new.scSrcFile="+scSrcFile);
         			       }   
         			    }   
   
					    break filenameLoop;
					}//end of idxRptCode 
			 }//end of find rptfilename
	    }catch(Exception e){
	        System.out.println("getFileName error:"+e.getMessage());
	        scSrcFile = "getFileName error:";
	    }		 
	    return scSrcFile;
    }
    
    private String CreateRpt(String S_YEAR,String S_MONTH,String BANK_NO,String BANK_NAME,String szrpt_code, String bank_type, String szUnit, String szhsien_id){    	  
        String errMsg = "";     
    	try{    	    
    	    String sqlCmd = "";
    	    String s_quarter = "";
    	    if(szrpt_code.equals("FR001WB_STDET")){//全體農(漁)會信用部主要經營指標明細表
         	   errMsg += RptFR001WB.createRpt(S_YEAR,S_MONTH,szUnit,bank_type,"1","",null);//1明細表    								
         	}else if(szrpt_code.equals("FR001WB_STOT")){//全體農(漁)會信用部主要經營指標總表
         	   errMsg += RptFR001WB.createRpt(S_YEAR,S_MONTH,szUnit,bank_type,"0","",null);//0總表   
         	}else if(szrpt_code.equals("FR001WB_ATOT")){//全體農漁會信用部主要經營指標總表
         	   errMsg += RptFR001WB.createRpt(S_YEAR,S_MONTH,szUnit,"ALL","0","",null);//0農漁會-總表.98.06.18 add        								
         	}else if(szrpt_code.equals("FR002WA_STDET")){//各縣內各農(漁)會經營指標變化表         			     
         	   errMsg += FR002WA_Excel.createRpt(S_YEAR,S_MONTH,szUnit,bank_type,szhsien_id);         			           			     
         	}else if(szrpt_code.equals("FR003W_DET")){//各農(漁)會信用部資產負債表
         	   if(bank_type.equals("6")) errMsg += FR003W_Excel.createRpt(S_YEAR,S_MONTH,BANK_NO,BANK_NAME,szUnit);//農會
         	   if(bank_type.equals("7")) errMsg += FR003F_Excel.createRpt(S_YEAR,S_MONTH,BANK_NO,BANK_NAME,szUnit);//漁會
         	}else if(szrpt_code.equals("FR003W_STOT")){//各農(漁)會信用部資產負債表總表
         	   if(bank_type.equals("6")) errMsg += FR003W_Excel.createRpt(S_YEAR,S_MONTH,"ALL","全體農會信用部",szUnit);//農會
         	   if(bank_type.equals("7")) errMsg += FR003F_Excel.createRpt(S_YEAR,S_MONTH,"ALL","全體漁會信用部",szUnit);//漁會   
         	}else if(szrpt_code.equals("FR004W_DET")){//各農(漁)會信用部損益表
         	   if(bank_type.equals("6")) errMsg += FR004W_Excel.createRpt(S_YEAR,S_MONTH,BANK_NO,BANK_NAME,szUnit,"false");//農會
         	   if(bank_type.equals("7")) errMsg += FR004F_Excel.createRpt(S_YEAR,S_MONTH,BANK_NO,BANK_NAME,szUnit,"false");//漁會
         	}else if(szrpt_code.equals("FR004W_STOT")){//各農(漁)會信用部損益表總表
         	   if(bank_type.equals("6")) errMsg += FR004W_Excel.createRpt(S_YEAR,S_MONTH,"ALL","全體農會信用部",szUnit,"false");//農會
         	   if(bank_type.equals("7")) errMsg += FR004F_Excel.createRpt(S_YEAR,S_MONTH,"ALL","全體漁會信用部",szUnit,"false");//漁會   
         	}else if(szrpt_code.equals("FR023W_ATOT")){//農(漁)會信用部各類對象存放款比率表
         	   errMsg += RptFR023W.createRpt(S_YEAR,S_MONTH,szUnit,"",bank_type);         			     
         	}else if(szrpt_code.equals("FR024W_STDET")){//農(漁)會信用部逾放比率超過5%明細表
         	   errMsg += RptFR024W.createRpt(S_YEAR,S_MONTH,szUnit,"",bank_type);        			        
         	}else if(szrpt_code.equals("FR025WA_STDET")){//全體農(漁)會信用部ATM裝設台數及異動明細表         	
         	    List paramList = new ArrayList();
         	    sqlCmd = " select bn01.bn_type,wlx01.hsien_id,bn01.bank_no, bn01.bank_name from bn01,wlx01 "
			      	   	+ " where bank_type = ?"	  				  
					    + " and bn01.bank_no = wlx01.bank_no "
		    			+ " order by wlx01.hsien_id,bn01.bank_no";	
         	    paramList.add(bank_type);
                List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");
                List bank_list = new LinkedList();
                List bank_detail = null;
                for(int i=0;i<dbData.size();i++){
                    bank_detail = new LinkedList();
                    bank_detail.add((String)((DataObject)dbData.get(i)).getValue("bank_no"));
                    bank_list.add(bank_detail);
                }
         		errMsg += RptFR025WA.createRpt(S_YEAR,S_MONTH,bank_type,bank_list);    			           
         	}else if(szrpt_code.equals("FR025W_STOT")){//農(漁)會信用部自動化服務機械CD/ATM概況表         			  
         	    errMsg += FR025W_Excel.createRpt(S_YEAR,S_MONTH,bank_type,szUnit);   		
         	}else if(szrpt_code.equals("FR026W_DET")){//農(漁)會信用部在台無住所外國人新台幣存款表        
         	    errMsg += FR026W_Excel.createRpt(S_YEAR,S_MONTH,bank_type,BANK_NO,szUnit);   		
         	}else if(szrpt_code.equals("FR027W_STDET")){//農(漁)會信用部牌告利率彙總表//季報               	    
         	     //96.11.05 96/10月以前為季報.96/10月以後為月報
         		 if((Integer.parseInt(S_YEAR) * 100 + Integer.parseInt(S_MONTH)) < 9610){         		 	         	    
         	         if(Integer.parseInt(S_MONTH) >= 1 && Integer.parseInt(S_MONTH) <= 3){
         	            s_quarter = "1";
         	         }else if(Integer.parseInt(S_MONTH) >= 4 && Integer.parseInt(S_MONTH) <= 6){
         	            s_quarter = "2";
         	         }else if(Integer.parseInt(S_MONTH) >= 7 && Integer.parseInt(S_MONTH) <= 9){   
         	            s_quarter = "3"; 
         	         }else if(Integer.parseInt(S_MONTH) >= 10 && Integer.parseInt(S_MONTH) <= 12){      
         	            s_quarter = "4"; 
         	         }
         	     }else{
         	        s_quarter=S_MONTH;
         	     }
         	     errMsg += FR027W_Excel.createRpt(S_YEAR,s_quarter,bank_type,"false");   		   
         	}else if(szrpt_code.equals("FR028W_STDET")){//台灣地區農(漁)會信用部放款餘額表       
         	     errMsg += RptFR028W.createRpt(S_YEAR,S_MONTH,S_YEAR,S_MONTH,bank_type,szUnit);		         			     
         	}else if(szrpt_code.equals("FR029W_STDET")){//全體農(漁)會信用部本期損益或淨值為負單位明細表      
         	     errMsg += RptFR029W.createRpt(S_YEAR,S_MONTH,szUnit,"",bank_type);	         			        
         	}else if(szrpt_code.equals("FR030W_STDET")){//台灣地區農(漁)會信用部支票存款戶數與餘額彙計表      
         	     errMsg += FR030W_Excel.createRpt(S_YEAR,S_MONTH,bank_type,szUnit);       			           
         	}   
         	
    	}catch(Exception e){
    	   System.out.println("CreateRpt Error:"+e.getMessage());
    	   errMsg += "CreateRpt Error:";
    	}
    	
    	logcalendar = Calendar.getInstance(); 
		nowlog = logcalendar.getTime();			    	
		if(errMsg.equals("")){
		   logps.println(logformat.format(nowlog)+bank_type+":"+BANK_NO+BANK_NAME+"產生"+S_YEAR+"年"+S_MONTH+"月:報表"+szrpt_code+"完成");		    					    		   
		}else{
		   logps.println(logformat.format(nowlog)+bank_type+":"+BANK_NO+BANK_NAME+"產生"+S_YEAR+"年"+S_MONTH+"月:報表"+szrpt_code+"失敗:"+errMsg);		    					    
		}   
		logps.flush();
    	return errMsg;
    }


    //100.01.05 fix 全部報表發根據查詢年度.100年以後取得新縣市別.100年以前取得舊縣市別  by 2295   
    public String GenerateRpt(List rptData,String lguser_id,String lguser_name,String S_YEAR,String S_MONTH,String szrpt_code, String szrpt_output_type, String szUnit, String szhsien_id){    	        	              	    
        String errMsg = "";
        String putMsg = "";	
    	String BANK_NO = "";
    	String ori_bank_no="";//106.10.03 add
		String BANK_NAME = "";
		String HSIEN_ID = "";		  		
		String scSrcFile = "";
		String copyOK = "";		  		
		String sqlCmd = "";
		String idxRptCode="";
		String filename="";
		String ori_filename="";//106.10.03 add
		String bank_type="";
		String rptLine="";
		List dbData = null;	
	    String szrpt_sort="";
	    String[] fname1;		    
        List filename_List  = new LinkedList();	
		List paramList =new ArrayList() ;		
		List<List> updateDBList = new ArrayList<List>();//0:sql 1:data		
		List updateDBSqlList = new ArrayList();
		List<List> updateDBDataList_insert_rpt_dirf= new ArrayList<List>();//儲存參數的List		
		List<List> updateDBDataList_update_rpt_dirf= new ArrayList<List>();//儲存參數的List		
		List<List> updateDBDataList_rpt_dirf_log= new ArrayList<List>();//儲存參數的List	
		List<String> dataList =  new ArrayList<String>();//儲存參數的data
    	try{
		  		String rptIP=Utility.getProperties("rptIP");			
	            String rptID=Utility.getProperties("rptID");			
	            String rptPwd=Utility.getProperties("rptPwd");	
		  		System.out.println("報表rptData.size="+rptData.size());		  					    			    
		  		//取得報表data
			    sqlCmd = " select rpt_code,rpt_name,rpt_output_type,rpt_include "
		   		   	   + " from rpt_nof "
		   		   	   + " where rpt_nof.rpt_code = ?";    			  
    			paramList.add(szrpt_code);   	   
    			dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");//報表data    
    			String szrpt_include = (String)((DataObject)dbData.get(0)).getValue("rpt_include");
    			String dbrpt_output_type = (String)((DataObject)dbData.get(0)).getValue("rpt_output_type");
			    //新增GenerateRptDir         		
		  		File ClientRptDir = new File(Utility.getProperties("GenerateRptDir"));        
	        	if(!ClientRptDir.exists()){
         			if(!Utility.mkdirs(Utility.getProperties("GenerateRptDir"))){
         		   		errMsg+=Utility.getProperties("GenerateRptDir")+"目錄新增失敗";
         			}    
        		}
		  		if(errMsg.equals("")){			  		   
		  		   for(int i=0;i<rptData.size();i++){			
		  		      System.out.println("rptData="+(String)rptData.get(i));		       			        
		  		      rptLine = (String)rptData.get(i);
		  		      bank_type = rptLine.substring(0,rptLine.indexOf(":"));     	         			  
		  		      System.out.print("bank_type="+bank_type);
		  		      rptLine = rptLine.substring(rptLine.indexOf(":")+1,rptLine.length());
		  		      HSIEN_ID = rptLine.substring(0,rptLine.indexOf(":"));     	  
		  		      System.out.print(":HSIEN_ID="+HSIEN_ID);         			         			  
		  		      rptLine = rptLine.substring(rptLine.indexOf(":")+1,rptLine.length());
         			  filename = rptLine.substring(0,rptLine.indexOf(":"));     	         			  
         			  System.out.print(":filename="+filename);         			  
         			  rptLine = rptLine.substring(rptLine.indexOf(":")+1,rptLine.length());
         			  BANK_NO = rptLine.substring(0,rptLine.indexOf(":")+8);     	         			           			  
         			  System.out.print(":BANK_NO="+BANK_NO);         			  
         			  BANK_NAME = rptLine.substring(rptLine.indexOf(":")+8,rptLine.length());     	         			           			           			  
         			  System.out.print(":BANK_NAME="+BANK_NAME);
         			  //106.10.03 add
    		          sqlCmd = " select bank_no,ori_bank_no,trans_date from bn01 where bank_no=?";     
    		          paramList.clear() ; 
                      paramList.add(BANK_NO) ;
    		          List bank_no_List = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"trans_date");
    		          if(bank_no_List != null && bank_no_List.size() != 0){
    		             ori_bank_no = (String)((DataObject)bank_no_List.get(0)).getValue("ori_bank_no");
    		          }
         			  System.out.println(":ori_bank_no="+ori_bank_no);
         			  
         			  //產生報表==========================================================================================
         			  if(szrpt_code.equals("FR023W_ATOT")){
         			     errMsg += CreateRpt(S_YEAR,S_MONTH,BANK_NO,BANK_NAME,szrpt_code,"6",szUnit,HSIEN_ID);
         			  }else{
         			     errMsg += CreateRpt(S_YEAR,S_MONTH,BANK_NO,BANK_NAME,szrpt_code,bank_type,szUnit,HSIEN_ID);
         			  }   
         			  //=======================================================================================================
         			  scSrcFile = getFileName(S_YEAR,S_MONTH,szrpt_code,bank_type);//找出實際產生的報表檔名
         			  
         			  if(scSrcFile.indexOf(".xls") != -1){//有找到實際檔名
         			     //if(filename.trim().equals("")){
         			        if((dbrpt_output_type.equals("X") && szrpt_include.equals("T")) || 
         			           (dbrpt_output_type.equals("T") && szrpt_include.equals("T")))
         			        {
         			           filename = bank_type;
         			           if(dbrpt_output_type.equals("T")){
         			              filename = dbrpt_output_type;
         			           }         			           
         			           
         			           filename += szrpt_include+"_";
         			           if(S_YEAR.length() == 2){
         			              filename += "0"+S_YEAR+S_MONTH+".xls";
         			           }else{
         			              filename += S_YEAR+S_MONTH+".xls";
         			           }         			                    			        
         			        }else if(dbrpt_output_type.equals("X") && szrpt_include.equals("B")){ 
         			          filename=bank_type+szrpt_include+"_"+BANK_NO+".xls";
         			          ori_filename=bank_type+szrpt_include+"_"+ori_bank_no+".xls";//106.10.03 add 增加轉檔前bank_no檔名
         			        }else{
         			          filename=bank_type+bank_type+"_"+BANK_NO+".xls";
         			          ori_filename=bank_type+bank_type+"_"+ori_bank_no+".xls";//106.10.03 add 增加轉檔前bank_no檔名
         			        }
         			        System.out.println("filename="+filename);
         			     //}//end of filename == ""
         			     copyOK = Utility.CopyFile(Utility.getProperties("reportDir") + System.getProperty("file.separator")+scSrcFile,Utility.getProperties("GenerateRptDir")+System.getProperty("file.separator")+filename);
         			     if(copyOK.equals("0")){         			        
         			        File tmpFile = new File(Utility.getProperties("reportDir") + System.getProperty("file.separator")+scSrcFile);
         			        paramList = new LinkedList();
         			        sqlCmd = " select count(*) as count from rpt_dirf"
         			               + " where rpt_code=?"
         			               + " and   m_year = ?"
         			               + " and   m_month = ?"         			               
         			               + " and   (rpt_fname = ? or rpt_fname = ? )";//106.10.03 add 增加轉檔前bank_no檔名
         			         paramList.add(szrpt_code);      
         			         paramList.add(S_YEAR);      
         			         paramList.add(S_MONTH);      
         			         paramList.add(filename);       
         			         paramList.add(ori_filename);//106.10.03 add         
         			         dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"count");  
         			        
         			         if(dbData != null && dbData.size() != 0 ){
         			            if(((((DataObject)dbData.get(0)).getValue("count")).toString()).equals("0")){
         			               //sqlCmd = "insert into rpt_dirf values(?,?,?,?,?,?,?,sysdate)";    
         			               dataList =  new ArrayList<String>();  
         			               dataList.add(szrpt_code);
         			               dataList.add(S_YEAR);
         			               dataList.add(S_MONTH);
         			               dataList.add(filename);
         			               dataList.add(String.valueOf(tmpFile.length()));
         			               dataList.add(lguser_id);
         			               dataList.add(lguser_name);
         			               updateDBDataList_insert_rpt_dirf.add(dataList);     
         			               System.out.println("add.insert filename="+filename);  	     			            
         			            }else{         			           
         			              /*sqlCmd = " insert into rpt_dirf_log" 
							   			  + " select rpt_code,m_year,m_month,rpt_fname,rpt_fsize,user_id,user_name,update_date"
							   			  + ",?,?,sysdate,'U'"
							   			  + " from rpt_dirf"
							   			  + " where rpt_code=?"
         			               		  + " and   m_year = ?"
         			               		  + " and   m_month = ?"
         			               		  + " and   rpt_fname = ?";
         			               */		  
         			               dataList =  new ArrayList<String>();  
         			               dataList.add(lguser_id);		  
         			               dataList.add(lguser_name);
         			               dataList.add(szrpt_code);
         			               dataList.add(S_YEAR);
         			               dataList.add(S_MONTH);
         			               dataList.add(filename);
         			               updateDBDataList_rpt_dirf_log.add(dataList);    
         			               System.out.println("log.insert filename="+filename);  
         			               /*
         			               sqlCmd = " update rpt_dirf set user_id=?"
         			                      + " ,user_name=?,rpt_fname=?,update_date=sysdate"
         			                      + " where rpt_code=?"
         			               		  + " and   m_year = ?"
         			               		  + " and   m_month = ?"
         			               		 + " and   (rpt_fname = ? or rpt_fname = ? )";//106.10.03 add
         			               */         			               	  
         			               dataList =  new ArrayList<String>();  
         			               dataList.add(lguser_id);		  
         			               dataList.add(lguser_name);
         			               dataList.add(filename);//106.10.03 add 增加更改上傳檔名
         			               dataList.add(szrpt_code);
         			               dataList.add(S_YEAR);
         			               dataList.add(S_MONTH);
         			               dataList.add(filename);
         			               dataList.add(ori_filename);//106.10.03 add 增加轉檔前bank_no檔名
         			               updateDBDataList_update_rpt_dirf.add(dataList);   
         			               System.out.println("update.insert filename="+filename);       			            
         			            }           			            
         			         }            			         
         			         //if(tmpFile.exists()) tmpFile.delete();//95.03.22 產生報表後,reportdir不刪除報表檔
         			     }else{
         			        errMsg += copyOK;
         			     }
         			  }//end of scSrcFile             			 		  
         		   }//end of rptData for
         		   
         		   if(updateDBDataList_insert_rpt_dirf.size() >= 1 ){
         		      sqlCmd = "insert into rpt_dirf values(?,?,?,?,?,?,?,sysdate)"; 
         		      updateDBSqlList = new ArrayList(); 
         		      updateDBSqlList.add(sqlCmd.toString());//0:欲執行的sql				
         			  updateDBSqlList.add(updateDBDataList_insert_rpt_dirf);//0:sql 1:參數List
					  updateDBList.add(updateDBSqlList);
         		   }
         		   
         		   if(updateDBDataList_rpt_dirf_log.size() >= 1 ){
         		      sqlCmd = " insert into rpt_dirf_log" 
							 + " select rpt_code,m_year,m_month,rpt_fname,rpt_fsize,user_id,user_name,update_date"
							 + ",?,?,sysdate,'U'"
							 + " from rpt_dirf"
							 + " where rpt_code=?"
         			         + " and   m_year = ?"
         			         + " and   m_month = ?"
         			         + " and   rpt_fname = ?";
         			  updateDBSqlList = new ArrayList();       
         		      updateDBSqlList.add(sqlCmd.toString());//0:欲執行的sql				
         			  updateDBSqlList.add(updateDBDataList_rpt_dirf_log);//0:sql 1:參數List
					  updateDBList.add(updateDBSqlList);
         		   }
         		   
         		   if(updateDBDataList_update_rpt_dirf.size() >= 1 ){
         		      sqlCmd = " update rpt_dirf set user_id=?"
         			         + " ,user_name=?,rpt_fname=?,update_date=sysdate"//106.10.03 add 更改上傳檔名
         			         + " where rpt_code=?"
         			         + " and   m_year = ?"
         			         + " and   m_month = ?"         			       
         			         + " and  (rpt_fname = ? or rpt_fname = ? )";//106.10.03 add 增加轉檔前bank_no檔名
         			  updateDBSqlList = new ArrayList();       
         		      updateDBSqlList.add(sqlCmd.toString());//0:欲執行的sql				
         			  updateDBSqlList.add(updateDBDataList_update_rpt_dirf);//0:sql 1:參數List
					  updateDBList.add(updateDBSqlList);
         		   }
         		   
         		   if(updateDBList.size() >= 1){         		       
                       System.out.println("updateDBList.size()="+updateDBList.size());
                       //for(int k=0;k<updateDBSqlList.size();k++){
                       //   System.out.println("updateDBSqlList.get("+k+")="+(String)updateDBSqlList.get(k));
                       //}               
                       System.out.println("serverRptDir="+Utility.getProperties("serverRptDir"));
    	               System.out.println("GenerateRptDir="+Utility.getProperties("GenerateRptDir")+System.getProperty("file.separator"));                   
                       File rptDir = new File(Utility.getProperties("GenerateRptDir"));
                       File rptFile = null;
                       MySFTPClient msftp = new MySFTPClient(rptIP, rptID, rptPwd);//110.06.25 add
                       boolean uploadSuccess = false;//110.06.25 add
                       if(rptDir.exists() && rptDir.isDirectory()){
		                  fname1= rptDir.list(); //====列出此目錄下的所有檔案===================
		                  for(int c=0;c<fname1.length;c++){
		                      rptFile = new File(Utility.getProperties("GenerateRptDir")+System.getProperty("file.separator")+fname1[c]);
		                      System.out.println(Utility.getProperties("GenerateRptDir")+System.getProperty("file.separator")+fname1[c]);
		                      uploadSuccess = false;//110.06.29 add
		                      if(!rptFile.isDirectory()){
		                      	 filename_List.add(fname1[c]);
		                      	 uploadSuccess = msftp.sendMyFiles(Utility.getProperties("serverRptDir")+szrpt_code+"/"+S_YEAR+S_MONTH, Utility.getProperties("GenerateRptDir"), fname1[c]);
		                         System.out.println(fname1[c]+(uploadSuccess==true?"檔案上傳完成":"檔案上傳失敗")); 
		                      }
		                  }
		                  //MyFTPClient ftpC = new MyFTPClient(rptIP, rptID, rptPwd);//110.06.25   
		                 
		                 
		                  if(S_YEAR.length() == 2){
		                     S_YEAR = "0"+S_YEAR;
		                  } 	     
		                  //putMsg = ftpC.putFiles(Utility.getProperties("serverRptDir"), Utility.getProperties("GenerateRptDir")+System.getProperty("file.separator"),szrpt_code+"/"+S_YEAR+S_MONTH,filename_List);
		                  //ftpC=null;
		                  //if(putMsg == null){//上傳檔案成功//110.06.25 fix		          
		                  if(uploadSuccess){//上傳檔案成功 //110.06.25 add		                     
		                     System.out.println("檔案上傳成功");
		                     for(int i=0;i<filename_List.size();i++){
		                         errMsg +="\n"+(String)filename_List.get(i);
		                         rptFile = new File(Utility.getProperties("GenerateRptDir")+System.getProperty("file.separator")+(String)filename_List.get(i));
		                         if(rptFile.exists()) rptFile.delete();
		                     }
		                     errMsg +="檔案上傳成功";		                     		             
		                     if(DBManager.updateDB_ps(updateDBList)){//寫入DB			 
				      	        errMsg += "\n-->相關資料寫入資料庫成功";					
			       	         }else{
			 	                errMsg += "\n-->相關資料寫入資料庫失敗[DBManager.getErrMsg()]:" + DBManager.getErrMsg();
					         }					 			
					         System.out.println("errMsg="+errMsg);		         					            		               
                          }else{//end of 上傳檔案成功
                             errMsg += "-->報表產生完成,但上傳至Sever未成功"+putMsg;    	           	       	
                          }
         	           }//end of rptDir存在
         		   }//end of updateDBSqlList
		        }//end of errMsg = ""		
		}catch(Exception e){
			errMsg += "Generate Report Error";
		}	
		System.out.println("errMsg = "+errMsg);  		
		logcalendar = Calendar.getInstance(); 
		nowlog = logcalendar.getTime();			    			
		logps.println(logformat.format(nowlog)+errMsg);		    
							    		   
		logps.flush();
	    return errMsg;

    }
    
    
   //取得查詢結果
    private List getQryResult(String szrpt_code,String szrpt_output_type,String szhsien_id,String S_YEAR,String S_MONTH){    	       
            //100.01.04 add 查詢年度100年以前.縣市別不同===============================
  	    	String cd01_table = (Integer.parseInt(S_YEAR) < 100)?"cd01_99":""; 
  	    	String wlx01_m_year = (Integer.parseInt(S_YEAR) < 100)?"99":"100"; 
  	    	//=====================================================================     
    		//查詢條件        		
    		String sqlCmd = "";                                                
    		String rule_1 = "";
    		String rule_2 = "";
    		String rule_3 = "";
    		String rule_4 = "";
    		List dbData = null;
    		List paramList =new ArrayList() ;
    		List paramList_rule_1 =new ArrayList() ;
    		List paramList_rule_2 =new ArrayList() ;
            sqlCmd = " select rpt_code,rpt_name,rpt_output_type,rpt_include "
		   		   + " from rpt_nof "
		   		   + " where rpt_nof.rpt_code = ?";
		   	paramList.add(szrpt_code);	   
    		dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");//報表data    
    		String szrpt_include = (String)((DataObject)dbData.get(0)).getValue("rpt_include");
    		String rpt_output_type = (String)((DataObject)dbData.get(0)).getValue("rpt_output_type");
    		System.out.print("szrpt_code="+szrpt_code);
            System.out.print(":szrpt_output_type="+szrpt_output_type);
            System.out.print(":szhsien_id="+szhsien_id);
            System.out.print(":rpt_output_type="+rpt_output_type);
            System.out.print(":szrpt_include="+szrpt_include);
            System.out.print(":S_YEAR="+S_YEAR);
            System.out.print(":S_MONTH="+S_MONTH);
    		String condition = " rpt_dirf.RPT_Code =? and "
	 					     + " rpt_dirf.M_Year = ? and "
	 					     + " rpt_dirf.M_Month = ?";
      	 	List paramList_condition =new ArrayList();		
      	 	paramList_condition.add(szrpt_code);
      	 	paramList_condition.add(S_YEAR);
      	 	paramList_condition.add(S_MONTH);
      	 	
            String condition_1 = " (select  * FROM  WML01 "
          				       + "  where WML01.M_Year = ?"
                          	   + "	and  WML01.M_Month = ?";
            List paramList_condition_1 =new ArrayList();	
            paramList_condition_1.add(S_YEAR);
      	 	paramList_condition_1.add(S_MONTH);	                          	   
            if(rpt_output_type.equals("X") && szrpt_include.equals("X") && szrpt_code.equals("FR026W_DET")){               
                  condition_1 += "	and WML01.Report_No = ?) WML01 ";
                  paramList_condition_1.add("F01");
            }else{     
                  condition_1 += "	and WML01.Report_No = ?) WML01 ";     
                  paramList_condition_1.add("A01");          
            }              	   
            if(rpt_output_type.equals("X") && szrpt_include.equals("T")){   
               if(szrpt_code.equals("FR025W_STOT") || szrpt_code.equals("FR025WA_SDET") || szrpt_code.equals("FR027W_STDET")){
                  paramList_condition_1 =new ArrayList();	
                  condition_1 = " (select 'U' as Upd_Code, Bank_Code"
 						      + " from WLX_APPLY_LOCK "
 						      + " where WLX_APPLY_LOCK.M_Year = ?"
 						      + " and   WLX_APPLY_LOCK.M_QUARTER = ?";
 				  paramList_condition_1.add(S_YEAR);	
 				  paramList_condition_1.add(String.valueOf(Integer.parseInt(S_MONTH)));     
 				  if(szrpt_code.equals("FR025W_STOT") || szrpt_code.equals("FR025WA_SDET")){
 				     condition_1 += " and   WLX_APPLY_LOCK.Report_No = ?) WML01";
 				     paramList_condition_1.add("C01");
 				  }else if(szrpt_code.equals("FR027W_STDET")){		      
 				     condition_1 += " and   WLX_APPLY_LOCK.Report_No = ?) WML01";
 				     paramList_condition_1.add("C07");
 				  } 						       				  
               }
            }              	   
            condition_1 += " on 	bn01.bank_no = WML01.Bank_Code  "                          	   
          			    +  "  ) temp_2 ";	 			
            
            if((rpt_output_type.equals("X") && szrpt_include.equals("B")) 
            || (rpt_output_type.equals("X") && szrpt_include.equals("X"))){   
                                   
            	rule_1 = " select NVL((BN01.BANK_NO || BN01.BANK_NAME), ' ')  as S_Report_Name,"
    			       + " BN01.BANK_NO, BN01.BANK_NAME,"
    				   + " bn01.bank_type as  Bank_Type,"
    				   + " decode(bn01.bank_type,'6','農會','7','漁會',' ')  as  Bank_Type_Name,"
    				   + " nvl(cd01.hsien_id,' ') as  hsien_id,"
					   + " nvl(cd01.hsien_name,'OTHER')  as  hsien_name,"
    				   + " cd01.FR001W_output_order     as  FR001W_output_order,"
   					   + " nvl(rpt_dirf.RPT_Fname,' ')  as RPT_Fname,"
   					   + " nvl(rpt_dirf.RPT_FSize,' ')  as RPT_FSize,"
   					   + " nvl(((to_char(rpt_dirf.UPDATE_DATE,'yyyymmdd')-19110000)  || to_char(rpt_dirf.UPDATE_DATE,' hh24:mi')),' ')  as S_UpdateDate "  
					   + " from  (select * from "+cd01_table+" cd01 where  cd01.hsien_id <> 'Y') cd01";
     		  //報表發佈無法發佈新北市、臺中市、臺南市、高雄市 增加 upper(cd01.hsien_id) By 2295	   
     		  if(szrpt_include.equals("B")){ 			  
     		      rule_1 += " left join "
     		              + " ((select BANK_NO,ORI_BANK_NO,trans_date,BANK_NAME, 6 as bank_type "//107.02.22 add 轉換前的bank_no    
	               		  + "   from (select * from bn01 where m_year=?)bn01 where bn01.bank_type='B') "
	               		  + " union all "
				 		  + "  (select BANK_NO,ORI_BANK_NO,trans_date,BANK_NAME, 7 as bank_type "//107.02.22 add 轉換前的bank_no    
	               		  + "   from (select * from bn01 where m_year=?)bn01 where bn01.bank_type='B'))  bn01 "
	             		  + " on  (upper(cd01.hsien_id) = SUBSTR(bn01.bank_no,1,1) and cd01.hsien_id <> 'h')";//100.06.28排除台灣省      
	              paramList_rule_1.add(wlx01_m_year);
			      paramList_rule_1.add(wlx01_m_year);		  
     		  }else if(szrpt_include.equals("X")){ 			   			  
     		      rule_1 += " left join (select * from wlx01 where m_year=?)wlx01 on wlx01.hsien_id=cd01.hsien_id " 
     		              + " left join "
     		              + " (select BANK_NO, ORI_BANK_NO,trans_date, BANK_NAME,  bank_type ";//106.10.03 add 轉換前的bank_no    
     		              if(szrpt_output_type.equals("ALL")){
	               		     rule_1 += "   from (select * from bn01 where m_year=?)bn01 where bn01.bank_type in('6','7'))  bn01";
	               		  }else if(szrpt_output_type.equals("6")){
	               		     rule_1 += "   from (select * from bn01 where m_year=?)bn01 where bn01.bank_type in('6'))  bn01";
	               		  }else if(szrpt_output_type.equals("7")){
	               		     rule_1 += "   from (select * from bn01 where m_year=?)bn01 where bn01.bank_type in('7'))  bn01";
	               		  }	               		  
			      rule_1 += "   on wlx01.bank_no=bn01.bank_no ";               
			      paramList_rule_1.add(wlx01_m_year);
			      paramList_rule_1.add(wlx01_m_year);
     		  }			       					  
	 			  rule_1 += " left join (select * from rpt_dirf "
	 				   	  + "            where "+condition+") rpt_dirf "
  	             		  + " 			 on  (SUBSTR(rpt_dirf.RPT_Fname,4,7) = bn01.bank_no or SUBSTR(rpt_dirf.RPT_Fname,4,7) = bn01.ori_bank_no) "//106.10.03 add 轉換前的bank_no        
	             		  + "			 and SUBSTR(rpt_dirf.RPT_Fname,1,1) = bn01.bank_type "
						  + " order by  bn01.Bank_Type, BN01.BANK_NO ";
                  for(int i=0;i<paramList_condition.size();i++){
                      paramList_rule_1.add(paramList_condition.get(i));
                  }
            	   rule_2 = " select  bank_type,";
            	if(szrpt_include.equals("B")){ 			 
            	   rule_2 += " hsien_id,";
            	}else if(szrpt_include.equals("X")){ 			 
            	   rule_2 += " bank_no,";
            	}
            	   rule_2 += " count(*)  as  T_Cnt,"
		 				  + " SUM(decode(temp_2.Upd_Code,'U',1,0)) as  OK_Cnt"
						  + " from("
						  + "	    select  nvl(temp_1.bank_no,' ')   as bank_no, "
        				  + "   			nvl(temp_1.hsien_id,' ')  as hsien_id, "
	    				  + "				nvl(bn01.bank_type,' ')   as bank_type,"
						  + "				nvl(WML01.Upd_Code,' ')   as Upd_Code"
						  + "		from ("
						  +	"				select wlx01.bank_no, wlx01.hsien_id from (select * from wlx01 where m_year=?)wlx01 "
     					  + "				where ((wlx01.CANCEL_NO = 'Y' and (to_char(wlx01.cancel_date,'yyyymm')-191101) <= ?) or (wlx01.CANCEL_NO <> 'Y'))"			  
     					  + "				and    wlx01.hsien_id in (select cd01.hsien_id from "+cd01_table+" cd01 where  cd01.hsien_id <> 'Y' ";
     			paramList_rule_2.add(wlx01_m_year);		
     			paramList_rule_2.add(S_YEAR+S_MONTH);  
     			if(szrpt_include.equals("B")){ 			 		  
     			    rule_2 += " )";
     			}else if(szrpt_include.equals("X")){ 			 		  
     				rule_2 += "  and hsien_id =?)";
     				paramList_rule_2.add(szhsien_id);  
     		    }			  
					rule_2 += "	         ) temp_1  left join (select * from bn01 where m_year=?)bn01 on temp_1.bank_no = bn01.bank_no and ";
					paramList_rule_2.add(wlx01_m_year);		
						  if(szrpt_output_type.equals("ALL")){
	               		     rule_2 += " bn01.bank_type in('6','7')";
	               		  }else if(szrpt_output_type.equals("6")){
	               		     rule_2 += " bn01.bank_type in('6')";
	               		  }else if(szrpt_output_type.equals("7")){
	               		     rule_2 += " bn01.bank_type in('7')";
	               		  }
						  
          			rule_2 += " left join "+condition_1+" where bank_type <> ' '";
          			for(int i=0;i<paramList_condition_1.size();i++){
                      paramList_rule_2.add(paramList_condition_1.get(i));
                    }
                if(szrpt_include.equals("B")){ 			           				  
                   rule_2 += " group by bank_type,  hsien_id"
		  			      + " order by bank_type,  hsien_id";		  				  
                }else if(szrpt_include.equals("X")){ 			           				  
                   rule_2 += " and bank_no <> ' '"
                          + " group by bank_type,  bank_no"
		  		 	      + " order by bank_type,  bank_no";		  				  
                }
          		paramList = new ArrayList(); 	  
				   sqlCmd = " Select   MTemp_2.* "
				  		  + " from ("
				   		  + "       select   MTemp_1.* ,  nvl(temp_3.T_Cnt,0)  as  T_Cnt ,  nvl(temp_3.OK_Cnt,0) as OK_Cnt"
				   		  + "		 from ( "+rule_1+")  MTemp_1 "
				   		  + "		 left join ("+rule_2+") temp_3 on ";
				for(int i=0;i<paramList_rule_1.size();i++){
                    paramList.add(paramList_rule_1.get(i));
                }  
                for(int i=0;i<paramList_rule_2.size();i++){
                    paramList.add(paramList_rule_2.get(i));
                } 		  
				if(szrpt_include.equals("B")){ 			           				  
				   sqlCmd += " MTemp_1.bank_type = temp_3.bank_type and "			 
             	   		   + " MTemp_1.hsien_id = temp_3.hsien_id "
				   		   + " ) MTemp_2  where T_CNT > 0 and ";
				}else if(szrpt_include.equals("X")){ 		
				   sqlCmd += " MTemp_1.bank_no = temp_3.bank_no "
						  +  " ) Mtemp_2  where T_CNT > 0  or (bank_no <> ' ' ) and";	           				  
				}
				   sqlCmd += " ((? = 'ALL') or (? <> 'ALL' and  hsien_id =?))"                    
                   		  + "  and ((?='ALL') OR (?='6' and  bank_type =  '6')"
			       		  + "  OR (?='7' and  bank_type =  '7')) "                                                     			       
				          + " order by  MTemp_2.bank_type,  MTemp_2.FR001W_output_order,";
				paramList.add(szhsien_id);				          
				paramList.add(szhsien_id);
				paramList.add(szhsien_id);
				paramList.add(szrpt_output_type);
				paramList.add(szrpt_output_type);
				paramList.add(szrpt_output_type);
				if(szrpt_include.equals("B")){ 			           				  
				   sqlCmd +=" MTemp_2.hsien_id";
				}else if(szrpt_include.equals("X")){ 			           				  
				   sqlCmd +=" MTemp_2.bank_no";
				}
	        }
	        if((rpt_output_type.equals("X") && szrpt_include.equals("T")) 
            || (rpt_output_type.equals("T") && szrpt_include.equals("T"))){                                  
	            rule_1 = " select ?  as S_Report_Name,"
    				   + " ' '  as BANK_NO,   ' ' as  BANK_NAME,";
    		   	paramList_rule_1.add(szrpt_code);	   
    			if(rpt_output_type.equals("X")){ 	   
    			   rule_1 += " bn01.bank_type as  Bank_Type,"
    				      +  " decode(bn01.bank_type,'6','農會','7','漁會',' ')  as  Bank_Type_Name,";
    			}else if(rpt_output_type.equals("T")){ 	   
    			   rule_1 += " 'T' as  Bank_Type,"
    					  +  "'農漁會'    as  Bank_Type_Name,";
    			}
    			rule_1 += " ' ' as  hsien_id,"
					    + " ' '  as  hsien_name,"
    				    + " ' '  as  FR001W_output_order,"
   					    + " nvl(rpt_dirf.RPT_Fname,' ')  as RPT_Fname,"
   					    + " nvl(rpt_dirf.RPT_FSize,' ')  as RPT_FSize,"
   					    + " nvl(((to_char(rpt_dirf.UPDATE_DATE,'yyyymmdd')-19110000)  || to_char(rpt_dirf.UPDATE_DATE,' hh24:mi')),' ')  as S_UpdateDate   "
					    + " from  ";
               if(rpt_output_type.equals("X")){ 	
                  rule_1 += "(select bank_type from (select * from bn01 where m_year=?)bn01 where bn01.bank_type = '6' group by bank_type "
	   					  + " union all"
       					  + " select bank_type from (select * from bn01 where m_year=?)bn01 where bn01.bank_type = '7' group by bank_type"
	   					  + " )  bn01"         
	 					  + " left join (select * from rpt_dirf where " + condition+ " ) rpt_dirf"
	            		  + "            on  SUBSTR(rpt_dirf.RPT_Fname,1,1) =  bn01.Bank_Type "
						  + " order by  bn01.Bank_Type";   
				 paramList_rule_1.add(wlx01_m_year);	  
				 paramList_rule_1.add(wlx01_m_year);	
				 for(int i=0;i<paramList_condition.size();i++){
                      paramList_rule_1.add(paramList_condition.get(i));
                 }   
			   }else if(rpt_output_type.equals("T")){ 
			      rule_1 += "(SELECT 'T'  as  bank_type  from DUAL )  bn01 "
       					  + " LEFT JOIN "
         				  + " rpt_dirf on "+ condition;
         		  for(int i=0;i<paramList_condition.size();i++){
                      paramList_rule_1.add(paramList_condition.get(i));
                  } 		  
			   } 			  
			   if(rpt_output_type.equals("X")){ 	
			      rule_2 = " select bank_type,";	
			   }else if(rpt_output_type.equals("T")){ 	
			      rule_2 = "select 'T' as bank_type,";
			   }
			   rule_2 += " count(*)  as  T_Cnt,"
		 			   + " SUM(decode(temp_2.Upd_Code,'U',1,0)) as  OK_Cnt"
					   + " from("
					   + "		select  nvl(temp_1.bank_no,' ')   as bank_no, "
        			   + "				nvl(temp_1.hsien_id,' ')  as hsien_id, "
	    			   + "				nvl(bn01.bank_type,' ')   as bank_type,"
					   + "				nvl(WML01.Upd_Code,' ')   as Upd_Code"
					   + "		from ("
					   + "		 		select wlx01.bank_no, wlx01.hsien_id from (select * from wlx01 where m_year=?)wlx01 "
     				   + "				where ((wlx01.CANCEL_NO = 'Y'  "
	         		   + "				and (to_char(wlx01.cancel_date,'yyyymm')-191101) <= ?)   "
			  		   + "				or (wlx01.CANCEL_NO <> 'Y')) "
			  		   + "				and wlx01.hsien_id in (select cd01.hsien_id from "+cd01_table+" cd01 where  cd01.hsien_id <> 'Y')"
					   + "      ) temp_1  left join (select * from bn01 where m_year=?)bn01 on temp_1.bank_no = bn01.bank_no and ";
			   paramList_rule_2.add(wlx01_m_year);	   
			   paramList_rule_2.add(S_YEAR+S_MONTH);
			   paramList_rule_2.add(wlx01_m_year);
			   
			   if(szrpt_output_type.equals("ALL")){
	              rule_2 += " bn01.bank_type in('6','7')";
	           }else if(szrpt_output_type.equals("6")){
	              rule_2 += " bn01.bank_type in('6')";
	           }else if(szrpt_output_type.equals("7")){
	              rule_2 += " bn01.bank_type in('7')";
	           }	   					   
          	   rule_2 += " left join " + condition_1;
          	   for(int i=0;i<paramList_condition_1.size();i++){
                   paramList_rule_2.add(paramList_condition_1.get(i));
               } 	   
			   if(rpt_output_type.equals("X")){ 	
			      rule_2 += " where bank_type <> ' '"
                		  + " group by bank_type";	
			   }else if(rpt_output_type.equals("T")){ 	
			      rule_2 += " where bank_type <> ' '";
			   }
	           paramList = new ArrayList(); 
	           sqlCmd = " Select   MTemp_2.* "
					  + " from ("
					  + "       select   MTemp_1.* ,  nvl(temp_3.T_Cnt,0)  as  T_Cnt ,  nvl(temp_3.OK_Cnt,0) as OK_Cnt"
				   	  + "		 from ( "+rule_1+")  MTemp_1 "
				   	  + "		 left join ("+rule_2+") temp_3 on MTemp_1.bank_type = temp_3.bank_type"
				      + " 		            ) MTemp_2  where T_CNT > 0";   
				for(int i=0;i<paramList_rule_1.size();i++){
                    paramList.add(paramList_rule_1.get(i));
                }  
                for(int i=0;i<paramList_rule_2.size();i++){
                    paramList.add(paramList_rule_2.get(i));
                }       
			  if(rpt_output_type.equals("X")){ 	
			     sqlCmd += "  and ((?='ALL') OR (?='6' and  bank_type =  '6')"
			       		 + "  OR (?='7' and  bank_type =  '7')) ";  
			     paramList.add(szrpt_output_type);  		      
			     paramList.add(szrpt_output_type);
			     paramList.add(szrpt_output_type);			    
			  }
			  sqlCmd += " order by  MTemp_2.bank_type";  			  
	        }
    		dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"t_cnt,ok_cnt");
    		if(dbData != null && dbData.size() != 0){
    		   System.out.println("QrydbData.size="+dbData.size());  
    		}else{
    		   System.out.println("dbData is null or size = 0");  
    		}
    		
			return dbData;
    }
%>	