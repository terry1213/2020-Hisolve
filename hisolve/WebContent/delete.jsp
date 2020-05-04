<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%
	String deletePath = request.getParameter("deletePath");
	String fileName = request.getParameter("fileName");
	File f = new File(deletePath + "/" + fileName);
	if( f.exists()) f.delete();
%>