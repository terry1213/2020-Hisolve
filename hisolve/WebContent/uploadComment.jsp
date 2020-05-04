<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.ResultDAO" %>
<%
	String sessionID = request.getParameter("sessionID");
	String problemID = request.getParameter("problemID");
	String resultID = request.getParameter("resultID");
	String comment = request.getParameter("comment");
	String userID = request.getParameter("userID");
	String toID = request.getParameter("toID");
	
	ResultDAO resultDAO = new ResultDAO();
  
	int result = resultDAO.comment(sessionID, problemID, resultID, comment, userID, toID);
%>