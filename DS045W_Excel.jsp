<%
//100.07.06 create 權益證券風險─個別風險之資本計提計算表(國家別)(6-B1) by 2295
//108.06.03 add 報表格式轉換 by rock.tsai
//112.02.13 fix 報表欄位,若大項名稱跟細項名稱一樣時合併 by 6820
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
   String printStyle = "";//輸出格式 108.06.03 add
  //輸出格式 108.06.03 add
   if(session.getAttribute("printStyle") != null && !((String)session.getAttribute("printStyle")).equals("")){
    printStyle = (String)session.getAttribute("printStyle");		  				   
   }
   if(act.equals("view")){
      //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.06.03調整顯示的副檔名
   }else if (act.equals("download")){   
	   response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.06.03調整顯示的副檔名
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
	String report_no="6-B1";	
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
						
			//titleName += Utility.getPgName("DS028W");	
			titleName += "權益證券風險─個別風險之資本計提計算表(國家別)(6-B1)";	  		
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
            sql.append(" select cano,rulename from rptrule_ds where acc_tr_type=? and type='1' order by cano ");
     		paramList.add(report_no);
     		List dbData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,""); 
			for(i=0;i<dbData.size();i++){
			    bean = (DataObject)dbData.get(i);
			    prop_column.setProperty((String)bean.getValue("cano"),(String)bean.getValue("rulename"));  
	        }		
	        System.out.println("prop_column.size()="+prop_column.size());
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
			    System.out.println("field="+(String)((List)btnFieldList_data.get(i)).get(0));
			    System.out.println("column_tmp="+column_tmp);
			    if(!column_tmp.equals("")){
			        detail_column = Utility.getStringTokenizerData(column_tmp,"+");
			        //System.out.println(detail_column);
			        if(detail_column != null && detail_column.size() != 0){               
			           columnLength += detail_column.size();//累加總欄位個數
              		   for(j=0;j<detail_column.size();j++){
            	 		   selectacc_code +="'"+(String)detail_column.get(j)+"'";            	
            	 		   //95.09.26 add================================================================================================================= 
            	 		   if(((String)detail_column.get(j)).length() <= 6){
            	 		      ori_field+= "amt"+(String)detail_column.get(j);
            	 		      if(field_sum.indexOf((String)detail_column.get(j)) == -1){//95.10.03 fix 若不存在時,才加入sum的acc_code裡
            	 		         field_sum += " ,sum(decode(acc_code,'"+(String)detail_column.get(j)+"',amt,0)) as amt"+(String)detail_column.get(j);            	 		               	
            	 		      }          						
            	 		   }else{
            	 		      ori_field += (String)detail_column.get(j);
            	 		      if(field_sum.indexOf((String)detail_column.get(j)) == -1){//95.10.03 fix 若不存在時,才加入sum的acc_code裡
            	 		         field_sum += " ,sum(decode(acc_code,'"+(String)detail_column.get(j)+"',amt,0)) as "+(String)detail_column.get(j);
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
  			//按bank_code,m_year,m_month排序
            select bank_code,decode(length(m_year),2,'0')||m_year || '/' || decode(length(m_month),1,'0')||m_month as m_yearmonth,       
                   amt001000,amt002000
            from (
            	  select m_year,m_month,bank_code,	       
            			 sum(decode(acc_code,'001000',amt,0)) as amt001000,
            			 sum(decode(acc_code,'002000',amt,0)) as amt002000, 
            			 '0' as type_001000,
            			 '0' as type_002000
            	  from ( select m_year,m_month,bank_code,acc_code,'0' as type,amt from agribank_rpt
            	    	 where (to_char(m_year * 100 + m_month) >= 9812 and to_char(m_year * 100 + m_month) <= 9912)
            		  	 and bank_code in  ('0180012')     
            		  	 and acc_tr_type = '6-B1'           		  		  
            		  	 and acc_code in ('001000','002000')
            			)		  
            	  group by m_year,m_month,bank_code
            	 )agribank_rpt
            group by bank_code,m_year,m_month,amt001000,amt002000,type_001000,type_002000
            order by bank_code,m_year,m_month
  			*/
  			
            String column = "";//選取欄位           
			//======================================================
            StringBuffer sqlCmd =new StringBuffer();            
            int parami = 0;
            List sqlCmd_paramList = new ArrayList();
            
            List main_table_paramList = new ArrayList();
            StringBuffer main_table=new StringBuffer(); 
		          
				 
			main_table.append(" ( ");
			main_table.append("  select m_year,m_month,bank_code"+field_sum);			
 			main_table.append("  from ( select m_year,m_month,bank_code,acc_code,amt from agribank_rpt ");
  			main_table.append("          where ((m_year * 100 + m_month) >= ? and (m_year * 100 + m_month) <= ?)");					   
			main_table.append("          and   bank_code in ('0180012') ");	
			main_table.append("          and   acc_tr_type = ? ");				      
			main_table.append("          and   acc_code in ("+selectacc_code+")");    
			main_table.append(" 		 ) ");			
			main_table.append("  group by m_year,m_month,bank_code ");
			main_table.append(" )agribank_rpt ");
			
			main_table_paramList.add(S_YEAR+S_MONTH);	
			main_table_paramList.add(E_YEAR+E_MONTH);
			main_table_paramList.add(report_no);
		
			sqlCmd.append(" select bank_code,decode(length(m_year),2,'0')||m_year || '/' || decode(length(m_month),1,'0')||m_month as m_yearmonth,");
			sqlCmd.append(ori_field);
			sqlCmd.append(" from ");
			sqlCmd.append(main_table);
			for(parami=0;parami<main_table_paramList.size();parami++){
            	sqlCmd_paramList.add(main_table_paramList.get(parami));
            }			
            
			sqlCmd.append(" group by bank_code,m_year,m_month,"+ori_field);
			sqlCmd.append(" order by bank_code,m_year,m_month ");
						      
            System.out.println("sqlCmd="+sqlCmd.toString());
            //讀取報表欄位名稱===================================================================================        	
        	Properties prop_column_name = new Properties();
			sql = new StringBuffer();		
	        paramList = new ArrayList();
	        bean = null;
            sql.append(" select acc_code,acc_name from ncacno where acc_tr_type=? order by acc_range ");
     		paramList.add(report_no);
     		dbData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,""); 
			for(i=0;i<dbData.size();i++){
			    bean = (DataObject)dbData.get(i);
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
            System.out.println("columnLength="+columnLength);
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

            //大類標頭
            String h_Title = ((List) btnFieldList_data.get(i)).get(1).toString().trim();

            //設定表頭欄位
            for(j=columnIdx;j<((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size() + columnIdx;j++){
                reportUtil.createCell(wb, row, (short) j, (String) ((List) btnFieldList_data.get(i)).get(1), columnStyle);

                detail_column = (List)h_column.get(((List)btnFieldList_data.get(i)).get(0));//取出該大項的細類
                for(int z=0 ;z<detail_column.size();z++){
                    String detailTitle = prop_column_name.get(detail_column.get(z)).toString().trim().replace("　", "");
                    if (h_Title.equals(detailTitle)) {
                        sheet.addMergedRegion( new Region( ( short )5, ( short )columnIdx,
                                ( short )6,
                                ( short )(((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size() + columnIdx - 1)) );
                        continue;
                    }
                }
            }
            sheet.addMergedRegion( new Region( ( short )5, ( short )columnIdx,
                    ( short )5,
                    ( short )(((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size() + columnIdx - 1)) );
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
			dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),sqlCmd_paramList,ori_field+"m_yearmonth");
			
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
                double amt_d = 0.0;                 
                float amt_f = 0; 
                String amt_type="";
                String amt="";
                String prtbank_code="";
                for(i=0;i<dbData.size();i++){            
                    row = sheet.createRow( rowNo );  
                    bean = (DataObject)dbData.get(i);
                    //System.out.println("rowNo="+rowNo);   
                    //System.out.println("m_yearmonth="+(bean.getValue("m_yearmonth").toString());
                    row.setHeight((short) 0x120); 
                    
                    //95.12.01 add 查詢年月
                    reportUtil.createCell( wb, row, ( short )columnIdx, bean.getValue("m_yearmonth").toString(), defaultStyle );//查詢年月
                    columnIdx++;
                    for(int cellIdx =2;cellIdx < (new Short(lastCellNum)).intValue();cellIdx++){                    
                         amt="";
                         amt_type = "";
                         cell = acc_code_row.getCell((short)cellIdx);                    
                         //System.out.println("acc_code="+cell.getStringCellValue()); 
                         
                         if((cell.getStringCellValue()).indexOf("field") == -1){                       
                            amt = bean.getValue("amt"+cell.getStringCellValue()).toString();                                             
                         }else{
                            amt = bean.getValue(cell.getStringCellValue()).toString();
                         }                                                   
                         
                         amt = Utility.getRound(amt,Unit);                                
                                                                                    
                         //System.out.println("amt="+amt);
                        
                         amt = Utility.setCommaFormat(amt);
                         reportUtil.createCell( wb, row, ( short )columnIdx, amt, rightStyle );               
                         columnIdx ++;
                    }
                    columnIdx = 1;
                    rowNo++;
                    //prtbank_code = (String) ((DataObject) dbData.get(i)).getValue("bank_code");
                }            
            }//end of 有data   
            
            //把中間值的acc_code合併成一個欄位=======================================================================            
           
            columnIdx = 2;
            
            row = sheet.getRow(5);
            System.out.println("LastCellNum="+row.getLastCellNum());			
			//合併acc_code時,科目代號跟欄位名稱時,合併後的列會縮小			
            for(i=0;i<btnFieldList_data.size();i++){
                //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(0));                
                //System.out.println("columnIdx="+columnIdx); 
          		//System.out.println("merge.acc_code="+(String)((List)btnFieldList_data.get(i)).get(0));
				//合計部份				
                if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("110000") ||
                   ((String)((List)btnFieldList_data.get(i)).get(0)).equals("120000") ||
                   ((String)((List)btnFieldList_data.get(i)).get(0)).equals("130000") ||
                   ((String)((List)btnFieldList_data.get(i)).get(0)).equals("140000") ||
                   ((String)((List)btnFieldList_data.get(i)).get(0)).equals("150000") ||
                   ((String)((List)btnFieldList_data.get(i)).get(0)).equals("160000")){
                    
                    for(j=columnIdx;j<((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size() + columnIdx;j++){
                       reportUtil.createCell( wb, row, ( short )j, (String)((List)btnFieldList_data.get(i)).get(1), columnStyle );               
                    }
                    
                    //設定表頭欄位.把中間值的acc_code合併成一個欄位只顯示中文名稱=====================================                   
                    sheet.addMergedRegion( new Region( ( short )5, ( short )columnIdx,
                   				                       ( short )6,
                                		               ( short )(((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size() + columnIdx - 1)) );                                              
                }                   
                columnIdx +=  ((List)h_column.get(((List)btnFieldList_data.get(i)).get(0))).size();                                                             
            }
            //設定寬度============================================================            
            for ( i = 1; i <= columnLength+3; i++ ) {                                
                  sheet.setColumnWidth( ( short )i,
                                        ( short ) ( 256 * ( 18 + 4 ) ) );                
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