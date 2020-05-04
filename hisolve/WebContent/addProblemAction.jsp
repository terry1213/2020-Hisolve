<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="user.SessionDAO"%><% request.setCharacterEncoding("UTF-8"); %><%
		String userID = request.getParameter("userID");
		String problemID = request.getParameter("problemID");
		String sessionName = request.getParameter("sessionName");
		
		String message = "";
		
		SessionDAO sessionDAO = new SessionDAO();
		int result = sessionDAO.addProblem(userID, sessionName, Integer.parseInt(problemID));
		if(result == 1){
			message = "해당 문제가 세션에 추가되었습니다.";
		}
%><%=message%>