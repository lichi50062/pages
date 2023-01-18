<%
//94.01.28 create by 2295
//94.02.21 fix 頁尾加上列印日期及時間 by2295
//94.03.24 add 營運中/已裁撤 by 2295
//99.12.14 fix SQLInjection by 2479
//99.12.31 add 查詢日期for100年以後取得新縣市別.100年以前取得舊縣市別 by 2295
//102.06.26 add 配合個資法,對所產生之EXCEL報表進行壓縮加密 by 2968
//108.05.31 add 報表格式轉換 by rock.tsai
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
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="java.lang.StringBuffer" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>


<%
   response.setContentType("application/octet-stream;charset=UTF-8");//通知client端要下載檔案類型
   String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");			  
   System.out.println("act="+act);
   String printStyle = "";//輸出格式 108.05.31 add
   //輸出格式 108.05.31 add
   if(session.getAttribute("printStyle") != null && !((String)session.getAttribute("printStyle")).equals("")){
    printStyle = (String)session.getAttribute("printStyle");		  				   
   }
   if(act.equals("view")){
      //以上這行設定傳送到前端瀏覽器時的檔名為test1.zip
      //就是靠這一行，讓前端瀏覽器以為接收到一個zip檔 
      response.setHeader("Content-disposition","inline; filename=view.zip");
   }else if(act.equals("download")){   
      response.setHeader("Content-Disposition","attachment; filename=download.zip");//使用對話方塊保存檔
   }
   
%>
<%
	String actMsg = "";
	FileOutputStream fileOut = null;      
	/*
  	int[] columnLen = {
  	15,30,18,40,18,
  	40,15,12,13,10,
  	15,10,40,20,15,
  	40,15,20,17,40,
  	17,20,15,23,18,
  	40,20,18,15};
  	*/
  	int[] columnLen = null;
    HSSFCellStyle defaultStyle;
    HSSFCellStyle noBorderDefaultStyle;
    HSSFCellStyle titleStyle;
	HSSFCellStyle columnStyle;
	HSSFCellStyle noBoderStyle;
	HSSFRow row;
	String titleName = "";
	String report_no = "BR021W";	
    reportUtil reportUtil = new reportUtil();
    String BankList = "";
    String btnFieldList = "";
    String SortList = "";
    String CANCEL_NO = "";
    String S_YEAR = "";//99.12.31 add
    String S_MONTH = "";//99.12.31 add
    List BankList_data = null;
    List btnFieldList_data = null;
    List SortList_data = null;
    List paramList = new ArrayList();
	int i = 0;
	String lguser_name = ( session.getAttribute("muser_name")==null ) ? "" : (String)session.getAttribute("muser_name");
	String lguser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");
	//99.12.31 add==================================================================
	String cd01_table = "";
    String wlx01_m_year = "";    
	//============================================================================
	try{
			//儲存報表的目錄================================================================
        	File reportDir = new File(Utility.getProperties("reportDir"));       
    		if(!reportDir.exists()){
     			if(!Utility.mkdirs(Utility.getProperties("reportDir"))){
     	   			actMsg +=Utility.getProperties("reportDir")+"目錄新增失敗";
     			}    
    		}
    		//==============================================================================
    		//查詢日期-年//99.12.31 add
    		if(session.getAttribute("S_YEAR") != null && !((String)session.getAttribute("S_YEAR")).equals("")){
		  		S_YEAR = (String)session.getAttribute("S_YEAR");
			}
			//查詢日期-月//99.12.31 add
			if(session.getAttribute("S_MONTH") != null && !((String)session.getAttribute("S_MONTH")).equals("")){
		  		S_MONTH = (String)session.getAttribute("S_MONTH");	
			}
    		//營運中/已裁撤
			if(session.getAttribute("CANCEL_NO") != null && !((String)session.getAttribute("CANCEL_NO")).equals("")){
		  		CANCEL_NO = (String)session.getAttribute("CANCEL_NO");
			}
    		//金融機構
			if(session.getAttribute("BankList") != null && !((String)session.getAttribute("BankList")).equals("")){
		   		BankList = (String)session.getAttribute("BankList");
		   		BankList_data = Utility.getReportData(BankList);
		   		System.out.println("BankList_data.size()="+BankList_data.size());		   
			}
			//報表欄位
			if(session.getAttribute("btnFieldList") != null && !((String)session.getAttribute("btnFieldList")).equals("")){
		   		btnFieldList = (String)session.getAttribute("btnFieldList");
		   		btnFieldList_data = Utility.getReportData(btnFieldList);
		   		System.out.println("btnFieldList_data.size()="+btnFieldList_data.size());		   
			}
			//排序欄位
			if(session.getAttribute("SortList") != null && !((String)session.getAttribute("SortList")).equals("")){
		  		SortList = (String)session.getAttribute("SortList");
		  		SortList_data = Utility.getReportData(SortList);
		   		System.out.println("SortList_data.size()="+SortList_data.size());		   
			}
        	//機構類別
			if(session.getAttribute("nowbank_type") != null && !((String)session.getAttribute("nowbank_type")).equals("")){		  		
		  	   titleName=(((String)session.getAttribute("nowbank_type")).equals("B"))?"地方主管機關農業金融監理承辦人通訊錄":"農業行庫專案金融通訊錄";		  		
			}
			
        	//讀取報表欄位長度===================================================================================
        	Properties p = new Properties();
			p.load(new FileInputStream(Utility.getProperties("schemaDir")+System.getProperty("file.separator")+"BANK_CMML.length"));
			//====================================================================================================
			
            //Creating Cells
            HSSFWorkbook wb = new HSSFWorkbook();
            HSSFSheet sheet = wb.createSheet( "report" ); //建立sheet，及名稱
            wb.setSheetName(0, titleName, HSSFWorkbook.ENCODING_UTF_16 );
            HSSFPrintSetup ps = sheet.getPrintSetup(); //取得設定
           
            //設定頁面符合列印大小
            //sheet.setZoom(80, 100); // 螢幕上看到的縮放大小
            //sheet.setAutobreaks(true); //自動分頁            
            sheet.setAutobreaks( false );
            ps.setScale( ( short )100 ); //列印縮放百分比

            ps.setPaperSize( ( short )9 ); //設定紙張大小 A4
            
            ps.setLandscape( true ); // 設定橫印
            //ps.setFitWidth((short)14);
            HSSFFooter footer = sheet.getFooter();
           
            //設定樣式和位置(請精減style物件的使用量，以免style物件太多excel報表無法開啟)
			defaultStyle = reportUtil.getDefaultStyle(wb);//有框內文置中
    		noBorderDefaultStyle = reportUtil.getNoBorderDefaultStyle(wb);//無框內文置中
			reportUtil.setDefaultStyle(defaultStyle);
			reportUtil.setNoBorderDefaultStyle(noBorderDefaultStyle);			
    		titleStyle = reportUtil.getTitleStyle(wb); //標題用
    		columnStyle = reportUtil.getColumnStyle(wb);//報表欄位名稱用--有框內文置中			                                               
    		noBoderStyle = reportUtil.getNoBoderStyle(wb);//無框置右			                                               
    		//============================================================================
            
            
            //設定title===============================================================================
            row = sheet.createRow( ( short )1 );
            reportUtil.createCell( wb, row, ( short )1, titleName, titleStyle );
            
            for(i=2;i<btnFieldList_data.size()+2;i++){
              reportUtil.createCell( wb, row, ( short )i, "", noBorderDefaultStyle );
            }
            
            sheet.addMergedRegion( new Region( ( short )1, ( short )1,
                                               ( short )1,
                                               ( short )(btnFieldList_data.size()) ) );
            
            row = sheet.createRow( ( short )2 );
            
            row.setHeight((short) 0x200);
            reportUtil.createCell( wb, row, ( short )1, "", titleStyle );
            for(i=2;i<btnFieldList_data.size()+2;i++){
               reportUtil.createCell( wb, row, ( short )i, "", noBorderDefaultStyle );
            }            
            //設定列印日期==========================================================
            row = sheet.createRow( ( short )3 );            
            String printTime = Utility.getDateFormat("  HH:mm:ss");
            String printDate = Utility.getDateFormat("yyyy/MM/dd");                                    
            reportUtil.createCell( wb, row, ( short )1, "列印日期："+Utility.getCHTdate(printDate, 1)+printTime, noBoderStyle );
            sheet.addMergedRegion( new Region( ( short )3, ( short )1,
                                               ( short )3,
                                               ( short )(btnFieldList_data.size()) ) );
            //設定列印人員==========================================================
            row = sheet.createRow( ( short )4 );                        
            reportUtil.createCell( wb, row, ( short )1, "列印人員："+lguser_name, noBoderStyle );
            sheet.addMergedRegion( new Region( ( short )4, ( short )1,
                                               ( short )4,
                                               ( short )(btnFieldList_data.size()) ) );
            
            //===============================================================================
            columnLen = new int[btnFieldList_data.size()];
            String column = "";//選取欄位
            String selectBank_no = "";//選取的金融機構代號
            String condition = "BANK_CMML.bank_no(+) = BA01.bank_no";//條件
            //99.12.31 add 查詢年度100年以前.縣市別不同===============================
  	    	cd01_table = (Integer.parseInt(S_YEAR) < 100)?"cd01_99":"cd01"; 
  	    	wlx01_m_year = (Integer.parseInt(S_YEAR) < 100)?"99":"100"; 
  	    	//=====================================================================      
            //94.03.24 add 營運中/已裁撤============================ 
            condition += " and BA01.bank_no=BN01.bank_no ";
            if(CANCEL_NO.equals("N")){//營運中
			   condition += " and BN01.bn_type <> '2'";//條件
			}else{//已裁撤
			   condition += " and BN01.bn_type = '2'";//條件
			}			  	 
			//======================================================
            String table = " (select * from bank_cmml where m_year=?)BANK_CMML,(select * from ba01 where m_year=?)BA01,(select * from bn01 where m_year=?)BN01";//查詢table            
            String order = "";//排序欄位
            String sqlCmd="";
            paramList.add(wlx01_m_year);//BANK_CMML用
            paramList.add(wlx01_m_year);//BA01用
            paramList.add(wlx01_m_year);//BN01用
            //金融機構代號=============================================================
            if(BankList_data != null && BankList_data.size() != 0){
               selectBank_no += " BA01.bank_no IN (";
               for(i=0;i<BankList_data.size();i++){
                 paramList.add((String)((List)BankList_data.get(i)).get(0));
            	 selectBank_no +=" ? ";            	
            	 if(i < BankList_data.size()-1) selectBank_no +=",";
               }
               selectBank_no += ")";
            }   
            //==============================================================================
            
            //報表欄位=======================================================================
            row = sheet.createRow( ( short )5 );//表頭
            for(i=0;i<btnFieldList_data.size();i++){
               System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1));
               //設定表頭欄位
               reportUtil.createCell( wb, row, ( short )(i+1), (String)((List)btnFieldList_data.get(i)).get(1), columnStyle );               
               //取得報表欄位長度
               columnLen[i]=Integer.parseInt(((String)p.get((String)((List)btnFieldList_data.get(i)).get(0))).trim());
               //選取欄位         			 			   
               column += (String)((List)btnFieldList_data.get(i)).get(0);               
               		
               if(i < btnFieldList_data.size() -1){
               	  column += ", ";
               }
               //條件式跟table=============================================================================               
               //=========================================================================================
            }            
            
            //排序欄位=========================================================================
            if(SortList_data != null && SortList_data.size() != 0){
            	for(i=0;i<SortList_data.size();i++){
            		order += (String)((List)SortList_data.get(i)).get(0);
            		if(i < SortList_data.size() -1 ) order +=",";            
	            }
	            System.out.println("order="+order);
            }
            //====================================================================================
            //wb.setRepeatingRowsAndColumns( 0, 1, 8, 1, 3 ); //設定表頭 為固定 先設欄的起始再設列的起始
            wb.setRepeatingRowsAndColumns(0, 1, btnFieldList_data.size(), 1, 5); //設定表頭 為固定 先設欄的起始再設列的起始

            
            
            	
            /* select BA01.BANK_NO,BA01.BANK_NAME,
	   				   BANK_CMML.BUSINESS_PERSON,BANK_CMML.M_POSITION_OFFICER,
	   				   BANK_CMML.M_NAME_OFFICER,BANK_CMML.M_POSITION,
	   				   BANK_CMML.M_NAME,BANK_CMML.M_TELNO,
	   				   BANK_CMML.M_FAX,BANK_CMML.M_EMAIL,BANK_CMML.ADDR
			   from (select * from bank_cmml where m_year=99)BANK_CMML,(select * from ba01 where m_year=99)BA01
			   where ba01.bank_no IN ('AAAA000') 
			   and BANK_CMML.bank_no(+) = BA01.bank_no                 			  
  			*/
  			
  			
  			sqlCmd = " select "+ column 
  				   + " from "  + table
  				   + " where " + selectBank_no
  				   + " and " + condition;
  			if(!order.equals("")){	   				  
  				sqlCmd += " order by BA01.bank_type," + order;
  				//SoryBy=asc/desc
  				if( session.getAttribute("SortBy") != null && !((String)session.getAttribute("SortBy")).equals("")){	   
  		            sqlCmd += " " + ((String)session.getAttribute("SortBy"));	
  		         }
  		    }else{	
  		       sqlCmd += " order by BA01.bank_type";
  			}
  			System.out.println("BR021W_Excel.sqlCmd="+sqlCmd);	   
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"business_person");          						
			//List dbData = DBManager.QueryDB(sqlCmd,"business_person");            
			String field = "";
			StringTokenizer paser = null;
			StringBuffer newstr = new StringBuffer("");
			int dataCount = 0;
			int dataCount_max = 0;
			short rowNo = ( short )6;//資料起始列      
			//無資料時,顯示訊息========================================================================
			if(dbData == null || dbData.size() == 0){
			   	row = sheet.createRow( rowNo );     
                row.setHeight((short) 0x120); 
                reportUtil.createCell( wb, row, ( short )1,"無"+titleName ,noBorderDefaultStyle ); 
                sheet.addMergedRegion( new Region( ( short )6, ( short )1,
                                               ( short )6,
                                               ( short )(btnFieldList_data.size()) ) );
			}
			//=========================================================================================           			
                			
            for ( i = 0; i < dbData.size(); i ++) {                
                row = sheet.createRow( rowNo );     
                row.setHeight((short) 0x120); 
                dataCount_max=0;
                for(int j=0;j<btnFieldList_data.size();j++){
                	field = ((String)((List)btnFieldList_data.get(j)).get(0)).toLowerCase();	
                	//System.out.println("cretea cell="+field);
                	if(field.indexOf(".") != -1){                	
                	   field = field.substring(field.indexOf(".")+1,field.length());
                	}
                	
			        if(field.equals("business_person")){ 
			           if((((DataObject)dbData.get(i)).getValue(field)) != null){			              
				 		  reportUtil.createCell( wb, row, ( short )(j+1),(((DataObject)dbData.get(i)).getValue(field)).toString() ,defaultStyle );				   				 		  				 		  
					   }else{				   
				   		  reportUtil.createCell( wb, row, ( short )(j+1),"" ,defaultStyle );   
					  }					     
			        }else{
			           if( ((DataObject)dbData.get(i)).getValue(field) != null && (((String)((DataObject)dbData.get(i)).getValue(field)).indexOf(",") != -1)){			              
			              dataCount = 0;
			              paser = new StringTokenizer(((String)((DataObject)dbData.get(i)).getValue(field)).trim());
	        			  newstr = new StringBuffer("");	        			  
	        			  while (paser.hasMoreTokens()){
	        			    if(!(newstr.toString().equals(""))){
	        			        newstr.append("\n"); 	        			   
	        			    }   
	        			    dataCount++;
	            			newstr.append(paser.nextToken(","));	            			
					      }
					      dataCount = 120 * dataCount;	
					      if(dataCount > dataCount_max) dataCount_max = dataCount;				      					      
					      System.out.println("dataCount="+String.valueOf(dataCount));
					      System.out.println(Short.parseShort(String.valueOf(dataCount),16));					      						   
					      //row.setHeight((short) 0x240); 	        			  						  
			              reportUtil.createCell( wb, row, ( short )(j+1), newstr.toString() ,defaultStyle );					
			           }else{		           
			             reportUtil.createCell( wb, row, ( short )(j+1),(String)((DataObject)dbData.get(i)).getValue(field) ,defaultStyle );					
			           }  
			           //System.out.println((String)((DataObject)dbData.get(i)).getValue(field));
			        }
			        
                }//insert 完成一列
                //設定此列最高寬度
                if(dataCount_max > 0){
				   row.setHeight(Short.parseShort(String.valueOf(dataCount_max),16)); 	        			  				                
				}   
				rowNo ++ ;
			}            
                
            //設定寬度============================================================
            for ( i = 1; i <= columnLen.length; i++ ) {                
                sheet.setColumnWidth( ( short )i,
                                      ( short ) ( 256 * ( columnLen[i - 1] + 4 ) ) );
            }
			//======================================================================================
            //設定涷結欄位
            //sheet.createFreezePane(0,1,0,1);
            footer.setCenter( "Page:" + HSSFFooter.page() + " of " +
                             HSSFFooter.numPages() );
            footer.setRight(Utility.getDateFormat("yyyy/MM/dd hh:mm aaa"));			
            // Write the output to a file            
            fileOut = new FileOutputStream( Utility.getProperties("reportDir")+System.getProperty("file.separator")+ report_no+".xls" ); //從來源地寫入資料至指定的檔案中
            wb.write( fileOut );
            fileOut.close();
            String filename = report_no+".xls";//108.05.31 add
            if(!printStyle.equalsIgnoreCase("xls")) {//108.05.31非xls檔須執行轉換	                
            	rptTrans rptTrans = new rptTrans();	  			
            	filename = rptTrans.transOutputFormat (printStyle,filename,""); 
            	System.out.println("newfilename="+filename);	  			   
            }
            //壓縮至zip
            //Utility.createZipFile(lguser_id,Utility.getProperties("reportDir")+System.getProperty("file.separator")+ Utility.ISOtoBig5(titleName)+".zip",Utility.getProperties("reportDir")+System.getProperty("file.separator")+ Utility.ISOtoBig5(titleName)+".xls");
            System.out.println();
            Utility.createEncZipFile(filename,titleName+".zip",lguser_id);//108.05.31 fix
            //to download file from HTTP	
            FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+ titleName+".zip"); 	 
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
