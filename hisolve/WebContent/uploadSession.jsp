<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.SessionDAO" %>
<%@page import="java.io.File"%>
<%@page import="java.util.Random"%>
<%
   String userID = request.getParameter("userID");
   String sessionName = request.getParameter("sessionName");
   String openTime = request.getParameter("openTime");
   String closeTime = request.getParameter("closeTime");
   
   SessionDAO sessionDAO = new SessionDAO();
   
   String sessionID = "";
   
   while(true){
      StringBuffer temp = new StringBuffer();
      Random rnd = new Random();
      for (int i = 0; i < 7; i++) {
          int rIndex = rnd.nextInt(3);
          switch (rIndex) {
          case 0:
              // a-z
              temp.append((char) ((int) (rnd.nextInt(26)) + 97));
              break;
          case 1:
              // A-Z
              temp.append((char) ((int) (rnd.nextInt(26)) + 65));
              break;
          case 2:
              // 0-9
              temp.append((rnd.nextInt(10)));
              break;
          }
      }
      
      sessionID = temp.toString();
      
      int check = sessionDAO.checkSession(sessionID);
      if(check == 0){
         break;
      }
   }
   int result = sessionDAO.insertSession(userID, sessionName, openTime, closeTime,sessionID);
   
%>