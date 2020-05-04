<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>    

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hisolve</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
</head>
<body>

	<script>
		if(sessionStorage.getItem("allowed")!="loginAction.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "loginAction2.jsp");
		}
	</script>

	<%
	String userID = request.getParameter("userID");
	String userName = request.getParameter("userName");
	
	
	UserDAO userDAO = new UserDAO();
	/* int insert = userDAO.join(userID,userName); */ //구글 로그인 삭제하면서 혹시 몰라서 주석처리
	%>
	
	<script type="text/javascript">
	function check(){
		document.getElementById('add').innerHTML+='<input type="text" value="Input Professor code" id="check" name="check">';
		document.getElementById('add').innerHTML+='<input type="submit" value="submit">';
	}
	
	function check2(){
		var inputString = document.getElementById("check").value;
		if(inputString=="1111"){
			post_to_next("YES");
		}
		else{
			post_to_next("NO");
		}
	}
	
	function post_to_next(state){
		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","change.jsp");
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
		
		var k = document.createElement("input");
		k.setAttribute("type","hidden");
		k.setAttribute("name","state");
		k.setAttribute("value",state);
		f.appendChild(k);
	
		f.submit();
	}
		
	</script>
	
	<h2> ARE YOU A PROFESSOR OR STUDENT? </h2>
	<button onclick="check()">Professor</button>
	<button onclick="post_to_next('NO')">Student</button>
	<br><br>
	<form action="javascript:check2();">
	<div id="add"></div>
	</form>
</body>
</html>