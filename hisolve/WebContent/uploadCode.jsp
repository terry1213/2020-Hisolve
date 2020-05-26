<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%><%@page import="com.oreilly.servlet.MultipartRequest"%><%@page import= "java.io.*"%><%request.setCharacterEncoding("UTF-8");%><%
String fileName = "";
/* String orgfileName = ""; */
String userID = request.getParameter("userID");
String sessionID = request.getParameter("sessionID");
String problemID = request.getParameter("problemID");
String changeName = request.getParameter("changeName");

String uploadPath = request.getSession().getServletContext().getRealPath("/upload") + '/' + userID + '/' + sessionID + '/' + problemID;

try {
	MultipartRequest multi = new MultipartRequest(
			request, 
			uploadPath,
			1024 * 1024 * 10,
			"utf-8",
			new DefaultFileRenamePolicy()
	);

	/* uploadPath = request.getSession().getServletContext().getRealPath("/upload") + "/" + userID; */
	fileName = multi.getFilesystemName("fileName"); // name=file의 업로드된 시스템 파일명을 구함(중복된 파일이 있으면, 중복 처리 후 파일 이름)
	/* orgfileName = multi.getOriginalFileName("fileName"); // name=file의 업로드된 원본파일 이름을 구함(중복 처리 전 이름) */

	if(changeName!=null){
		File file = new File(uploadPath+"/"+fileName);
	    File fileNew = new File(uploadPath+"/"+changeName);
	    if( file.exists() ) {
	    	file.renameTo( fileNew );
	    	fileName = changeName;
	    }
	}
	
} catch (Exception e) {
	e.getStackTrace();
}
%><%=fileName%>