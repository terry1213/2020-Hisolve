<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.StudentDAO" %>
<%@ page import="user.SessionDAO" %>
<%@ page import="user.ResultDAO" %>
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
		if(sessionStorage.getItem("allowed")!="loginAction.jsp" && sessionStorage.getItem("allowed")!="change.jsp" && sessionStorage.getItem("allowed")!="studentPage.jsp" && sessionStorage.getItem("allowed")!="upload.jsp" && sessionStorage.getItem("allowed")!="applySession.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "studentPage.jsp");
		}
	</script>

	<div id="nav" name="nav">
	</div>

	<% 
		String userID = request.getParameter("userID");		
	
		StudentDAO studentDAO = new StudentDAO();
		SessionDAO sessionDAO = new SessionDAO();
		ResultDAO resultDAO = new ResultDAO();
		
		int all = studentDAO.countall();
		String [] check = new String[all];
		
		check = studentDAO.seeSessionID(all);
		
		int result = studentDAO.howmany(userID);
		String[][] temp = new String[result][2];
		String[][] show = new String[result][5];
		String[][] time = new String[result][2];
		
		temp = studentDAO.keyinfo(userID,result);
		%>
    				
		<%
		
		for(int i=0;i<result;i++){
			show[i] = studentDAO.seeSession(temp[i][0],temp[i][1]);
		}
		%>
		
			<script type="text/javascript">
		
	function apply(){
		var inputString = document.getElementById("apply").value;
		var flag=0;
		var tmpArr = new Array();

		<%for(int i=0;i<all;i++){%>
		tmpArr[<%=i%>]="<%=check[i]%>";
		<%}%>
		
		for(i=0;i<<%=all%>;i++){
			if(inputString == tmpArr[i]){
				flag=1;
			}	
		}
		if(flag==1){
			post_to_url(inputString);
		}
		else{
			alert("잘못된 ID 값입니다. 다시 시도해주세요.");
		}
	}
	</script>
	
	<script>
		function post_to_url(sessionID){
		
		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","apply.jsp");
		document.body.appendChild(f);
	
		var i = document.createElement("input");
		i.setAttribute("type","hidden");
		i.setAttribute("name","userID");
		i.setAttribute("value",sessionStorage.getItem("userID"));
		f.appendChild(i);
		
		var j = document.createElement("input");
		j.setAttribute("type","hidden");
		j.setAttribute("name","sessionID");
		j.setAttribute("value",sessionID);
		f.appendChild(j);
		
		f.submit();
		}
	</script>
	
	<div class="card" style="width:25%; margin-left:2%; margin-top:2%">
		<div class="card-header">
			<h2> 새로운 세션 참여하기 </h2>
		</div>
		<div class="card-body">
			<input type="text" placeholder="세션ID를 입력하세요." id="apply" name="apply">
			<button type="button" class="btn btn-primary" onclick="apply()">등록하기</button>
		</div>
	</div>
		
	<div class="card" style="width:60%; margin-left:2%; margin-top:2%">
		<div class="card-header"><h2> 참여 중인 세션 목록 </h2></div>
		<div class="card-body">
		<lu class="list-group">
		<% 
			for(int i=0;i<result;i++){
				String professorID = show[i][0];
				String sessionName= show[i][1];
				String openTime = show[i][2];
				String closeTime = show[i][3];
				String sessionID = show[i][4];
				String timeleft = "timeleft"+ Integer.toString(i);
				time[i][0] = openTime;
				time[i][1] = closeTime;
				
				int percent = sessionDAO.howmany2(professorID,sessionName);
				int a[] = new int[percent];
				String[][] hide = new String[percent][4];
				int correct = 0;
				int fin=0;
				
				a = sessionDAO.keyinfo2(professorID,sessionName,percent);
				
				for(int j=0;j<percent;j++){
					hide[j] = sessionDAO.seeproblem(a[j]);
				}
				
				for(int j=0;j<percent;j++){
					int choose = sessionDAO.checkResult(userID,sessionID,hide[j][0],"correct");
					if(choose == 1){
						correct++;
					}
				}
				
				if(percent!=0){
					 fin = 100/percent*correct;
				}
		%>
			<li class="list-group-item" style="cursor:pointer; border: 1px solid lightgray; margin-bottom:10px; background-color:lightgray;">
			<a onclick="javascript: sessioninfo('<%=professorID %>','<%=sessionName%>','<%=openTime%>','<%=closeTime%>','<%=sessionID%>')">
				<%
  					int newComment = resultDAO.countComment1(sessionID, userID, "NEW");
     				if(newComment > 0){
     					%>
     					<h3><span style="float:right;" class="badge badge-pill badge-secondary">New Comments! <span class="badge badge-pill badge-success"><%=newComment%></span></span></h3>
     					<%
     				}
     			%>
    			<h2><%= show[i][1] %> / <%= show[i][4] %></h2>
    			<p class="list-group-item-text" style="font-size : 20px;">시작 시간 : <%= show[i][2] %> <br> 끝 시간 : <%= show[i][3] %><br><br></p>
  				<h3>진행률 : <%=fin%>% / 남은 시간 : <span id="<%=timeleft %>"></span></h3>
    			<div class="progress">
  					<div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: <%=fin%>%">
    					<span class="sr-only"></span>
  					</div>
				</div>
    		</a>
    		</li>
		<% 
			}
		%>
		</lu>
		</div>
	</div>
	
	<script>
	
	$(document).ready(function(){
		$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));
		
		<%
			for(int z=0;z<result;z++){
				String tempOpenTime=time[z][0];
				String tempCloseTime=time[z][1];
		%>
			var present = getTimeStamp();
			
			var time1 = prepare("<%=tempOpenTime%>");
			var time2 = prepare("<%=tempCloseTime%>");
			var time3 = prepare(present);
			
			if(parseInt(time1)>parseInt(time3)){
				var a = "timeleft" + <%=z%>;
				document.getElementById(a).innerHTML = "-";
			}
			else if(parseInt(time3)>parseInt(time2)){
				var b = "timeleft" + <%=z%>;
				document.getElementById(b).innerHTML = "0";
			}
			else{
				var moments = compare(present,"<%=tempCloseTime%>")
				var c = "timeleft" + <%=z%>;
				document.getElementById(c).innerHTML = moments;
			}
			
		
		<%
			}
		%>
	});
	
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
	
	function sessioninfo(professorID,sessionName,openTime,closeTime,sessionID){
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
		
		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","applySession.jsp");
		document.body.appendChild(f);
	
		var i = document.createElement("input");
		i.setAttribute("type","hidden");
		i.setAttribute("name","sessionName");
		i.setAttribute("value",sessionName);
		f.appendChild(i);
		
		var j = document.createElement("input");
		j.setAttribute("type","hidden");
		j.setAttribute("name","sessionID");
		j.setAttribute("value",sessionID);
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
        m.setAttribute("name","professorID");
        m.setAttribute("value",professorID);
        f.appendChild(m);
         
        var n = document.createElement("input");
        n.setAttribute("type","hidden");
        n.setAttribute("name","userID");
        n.setAttribute("value",sessionStorage.getItem("userID"));
        f.appendChild(n);
        
        var o = document.createElement("input");
        o.setAttribute("type","hidden");
        o.setAttribute("name","state");
        o.setAttribute("value",state);
        f.appendChild(o);
		
		f.submit();
	}
	
	function compare(present,closeTime){
		var first = present.split(" ");
		var firstDate = first[0].split("-");
		var firstTime = first[1].split(":");
		
		var second = closeTime.split(" ");
		var secondDate = second[0].split("-");
		var secondTime = second[1].split(":");
		
		secondDate[0] = secondDate[0] - firstDate[0];
		secondDate[1] = secondDate[1] - firstDate[1];
		secondDate[2] = secondDate[2] - firstDate[2];
		
		secondTime[0] = secondTime[0] - firstTime[0];
		secondTime[1] = secondTime[1] - firstTime[1];		
		
		if(secondDate[1]<0){
			secondDate[1] = 12 + parseInt(secondDate[1]);
			secondDate[0] = secondDate[0] - 1;
		}
		if(secondDate[2]<0){
			secondDate[2] = 30 + parseInt(secondDate[2]);
			secondDate[1] = secondDate[1] - 1;
		}
		if(secondTime[0]<0){
			secondTime[0] = 24 + parseInt(secondTime[0]);
			secondDate[2] = secondDate[2] - 1;
		}
		if(secondTime[1]<0){
			secondTime[1] = 60 + parseInt(secondTime[1]);
			secondTime[0] = secondTime[0] - 1;
		}
		
		var result = secondDate.concat(secondTime);
		
		for(var i=0; i<5;i++){
			if(result[i]==0){
				result[i] = "";
			}
			else{
				switch(i){
				case 0 :
					result[i] = result[i] + "년 ";
					break;
				case 1 :
					result[i] = result[i] + "월 ";
					break;
				case 2 :
					result[i] = result[i] + "일 ";
					break;
				case 3 :
					result[i] = result[i] + "시간 ";
					break;
				case 4 :
					result[i] = result[i] + "분";
					break;
				}
			}
		}
		
		var fin = result.join('');
		
		return fin;
	}
	
	function prepare(timedata){
		var start = timedata.split(" ");
		var startDate = start[0].split("-");
		var startTime = start[1].split(":");
		
		var result = startDate.concat(startTime);
		
		var fin = result.join('');
		
		return fin;
	}
	</script>
	
</body>
</html>