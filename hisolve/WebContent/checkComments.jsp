<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ page import="user.ResultDAO" %><%
	String userID = request.getParameter("userID");
	String sessionID = request.getParameter("sessionID");
	String problemID = request.getParameter("problemID");
	String resultID = request.getParameter("resultID");
	
	ResultDAO resultDAO = new ResultDAO();
		
	int count = resultDAO.countComment6(sessionID, problemID, resultID, userID, "NEW");
	
	String result = "NO";
	if(count > 0){
		result = "NEW";
	}
%><%=result%>