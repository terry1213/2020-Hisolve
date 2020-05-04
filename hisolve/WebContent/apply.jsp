<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.StudentDAO" %>
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
		if(sessionStorage.getItem("allowed")!="studentPage.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "apply.jsp");
		}
	</script>

	<%
	String userID = request.getParameter("userID");
	String sessionID = request.getParameter("sessionID");
	
	StudentDAO studentDAO = new StudentDAO();
	String [] result = new String[2];
	
	result = studentDAO.useSessionID(sessionID);

	studentDAO.registerSession(userID,result[0],result[1]);
	
	String sessionInfo[] = new String[5];
	sessionInfo = studentDAO.seeSession(result[0],result[1]);
	
	%>
	
	<script>
	function post_to_next(professorID,sessionName,openTime,closeTime,sessionID){
		
		var present = getTimeStamp();
		
		var time1 = prepare(openTime);
		var time2 = prepare(closeTime);
		var time3 = prepare(present);
		
		var state = "right";
		
		if(parseInt(time1)>parseInt(time3)){
			state = "early";
		}
		else if(parseInt(time3)>parseInt(time2)){
			state = "late";
		}
		
		else{
			var f = document.createElement("form");
			f.setAttribute("method","post");
			f.setAttribute("action","applySession.jsp");
			document.body.appendChild(f);
		
			var i = document.createElement("input");
			i.setAttribute("type","hidden");
			i.setAttribute("name","userID");
			i.setAttribute("value",sessionStorage.getItem("userID"));
			f.appendChild(i);
			
			var j = document.createElement("input");
			j.setAttribute("type","hidden");
			j.setAttribute("name","sessionName");
			j.setAttribute("value",sessionName);
			f.appendChild(j);
			
			var k = document.createElement("input");
			k.setAttribute("type","hidden");
			k.setAttribute("name","openTime");
			k.setAttribute("value",openTime);
			f.appendChild(k);
			
			var l = document.createElement("input");
			l.setAttribute("type","hidden");
			l.setAttribute("name","closeTime");
			l.setAttribute("value",closeTime);
			f.appendChild(l);
			
			var m = document.createElement("input");
			m.setAttribute("type","hidden");
			m.setAttribute("name","sessionID");
			m.setAttribute("value",sessionID);
			f.appendChild(m);
			
			var n = document.createElement("input");
			n.setAttribute("type","hidden");
			n.setAttribute("name","professorID");
			n.setAttribute("value",professorID);
			f.appendChild(n);
		
			var o = document.createElement("input");
	        o.setAttribute("type","hidden");
	        o.setAttribute("name","state");
	        o.setAttribute("value",state);
	        f.appendChild(o);
			
			f.submit();	
		}
	}
	
	function prepare(timedata){
		var start = timedata.split(" ");
		var startDate = start[0].split("-");
		var startTime = start[1].split(":");
		
		var result = startDate.concat(startTime);
		
		var fin = result.join('');
		
		return fin;
	}
	
	function getTimeStamp() {
		  var d = new Date();
		  var s =
		    leadingZeros(d.getFullYear(), 4) + '-' +
		    leadingZeros(d.getMonth() + 1, 2) + '-' +
		    leadingZeros(d.getDate(), 2) + ' ' +

		    leadingZeros(d.getHours(), 2) + ':' +
		    leadingZeros(d.getMinutes(), 2);

		  return s;
		}

		function leadingZeros(n, digits) {
		  var zero = '';
		  n = n.toString();
		
		  if (n.length < digits) {
		    for (i = 0; i < digits - n.length; i++)
		      zero += '0';
		  }
		  return zero + n;
		}
	</script>
	
	<script>
		post_to_next('<%=sessionInfo[0]%>','<%=sessionInfo[1]%>','<%=sessionInfo[2]%>','<%=sessionInfo[3]%>','<%=sessionInfo[4]%>');
	</script>

</body>
</html>