<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.io.*"%>
<%
	String uploadPath = request.getParameter("uploadPath");
	String fileName = request.getParameter("fileName");
	
	Runtime rt = Runtime.getRuntime();
    Process p = rt.exec("rm "+ uploadPath + fileName);
%>