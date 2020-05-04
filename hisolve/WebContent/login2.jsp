<%@ page language="java" contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="user.UserDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="./css/bootstrap-theme.min.css">

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<title>Hisolve</title>
</head>
<body>
</body>
<%
UserDAO userDAO = new UserDAO();
String userID = request.getParameter("userID");
String password = request.getParameter("password");

if(userDAO.check(userID, password) == 1){
	String userName = userDAO.login(userID);
	%>
	<script>
	sessionStorage.setItem("userID", "<%=userID%>");
	sessionStorage.setItem("userName", "<%=userName%>");
	sessionStorage.setItem("allowed", "login2.jsp");
	function post_to_url(){

		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","loginAction.jsp");
		document.body.appendChild(f);
	
		var i = document.createElement("input");
		i.setAttribute("type","hidden");
		i.setAttribute("name","userID");
		i.setAttribute("value",sessionStorage.getItem("userID"));
		f.appendChild(i);
	
		f.submit();
	}
	</script>
	<script>
	post_to_url();
	</script>
	<%
}
else{
	%>
	<script>
	alert("아이디와 비밀번호를 확인해주세요.");
	history.back();
	</script>
	<%
}

%>
</html>