<%@ page language="java" contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@page import="java.io.*"%>

<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Hisolve</title>
</head>
<body>

	<script>
		if(sessionStorage.getItem("allowed")!="login.jsp" && sessionStorage.getItem("allowed")!="login2.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "loginAction.jsp");
		}
	</script>

	<script>
	function post_to_url(){
		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","loginAction2.jsp");
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
	</script>

	<%
	String uploadPath = request.getSession().getServletContext().getRealPath("/upload");
	String userID = request.getParameter("userID");
	//String command = "mkdir " + uploadPath + "/" + userID;
	//Runtime rt = Runtime.getRuntime();
   // Process ps = null;
    //try{
    //	ps = rt.exec(command);
    //}
    //finally{
    //	ps.waitFor();
    //}
	
	File f = new File(uploadPath + '/' + userID);
	if(!f.exists()){
		f.mkdirs();
	}
	%>
	
	<% 
		UserDAO userDAO = new UserDAO();
		String result = userDAO.login(userID);	
		if(result!=null){
			String access = userDAO.check(userID);
			if(access.equals("YES")){
				%>
				<script>
				sessionStorage.removeItem("userName");
				sessionStorage.setItem("userName", "<%=result%>");
				post_to_next();
				</script>
			<%
			}
			if(access.equals("NO")){
			%>
			<script>
				sessionStorage.removeItem("userName");
				sessionStorage.setItem("userName", "<%=result%>");
				post_to_next2();
			</script>
			<%
			}
			else{
			%>
				<script>
					sessionStorage.removeItem("userName");
					sessionStorage.setItem("userName", "<%=result%>");
					location.href="loginAction2.jsp";
				</script>
			<%
			}
		}
		else{
			%>
			
			<h3>앞으로 활동하면서 사용하실 닉네임을 설정해주세요!</h3><br>
			<form action="javascript:insertName();">
			<input type="text" value="" id="nickname" name="nickname" required><br><br>
			<input type="submit" value="등록하기">
			</form>
			
			<script>
				document.getElementById("nickname").value = sessionStorage.getItem("userName");
			</script>
			
			<script type="text/javascript"> 
				function insertName(){
					var inputString = document.getElementById("nickname").value;
					sessionStorage.removeItem("userName");
					sessionStorage.setItem("userName", inputString);
					post_to_url();	
				}
			</script>
			<%
		}
	%>

</body>
</html>