package user;

import java.sql.*;
import java.util.Calendar;

public class StudentDAO {
   private Connection conn;
   private PreparedStatement pstmt;
   private ResultSet rs;
   
   public StudentDAO() {
      try {
    	 String dbURL = "jdbc:mysql://localhost:3306/FALCON?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC&characterEncoding=utf8";
         String dbID = "falcon";
         String dbPassword="falcon";
         Class.forName("com.mysql.cj.jdbc.Driver");
         conn = DriverManager.getConnection(dbURL,dbID,dbPassword);
      } catch (Exception e) {
         e.printStackTrace();
      }
   }
   
   public int howmany(String userID) {
	      String SQL = "SELECT COUNT(sessionName) FROM APPLY WHERE userID = ?";
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
	      String SQL = "SELECT professorID, sessionName FROM APPLY WHERE userID = ?";
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
   
   public int countall() {
	      String SQL = "SELECT COUNT(*) FROM SESSION";
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
   
   public String[] seeSession(String userID, String sessionName) {
	      String SQL = "SELECT * FROM SESSION WHERE userID = ? AND sessionName = ?";
	      String temp[] = new String[5];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionName);
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
   
   public String[] seeSessionID(int all) {
	      String SQL = "SELECT sessionID FROM SESSION";
	      String temp[] = new String[all];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         rs = pstmt.executeQuery();
	         int i = 0;
	         while(rs.next()) {
	        	 temp[i] = rs.getString(1);
	        	 i++;
	         }
	         return temp;
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return null;
	   }
   
   public String[] useSessionID(String sessionID) {
	      String SQL = "SELECT userID, sessionName FROM SESSION WHERE sessionID = ?";
	      try {
		         pstmt = conn.prepareStatement(SQL);
		         pstmt.setString(1, sessionID);
		         rs = pstmt.executeQuery();
		         
		         String[] temp = new String[2];
		         while(rs.next()) {
		        	 temp[0] = rs.getString(1);
		        	 temp[1] = rs.getString(2);
		         }
				return temp;
		      } catch (Exception e) {
		         e.printStackTrace();
		      }
		      return null;
	   }
   
   public int registerSession(String userID, String professorID, String sessionName) {
	      String SQL = "INSERT INTO APPLY VALUES(?,?,?)";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, professorID);
	         pstmt.setString(3, sessionName);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
 
}
