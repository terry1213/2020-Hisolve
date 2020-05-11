<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.io.*"%>
<%@ page import= "java.util.Arrays"%>
<%
   String uploadPath = request.getParameter("uploadPath");
   String finalFileName = "sampleProgram.tar";
   String temp = "";
   
   int listsize=0;
   
   File dir = new File(uploadPath);
   File[] fileList = dir.listFiles();
   String[] nameList = new String[fileList.length];
      
   for(int i = 0 ; i < fileList.length ; i++){
      File file = fileList[i];
      if(file.isFile()){
         String str = file.getName();
         if(!str.substring(str.length()-4,str.length()).equals(".tar") && !str.equals("problemContent.txt")){
            nameList[listsize] = str;
            listsize++;
         }
      }
   }
   
   Runtime rt = Runtime.getRuntime();
   Process p;
   String buildPath = uploadPath + "/build";
   
   for(int i=0;i<listsize;i++){
      p = rt.exec("mv "+ uploadPath +"/" + nameList[i]+ " " + buildPath);
      p.waitFor();
   }
   
   listsize=0;
   int listsize2=0;
   File dir2 = new File(buildPath);
   File[] fileList2 = dir2.listFiles();
   String[] finaltar = new String[fileList2.length];
   String[] shList = new String[fileList2.length];
      
   for(int i = 0 ; i < fileList2.length ; i++){
      File file = fileList2[i];
      if(file.isFile()){
         String str = file.getName();
         if(!str.substring(str.length()-4,str.length()).equals(".tar")){
            if(str.substring(str.length()-3,str.length()).equals(".sh")){
               shList[listsize] = str;
               listsize++;
            }
            finaltar[listsize2] = str;
            listsize2++;
         }
      }
   }
   
   for(int i=0;i<shList.length;i++){
      String[] shell = {"/bin/sh", "-c", "cd " + buildPath + " ; chmod +x " + shList[i]};
      p = rt.exec(shell);
      p.waitFor();
   }
   
   p = rt.exec("rm -r "+buildPath+"/sampleProgram.tar");
   p.waitFor();
   for(int i=0;i<finaltar.length;i++){
       temp += " ";
       temp += finaltar[i];
    }
    String[] shell = {"/bin/sh", "-c", "cd " + buildPath + " ; tar -cvf finalProgram.tar" + temp};
    p = rt.exec(shell);
    p.waitFor();
   
   
   
    /* Process p = rt.exec("rm -r "+uploadPath+"/sampleProgram.tar");
    p.waitFor();
    for(int i=0;i<fileList.length;i++){
       temp += " ";
       temp += fileList[i];
    }
    String[] shell = {"/bin/sh", "-c", "cd " + uploadPath + " ; tar -cvf sampleProgram.tar" + temp};
    p = rt.exec(shell);
    p.waitFor();*/
%>