<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.SessionDAO" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hisolve</title>

<link rel="icon" href="favicon.ico">
<link rel="stylesheet" href="./css/bootstrap-datetimepicker.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
<script src="js/bootstrap-datetimepicker.min.js"></script>
<script src="js/bootstrap-datetimepicker.ko.js"></script>

</head>
<body>
	
<script>
	if(sessionStorage.getItem("allowed")!="showSession.jsp"){
		alert("잘못된 접근입니다.");
		history.back();
	}
	else{
		sessionStorage.setItem("allowed", "reviseTime.jsp");
	}
</script>
	
<%
	SessionDAO sessionDAO = new SessionDAO();
	
	String sessionName = request.getParameter("sessionName");
	String sessionID = request.getParameter("sessionID");
	String userID = request.getParameter("userID");
	
	String[] sessionInfo = new String[5];
	sessionInfo = sessionDAO.seeSession(userID, sessionName);
%>
	
<div id="nav" name="nav">
</div>

<div class="container">
	<div class="row">
		<div class="col-md-3">
			<div class="page-header">
				<h5>세션 시간 변경</h5>
			</div>
			<form id="postData">
				
				<div class="input-group mb-3">
					<div class="input-group-prepend">
    					<label class="input-group-text" for="openTime">여는 시간:</label>
  					</div>
					<input name="openTime" id="openTime" type="text" style="background-color: white;" readonly class="form_datetime form-control" required>
				</div>
				
				<div class="input-group mb-3">
					<div class="input-group-prepend">
    					<label class="input-group-text" for="closeTime">닫는 시간:</label>
  					</div>
					<input name="closeTime" id="closeTime" type="text" style="background-color: white;" readonly class="form_datetime form-control" required>
				</div>
			</form>
			<div class="form-group">
				<button id="submit" class="btn btn-primary" style="border-color:blue">변경</button>
				<button onclick="history.back();" class="btn btn-primary" style="border-color:blue">취소</button>
			</div>
		</div>
	</div>
</div>

<script>
	$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));

	$(".form_datetime").datetimepicker({
        format: "yyyy-mm-dd hh:ii",
        autoclose: true,
        todayBtn: true,
        pickerPosition: "bottom-left",
        startDate: new Date(),
        language: 'ko'
    });
	var currentDate = new Date(); 
	$('#openTime').val("<%=sessionInfo[2]%>");
	$('#closeTime').val("<%=sessionInfo[3]%>");
	
	
	$("#submit").click(function(){
		var start_date = new Date($('#openTime').val()),
	    end_date = new Date($('#closeTime').val()),
	    diff  = new Date(end_date - start_date),
	    minutes  = parseInt(diff/(1000*60), 10);
		if(minutes < 1){
	    	alert('닫는 시간을 여는 시간보다 이후로 설정해 주세요.');
		}		
		else{
			$.ajax({
	        	url:'updateSession.jsp',
	        	dataType:'text',
	        	type:'POST',
	        	data:{'userID':sessionStorage.getItem("userID"), 'openTime':$('#openTime').val(), 'closeTime':$('#closeTime').val(), 'sessionID':"<%=sessionID%>", 'sessionName':"<%=sessionName%>",},
	        	success : function(){
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
	            },
	        	error : function(request,status,error){
	    			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	        	}
	    	});
		}
	});

</script>
</body>
</html>