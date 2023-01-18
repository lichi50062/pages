﻿<%
//101.07.31 create 農信保--貸款用途分析表(M106) by 2295
//108.04.29 add 報表格式轉換 by 2295
//111.04.08 fix 有細項的欄位才橫向合併 by 2295
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
	DecimalFormat dft = new DecimalFormat("#.##");
	String actMsg = "";
	FileOutputStream fileOut = null;      	
    HSSFCellStyle defaultStyle;
    HSSFCellStyle rightStyle;
    HSSFCellStyle noBorderDefaultStyle;
    HSSFCellStyle noBorderLeftStyle;
    HSSFCellStyle titleStyle;
	HSSFCellStyle columnStyle;
	HSSFCellStyle noBoderStyle;
	HSSFRow row;
	HSSFRow acc_code_row;//讀取acc_code的row
	HSSFCell cell = null;//宣告一個儲存格
	String titleName = "";
    reportUtil reportUtil = new reportUtil();
    String BankList = "";//儲存bank_code/bank_name
    String btnFieldList = "";//儲存所選取的大類acc_code/名稱 
    String Unit = "";//列印單位
    String S_YEAR = "";//年
    String E_YEAR = "";//年
    String S_MONTH = "";//月
    String E_MONTH = "";//月    
    List btnFieldList_data = null;
    List SortList_data = null;    
	int i = 0;
	int j= 0;
	String lguser_name = ( session.getAttribute("muser_name")==null ) ? "" : (String)session.getAttribute("muser_name");
	String report_no="M106";
			
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
						
			titleName += "貸款用途分析表(M106)";		  		
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
			//金額單位
			if(session.getAttribute("Unit") != null && !((String)session.getAttribute("Unit")).equals("")){
		  		Unit = (String)session.getAttribute("Unit");		  				   
			}  
		
			//讀取欄位大類所包含的細項===================================================================================        	
        	Properties prop_column = new Properties();
			StringBuffer sql = new StringBuffer();		
	        List paramList = new ArrayList();
	        DataObject bean = null;
            sql.append(" select cano,rulename from rptrule_acgf where acc_tr_type=? and type='1' order by cano ");
     		paramList.add(report_no);
     		List dbData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,""); 
			for(i=0;i<dbData.size();i++){
			    bean = (DataObject)dbData.get(i);
			    prop_column.setProperty((String)bean.getValue("cano"),(String)bean.getValue("rulename"));  
	        }		
			//=======================================================================================================================			
			//取出欄位細項將資料存入MAP-->key=大類acc_code,value=細項acc_code=============================================================
			HashMap h_column = new HashMap();//儲存column大類,及其細項的acc_code			
			List detail_column = new LinkedList();
			String column_tmp = "";			
			String selectacc_code = "";//選取的detail科目代號		
			String field_sum="";			
			String ori_field="";
			String trans_field="";
			int columnLength=0;//column個數
			for(i=0;i<btnFieldList_data.size();i++){			    
			    column_tmp = "";
			    column_tmp = (String)prop_column.get((String)((List)btnFieldList_data.get(i)).get(0));
			    //System.out.println("column_tmp="+column_tmp);
			    if(!column_tmp.equals("")){
			        detail_column = Utility.getStringTokenizerData(column_tmp,"+");
			        System.out.println(detail_column);
			        if(detail_column != null && detail_column.size() != 0){               
			           columnLength += detail_column.size();//累加總欄位個數
              		   for(j=0;j<detail_column.size();j++){
            	 		   selectacc_code +="'"+(String)detail_column.get(j)+"'";           	
            	 		   trans_field = (String)detail_column.get(j);
            	 		   ori_field += (String)detail_column.get(j);
            	 		   //合計欄位,不加入field_sum,獨立選取
            	 		   if(!trans_field.equals("guarantee_cnt_year0") && !trans_field.equals("loan_amt_year0") && !trans_field.equals("guarantee_amt_year0")
            	 		   && !trans_field.equals("guarantee_cnt_sum0") && !trans_field.equals("loan_amt_sum0") && !trans_field.equals("guarantee_amt_sum0")){
            	 		       if(field_sum.indexOf(trans_field) == -1){//95.10.03 fix 若不存在時,才加入sum的acc_code裡
            	 		       	//System.out.println(trans_field.substring(trans_field.length()-1,trans_field.length()));//'A'
            	 		       	//System.out.println(trans_field.substring(0,trans_field.length()-2));//'filename'            	 		   	
            	 		          field_sum += " ,sum(decode(loan_use_no,'"+trans_field.substring(trans_field.length()-1,trans_field.length()).toUpperCase()+"',"+trans_field.substring(0,trans_field.length()-2)+",0)) as "+trans_field;
						       }              
            	 		   }            	 		  				
            	 		   //====================================================================================================================================
            	 		   if(j < detail_column.size()-1){
            	 		      selectacc_code +=",";            	 		      
            	 		      ori_field +=",";            	 		      
            	 		   }  
               		   }                              		   
               		   //System.out.println("select acc_code="+selectacc_code);
            	   }else{
            	       
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
  			select m_year || '/' || decode(length(m_month),'1','0','') || m_month as m_yearmonth,
                   guarantee_cnt_year_a,guarantee_cnt_year_b,loan_amt_year_a,loan_amt_year_b,guarantee_cnt_year0
            from (
                  select m_year,m_month,
                         sum(decode(loan_use_no,'A',guarantee_cnt_year,0)) as guarantee_cnt_year_a,--當年度件數-耕作
                         sum(decode(loan_use_no,'B',guarantee_cnt_year,0)) as guarantee_cnt_year_b,--當年度件數-畜牧
                         sum(decode(loan_use_no,'C',guarantee_cnt_year,0)) as guarantee_cnt_year_c,--當年度件數-養殖
                         sum(decode(loan_use_no,'D',guarantee_cnt_year,0)) as guarantee_cnt_year_d,--當年度件數-捕撈
                         sum(decode(loan_use_no,'E',guarantee_cnt_year,0)) as guarantee_cnt_year_e,--當年度件數-加工
                         sum(decode(loan_use_no,'F',guarantee_cnt_year,0)) as guarantee_cnt_year_f,--當年度件數-運銷
                         sum(decode(loan_use_no,'G',guarantee_cnt_year,0)) as guarantee_cnt_year_g,--當年度件數-倉儲
                         sum(decode(loan_use_no,'H',guarantee_cnt_year,0)) as guarantee_cnt_year_h,--當年度件數-其他
                         sum(decode(loan_use_no,'0',guarantee_cnt_year,0)) as guarantee_cnt_year_0,--當年度件數-合計
                         sum(decode(loan_use_no,'A',loan_amt_year,0)) as loan_amt_year_a,--當年度貸款金額-耕作
                         sum(decode(loan_use_no,'B',loan_amt_year,0)) as loan_amt_year_b,--當年度貸款金額-畜牧
                         sum(decode(loan_use_no,'C',loan_amt_year,0)) as loan_amt_year_c,--當年度貸款金額-養殖
                         sum(decode(loan_use_no,'D',loan_amt_year,0)) as loan_amt_year_d,--當年度貸款金額-捕撈
                         sum(decode(loan_use_no,'E',loan_amt_year,0)) as loan_amt_year_e,--當年度貸款金額-加工
                         sum(decode(loan_use_no,'F',loan_amt_year,0)) as loan_amt_year_f,--當年度貸款金額-運銷
                         sum(decode(loan_use_no,'G',loan_amt_year,0)) as loan_amt_year_g,--當年度貸款金額-倉儲
                         sum(decode(loan_use_no,'H',loan_amt_year,0)) as loan_amt_year_h,--當年度貸款金額-其他
                         sum(decode(loan_use_no,'0',loan_amt_year,0)) as loan_amt_year_0, ---當年度貸款金額-合計
                         sum(decode(loan_use_no,'0',guarantee_cnt_year,0)) as guarantee_cnt_year0,--當年度件數-合計
                         sum(decode(loan_use_no,'0',loan_amt_year,0)) as loan_amt_year0,--當年度貸款金額-合計
                         sum(decode(loan_use_no,'0',guarantee_amt_year,0)) as guarantee_amt_year0,--當年度保證金額-合計
                         sum(decode(loan_use_no,'0',guarantee_cnt_sum,0)) as guarantee_cnt_sum0,--累計件數-合計
                         sum(decode(loan_use_no,'0',loan_amt_sum,0)) as loan_amt_sum0,--累計貸款金額-合計
                         sum(decode(loan_use_no,'0',guarantee_amt_sum,0)) as guarantee_amt_sum0,--累計保證金額-合計
                  from m106
                  where (to_char(m_year * 100 + m_month) >= 10001 and to_char(m_year * 100 + m_month) <= 10106)
                  group by m_year,m_month
                 )m106
            group by m_year,m_month,guarantee_cnt_year_a,guarantee_cnt_year_b,loan_amt_year_a,loan_amt_year_b,guarantee_cnt_year0
            order by m_year,m_month
  			*/
  			
            String column = "";//選取欄位           
			//======================================================
            StringBuffer sqlCmd =new StringBuffer();            
            int parami = 0;
            List sqlCmd_paramList = new ArrayList();
            
            List main_table_paramList = new ArrayList();
            StringBuffer main_table=new StringBuffer(); 
		          
			
			
			sqlCmd.append(" select m_year || '/' || decode(length(m_month),'1','0','') || m_month as m_yearmonth,");
			sqlCmd.append(ori_field);
            sqlCmd.append(" from (");
            sqlCmd.append("      select m_year,m_month");
            sqlCmd.append(field_sum +",");    
            sqlCmd.append(" sum(decode(loan_use_no,'0',guarantee_cnt_year,0)) as GUARANTEE_CNT_YEAR0,");//--當年度件數-合計
            sqlCmd.append(" sum(decode(loan_use_no,'0',loan_amt_year,0)) as LOAN_AMT_YEAR0,");//--當年度貸款金額-合計
            sqlCmd.append(" sum(decode(loan_use_no,'0',guarantee_amt_year,0)) as GUARANTEE_AMT_YEAR0,");//--當年度保證金額-合計
            sqlCmd.append(" sum(decode(loan_use_no,'0',guarantee_cnt_sum,0)) as GUARANTEE_CNT_SUM0,");//--累計件數-合計
            sqlCmd.append(" sum(decode(loan_use_no,'0',loan_amt_sum,0)) as LOAN_AMT_SUM0,");//--累計貸款金額-合計
            sqlCmd.append(" sum(decode(loan_use_no,'0',guarantee_amt_sum,0)) as GUARANTEE_AMT_SUM0");//--累計保證金額-合計        
            sqlCmd.append("      from m106");
            //sqlCmd.append("      where (to_char(m_year * 100 + m_month) >= ? and to_char(m_year * 100 + m_month) <= ?)");//101.11.05
            sqlCmd.append("      where ((m_year * 100 + m_month) >= ? and (m_year * 100 + m_month) <= ?)");		
            sqlCmd.append("      group by m_year,m_month");
            sqlCmd.append("     )m106");
            sqlCmd.append(" group by m_year,m_month,"+ori_field);
            sqlCmd.append(" order by m_year,m_month");
			
			sqlCmd_paramList.add(S_YEAR+S_MONTH);	
			sqlCmd_paramList.add(E_YEAR+E_MONTH);
			
						      
            System.out.println("sqlCmd="+sqlCmd.toString());
            //讀取報表欄位名稱===================================================================================        	
        	Properties prop_column_name = new Properties();
			sql = new StringBuffer();		
	        paramList = new ArrayList();
	        bean = null;
	        sql.append(" select cano,rulename from rptrule_acgf where acc_tr_type=? and type='2' order by cano ");
     		paramList.add(report_no);
     		dbData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,""); 
			for(i=0;i<dbData.size();i++){
			    bean = (DataObject)dbData.get(i);
			    prop_column_name.setProperty((String)bean.getValue("cano"),(String)bean.getValue("rulename"));  
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
            
            for(i=2;i<columnLength+2;i++){
              reportUtil.createCell( wb, row, ( short )i, "", noBorderDefaultStyle );
            }            
            sheet.addMergedRegion( new Region( ( short )1, ( short )1,
                                               ( short )1,
                                               ( short )(columnLength+1)) );
                                                           
            //列印年月=======================================================================================
            row = sheet.createRow( ( short )2 );            
            row.setHeight((short) 0x200);
            //95.12.01 add 查詢年月區間
            reportUtil.createCell( wb, row, ( short )1, S_YEAR + "年" + S_MONTH + "月~"+E_YEAR + "年" + E_MONTH + "月", titleStyle );
            for(i=2;i<columnLength+2;i++){
               reportUtil.createCell( wb, row, ( short )i, "", noBorderDefaultStyle );
            }            
            sheet.addMergedRegion( new Region( ( short )2, ( short )1,
                                               ( short )2,
                                               ( short )(columnLength+1) ) );
            //======================================================================================================                                                                     
            row = sheet.createRow( ( short )3 );            
            String printTime = Utility.getDateFormat("  HH:mm:ss");
            String printDate = Utility.getDateFormat("yyyy/MM/dd");                                    
            reportUtil.createCell( wb, row, ( short )1, "列印日期："+Utility.getCHTdate(printDate, 1)+printTime, noBoderStyle );
            sheet.addMergedRegion( new Region( ( short )3, ( short )1,
                                               ( short )3,
                                               ( short )(columnLength+1) ) );            
            row = sheet.createRow( ( short )4 );                        
            //列印單位=======================================================================================            
            //System.out.println("unit_name="+Utility.getUnitName(Unit));                                               
            //System.out.println("columnLength="+columnLength);
            reportUtil.createCell( wb, row, ( short )1, "單位：新台幣"+Utility.getUnitName(Unit)+"、％", noBorderLeftStyle );                                                
            /*
            sheet.addMergedRegion( new Region( ( short )4, ( short )1,
                                               ( short )4,
                                               ( short )2) );          
            */                                   
            //設定列印人員==========================================================            
            reportUtil.createCell( wb, row, ( short )2, "列印人員："+lguser_name, noBoderStyle );
            sheet.addMergedRegion( new Region( ( short )4, ( short )2,
                                               ( short )4,
                                               ( short )(columnLength+1) ) );            
            //報表欄位=======================================================================
            //列印單位代號+機構名稱            
            for(i=5;i<8;i++){
                row = sheet.createRow( ( short )i );                
                reportUtil.createCell( wb, row, ( short )1, "查詢年月", columnStyle );
            }           
            sheet.addMergedRegion( new Region( ( short )5, ( short )1,
                                               ( short )7,
                                               ( short )1) );                                                                     
                                                                                                       
            row = sheet.createRow( ( short )5 );//大類表頭
            int columnIdx = 2;
            for(i=0;i<btnFieldList_data.size();i++){
            	//System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(0));
               //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1));
               //System.out.println("columnIdx="+columnIdx);
               //設定表頭欄位
               for(j=columnIdx;j<((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size() + columnIdx;j++){
                  reportUtil.createCell( wb, row, ( short )j, (String)((List)btnFieldList_data.get(i)).get(1), columnStyle );               
               }
                                   
               //111.04.08 fix 有細項的欄位才橫向合併
               if(!((String)((List)btnFieldList_data.get(i)).get(0)).equals("GUARANTEE_CNT_YEAR0") && !((String)((List)btnFieldList_data.get(i)).get(0)).equals("LOAN_AMT_YEAR0")
               && !((String)((List)btnFieldList_data.get(i)).get(0)).equals("GUARANTEE_AMT_YEAR0") && !((String)((List)btnFieldList_data.get(i)).get(0)).equals("GUARANTEE_CNT_SUM0")
               && !((String)((List)btnFieldList_data.get(i)).get(0)).equals("LOAN_AMT_SUM0") && !((String)((List)btnFieldList_data.get(i)).get(0)).equals("GUARANTEE_AMT_SUM0")){ 
               sheet.addMergedRegion( new Region( ( short )5, ( short )columnIdx,
                                               ( short )5,
                                               ( short )(((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size() + columnIdx - 1)) );                                              
               }                                               
               columnIdx +=  ((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size();                                             
            }
            
            row = sheet.createRow( ( short ) 6);//細項表頭
            columnIdx = 2;          
            for(i=0;i<btnFieldList_data.size();i++){
               //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1));
               //System.out.println("columnIdx="+columnIdx);
               detail_column = (List)h_column.get(((List)btnFieldList_data.get(i)).get(0));//取出該大項的細類
               //System.out.println("detail_column="+detail_column);
               //設定細項表頭欄位
               for(j=0 ;j<detail_column.size();j++){                    
                  //System.out.println((String)detail_column.get(j)+"="+((String)prop_column_name.get((String)detail_column.get(j)));                                           
                  reportUtil.createCell( wb, row, ( short )columnIdx, (String)prop_column_name.get((String)detail_column.get(j)), columnStyle );               
                  columnIdx ++;
               }                              
            }
            row = sheet.createRow( ( short ) 7);//細項-科目代號
            columnIdx = 2;          
            for(i=0;i<btnFieldList_data.size();i++){
               //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1));
               //System.out.println("columnIdx="+columnIdx);
               detail_column = (List)h_column.get(((List)btnFieldList_data.get(i)).get(0));//取出該大項的細類
               //設定細項表頭欄位
               for(j=0 ;j<detail_column.size();j++){ 
                  //System.out.println((String)detail_column.get(j)+"="+(String)prop_column_name.get((String)detail_column.get(j)));                                           
                  reportUtil.createCell( wb, row, ( short )columnIdx, (String)detail_column.get(j), columnStyle );               
                  columnIdx ++;
               }                              
            }
            
            //wb.setRepeatingRowsAndColumns( 0, 1, 8, 1, 3 ); //設定表頭 為固定 先設欄的起始再設列的起始              
            wb.setRepeatingRowsAndColumns(0, 1, columnLength+3, 1, 7); //設定表頭 為固定 先設欄的起始再設列的起始
  			  			
  			//System.out.println("DS001W_Excel.sqlCmd="+sqlCmd);	   
  			System.out.println("ori_field="+ori_field);   				
			dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),sqlCmd_paramList,ori_field+",m_yearmonth");
			System.out.println("dbData.size()="+dbData.size());
			short rowNo = ( short )8;//資料起始列     
			//無資料時,顯示訊息========================================================================			
			if(dbData == null || dbData.size() == 0){
			   	row = sheet.createRow( rowNo );     
                row.setHeight((short) 0x120); 
                reportUtil.createCell( wb, row, ( short )1,"無資料" ,noBorderDefaultStyle ); 
                sheet.addMergedRegion( new Region( ( short )8, ( short )1,
                                               ( short )8,
                                               ( short )(columnLength+1)) );
			}else{
			    //將DBData寫入===============================================================================================      
                acc_code_row = sheet.getRow(7);
                short lastCellNum = acc_code_row.getLastCellNum();
                //System.out.println("lastCellNum="+lastCellNum);                        
                columnIdx = 1; 
                String amt="";               
                for(i=0;i<dbData.size();i++){            
                    row = sheet.createRow( rowNo );  
                    bean = (DataObject)dbData.get(i);
                    //System.out.println("rowNo="+rowNo);   
                    //System.out.println("m_yearmonth="+(bean.getValue("m_yearmonth").toString()));
                    row.setHeight((short) 0x120); 
                    
                    //95.12.01 add 查詢年月
                    reportUtil.createCell( wb, row, ( short )columnIdx, bean.getValue("m_yearmonth").toString(), defaultStyle );//查詢年月
                    columnIdx++;
                    for(int cellIdx =2;cellIdx < (new Short(lastCellNum)).intValue();cellIdx++){                    
                         amt="";                        
                         cell = acc_code_row.getCell((short)cellIdx);                    
                         //System.out.println("acc_code="+cell.getStringCellValue()); 
                         amt = bean.getValue(cell.getStringCellValue()).toString();
                         if(cell.getStringCellValue().indexOf("cnt") == -1 && cell.getStringCellValue().indexOf("cnt") == -1){//cnt為件數,不除以金額單位
                         	amt = Utility.getRound(amt,Unit);                         
                         }
                         //System.out.println("amt="+amt);
                        
                         amt = Utility.setCommaFormat(amt);
                         reportUtil.createCell( wb, row, ( short )columnIdx, amt, rightStyle );               
                         columnIdx ++;
                    }
                    columnIdx = 1;
                    rowNo++;                    
                }            
            }//end of 有data   
          
            //把中間值的acc_code合併成一個欄位=======================================================================     
                 
            row = sheet.getRow(7);
            columnIdx = 2;
            short lastCellNum = row.getLastCellNum();
            for(i=2;i<(new Short(lastCellNum)).intValue();i++){
                //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(0));                
                        
                //System.out.println((((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size() + columnIdx - 1));
                cell = row.getCell((short)i);     
                //System.out.println("i="+i+":"+cell.getStringCellValue());      
                if(cell.getStringCellValue().indexOf("year0") != -1 || cell.getStringCellValue().indexOf("sum0") != -1){//合併單一科目代號                									 
                	sheet.addMergedRegion( new Region( ( short )5, ( short )columnIdx,
                                               ( short )7,
                                               ( short )columnIdx) );      
                }else{//合併中間值科目代號
            	 	sheet.addMergedRegion( new Region( ( short )6, ( short )columnIdx,
                                               ( short )7,
                                               ( short )columnIdx) );      
            	}	
                    
                                                            
                   columnIdx++;                            
                //columnIdx +=  ((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size();                                                             
            }
           
            //設定寬度============================================================            
            for ( i = 1; i <= columnLength+3; i++ ) {                                
                  sheet.setColumnWidth( ( short )i,
                                        ( short ) ( 256 * ( 15 + 4 ) ) );                
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
            
            String filename = titleName+".xls";//108.04.29 add
            if(!printStyle.equalsIgnoreCase("xls")) {//108.04.29非xls檔須執行轉換	                
	  			rptTrans rptTrans = new rptTrans();	  			
	  			filename = rptTrans.transOutputFormat (printStyle,filename,""); 
	  			System.out.println("newfilename="+filename);	  			   
            };
            
            FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+ filename);//108.04.29 fix  	 
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