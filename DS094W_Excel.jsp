<%
//110.10.04~08 created 系統登錄紀錄 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.Region" %>
<%@ page import="com.tradevan.util.Utility" %>								          
<%@ page import="com.tradevan.util.report.Report01" %>								          
<%@ page import="com.tradevan.util.report.HssfStyle" %>								          
<%@ page import="com.tradevan.util.report.reportUtil" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁   
   String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");			  
   System.out.println("act="+act);
   String printStyle = "";//輸出格式 108.04.29 add 	     
   //輸出格式 108.04.29 add
   if(session.getAttribute("printStyle") != null && !((String)session.getAttribute("printStyle")).equals("")){
   	 printStyle = (String)session.getAttribute("printStyle");		  				  
   }
   if(act.equals("view")){
      //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.04.29調整顯示的副檔名
   }else if (act.equals("download")){   
      response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.04.29調整顯示的副檔名
   }   
%>
<%
	NumberFormat nf = NumberFormat.getInstance();
	nf.setMinimumFractionDigits(2);                        // 若小數點不足二位，則補足二位
	String actMsg = "";
	FileOutputStream fileOut = null;      	
    HSSFCellStyle defaultStyle;
    HSSFCellStyle rightStyle;
    HSSFCellStyle noBorderDefaultStyle;
    HSSFCellStyle noBorderLeftStyle;
    HSSFCellStyle titleStyle;
	HSSFCellStyle columnStyle;
	HSSFCellStyle noBoderStyle;
	HSSFCellStyle leftStyle;
	HSSFRow row;
	HSSFRow acc_code_row;//讀取acc_code的row
	HSSFCell cell = null;//宣告一個儲存格
	String titleName = "";
    reportUtil reportUtil = new reportUtil();
    String BankList = "";//儲存bank_code/bank_name
    String btnFieldList = "";//儲存所選取的大類acc_code/名稱 
    String S_YEAR = "";//年
    String E_YEAR = "";//年
    String S_MONTH = "";//月
    String E_MONTH = "";//月    
    String S_DAY = "";//日
    String E_DAY = "";//日
    String S_DATE = "";    
    String E_DATE = "";    
    String sysType = "";//系統類別
    String loginFlag = "";//登入狀態
    List btnFieldList_data = null;
    List SortList_data = null;    
	int i = 0;
	int j= 0;
	int tmpCell=0;
	String lguser_name = ( session.getAttribute("muser_name")==null ) ? "" : (String)session.getAttribute("muser_name");
	String report_no="DS094W";
	System.out.println("=================DS094W.Excel.jsp start===================");		
	try{	      	
			//儲存報表的目錄================================================================
        	File reportDir = new File(Utility.getProperties("reportDir"));       
    		if(!reportDir.exists()){
     			if(!Utility.mkdirs(Utility.getProperties("reportDir"))){
     	   			actMsg +=Utility.getProperties("reportDir")+"目錄新增失敗";
     			}    
    		}
    		//==============================================================================    		
    		
			//報表欄位
			if(session.getAttribute("btnFieldList") != null && !((String)session.getAttribute("btnFieldList")).equals("")){
		   		btnFieldList = (String)session.getAttribute("btnFieldList");
		   		btnFieldList_data = Utility.getReportData(btnFieldList);
		   		System.out.println("btnFieldList_data.size()="+btnFieldList_data.size());		   
		   		System.out.println("btnFieldList_data="+btnFieldList_data);		   
			}
			//年
			if(session.getAttribute("S_YEAR") != null && !((String)session.getAttribute("S_YEAR")).equals("")){
		  		S_YEAR = (String)session.getAttribute("S_YEAR");		  				   
			}
			//年
			if(session.getAttribute("E_YEAR") != null && !((String)session.getAttribute("E_YEAR")).equals("")){
		  		E_YEAR = (String)session.getAttribute("E_YEAR");		  				   
			}			
			//月
			if(session.getAttribute("S_MONTH") != null && !((String)session.getAttribute("S_MONTH")).equals("")){
		  		S_MONTH = (String)session.getAttribute("S_MONTH");		  				   
			}
			//月
			if(session.getAttribute("E_MONTH") != null && !((String)session.getAttribute("E_MONTH")).equals("")){
		  		E_MONTH = (String)session.getAttribute("E_MONTH");		  				   
			}
			//日
			if(session.getAttribute("S_DAY") != null && !((String)session.getAttribute("S_DAY")).equals("")){
		  		S_DAY = (String)session.getAttribute("S_DAY");		  				   
			}
			//日
			if(session.getAttribute("E_DAY") != null && !((String)session.getAttribute("E_DAY")).equals("")){
		  		E_DAY = (String)session.getAttribute("E_DAY");		  				   
			}
			//起始日期
			if(session.getAttribute("S_DATE") != null && !((String)session.getAttribute("S_DATE")).equals("")){
		  		S_DATE = (String)session.getAttribute("S_DATE");		  				   
			}
			//結束日期
			if(session.getAttribute("E_DATE") != null && !((String)session.getAttribute("E_DATE")).equals("")){
		  		E_DATE = (String)session.getAttribute("E_DATE");		  				   
			}
			//系統類別
			if(session.getAttribute("sysType") != null && !((String)session.getAttribute("sysType")).equals("")){
		  		sysType = (String)session.getAttribute("sysType");		  				   
			}  
			//登入狀態
			if(session.getAttribute("loginFlag") != null && !((String)session.getAttribute("loginFlag")).equals("")){
		  		loginFlag = (String)session.getAttribute("loginFlag");		  				   
			}
			titleName += "系統登錄紀錄明細資料";		  		
			//讀取欄位大類所包含的細項===================================================================================        	
        	Properties prop_column = new Properties();
			StringBuffer sql = new StringBuffer();		
	        List paramList = new ArrayList();
	        DataObject bean = null;
            sql.append(" select acc_code,acc_name from  ncacno_ds where acc_tr_type=? order by acc_range ");
     		paramList.add(report_no);
     		List qData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,""); 
			for(i=0;i<qData.size();i++){
			    bean = (DataObject)qData.get(i);
			    prop_column.setProperty((String)bean.getValue("acc_code"),(String)bean.getValue("acc_code"));  
	        }		
			//=======================================================================================================================			
			//取出欄位細項將資料存入MAP-->key=大類acc_code,value=細項acc_code=============================================================
			HashMap h_column = new HashMap();//儲存column大類,及其細項的acc_code			
			List detail_column = new LinkedList();
			String column_tmp = "";			
			String selectacc_code = "";//選取的detail科目代號		
			String field_sum="";			
			String ori_field="";
			int columnLength=0;//column個數
			for(i=0;i<btnFieldList_data.size();i++){			    
			    column_tmp = "";
			    column_tmp = (String)prop_column.get((String)((List)btnFieldList_data.get(i)).get(0));
			    if(!column_tmp.equals("")){
			        detail_column = Utility.getStringTokenizerData(column_tmp,"+");
			        if(detail_column != null && detail_column.size() != 0){               
			           columnLength += detail_column.size();//累加總欄位個數
              		   for(j=0;j<detail_column.size();j++){
            	 		   selectacc_code +=(String)detail_column.get(j); 
            	 		   ori_field += (String)detail_column.get(j);
            	 		   if(j < detail_column.size()-1){
            	 		      selectacc_code +=",";            	 		      
            	 		      ori_field +=",";            	 		      
            	 		   }  
               		   }                              		   
            	   }  			      
			       h_column.put((String)((List)btnFieldList_data.get(i)).get(0),detail_column);			       
			       if(i < btnFieldList_data.size()-1){
			          selectacc_code +=",";
			          ori_field +=",";            	
			       }   
			    }
			}
			System.out.println("h_column.size()="+h_column.size());
			System.out.println("select acc_code="+selectacc_code);        		
  			
  			/*
  			 select wtt06.muser_id as field_muser_id,--登入帳號
             bank_type,tbank_no,
             bank_name as field_bank_name,--總機構名稱
             muser_name as field_muser_name,--使用者名稱
             F_TRANSCHINESEDATE(input_date) || to_char(wtt06.input_date,' HH24:MI:SS') as field_input_date,--登入時間
             case login_flag 
             when 'Y' then '成功'
             when 'N' then '失敗'
             end as field_login_flag,--登入狀態
             F_TRANSCHINESEDATE(logout_time) || to_char(wtt06.logout_time,' HH24:MI:SS') as field_logout_time,--登出時間
             decode(type,'1','申報系統','2','MIS管理系統','') as field_sys_type,--系統類別
             ip_address as field_ip_addr --來源IP
             from wtt06 left join (select muser_id,muser_name,wtt01.bank_type,tbank_no,bank_name
             from wtt01 left join (select * from bn01 where m_year=100)bn01 on wtt01.tbank_no=bn01.bank_no
             )wtt01 on wtt06.muser_id=wtt01.muser_id
             where 1=1
             and TO_CHAR(input_date ,'yyyymmdd') BETWEEN 'UI.登入日期begin ex:20210101' AND 'UI.登入日期end ex:20210831'
             and type ='UI.系統類別' 
             and login_flag='UI.登入狀態'
             order by wtt06.input_date desc
  			*/

  			
            //String column = "";//選取欄位           
			//======================================================
            StringBuffer sqlCmd =new StringBuffer();            
            List sqlCmd_paramList = new ArrayList();
            int parami = 0;
   			sqlCmd.append(" select wtt06.muser_id as field_muser_id, ");//--登入帳號
            sqlCmd.append(" bank_type,tbank_no, ");
            sqlCmd.append(" bank_name as field_bank_name, ");//--總機構名稱
            sqlCmd.append(" muser_name as field_muser_name, ");//--使用者名稱
            sqlCmd.append(" F_TRANSCHINESEDATE(input_date) || to_char(wtt06.input_date,' HH24:MI:SS') as field_input_date, ");//--登入時間
            sqlCmd.append(" case login_flag ");
            sqlCmd.append(" when 'Y' then '成功' ");
            sqlCmd.append(" when 'N' then '失敗' ");
            sqlCmd.append(" end as field_login_flag, ");//--登入狀態
            sqlCmd.append(" F_TRANSCHINESEDATE(logout_time) || to_char(wtt06.logout_time,' HH24:MI:SS') as field_logout_time, ");//--登出時間
            sqlCmd.append(" decode(type,'1','申報系統','2','MIS管理系統','') as field_sys_type, ");//--系統類別
            sqlCmd.append(" ip_address as field_ip_addr ");//--來源IP
            sqlCmd.append(" from wtt06 left join (select muser_id,muser_name,wtt01.bank_type,tbank_no,bank_name ");
            sqlCmd.append(" from wtt01 left join (select * from bn01 where m_year=?)bn01 on wtt01.tbank_no=bn01.bank_no ");
            sqlCmd.append(" )wtt01 on wtt06.muser_id=wtt01.muser_id ");
            sqlCmd.append(" where 1=1 ");

            sqlCmd_paramList.add("100");
            if(!"".equals(S_DATE) && !"".equals(E_DATE)) {//登入時間
    	     sqlCmd.append(" and TO_CHAR(input_date ,'yyyymmdd') BETWEEN ? AND ? ");
    	     sqlCmd_paramList.add(String.valueOf(Integer.parseInt(S_DATE)+19110000));
    	     sqlCmd_paramList.add(String.valueOf(Integer.parseInt(E_DATE)+19110000));
	        }
            
            if(!"ALL".equals(sysType)){
            sqlCmd.append(" and type = ? ");            
            sqlCmd_paramList.add(sysType);
        	}
        	
        	if(!"ALL".equals(loginFlag)){
            sqlCmd.append(" and login_flag = ? ");			
			sqlCmd_paramList.add(loginFlag);
        	}
            
            sqlCmd.append(" order by wtt06.input_date desc ");
			List dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),sqlCmd_paramList,"field_input_date,field_logout_time");
            System.out.println("dbData.size()="+dbData.size());
			//讀取報表欄位名稱===================================================================================        	
        	Properties prop_column_name = new Properties();
			sql = new StringBuffer();		
	        paramList = new ArrayList();
	        bean = null;
            sql.append(" select acc_code,acc_name from ncacno_ds where acc_tr_type=? order by acc_range ");
     		paramList.add(report_no);
     		qData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,""); 
			for(i=0;i<qData.size();i++){
			    bean = (DataObject)qData.get(i);
			    prop_column_name.setProperty((String)bean.getValue("acc_code"),(String)bean.getValue("acc_name"));  
			}	
			//====================================================================================================
			
            //Creating Cells
            HSSFWorkbook wb = new HSSFWorkbook();
            HSSFSheet sheet = wb.createSheet( "report" ); //建立sheet，及名稱
            wb.setSheetName(0, titleName, HSSFWorkbook.ENCODING_UTF_16 );
            HSSFPrintSetup ps = sheet.getPrintSetup(); //取得設定            
            //設定頁面符合列印大小          
            sheet.setAutobreaks( false );
            ps.setScale( ( short )100 ); //列印縮放百分比
            ps.setPaperSize( ( short )9 ); //設定紙張大小 A4            
            ps.setLandscape( true ); // 設定橫印           
            HSSFFooter footer = sheet.getFooter();            
            //設定樣式和位置(請精減style物件的使用量，以免style物件太多excel報表無法開啟)
			defaultStyle = reportUtil.getDefaultStyle(wb);//有框內文置中
			rightStyle = reportUtil.getRightStyle(wb);//有框內文置右
			leftStyle = reportUtil.getLeftStyle(wb);//有框內文置右
    		noBorderDefaultStyle = reportUtil.getNoBorderDefaultStyle(wb);//無框內文置中
    		noBorderLeftStyle = reportUtil.getNoBorderLeftStyle(wb);//無框內文置左
			reportUtil.setDefaultStyle(defaultStyle);
			reportUtil.setNoBorderDefaultStyle(noBorderDefaultStyle);			
    		titleStyle = reportUtil.getTitleStyle(wb); //標題用
    		columnStyle = reportUtil.getColumnStyle(wb);//報表欄位名稱用--有框內文置中			                                               
    		noBoderStyle = reportUtil.getNoBoderStyle(wb);//無框置右			                                               
    		//============================================================================                        
            //設定表頭===============================================================================
            row = sheet.createRow( ( short )1 );
            reportUtil.createCell( wb, row, ( short )1, titleName, titleStyle );
            
            for(i=2;i<columnLength+1;i++){
              reportUtil.createCell( wb, row, ( short )i, "", noBorderDefaultStyle );
            }            
            sheet.addMergedRegion( new Region( ( short )1, ( short )1,
                                               ( short )1,
                                               ( short )columnLength ) );
                                                           
            //列印年月=======================================================================================
            row = sheet.createRow( ( short )2 );            
            row.setHeight((short) 0x200);
            //95.12.01 add 查詢年月區間
            reportUtil.createCell( wb, row, ( short )1, S_YEAR + "年" + S_MONTH + "月" + S_DAY + "日~" + E_YEAR  +  "年" + E_MONTH +  "月" +  E_DAY+ "日" , titleStyle );
            for(i=2;i<columnLength+1;i++){
               reportUtil.createCell( wb, row, ( short )i, "", noBorderDefaultStyle );
            }            
            
            sheet.addMergedRegion( new Region( ( short )2, ( short )1,
                                               ( short )2,
                                               ( short )columnLength ) );
         
            //======================================================================================================                                                                     
            row = sheet.createRow( ( short )3 );            
            String printTime = Utility.getDateFormat("  HH:mm:ss");
            String printDate = Utility.getDateFormat("yyyy/MM/dd");                                    
            reportUtil.createCell( wb, row, ( short )1, "列印日期："+Utility.getCHTdate(printDate, 1)+printTime, noBoderStyle );
     
            sheet.addMergedRegion( new Region( ( short )3, ( short )1,
                                               ( short )3,
                                               ( short )columnLength ) );            
             /*110.10.05                                   
            row = sheet.createRow( ( short )4 );                        
            //列印單位=======================================================================================            
            //System.out.println("columnLength="+columnLength);
            //reportUtil.createCell( wb, row, ( short )1, "單位：新台幣"+Utility.getUnitName(Unit)+"、％", noBorderLeftStyle );                                                
            /*
            sheet.addMergedRegion( new Region( ( short )4, ( short )1,
                                               ( short )4,
                                               ( short )2) );          
            */                                   
            //設定列印人員==========================================================            
            row = sheet.createRow( ( short )4 );     
            reportUtil.createCell( wb, row, ( short )1, "列印人員："+lguser_name, noBoderStyle );
            
            sheet.addMergedRegion( new Region( ( short )4, ( short )2,
                                               ( short )4,
                                               ( short )columnLength ) );            
                                              
            //報表欄位=======================================================================
            
            //列印單位代號+機構名稱            
            /*
            for(i=5;i<8;i++){
                row = sheet.createRow( ( short )i );                
                reportUtil.createCell( wb, row, ( short )1, "項目", columnStyle );
                
            }           
            sheet.addMergedRegion( new Region( ( short )5, ( short )1,
                                               ( short )7,
                                               ( short )1) );                                                                                              
            */                             
            int columnIdx = 1;
            row = sheet.createRow( ( short )5);   
            for(i=0;i<btnFieldList_data.size();i++){
               System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1)+":"+(String)((List)btnFieldList_data.get(i)).get(0));
               System.out.println("columnIdx="+columnIdx);
               //設定表頭欄位名稱
               for(j=columnIdx;j<((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size() + columnIdx;j++){
                  reportUtil.createCell( wb, row, ( short )j, (String)((List)btnFieldList_data.get(i)).get(1), columnStyle );               
               }
               /*
               sheet.addMergedRegion( new Region( ( short )5, ( short )columnIdx,
                                               ( short )5,
                                               ( short )(((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size() + columnIdx - 1)) );                                              
               */                                 
               columnIdx +=  ((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size();                                             
            }
            columnIdx = 1;
            row = sheet.createRow( ( short )6);   
            for(i=0;i<btnFieldList_data.size();i++){
               //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1)+":"+(String)((List)btnFieldList_data.get(i)).get(0));
               System.out.println("columnIdx="+columnIdx);
               //設定表頭欄位field_name
               for(j=columnIdx;j<((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size() + columnIdx;j++){
                  reportUtil.createCell( wb, row, ( short )j, (String)((List)btnFieldList_data.get(i)).get(0), columnStyle );               
               }
               /*
               sheet.addMergedRegion( new Region( ( short )5, ( short )columnIdx,
                                               ( short )5,
                                               ( short )(((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size() + columnIdx - 1)) );                                              
               */                                
               columnIdx +=  ((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size();                                             
            }
            //設定表頭欄位(選項)
            /*
            for(i=0;i<btnFieldList_data.size();i++){
               int rowNum=5+i;
               row = sheet.createRow( ( short )rowNum );
               cell=row.createCell((short)1);
               reportUtil.createCell( wb, row, (short)1, (String)((List)btnFieldList_data.get(i)).get(1), leftStyle );
   	           sheet.setColumnWidth((short)1, (short)(((String)((List)btnFieldList_data.get(i)).get(1)).length()));
   	           
            }
            */
            short rowNo = ( short )7;//資料起始列     
			//無資料時,顯示訊息========================================================================			
			if(dbData == null || dbData.size() == 0){
			   	row = sheet.createRow( rowNo );     
                row.setHeight((short) 0x120); 
                reportUtil.createCell( wb, row, ( short )1,"無資料" ,noBorderDefaultStyle ); 
                sheet.addMergedRegion( new Region( ( short )7, ( short )1,
                                               ( short )7,
                                               ( short )columnLength) );
			}else{
				
			    //將DBData寫入===============================================================================================      
                acc_code_row = sheet.getRow(6);
                short lastCellNum = acc_code_row.getLastCellNum();
                //System.out.println("lastCellNum="+lastCellNum);                        
                columnIdx = 1;       
                double amt_d = 0.0;                 
                float amt_f = 0; 
                String amt_type="";
                String amt="";
                String prtbank_code="";
                for(i=0;i<dbData.size();i++){            
                    row = sheet.createRow( rowNo );  
                    bean = (DataObject)dbData.get(i);
                    //System.out.println("rowNo="+rowNo);    
                    row.setHeight((short) 0x120);                     
                     for(int cellIdx =1;cellIdx < (new Short(lastCellNum)).intValue();cellIdx++){                    
                         amt="";
                         amt_type = "";
                         cell = acc_code_row.getCell((short)cellIdx);                    
                         //System.out.println("acc_code="+cell.getStringCellValue()); 
         			     if(bean.getValue(cell.getStringCellValue()) != null){                         
                            amt = bean.getValue(cell.getStringCellValue()).toString();
                            //System.out.println("amt="+amt);
                         }   
                           reportUtil.createCell( wb, row, ( short )columnIdx, amt, defaultStyle );               
                         columnIdx ++;
                    }
                    columnIdx = 1;
                    rowNo++;                    
                }   
                        
            }//end of 有data   
            
            //把中間值的acc_code合併成一個欄位=======================================================================            
           
            columnIdx = 1;
            
            row = sheet.getRow(5);
            System.out.println("LastCellNum="+row.getLastCellNum());			
			//合併acc_code時,科目代號跟欄位名稱時,合併後的列會縮小			
            for(i=0;i<btnFieldList_data.size();i++){
                //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(0));                
                //System.out.println("columnIdx="+columnIdx); 
          		//System.out.println("merge.acc_code="+(String)((List)btnFieldList_data.get(i)).get(0));
                    
                for(j=columnIdx;j<((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size() + columnIdx;j++){
                   reportUtil.createCell( wb, row, ( short )j, (String)((List)btnFieldList_data.get(i)).get(1), columnStyle );               
                }
                
                //設定表頭欄位.把中間值的acc_code合併成一個欄位只顯示中文名稱=====================================                   
                sheet.addMergedRegion( new Region( ( short )5, ( short )columnIdx,
                			                       ( short )6,
                            		               ( short )(((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size() + columnIdx - 1)) );                                              
                     
                columnIdx +=  ((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size();                                                             
            }
            
            //設定寬度============================================================            
            for ( i = 1; i <= columnLength; i++ ) {                                                                        
				if(i==4 || i==6){
                  sheet.setColumnWidth( ( short )i,
                                        ( short ) ( 256 * ( 25 + 4 ) ) );//登入/登出時間
                }else{
                  sheet.setColumnWidth( ( short )i,
                                        ( short ) ( 256 * ( 15 + 4 ) ) );
                }                                             
            }
            
			//======================================================================================
            //設定涷結欄位
            //sheet.createFreezePane(0,1,0,1);
            footer.setCenter( "Page:" + HSSFFooter.page() + " of " +
                             HSSFFooter.numPages() );		                                 
			footer.setRight(Utility.getDateFormat("yyyy/MM/dd hh:mm aaa"));			
			
            // Write the output to a file            
            fileOut = new FileOutputStream( Utility.getProperties("reportDir")+System.getProperty("file.separator")+ titleName+".xls" );
            wb.write( fileOut );
            fileOut.close();            
            
            String filename = titleName+".xls";//108.06.03 add
            if(!printStyle.equalsIgnoreCase("xls")) {//108.06.03非xls檔須執行轉換	                
            	rptTrans rptTrans = new rptTrans();	  			
            	filename = rptTrans.transOutputFormat (printStyle,filename,""); 
            	System.out.println("newfilename="+filename);	  			   
            }

            FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+  filename);//108.06.03 fix  		 
			ServletOutputStream out1 = response.getOutputStream();           
			byte[] line = new byte[8196];
			int getBytes=0;
			while( ((getBytes=fin.read(line,0,8196)))!=-1 ){		    		
				out1.write(line,0,getBytes);
				out1.flush();
	    	}
		
			fin.close();
			out1.close();          		      
        } catch ( Exception e ) {            
            e.printStackTrace();
            
        } finally {
            try {
                if ( fileOut != null ) {
                    fileOut.close();
                }
            } catch ( Exception e ) {
                  System.out.println(e.getMessage() );
            }
        }
        
%>
<%!
public static String addZeroForNum(String str, int strLength) {
    int strLen = str.length();
    if (strLen < strLength) {
        while (strLen < strLength) {
            StringBuffer sb = new StringBuffer();
            sb.append("0").append(str);//左補零
            //sb.append(str).append("0");//右補零
            str = sb.toString();
            strLen = str.length();
        }
    }
    return str;
}
public static String splitStr(String str, int i) {
    String[] strarray=str.split(",");
    return strarray[i];
}
%>	    		