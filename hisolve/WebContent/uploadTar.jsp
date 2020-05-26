<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@page import="com.oreilly.servlet.MultipartRequest"%><%@page import= "java.io.*"%><%request.setCharacterEncoding("UTF-8");%><%
String fileName = "";
String name = request.getParameter("name");
String userID = request.getParameter("userID");
String uploadPath = request.getSession().getServletContext().getRealPath("/upload") + '/' + userID + "/problem/test";
String decompressionPath = uploadPath;

if(name.equals("testForm")){
	decompressionPath += "/build";
}

try {
	MultipartRequest multi = new MultipartRequest(
			request, 
			uploadPath,
			1024 * 1024 * 10,
			"utf-8"
	);
	

	/* uploadPath = request.getSession().getServletContext().getRealPath("/upload") + "/" + userID; */
	fileName = multi.getFilesystemName(name); // name=file의 업로드된 원본파일 이름을 구함(중복 처리 전 이름)
	String assignedName = name +".tar";
	
	File f1 = new File(uploadPath+"/"+fileName);
	File f2 = new File(uploadPath+"/"+assignedName);
	f1.renameTo(f2);
	fileName = assignedName;
	
    Runtime rt = Runtime.getRuntime();
    Process p = rt.exec("tar -xvf " +uploadPath+"/"+fileName+" -C "+decompressionPath);
    p.waitFor();
    
} catch (Exception e) {
	e.getStackTrace();
}
%><%=fileName%>
