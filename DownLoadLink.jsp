<%
//103.09.25 fix 農金局.主機檔案無法下載問題 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.dao.DAOFactory" %>
<%@ page import="com.tradevan.util.dao.RdbCommonDao" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.io.*" %>
<%@ page import="com.tradevan.util.ftp.MyFTPClient" %>
<%@ page import="java.net.URLEncoder" %>
<%

String file_name = Utility.getTrimString(request.getParameter("append_file"));
List filename_List = new LinkedList();
filename_List.add(file_name);
String downloadlink = Utility.getProperties("ClientRptDir")+System.getProperty("file.separator")+file_name;

MyFTPClient ftpC = new MyFTPClient(Utility.getProperties("rptIP"), Utility.getProperties("rptID"), Utility.getProperties("rptPwd"));
ftpC.getFiles(Utility.getProperties("serverRptDir")+"MC001W", Utility.getProperties("ClientRptDir")+System.getProperty("file.separator"),filename_List);

System.out.println("downloadlink:"+downloadlink);
response.setContentType("multipart/form-data;charset=UTF-8;Content-Transfer-Encoding=8bit;");
response.setHeader("Content-Disposition","attachment; filename="+Utility.getTrimString(request.getParameter("append_file")));
FileInputStream fin = new FileInputStream(Utility.getProperties("ClientRptDir")+System.getProperty("file.separator")+file_name);  		 
ServletOutputStream out1 = response.getOutputStream();           
byte[] line = new byte[8196];
int getBytes=0;
while( ((getBytes=fin.read(line,0,8196)))!=-1 ){		    		
	out1.write(line,0,getBytes);
	out1.flush();
}
fin.close();
out1.close();       			 
File tmpFile = new File(Utility.getProperties("ClientRptDir")+System.getProperty("file.separator")+file_name);
if(tmpFile.exists()) tmpFile.delete();
ftpC=null;
%>

<HTML>
<head>
<title>下載訴願答辯書</title>
</head>
</HTML>



