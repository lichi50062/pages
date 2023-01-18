<%
// 94.01.26 create by 2295
// 94.02.21 fix 頁尾加上列印日期及時間 by2295
// 94.03.25 add 營運中/已裁撤 by 2295
// 99.04.08 fix 因應縣市合併調整SQL&調整SQL以PreparedStatement方式查詢 by 2808
//105.11.02 fix 分部家數無法顯示 by 2295
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
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="java.lang.StringBuffer" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>

<%
   Map dataMap =Utility.saveSearchParameter(request);
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
   int  s_year = (String)dataMap.get("S_YEAR")==null? 100 :  Integer.parseInt((String)dataMap.get("S_YEAR") ) ;
   String cd01Table = "cd01" ;
   if(s_year >= 100) {
	   s_year = 100 ;
	}else {
	   s_year = 99 ;
	   cd01Table = "cd01_99" ;
	   
   }
   String city_type = Utility.getTrimString(dataMap.get("hsien_id"));
   String act = Utility.getTrimString(dataMap.get("act"));			  
   System.out.println("act="+act);
   String printStyle = "";//輸出格式 108.05.31 add
   //輸出格式 108.05.31 add
   if(session.getAttribute("printStyle") != null && !((String)session.getAttribute("printStyle")).equals("")){
    printStyle = (String)session.getAttribute("printStyle");		  				   
   }
   if(act.equals("view")){
      //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.31調整顯示的副檔名
   }else if (act.equals("download")){   
	   response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.31調整顯示的副檔名
   }
   
%>
<%
	String actMsg = "";
	FileOutputStream fileOut = null;      
	
  	int[] columnLen = {10,10,5,10,5,5};
  	/*
  	1.縣市別  10
	2.鄉/鎮/市/區 10
	3.分部 5
	4.簡易型分部 10
	5.其它 5
	6.合計 5	
  	*/  	
    HSSFCellStyle defaultStyle;
    HSSFCellStyle noBorderDefaultStyle;
    HSSFCellStyle titleStyle;
	HSSFCellStyle columnStyle;
	HSSFCellStyle noBoderStyle;
	HSSFRow row;
	HSSFRow row_count;
	int rowStart=6;
	int rowEnd=0;
	HSSFCell cell;
	String titleName = "分支機構分布表";
    reportUtil reportUtil = new reportUtil();
    String bank_type = "";
	
	String cancel_no = Utility.getTrimString(dataMap.get("cancel_no"));
	String hsien_name = "";
	int i = 0;
	String lguser_name = "測試使用者";
	List paramList = new ArrayList();
	List dbData = null;
	DataObject bean = null;
	try{
			//儲存報表的目錄================================================================
        	File reportDir = new File(Utility.getProperties("reportDir"));       
    		if(!reportDir.exists()){
     			if(!Utility.mkdirs(Utility.getProperties("reportDir"))){
     	   			actMsg +=Utility.getProperties("reportDir")+"目錄新增失敗";
     			}    
    		}
    		//==============================================================================
    		
			//機構類別
			if(session.getAttribute("nowbank_type") != null && !((String)session.getAttribute("nowbank_type")).equals("")){
			    bank_type = (String)session.getAttribute("nowbank_type");
		  		if(((String)session.getAttribute("nowbank_type")).equals("6")){
		  		   titleName = "農會"+titleName;
		  		}		  		
		  		if(((String)session.getAttribute("nowbank_type")).equals("7")){
		  		   titleName = "漁會"+titleName;
		  		}
			}        	      		
      		//縣市別
      		if(city_type.equals("ALL")){
      		   hsien_name = "縣市別:全部";
      		}else{
      			List hsien_data = DBManager.QueryDB("select * from "+cd01Table+" where hsien_id='"+city_type+"'","");
      		    if(hsien_data != null && hsien_data.size() != 0){
      		       hsien_name = "縣市別:"+(String)((DataObject)hsien_data.get(0)).getValue("hsien_name");
      		    }
      		}
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
            
            //ps.setLandscape( true ); // 設定橫印
            //ps.setFitWidth((short)14);
            HSSFFooter footer = sheet.getFooter();
            
            //HSSFCellStyle style;
            //HSSFFont font;
            //style = wb.createCellStyle();
            //Font = wb.createFont();

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
            reportUtil.createCell( wb, row, ( short )0, titleName, titleStyle );           
            sheet.addMergedRegion( new Region( ( short )1, ( short )0,
                                               ( short )1,
                                               ( short )(columnLen.length -1) ) );
            
            row = sheet.createRow( ( short )2 );
            
            row.setHeight((short) 0x200);
            reportUtil.createCell( wb, row, ( short )0, "", titleStyle );
            for(i=0;i<columnLen.length;i++){
               reportUtil.createCell( wb, row, ( short )i, "", noBorderDefaultStyle );
            }            
            //設定列印日期==========================================================
            row = sheet.createRow( ( short )3 );            
            String printTime = Utility.getDateFormat("  HH:mm:ss");
            String printDate = Utility.getDateFormat("yyyy/MM/dd");                                    
            reportUtil.createCell( wb, row, ( short )0, "列印日期："+Utility.getCHTdate(printDate, 1)+printTime, noBoderStyle );
            sheet.addMergedRegion( new Region( ( short )3, ( short )0,
                                               ( short )3,
                                               ( short ) (columnLen.length -1) ) );
            //設定列印人員==========================================================
            row = sheet.createRow( ( short )4 ); 
			reportUtil.createCell( wb, row, ( short )0, hsien_name, noBoderStyle );                                   
            reportUtil.createCell( wb, row, ( short )1, "列印人員："+lguser_name, noBoderStyle );
            sheet.addMergedRegion( new Region( ( short )4, ( short )1,
                                               ( short )4,
                                               ( short )(columnLen.length-1) ) );
            
            //===============================================================================
            
            //報表欄位表頭=======================================================================
            row = sheet.createRow( ( short )5 );//表頭    
            reportUtil.createCell( wb, row, ( short )0, "縣市別", columnStyle );               
            reportUtil.createCell( wb, row, ( short )1, "鄉/鎮/市/區", columnStyle );               
            reportUtil.createCell( wb, row, ( short )2, "分部", columnStyle );               
            reportUtil.createCell( wb, row, ( short )3, "簡易型分部", columnStyle );               
            reportUtil.createCell( wb, row, ( short )4, "其它", columnStyle );               
            reportUtil.createCell( wb, row, ( short )5, "合計", columnStyle );                           
            //====================================================================================
            //wb.setRepeatingRowsAndColumns( 0, 1, 8, 1, 3 ); //設定表頭 為固定 先設欄的起始再設列的起始
            wb.setRepeatingRowsAndColumns(0, 0, 5, 0, 5); //設定表頭 為固定 先設欄的起始再設列的起始

            
            
            StringBuffer sql = new StringBuffer() ;
            
            sql.append("SELECT 1                                  AS order_type,     ");
            sql.append("       hsien_id,                                             ");
            sql.append("       area_id,                                              ");
            sql.append("       const_type,                                           ");
            sql.append("       COUNT(*)                           AS bank_cnt,       ");
            sql.append("       (SELECT hsien_name                                    ");
            sql.append("        FROM   cd01                                          ");
            sql.append("        WHERE  hsien_id = wlx02.hsien_id) AS hsien_name,     ");
            sql.append("       (SELECT area_name                                     ");
            sql.append("        FROM   cd02                                          ");
            sql.append("        WHERE  area_id = wlx02.area_id)   AS area_name       ");
            sql.append("  ,(select FR001W_OUTPUT_ORDER from ").append(cd01Table).append(" where hsien_id = wlx02.hsien_id ) output_order  ");
            sql.append("FROM   (select * from bn02 where m_year=?)bn02");
            sql.append("       JOIN (select * from wlx02 where m_year=?)wlx02      ");
            sql.append("         ON wlx02.bank_no = bn02.bank_no                     ");
            sql.append("       JOIN (select * from bn01 where m_year=?)bn01           ");
            sql.append("         ON bn02.tbank_no = bn01.bank_no                     ");
            sql.append("WHERE  bn02.bank_type = ?                                    ");
            sql.append("       AND wlx02.hsien_id IN (SELECT hsien_id                ");
            sql.append("                              FROM   cd01)                   ");
            if(!"ALL".equals(city_type)) { //全部列印時.......
            	sql.append("       and hsien_id = ?  ") ;
            }
            //94.03.25 add 區分營運中/已裁撤========================================	   		  			
   			if(cancel_no.equals("N")){//營運中
   				sql.append("       AND bn02.bn_type <> ?                              ");
   			}else{
   				sql.append("       AND bn02.bn_type =  ?                              ");
   			}
            sql.append("GROUP  BY hsien_id,                                          ");
            sql.append("          area_id,                                           ");
            sql.append("          const_type                                         ");
            sql.append("UNION                                                        ");
            sql.append("SELECT 2        AS order_type,                               ");
            sql.append("       ''       AS hsien_id,                                 ");
            sql.append("       ''       AS area_id,                                  ");
            sql.append("       const_type,                                           ");
            sql.append("       COUNT(*) AS bank_cnt,                                 ");
            sql.append("       ''       AS hsien_name,                               ");
            sql.append("       ''       AS area_name                                 ");
            sql.append("       ,'' As output_order ");
            sql.append("FROM   (select * from bn02 where m_year=?)bn02  ");
            sql.append("       JOIN (select * from wlx02 where m_year=?)wlx02  ");
            sql.append("         ON wlx02.bank_no = bn02.bank_no                     ");
            sql.append("WHERE  bank_type = ?                                       ");
          //94.03.25 add 區分營運中/已裁撤========================================	   		  			
   			if(cancel_no.equals("N")){//營運中
   				sql.append("       AND bn02.bn_type <> ?                             ");
   			}else{
   				sql.append("       AND bn02.bn_type =  ?                              ");
   			}
            sql.append("       AND ( hsien_id IS NULL                                ");
            sql.append("              OR hsien_id NOT IN (SELECT hsien_id            ");
            sql.append("                                  FROM   cd01) )             ");
            if(!"ALL".equals(city_type)) {
            	sql.append("       and hsien_id = ?  ") ;
            }
            sql.append("GROUP  BY const_type                                         ");
            sql.append("ORDER  BY 1,output_order ,                                   ");
            sql.append("          2,                                                 ");
            sql.append("          3                                                  ");

            
            //設定SQL參數        
            paramList.add(s_year);    
            paramList.add(s_year);
            paramList.add(s_year);
            paramList.add(bank_type);
            if(!"ALL".equals(city_type)) {
            	paramList.add(city_type);
            }
            paramList.add("2");
            paramList.add(s_year);
             paramList.add(s_year);
            paramList.add(bank_type);
            paramList.add("2");
            if(!"ALL".equals(city_type)) {
            	paramList.add(city_type);
            }
            
		    dbData = DBManager.QueryDB_SQLParam(sql.toString(),paramList, "order_type,bank_cnt");            
			String field = "";			
			String tmparea_name="";
			if(dbData != null && dbData.size() != 0){
			   tmparea_name=(String)((DataObject)dbData.get(0)).getValue("area_name");//鄉鎮市區
			}
			String tmphsien_name = "";			
			String const_type_1="";//分部
			String const_type_2="";//簡易型分部
			String const_type_9="";//其他 
			int const_type_all=0;//合計
			int area_id_1 =0;//分部小計
			int area_id_2 =0;//簡易型分部小計
			int area_id_9 =0;//其他小計
			int const_type_all_sum=0;//合計
			int area_id_1_sum =0;//分部小計
			int area_id_2_sum =0;//簡易型分部小計
			int area_id_9_sum =0;//其他小計
			String  tmphsien_name_all = "";			
			if(dbData != null && dbData.size() != 0){
			   tmphsien_name_all = (String)((DataObject)dbData.get(0)).getValue("hsien_name");//縣市別小計
			}
			short rowNo = ( short )6;//資料起始列   
			         			
			//無資料時,顯示訊息========================================================================
			if(dbData == null || dbData.size() == 0){
			   	row = sheet.createRow( rowNo );     
                row.setHeight((short) 0x120); 
                reportUtil.createCell( wb, row, ( short )1,"無分支機構分佈資料" ,noBorderDefaultStyle ); 
                sheet.addMergedRegion( new Region( ( short )6,( short )0,
                                                   ( short )6,( short )5 ));
			}
			//=========================================================================================           			
            System.out.println("dbData.size()="+dbData.size());
            for ( i = 0; i < dbData.size(); i ++) {                
            	//鄉/鎮/市/區與上一個不同時
                bean = (DataObject) dbData.get(i);
                String order_type = bean.getValue("order_type").toString();
                String area_name  = (String)bean.getValue("area_name");
                if( order_type!= null && "1".equals(order_type)){
                	
			    if( area_name != null && !tmparea_name.equals(area_name)){
			    	String hsienNm  = (String)bean.getValue("hsien_name");
			    	//縣市別不同時
			        if( hsienNm != null &&  !tmphsien_name.equals(hsienNm)){                 	 			            			        			          
			             if(!const_type_1.equals("")){
                	   		const_type_all += Integer.parseInt(const_type_1);
                	   		area_id_1 += Integer.parseInt(const_type_1);
                		  }
                		  if(!const_type_2.equals("")){
                	   		 const_type_all += Integer.parseInt(const_type_2);
                	   		 area_id_2 += Integer.parseInt(const_type_2);
                		  }
                		  if(!const_type_9.equals("")){
                	   		 const_type_all += Integer.parseInt(const_type_9);
                	   		 area_id_9 += Integer.parseInt(const_type_9);
                		  }
                		  System.out.println("tmparea_name="+tmparea_name);
                		  //先把前一筆鄉/鎮/市/區印出來
                		  System.out.println("print hsien_name != tmphsein_name "+tmparea_name);
                		  row = sheet.createRow( rowNo );     
                	      row.setHeight((short) 0x120);      
                		  reportUtil.createCell( wb, row, ( short )1, tmparea_name, defaultStyle );					                
                		  reportUtil.createCell( wb, row, ( short )2, const_type_1, defaultStyle );					
                		  reportUtil.createCell( wb, row, ( short )3, const_type_2 ,defaultStyle );					
                		  reportUtil.createCell( wb, row, ( short )4, const_type_9 ,defaultStyle );					                	
                		  reportUtil.createCell( wb, row, ( short )5, String.valueOf(const_type_all) ,defaultStyle );					                                     
			        	  tmparea_name = area_name==null?"" : area_name;
			        	  const_type_1 = "";
			        	  const_type_2 = "";
			        	  const_type_9 = "";
			        	  const_type_all = 0;
			        	  
			        	  String const_type  = (String)bean.getValue("const_type");
			        	  if( const_type != null && "1".equals(const_type)){//分部
		       	     	 	  const_type_1 = bean.getValue("bank_cnt").toString(); 
		        		  }else if( const_type != null && "2".equals(const_type)){//簡易型分部
			        	 	  const_type_2 = bean.getValue("bank_cnt").toString(); 
			    		  }else{//其他
			     		 	  const_type_9 = bean.getValue("bank_cnt").toString(); 
			    		  }  			                
			        	  rowNo ++ ;
			       
			         	 //印出小計=============================================================================================			         	 
			         	 if(!tmphsien_name_all.equals(hsienNm)){ 			    	
			         	     row = sheet.createRow( rowNo );     			         	     
                			 row.setHeight((short) 0x120);      
			         	     reportUtil.createCell( wb, row, ( short )0,tmphsien_name_all+"小計" ,defaultStyle );					
			         		 reportUtil.createCell( wb, row, ( short )1, "", defaultStyle );					                
                	     	 reportUtil.createCell( wb, row, ( short )2, String.valueOf(area_id_1), defaultStyle );					
                	     	 reportUtil.createCell( wb, row, ( short )3, String.valueOf(area_id_2) ,defaultStyle );					
                	     	 reportUtil.createCell( wb, row, ( short )4, String.valueOf(area_id_9) ,defaultStyle );					                	
                	     	 reportUtil.createCell( wb, row, ( short )5, String.valueOf((area_id_1 + area_id_2 + area_id_9)) ,defaultStyle );					                                     			        
                	     	 //System.out.println(i+"nowhsien_name="+(String)((DataObject)dbData.get(i)).getValue("hsien_name"));
                	     	 //System.out.println(i+"tmphsien_name_all="+tmphsien_name_all);
                	     	 //System.out.println(i+"rowNo="+rowNo);
                	     	 tmphsien_name_all = hsienNm ==null?"":hsienNm ;                	 
                	     	 //合計========================================================
                	     	 area_id_1_sum += area_id_1;
						     area_id_2_sum += area_id_2;
						     area_id_9_sum += area_id_9;
						     const_type_all_sum += area_id_1 + area_id_2 + area_id_9;      			
						     //=============================================================
                	     	 area_id_1 = 0;
                	     	 area_id_2 = 0;
                	     	 area_id_9 = 0;                	     	                 	 
                	     	 //合併縣市別cell=============================================================
                	     	 rowEnd = rowNo -1;
							         	     	                 	     	 
                	     	 for(int j=rowStart+1;j<=rowEnd;j++){                	     	 
			             	 	 row_count = sheet.createRow( ( short )j );
			                     reportUtil.createCell( wb, row_count,( short )0, "" ,defaultStyle );					
			                 }
  	                 	     sheet.addMergedRegion( new Region( ( short )rowStart, ( short )0,( short )rowEnd,( short )0 ) );  	                 	 
  	                 	     //=======================================================================
                	     	 rowNo++;
			         		 row = sheet.createRow( rowNo );    
			         		 rowStart=rowNo; 
			         	 }//印出小計============================================================================================	
			         	 System.out.println("i="+i);
                	 	 System.out.println("rowNo="+rowNo);
  	                 	 System.out.println("hsien_name="+hsienNm);  	                 	   
  	                 	 //印出目前的縣市別	                 	
  	                 	 if(tmphsien_name.equals("")){
  	                 	    tmphsien_name = hsienNm ==null?"":hsienNm ;
  	                 	 }
			             reportUtil.createCell( wb, row,( short )0, hsienNm ,defaultStyle );								             
			             tmphsien_name = hsienNm ==null?"":hsienNm;			    
			             continue;
			    	}					        
                	if(!const_type_1.equals("")){
                	   const_type_all += Integer.parseInt(const_type_1);
                	   area_id_1 += Integer.parseInt(const_type_1);
                	}
                	if(!const_type_2.equals("")){
                	   const_type_all += Integer.parseInt(const_type_2);
                	   area_id_2 += Integer.parseInt(const_type_2);
                	}
                	if(!const_type_9.equals("")){
                	   const_type_all += Integer.parseInt(const_type_9);
                	   area_id_9 += Integer.parseInt(const_type_9);
                	}
                	//印出前一筆鄉/鎮/市/區
                	System.out.println("print before area_name="+tmparea_name);
                	row = sheet.createRow( rowNo );     			         	     
                	row.setHeight((short) 0x120);      			         	
                	reportUtil.createCell( wb, row, ( short )1, tmparea_name, defaultStyle );					                
                	reportUtil.createCell( wb, row, ( short )2,	const_type_1, defaultStyle );					
                	reportUtil.createCell( wb, row, ( short )3, const_type_2 ,defaultStyle );					
                	reportUtil.createCell( wb, row, ( short )4, const_type_9 ,defaultStyle );					                	
                	reportUtil.createCell( wb, row, ( short )5, String.valueOf(const_type_all) ,defaultStyle );					                                                     	
			        tmparea_name = area_name ==null?"":area_name;
			        System.out.println("now area_name="+tmparea_name);
			        const_type_1 = "";
			        const_type_2 = "";
			        const_type_9 = "";
			        const_type_all = 0;
			        String const_type = (String)bean.getValue("const_type");
			        if( const_type != null && "1".equals(const_type)){//分部
		       	     	 const_type_1 = bean.getValue("bank_cnt").toString();
		        	}else if( const_type != null  && "2".equals(const_type)){//簡易型分部
			        	 const_type_2 = bean.getValue("bank_cnt").toString();
			    	}else{//其他
			     		 const_type_9 = bean.getValue("bank_cnt").toString();
			    	}  
			                
			        rowNo ++ ;
			    }			   
			    	String const_type = (String)bean.getValue("const_type");
			    	if( const_type!= null && "1".equals(const_type)){//分部
			       	     const_type_1 =  bean.getValue("bank_cnt").toString();
			        }else if( const_type!= null && "2".equals(const_type)){//簡易型分部
				         const_type_2 = bean.getValue("bank_cnt").toString();
				    }else{//其他
				     	 const_type_9 = bean.getValue("bank_cnt").toString();
				    }      	
			    }	    
			}
            
             //印出order_type=1的最後一筆==================================================================			             
			 if(!const_type_1.equals("")){
            	const_type_all += Integer.parseInt(const_type_1);
            	area_id_1 += Integer.parseInt(const_type_1);
             }
             if(!const_type_2.equals("")){
            	 const_type_all += Integer.parseInt(const_type_2);
            	 area_id_2 += Integer.parseInt(const_type_2);
             }
             if(!const_type_9.equals("")){
            	 const_type_all += Integer.parseInt(const_type_9);
            	 area_id_9 += Integer.parseInt(const_type_9);
             }
             System.out.println("tmparea_name="+tmparea_name);
             //先把前一筆鄉/鎮/市/區印出來             
             System.out.println("print last area_name="+tmparea_name);
             row = sheet.createRow( rowNo );     
             row.setHeight((short) 0x120);      
             if(dbData.size() == 1){//data只有一筆時,將縣市別印出來
                System.out.println("print one hsien_name");
                reportUtil.createCell( wb, row, ( short )0, (String)bean.getValue("hsien_name"), defaultStyle );					                
             }
             reportUtil.createCell( wb, row, ( short )1, tmparea_name, defaultStyle );					                
             reportUtil.createCell( wb, row, ( short )2, const_type_1, defaultStyle );					
             reportUtil.createCell( wb, row, ( short )3, const_type_2 ,defaultStyle );					
             reportUtil.createCell( wb, row, ( short )4, const_type_9 ,defaultStyle );					                	
             reportUtil.createCell( wb, row, ( short )5, String.valueOf(const_type_all) ,defaultStyle );					                                     
			 //tmparea_name = (String)((DataObject)dbData.get(dbData.size())).getValue("area_name");			    			                
			 rowNo++ ;			  
			 //印出小計=============================================================================================			         	 
			 row = sheet.createRow( rowNo );     
             row.setHeight((short) 0x120);      			         	
			 reportUtil.createCell( wb, row, ( short )0,tmphsien_name_all+"小計" ,defaultStyle );					
			 reportUtil.createCell( wb, row, ( short )1, "", defaultStyle );					                
             reportUtil.createCell( wb, row, ( short )2, String.valueOf(area_id_1), defaultStyle );					
             reportUtil.createCell( wb, row, ( short )3, String.valueOf(area_id_2) ,defaultStyle );					
             reportUtil.createCell( wb, row, ( short )4, String.valueOf(area_id_9) ,defaultStyle );					                	
             reportUtil.createCell( wb, row, ( short )5, String.valueOf((area_id_1 + area_id_2 + area_id_9)) ,defaultStyle );					                                     			                                    
             area_id_1_sum += area_id_1;
		     area_id_2_sum += area_id_2;
			 area_id_9_sum += area_id_9;
			 const_type_all_sum += area_id_1 + area_id_2 + area_id_9;    
             //合併縣市別cell=============================================================
             rowEnd = rowNo -1;
			 System.out.println("rowStart="+rowStart);                	     	                 	     	 
			 System.out.println("rowEnd="+rowEnd);                	     	                 	     	 
			 //印出目前的縣市別	                 	  	          
			 //reportUtil.createCell( wb, row,( short )0, tmphsien_name ,defaultStyle );								             
			 for(int j=rowStart+1;j<=rowEnd;j++){  
			       System.out.println("print insert '' to excel");              	     	 			 	   			 	   
			 	   row_count = sheet.createRow( ( short )j );
			       reportUtil.createCell( wb, row_count,( short )0, "" ,defaultStyle );					
			 }
			 if(rowEnd > rowStart){
  	            sheet.addMergedRegion( new Region( ( short )rowStart, ( short )0,( short )rowEnd,( short )0 ) );  	                 	 
  	         }
  	         //=======================================================================
  	         if(city_type.equals("ALL")){//縣市別為全部時
			    //印出其他================================================================
			    const_type_1 = "";
			    const_type_2 = "";
			    const_type_9 = "";
			    const_type_all = 0;
			    area_id_1 = 0;
                area_id_2 = 0;
                area_id_9 = 0;    
                for ( i = 0; i < dbData.size(); i ++) {                
                	  //order_type=2其他
                	 if( "2".equals(bean.getValue("order_type").toString())){                        
                        if( (String)bean.getValue("const_type") != null && "1".equals((String)bean.getValue("const_typ"))){//分部
		          	  		 const_type_1 = bean.getValue("bank_cnt").toString();
		           	 }else if( (String)bean.getValue("const_type") != null && "2".equals((String)bean.getValue("const_typ"))){//簡易型分部
			            	 const_type_2 = bean.getValue("bank_cnt").toString();
			       	 }else{//其他			    	 
			        	 	 const_type_9 = bean.getValue("bank_cnt").toString();			     	 
			       	 } 
                     }
               }
               
               if(!const_type_1.equals("")){
               	const_type_all += Integer.parseInt(const_type_1);
               	area_id_1 += Integer.parseInt(const_type_1);
               }
               if(!const_type_2.equals("")){
                   const_type_all += Integer.parseInt(const_type_2);
               	area_id_2 += Integer.parseInt(const_type_2);
               }
               if(!const_type_9.equals("")){
                   const_type_all += Integer.parseInt(const_type_9);
               	area_id_9 += Integer.parseInt(const_type_9);
               }
               area_id_1_sum += area_id_1;
		       area_id_2_sum += area_id_2;
			   area_id_9_sum += area_id_9;
			   const_type_all_sum += area_id_1 + area_id_2 + area_id_9;       
			   
               rowNo++;
			   row = sheet.createRow( rowNo );     
               row.setHeight((short) 0x120);       
               reportUtil.createCell( wb, row, ( short )0, "其他", defaultStyle );					                
               reportUtil.createCell( wb, row, ( short )1, "", defaultStyle );					                
               reportUtil.createCell( wb, row, ( short )2, const_type_1, defaultStyle );					
               reportUtil.createCell( wb, row, ( short )3, const_type_2 ,defaultStyle );					
               reportUtil.createCell( wb, row, ( short )4, const_type_9 ,defaultStyle );					                	
               reportUtil.createCell( wb, row, ( short )5, String.valueOf(const_type_all) ,defaultStyle );					                                     			                
			  //========================================================================================= 
			 
			  //印出所有總合計========================================================================== 
			  rowNo++;
			  row = sheet.createRow( rowNo );     
              row.setHeight((short) 0x120);       
              reportUtil.createCell( wb, row, ( short )0, "合計", defaultStyle );					                
              reportUtil.createCell( wb, row, ( short )1, "", defaultStyle );					                
              reportUtil.createCell( wb, row, ( short )2, String.valueOf(area_id_1_sum), defaultStyle );					
              reportUtil.createCell( wb, row, ( short )3, String.valueOf(area_id_2_sum),defaultStyle );					
              reportUtil.createCell( wb, row, ( short )4, String.valueOf(area_id_9_sum),defaultStyle );					                	
              reportUtil.createCell( wb, row, ( short )5, String.valueOf(const_type_all_sum) ,defaultStyle );					                                     			                
			}//end of 縣市別為全部時 			     
            //設定寬度============================================================
            for ( i = 0; i < columnLen.length; i++ ) {                
                sheet.setColumnWidth( ( short )i,
                                      ( short ) ( 256 * ( columnLen[i] + 4 ) ) );
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
            
            String filename = titleName+".xls";//108.05.31 add
            if(!printStyle.equalsIgnoreCase("xls")) {//108.05.31非xls檔須執行轉換	                
            	rptTrans rptTrans = new rptTrans();	  			
            	filename = rptTrans.transOutputFormat (printStyle,filename,""); 
            	System.out.println("newfilename="+filename);	  			   
            }

            FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+  filename);//108.05.31 fix  		 
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
