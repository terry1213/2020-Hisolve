<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.SessionDAO" %>
<%
	
SessionDAO sessionDAO = new SessionDAO();

String sessionName = request.getParameter("sessionName");
String sessionID = request.getParameter("sessionID");
String userID = request.getParameter("userID");
String openTime = request.getParameter("openTime");
String closeTime = request.getParameter("closeTime");

int result = sessionDAO.updateSession(openTime, closeTime, userID, sessionName, sessionID);
%>