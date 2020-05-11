<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import= "java.io.*, java.util.*, java.text.SimpleDateFormat, user.ResultDAO, user.UserDAO, user.ProblemDAO, user.SessionDAO"%><%	
	int correct = 0;
	String fin="";
	String uploadPath = request.getParameter("uploadPath");
	String txtPath = request.getParameter("txtPath");
	String fileName = request.getParameter("fileName");
	String userID = request.getParameter("userID");
	String timeLimit = request.getParameter("timeLimit");
	String sessionID = request.getParameter("sessionID");
	String problemID = request.getParameter("problemID");
	String problemName = request.getParameter("problemName");
	String problemContent = request.getParameter("problemContent");
	String code = request.getParameter("code");
	String type = request.getParameter("type");
	String testing = request.getParameter("testing");
	
	ResultDAO resultDAO = new ResultDAO();
	UserDAO userDAO = new UserDAO();
	ProblemDAO problemDAO = new ProblemDAO();
	SessionDAO sessionDAO = new SessionDAO();
	
	String message = "";
	int timeover = 0;
	String upload_time = "";
	String code_result = "correct";
	uploadPath += "/build";
	
	Runtime rt = Runtime.getRuntime();
    Process ps = null;
	
	if(userDAO.check(userID).equals("NO") && testing.equals("NO")){
		
		Date now = new Date();
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd kk:mm");
		upload_time = sf.format(now);
		String sessionTime[] = new String[2];
		sessionTime = sessionDAO.seeSessionTime(sessionID);
		
		int num = resultDAO.chance(userID,sessionID,problemID);
		
		if(upload_time.compareTo(sessionTime[0]) < 0 || upload_time.compareTo(sessionTime[1]) > 0){
			timeover = 1;
			message = num + "opportunity";
			message += "세션이 닫혀있습니다.";
			ps = rt.exec("rm " + uploadPath + "/" + fileName);
			ps.waitFor();
			ps.destroy();
		}
		else{
			if(num==-1){
				resultDAO.insertChance(userID,sessionID,problemID,49);
				message = "49opportunity";
			}
			else{
				resultDAO.changeChance(userID,sessionID,problemID,num-1);
				message = (num - 1) + "opportunity";
			}
		}
	}
	
	if(timeover == 0){
		String[] available = resultDAO.checkContainer();// container 상태 확인 (db)
		String container = "";
		int size = resultDAO.countContainer("FREE");
		
		if(size==0){
			//사용할 수 있는 container가 현재 없음 -> queue에 넣어야 함
			resultDAO.insertQueue(userID, "none");
			while(true){
				if(resultDAO.checkQueue(userID) == 1){
					break;
				}
				//sleep
			}
			container = resultDAO.freeContainer(userID);	// 할당받은 container 받아오기
			resultDAO.deleteJob(userID);	// Job 지우기
		}
		else{
			container = available[0];	// container 사용 가능한 것 하나 골라서 사용
			resultDAO.changeState("BUSY",container);	//	container 상태를 바꿔줌
		}
		
		String[] getInputNum = {"/bin/sh", "-c", "ls -l " + txtPath + "/input | grep ^- | wc -l"};
		String inputNum = "";
	    try{
			ps = rt.exec(getInputNum);
		}
		finally{
			BufferedReader br =
		 			new BufferedReader(
		 					new InputStreamReader(
		 							new SequenceInputStream(ps.getInputStream(), ps.getErrorStream())));
			inputNum = br.readLine();
		}
	    
		int count = 0;
		int check = 0;
		
		String line = "";
	    String command[] = {"/usr/local/bin/docker exec -w /home/ " + container + " mkdir " + userID,
				"/usr/local/bin/docker cp " + uploadPath + "/" + fileName + " "+ container +":/home/" + userID,
				"/usr/local/bin/docker exec -w /home/ "+ container +" /bin/bash -c 'ulimit -Su 100 ; python container.py " + userID + " " + fileName + " " + String.valueOf(count) + " " + timeLimit + " " + type + "' ; echo $?",
				"/usr/local/bin/docker exec -w /home/ "+ container +" rm -r " + userID,
				"rm " + uploadPath + "/error.txt",
				"rm " + uploadPath + "/" + fileName};

	    
	    for(int i = 0; i < command.length; i++){
	    	try{
	    		if(i == 2){		//컨테이너 내부 프로그램 run할 때 exit 코드를 출력하기 위해 shell 사용
	    			String[] shell = {"/bin/sh", "-c", command[i]};
	    			ps = rt.exec(shell);
	    		}else
	    			ps = rt.exec(command[i]);
	    		
	   		}finally{
	   			ps.waitFor();
	   			
	   			BufferedReader br =
	    	 			new BufferedReader(
	    	 					new InputStreamReader(
	    	 							new SequenceInputStream(ps.getInputStream(), ps.getErrorStream())));
				
	   			if(i == 1){
	   				ps = rt.exec("/usr/local/bin/docker exec -w /home/" + userID + " "+ container + " tar -xvf " + fileName);
	   				ps.waitFor();
	   				ps = rt.exec("/usr/local/bin/docker cp " + txtPath + "/input " + container +":/home/" + userID);
	   				ps.waitFor();
	   			}
	   			
	   			if(i == 2){
	   				if((line = br.readLine()) != null){
	   					switch(line){
	   						case "0":	//정상 종료
	   							count += 1;
	   			         	 	message += String.valueOf(count) + "번: 정답입니다!\n";
	   			         	 	correct += 1;
	   							if(testing.equals("YES") || count == 1){					
	   								if(testing.equals("YES")){
		   								message += "\n정답:\n";
		   					            BufferedReader answerReader = new BufferedReader(new FileReader(txtPath + "/input/input" + String.valueOf(count-1) + ".txt"));
		   					            StringBuilder answerSB = new StringBuilder();
		   					            String line2;

		   					            while((line2 = answerReader.readLine())!= null){
		   					            	answerSB.append(line2+"\n");
		   					            }
		   								message += answerSB.toString();
		   								answerReader.close();
	   								}
	   								
	   								message += "\n코드 결과:\n";
	   								message += "Test Command " + String.valueOf(count) + "번: 정답입니다!\n";
	   							}
	   							break;
	   						case "1":
	   							count += 1;
	   							message += String.valueOf(count) + "번: 틀렸습니다.\n";
	   							if(testing.equals("YES") || count == 1){					
	   								if(testing.equals("YES")){
		   								message += "\n정답:\n";
		   					            BufferedReader answerReader = new BufferedReader(new FileReader(txtPath + "/input/input" + String.valueOf(count-1) + ".txt"));
		   					            StringBuilder answerSB = new StringBuilder();
		   					            String line2;

		   					            while((line2 = answerReader.readLine())!= null){
		   					            	answerSB.append(line2+"\n");
		   					            }
		   								message += answerSB.toString();
		   								answerReader.close();
	   								}
	   								
	   								message += "\n코드 결과:\n";
	   								message += "Test Command " + String.valueOf(count) + "번: 틀렸습니다.\n";
	   							}
	   							break;
	   							
	   						case "-1":	//컴파일 에러
	   							message += "컴파일 에러!\n\n";
	   							code_result = "compile";
	   							ps  = rt.exec("/usr/local/bin/docker cp " + container + ":/home/" + userID + "/error.txt " + uploadPath);
	   							ps.waitFor();
	   							File errorFile = new File(uploadPath + "/error.txt");
	   			    			BufferedReader fileReader = new BufferedReader(new FileReader(errorFile));

	   							while((line = fileReader.readLine()) != null){
	   								message= message + line + "\n";
	   			    	        }

	   			    	        fileReader.close();
	   			    	        check = 1;
	   							break;
	   					}
	   					if(check == 0){
	   						if(count < Integer.valueOf(inputNum.trim())){
		    					i -= 1;
		    					command[2] = "/usr/local/bin/docker exec -w /home/ " + container + " /bin/bash -c 'ulimit -Su 100 ; python container.py " + userID + " " + fileName + " " + String.valueOf(count) + " " + timeLimit + " " + type + "' ; echo $?";
		    				}
	   					}
	   					continue;
	    			}
	   			}

	    		if(i == 5){
	    			String authority = userDAO.check(userID);
	    			if(authority.equals("YES")){
	    				if(correct == Integer.valueOf(inputNum.trim())){
	    					if(testing.equals("NO")){
	        					int check1 = problemDAO.insertProblem(userID, problemName, timeLimit, problemContent, type);
	            				File f1 = new File(uploadPath);
	        					File f2 = new File(request.getSession().getServletContext().getRealPath("/upload") + "/problem/" + check1);
	        					f1.renameTo(f2);
	        					break;
	    					}
	    				}
	    			}
	    			else{
	    				if(testing.equals("YES")){
	    					/* break; */
	    				}
	    				else if(correct == Integer.valueOf(inputNum.trim())){		
	    					int result = resultDAO.result(userID, sessionID, problemID, code,"correct");
	    					resultDAO.resultTime(String.valueOf(result), upload_time);
	    					/* break; */
	    				}
	    				else{
	    					int result = 0;
	    					if(code_result == "compile"){
	    						result = resultDAO.result(userID, sessionID, problemID, code,"compile");
	    					}
	    					else{
	    						result = resultDAO.result(userID, sessionID, problemID, code,"wrong");
	    					}
	    					resultDAO.resultTime(String.valueOf(result), upload_time);
	    					/* break; */
	    				}
	    			}
	    		}
	    		
	    		br.close();
	   		}
	    }
	    
	    if(resultDAO.checkJob() == 1){//queue에 대기 중인 job이 있다
	    	resultDAO.changeQueue(container, resultDAO.minJob());//해당 job queue를 바꿔준다
	    }
	    else{
	    	resultDAO.changeState("FREE",container);// 다시 사용한 container 상태를 FREE로 바꿔줌
	    }
	    
	    ps.destroy();
	}
	
	
%><%=message%>