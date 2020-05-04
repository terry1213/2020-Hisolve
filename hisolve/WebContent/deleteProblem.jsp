<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="user.SessionDAO" %>
   <% 
      String userID = request.getParameter("userID");
      String problemID = request.getParameter("problemID");
      String sessionName = request.getParameter("sessionName");
      String openTime = request.getParameter("openTime");
      String closeTime = request.getParameter("closeTime");
      
      SessionDAO sessionDAO = new SessionDAO();
      
      sessionDAO.deleteProblem(userID,sessionName,Integer.parseInt(problemID));
      
   %>