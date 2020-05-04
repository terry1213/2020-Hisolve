<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name ="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.min.css">
<title>Hisolve</title>

<link rel="icon" href="favicon.ico">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
<script src="https://apis.google.com/js/platform.js" async defer></script>

<meta name = "google-signin-client_id" content = "40970117670-8cm8sofuv6npui6p9edlq400t4e7i086.apps.googleusercontent.com">

</head>
<body>

	<nav class="navbar navbar-expand-md navbar-light bg-dark mb-4">
			<div class="navbar justify-content-start">
				<a class="navbar-brand">
					<font color=white>
						<p class="h2">Hisolve</p>
					</font>
				</a>
			</div>
	</nav>

	<div class ="container">
      <div class="col-lg-4" style="margin:auto">
         <div class="jumbotron" style="padding-top:20px;">
            <form method="post" action="login2.jsp">
               <h2 style="text-align:center;">Login</h2>
               <div class="form-group">
                  <input type="text" class="form-control" placeholder="ID" name="userID" maxlength="20">
               </div>
               <div class="form-group">
                  <input type="password" class="form-control" placeholder="password" name="password" maxlength="20">
               </div>
               <input type="submit" class="btn btn-dark form-control" value="login">
               <!-- <br><br>
               <button type="button" class="btn btn-primary form-control" onclick="location.href = 'join.jsp'">register</button>
               <br><br> -->
            </form>
            <!-- <div class="g-signin2" data-onsuccess="onSignIn" data-width="250" data-height="50" data-longtitle="true" data-value="login"></div> -->
         </div>
      </div>
   </div>

   <div class="d-flex align-items-center justify-content-center mt-4">
    <div class="">
        <div class="d-flex justify-content-center">
            <p class="h4 mb-3">Team Contact</p>
        </div>

        <div class="d-flex justify-content-center align-items-center">
            <div>
                <p class="d-flex justify-content-center"><svg class="bi bi-envelope-fill" width="1.5em" height="1.5em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
  <path d="M.05 3.555L8 8.414l7.95-4.859A2 2 0 0014 2H2A2 2 0 00.05 3.555zM16 4.697l-5.875 3.59L16 11.743V4.697zm-.168 8.108L9.157 8.879 8 9.586l-1.157-.707-6.675 3.926A2 2 0 002 14h12a2 2 0 001.832-1.195zM0 11.743l5.875-3.456L0 4.697v7.046z"/>
</svg></p>
                <p align="center">민예홍</p>
                <p>21500247@handong.edu</p>
                <p align="center">임연우</p>
                <p class="mb-0">21500602@handong.edu</p>
            </div>
        </div>
    </div>
	</div>

<span id="result"></span>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script type="text/javascript" src="https://apis.google.com/js/platform.js?onload=onLoad" async defer></script>

<script>
function post_to_url(){
	sessionStorage.setItem("allowed", "login.jsp");
	
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

if(sessionStorage.getItem("userID") != null){
	post_to_url();
}

function onSignIn(googleUser) {
// 프로필 가져오기
var profile = googleUser.getBasicProfile();

var email = profile.getEmail();
var idx = email.indexOf("@"); 

var userID = email.substring(0, idx);

sessionStorage.setItem("userID", userID);
sessionStorage.setItem("userName", profile.getName());

// 로그인 정보 출력하기
//$("span#result").html("id : "+profile.getId()+"<br />"+"email : "+profile.getEmail()+"<br />"+"name : "+profile.getName());


if(sessionStorage.getItem("userID") != null){
    var auth2 = gapi.auth2.getAuthInstance();
    auth2.signOut().then(function () {
      console.log('User signed out.');
    });
    auth2.disconnect();
    post_to_url();
    /*$.ajax({
    	url:'loginAction.jsp',
    	dataType:'text',
    	type:'POST',
    	data:{'userID': sessionStorage.getItem("userID")},
    	success : function(){
    		location.href = 'sendingPage.jsp';
        },
    	error : function(request,status,error){
			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
    	}
	});*/

}

}

</script>

</body>
</html>