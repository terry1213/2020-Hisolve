package user;

import java.sql.*;
import java.util.ArrayList;
import java.util.Calendar;

public class ResultDAO {
   private Connection conn;
   private PreparedStatement pstmt;
   private ResultSet rs;
   
   public ResultDAO() {
      try {
         String dbURL = "jdbc:mysql://localhost:3306/FALCON?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
         String dbID = "falcon";
         String dbPassword="falcon";
         Class.forName("com.mysql.cj.jdbc.Driver");
         conn = DriverManager.getConnection(dbURL,dbID,dbPassword);
      } catch (Exception e) {
         e.printStackTrace();
      }
   }
   
   public int insertclass(String userID, String className, String classNumber, String start, String finish) {
	      String SQL = "INSERT INTO CLASS VALUES(?,?,?,?,?)";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, className);
	         pstmt.setString(3, classNumber);
	         pstmt.setString(4, start);
	         pstmt.setString(5, finish);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int registerclass(String userID, String className, String classNumber) {
	      String SQL = "INSERT INTO APPLYCLASS VALUES(?,?,?)";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, className);
	         pstmt.setString(3, classNumber);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }  
   
   public String[] seeclass(String className, String classNumber) {
	      String SQL = "SELECT * FROM CLASS WHERE className = ? AND classNumber = ?";
	      String temp[] = new String[5];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, className);
	         pstmt.setString(2, classNumber);
	         rs = pstmt.executeQuery();
	         
	         while(rs.next()) {
	        	 temp[0] = rs.getString(1);
	        	 temp[1] = rs.getString(2);
	        	 temp[2] = rs.getString(3);
	        	 temp[3] = rs.getString(4);
	        	 temp[4] = rs.getString(5);
	         }
	         return temp;
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return null;
	   }
   
   public String[][] listclass(int result) {
	      String SQL = "SELECT * FROM CLASS";
	      String temp[][] = new String[result][5];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         rs = pstmt.executeQuery();
	         
	         int i=0;
	         while(rs.next()) {
	        	 temp[i][0] = rs.getString(1);
	        	 temp[i][1] = rs.getString(2);
	        	 temp[i][2] = rs.getString(3);
	        	 temp[i][3] = rs.getString(4);
	        	 temp[i][4] = rs.getString(5);
	        	 i++;
	         }
	         return temp;
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return null;
	   }
   
   public String[] seeproblem(int problemID) {
	      String SQL = "SELECT * FROM PROBLEM WHERE problemID = ?";
	      String temp[] = new String[7];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setInt(1, problemID);
	         rs = pstmt.executeQuery();
	         
	         while(rs.next()) {
	        	 temp[0] = Integer.toString(rs.getInt(1));
	        	 temp[1] = rs.getString(2);
	        	 temp[2] = rs.getString(3);
	        	 temp[3] = rs.getString(4);
	        	 temp[4] = rs.getString(5);
	        	 temp[5] = rs.getString(6);
	        	 temp[6] = rs.getString(7);
	         }
	         return temp;
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return null;
	   }
   
   public int countall() {
	      String SQL = "SELECT COUNT(*) FROM CLASS";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int howmany(String userID) {
	      String SQL = "SELECT COUNT(userID) FROM CLASS WHERE userID = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int howmany2(String userID, String className, String classNumber) {
	      String SQL = "SELECT COUNT(userID) FROM PROBLEM WHERE userID = ? AND className = ? AND classNumber = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, className);
	         pstmt.setString(3, classNumber);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int howmany3(String userID) {
	      String SQL = "SELECT COUNT(className) FROM APPLYCLASS WHERE userID = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public String[][] keyinfo(String userID, int result) {
	      String SQL = "SELECT className, classNumber FROM CLASS WHERE userID = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         rs = pstmt.executeQuery();
	         
	         String[][] temp = new String[result][2];
	         int i=0;
	         while(rs.next()) {
	        	 temp[i][0] = rs.getString(1);
	        	 temp[i][1] = rs.getString(2);
	        	 i++;
	         }

			return temp;
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return null;
	   }
   
   	public int[] keyinfo2(String userID, String className, String classNumber, int result) {
	      String SQL = "SELECT problemID FROM PROBLEM WHERE userID = ? AND className = ? AND classNumber = ?";
	      int[] temp = new int[result];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, className);
	         pstmt.setString(3, classNumber);
	         rs = pstmt.executeQuery();
	         int i=0;
	         while(rs.next()) {
	        	 temp[i] = rs.getInt(1);
	        	 i++;
	         }
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return temp;
	   }
   
   	public String[][] keyinfo3(String userID, int result) {
	      String SQL = "SELECT className, classNumber FROM APPLYCLASS WHERE userID = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         rs = pstmt.executeQuery();
	         
	         String[][] temp = new String[result][2];
	         int i=0;
	         while(rs.next()) {
	        	 temp[i][0] = rs.getString(1);
	        	 temp[i][1] = rs.getString(2);
	        	 i++;
	         }

			return temp;
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return null;
	   }
   	
   public int deleteSession(String userID, String className, String classNumber) {
	      String SQL = "DELETE FROM CLASS WHERE userID=? AND className=? AND classNumber=?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, className);
	         pstmt.setString(3, classNumber);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   
   
   public int deleteAllProblems(String userID, String className, String classNumber) {
	      String SQL = "DELETE FROM PROBLEM WHERE userID=? AND className=? AND classNumber=?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, className);
	         pstmt.setString(3, classNumber);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }

   public int result(String userID, String fileName, String fin) {
	  Calendar calendar = Calendar.getInstance();
	  java.sql.Timestamp ourJavaTimestampObject = new java.sql.Timestamp(calendar.getTime().getTime());
      String SQL = "INSERT INTO RESULT VALUES(?,?,?,?)";
      try {
         pstmt = conn.prepareStatement(SQL);
         pstmt.setString(1, userID);
         pstmt.setString(2, fileName);
         pstmt.setString(3, fin);
         pstmt.setTimestamp(4, ourJavaTimestampObject);
         return pstmt.executeUpdate();
      } catch (Exception e) {
         e.printStackTrace();
      }
      return -1;
   }
   
   public int checkResult(String userID, String fileName) {
	      String SQL = "SELECT EXISTS (SELECT * FROM RESULT WHERE userID = ? AND fileName = ?) as success";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, fileName);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }

   public int deleteResult(String userID, String fileName) {
	      String SQL = "DELETE FROM RESULT WHERE userID=? AND fileName=?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, fileName);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
}
