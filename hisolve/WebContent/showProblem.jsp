<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="user.ProblemDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<title>Hisolve</title>

<link rel="icon" href="favicon.ico">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
</head>
<body>

	<script>
		if(sessionStorage.getItem("allowed")!="reviseProblem.jsp" && sessionStorage.getItem("allowed")!="professorPage.jsp" && sessionStorage.getItem("allowed")!="cloneProblem.jsp" && sessionStorage.getItem("allowed")!="addProblem.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "showProblem.jsp");
		}
	</script>

	<% 
		String problemName = request.getParameter("problemName");
		String problemID = request.getParameter("problemID");
		String timeLimit = request.getParameter("timeLimit");
	%>
	
	<div id="nav" name="nav">
	</div>
	
	<div class="jumbotron" style="width:60%; margin-left:2%; margin-top:2%;">

  		<h3><%=problemName %></h3>
  		<p>시간 제한 : <%=timeLimit%> sec</p>
  		<p>문제 설명 :</p>
  		<p id="problemInfo"></p>
  		<button type="button" class="btn btn-primary" onclick="javascript: history.back();"> 이전 페이지로 돌아가기 </button>
  		<button type="button" class="btn btn-primary" onclick="javascript: cloneProblem()"> 문제 클론 </button>
  		<!-- <button type="button" class="btn btn-default" style="padding: 10px 10px; background:GhostWhite" onclick="javascript: deleteProblem()"> 문제 삭제 </button> -->
		<!-- <button type="button" class="btn btn-default" style="padding: 10px 10px; background:GhostWhite" onclick="javascript: reviseProblem()"> Revise Problem </button> -->

	</div>
	<script>
	$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));
	
	function showProblemInfo(){
		$.ajax({
			url : "upload/problem/<%=problemID%>/problemContent.txt",
	       	dataType: "text",
	       	success : function (data) {
	       		document.getElementById('problemInfo').innerHTML = data;
	       	}
	   	}); 
	}
	
	showProblemInfo();

	
/* 	function tossback(){
		
		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","professorPage.jsp");
		document.body.appendChild(f);
		
		var g = document.createElement("input");
		g.setAttribute("type","hidden");
		g.setAttribute("name","userID");
		g.setAttribute("value",sessionStorage.getItem("userID"));
		f.appendChild(g);
		
		var h = document.createElement("input");
		h.setAttribute("type","hidden");
		h.setAttribute("name","userName");
		h.setAttribute("value",sessionStorage.getItem("userName"));
		f.appendChild(h);
		
		f.submit();
	} */
	
<%-- 	function deleteProblem(){
		var input = confirm("해당 문제를 삭제하시겠습니까?");
		if(input==true){
			sendinfo();
		}
	}
	
	function sendinfo(){
		
		$.ajax({
			url : "deleteProblem.jsp",
	       	dataType: "text",
	       	data: {'problemID': "<%=problemID%>"},
	       	success : function (data) {
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
	   	}); 
	} --%>
	
	function cloneProblem(){
		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","cloneProblem.jsp");
		document.body.appendChild(f);
	
		var i = document.createElement("input");
		i.setAttribute("type","hidden");
		i.setAttribute("name","problemName");
		i.setAttribute("value","<%=problemName%>");
		f.appendChild(i);
		
		var j = document.createElement("input");
		j.setAttribute("type","hidden");
		j.setAttribute("name","problemID");
		j.setAttribute("value","<%=problemID%>");
		f.appendChild(j);
		
		var k = document.createElement("input");
		k.setAttribute("type","hidden");
		k.setAttribute("name","timeLimit");
		k.setAttribute("value",<%=timeLimit%>);
		f.appendChild(k);
		
		var l = document.createElement("input");
		l.setAttribute("type","hidden");
		l.setAttribute("name","userID");
		l.setAttribute("value",sessionStorage.getItem("userID"));
		f.appendChild(l);
		
		f.submit();
	}
	
<%-- 	function reviseProblem(){
		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","reviseProblem.jsp");
		document.body.appendChild(f);
	
		var i = document.createElement("input");
		i.setAttribute("type","hidden");
		i.setAttribute("name","sessionName");
		i.setAttribute("value","<%=sessionName%>");
		f.appendChild(i);
		
		var m = document.createElement("input");
		m.setAttribute("type","hidden");
		m.setAttribute("name","problemContent");
		m.setAttribute("value",document.getElementById('problemInfo').innerHTML);
		f.appendChild(m);
		
		f.submit();
	} --%>
	
	</script>

</body>
</html>