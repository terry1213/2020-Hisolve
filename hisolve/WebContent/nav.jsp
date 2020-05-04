<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% String userName = request.getParameter("userName"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/bootstrap.min.css">
<title>Hisolve</title>

<link rel="icon" href="favicon.ico">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>

</head>
<body>
	<nav class="navbar navbar-expand-md navbar-light bg-dark mb-4">
			<div class="navbar justify-content-start">
				<div class="navbar-brand" onclick="location.href = 'login.jsp';">
					<font color=white>
						<p class="h2" style="cursor:pointer;">Hisolve</p>
					</font>
				</div>
			</div>
			<ul class="navbar-nav ml-auto">
			<li class="nav-item" style="margin-right:10px;">
				<div>
					<font color=white>
						<p class="h5"><%=userName%></p>
					</font>
				</div>
			</li>
			<li class="nav-item">
				<div>
					<button type="button" class="btn btn-danger btn-sm" onclick="logout()">로그아웃</button>
				</div>
			</li>
			</ul>
	</nav>
	
	<script>
	
	function logout(){
		sessionStorage.removeItem("userID");
		sessionStorage.removeItem("userName");
		sessionStorage.removeItem("allowed");
		location.href = 'login.jsp';
	}

	</script>

</body>
</html>