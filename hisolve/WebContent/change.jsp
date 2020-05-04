<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hisolve</title>
<link rel="icon" href="favicon.ico">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
</head>
<body>

	<script>
		if(sessionStorage.getItem("allowed")!="loginAction2.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "change.jsp");
		}
	</script>

	<%
	String userID = request.getParameter("userID");
	String userName = request.getParameter("userName");
	String state = request.getParameter("state");
	
	UserDAO userDAO = new UserDAO();
	int change = userDAO.changeauthority(userID,state);
	%>
	
	<script>
	function post_to_next(){
		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","professorPage.jsp");
		document.body.appendChild(f);
	
		var i = document.createElement("input");
		i.setAttribute("type","hidden");
		i.setAttribute("name","userID");
		i.setAttribute("value",sessionStorage.getItem("userID"));
		f.appendChild(i);
		
		var j = document.createElement("input");
		j.setAttribute("type","hidden");
		j.setAttribute("name","userName");
		j.setAttribute("value",sessionStorage.getItem("userName"));
		f.appendChild(j);
	
		f.submit();
	}
	
	function post_to_next2(){
		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","studentPage.jsp");
		document.body.appendChild(f);
	
		var i = document.createElement("input");
		i.setAttribute("type","hidden");
		i.setAttribute("name","userID");
		i.setAttribute("value",sessionStorage.getItem("userID"));
		f.appendChild(i);
	
		f.submit();
	}
	
	var stance = "<%=state%>";
	
	if(stance == "NO"){
		post_to_next2();
	}
	if(stance == "YES"){
		post_to_next();
	}
	</script>

</body>
</html>