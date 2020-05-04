package user;

import java.sql.*;
import java.util.ArrayList;
import java.util.Calendar;

public class SessionDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	public SessionDAO() {
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
	      String SQL = "SELECT COUNT(userID) FROM SESSION WHERE userID = ?";
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
	
	public int howmany2(String userID, String sessionName) {
	      String SQL = "SELECT COUNT(problemID) FROM CONNECTION WHERE userID = ? AND sessionName = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionName);
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
	      String SQL = "SELECT COUNT(sessionName) FROM SESSION WHERE userID = ?";
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
	
	public int howmany4(String professorID, String sessionName) {
	      String SQL = "SELECT COUNT(userID) FROM APPLY WHERE professorID = ? AND sessionName = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, professorID);
	         pstmt.setString(2, sessionName);
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
	      String SQL = "SELECT userID, sessionName FROM SESSION WHERE userID = ?";
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
	
	public int[] keyinfo2(String userID, String sessionName, int result) {
	      String SQL = "SELECT problemID FROM CONNECTION WHERE userID = ? AND sessionName = ?";
	      int[] temp = new int[result];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionName);
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
	
	public int checkSession(String sessionID) {
	      String SQL = "SELECT EXISTS (SELECT * FROM SESSION WHERE sessionID = ?) as success";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, sessionID);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }

	      return -1;
	   }
	
	public int checkProblem(String userID, String sessionName, int problemID) {
	      String SQL = "SELECT EXISTS (SELECT * FROM CONNECTION WHERE userID = ? AND sessionName = ? AND problemID = ?) as success";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionName);
	         pstmt.setInt(3, problemID);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }

	      return -1;
	   }
	
	public String[] checkNames(String userID, int howmany) {
	      String SQL = "SELECT sessionName FROM SESSION WHERE userID = ?";
	      String temp[] = new String[howmany];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         rs = pstmt.executeQuery();
	         int i=0;
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
	
	public int checkResult(String userID, String sessionID, String problemID, String fin) {
	      String SQL = "SELECT EXISTS (SELECT * FROM RESULT WHERE userID = ? AND sessionID = ? AND problemID = ? AND final = ?) as success";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionID);
	         pstmt.setString(3, problemID);
	         pstmt.setString(4, fin);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }

	      return -1;
	   }
	
	public int existResult(String userID, String sessionID, String problemID) {
	      String SQL = "SELECT EXISTS (SELECT * FROM RESULT WHERE userID = ? AND sessionID = ? AND problemID = ?) as success";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionID);
	         pstmt.setString(3, problemID);
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
	
	public String[] seeSession2(String sessionID) {
	      String SQL = "SELECT * FROM SESSION WHERE sessionID = ?";
	      String temp[] = new String[5];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, sessionID);
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
	
	public String[] seeSessionTime(String sessionID) {
	      String SQL = "SELECT * FROM SESSION WHERE sessionID = ?";
	      String temp[] = new String[2];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, sessionID);
	         rs = pstmt.executeQuery();
	         
	         while(rs.next()) {
	        	 temp[0] = rs.getString(3);
	        	 temp[1] = rs.getString(4);
	         }
	         return temp;
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return null;
	   }
	
	public String[] seeproblem(int problemID) {
	      String SQL = "SELECT * FROM PROBLEM WHERE problemID = ?";
	      String temp[] = new String[4];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setInt(1, problemID);
	         rs = pstmt.executeQuery();
	         
	         while(rs.next()) {
	        	 temp[0] = Integer.toString(rs.getInt(1));
	        	 temp[1] = rs.getString(2);
	        	 temp[2] = rs.getString(3);
	        	 temp[3] = rs.getString(4);
	         }
	         return temp;
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return null;
	   }
	
	public String[] seeStudent(String professorID, String sessionName, int result) {
	      String SQL = "SELECT userID FROM APPLY WHERE professorID = ? AND sessionName = ?";
	      String temp[] = new String[result];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, professorID);
	         pstmt.setString(2, sessionName);
	         rs = pstmt.executeQuery();
	         int i=0;
	         while(rs.next()) {
	        	 temp[i]=rs.getString(1);
	        	 i++;
	         }
	         return temp;
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return null;
	   }
	
	public String seeResult(String userID, String sessionID, String problemID) {
		  String temp = new String();
	      String SQL = "SELECT final FROM RESULT WHERE userID = ? AND sessionID = ? AND problemID = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionID);
	         pstmt.setString(3, problemID);
	         rs = pstmt.executeQuery();
	         while(rs.next()) {
	        	 temp =rs.getString(1);
	         }
	         return temp;
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return null;
	   }
	
	public int insertSession(String userID, String sessionName, String openTime, String closeTime, String sessionID) {
	      String SQL = "INSERT INTO SESSION VALUES(?,?,?,?,?)";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionName);
	         pstmt.setString(3, openTime);
	         pstmt.setString(4, closeTime);
	         pstmt.setString(5, sessionID);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
	
	public int updateSession(String openTime, String closeTime, String userID ,String sessionName, String sessionID) {
		String SQL = "UPDATE SESSION SET openTime = ?, closeTime = ? WHERE userID = ? AND sessionName = ? AND sessionID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, openTime);
			pstmt.setString(2, closeTime);
			pstmt.setString(3, userID);
			pstmt.setString(4, sessionName);
			pstmt.setString(5, sessionID);		
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int deleteSession(String userID, String sessionName) {
	      String SQL = "DELETE FROM SESSION WHERE userID=? AND sessionName=?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionName);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
	
	public int deleteAllProblems(String userID, String sessionName) {
	      String SQL = "DELETE FROM CONNECTION WHERE userID=? AND sessionName=?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionName);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
	
	public int addProblem(String userID, String sessionName, int problemID) {
	      String SQL = "INSERT INTO CONNECTION VALUES(?,?,?)";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionName);
	         pstmt.setInt(3, problemID);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
	
	public int deleteProblem(String userID, String sessionName, int problemID) {
	      String SQL = "DELETE FROM CONNECTION WHERE userID=? AND sessionName=? AND problemID=?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionName);
	         pstmt.setInt(3, problemID);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }

}
