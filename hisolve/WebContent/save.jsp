<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.io.*"%>
<%
   String uploadPath = request.getParameter("uploadPath");
   String fileName = request.getParameter("fileName");
   String data = request.getParameter("data");
   File saveFile = new File(uploadPath + "/" + fileName);
   FileWriter fw = new FileWriter(saveFile);
   
   while(data.length() > 0 && data.charAt(data.length()-1)=='\n') {
         data = data.substring(0, data.length()-1);
   }
   
   fw.write(data);
   fw.close();
%>>