<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.SessionDAO" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%
	String userID = request.getParameter("userID");
	String sessionName = request.getParameter("sessionName");

	SessionDAO sessionDAO = new SessionDAO();
	int howmany = sessionDAO.howmany3(userID);
	String[] names = new String[howmany];
	
	names = sessionDAO.checkNames(userID,howmany);
	String message="0";
	
	for(int i=0;i<howmany;i++){
		if(sessionName.equals(names[i])){
			message="1";
		}
	}
%><%=message %>