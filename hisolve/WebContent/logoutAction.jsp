<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Hisolve</title>
</head>
<body>
	<%
	String uploadPath = request.getSession().getServletContext().getRealPath("/upload");
	String userID = request.getParameter("userID");
	String command = "rmdir " + uploadPath + "/" + userID;
	Runtime rt = Runtime.getRuntime();
    Process ps = null;
    try{
    	ps = rt.exec(command);
    }
    finally{
    	ps.waitFor();
    }
	%>

</body>
</html>