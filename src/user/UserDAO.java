package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class UserDAO {

		private Connection conn;
		private PreparedStatement pstmt;
		private ResultSet rs;
		
		public UserDAO() {
			try {
				String dbURL = "jdbc:mysql://localhost:3306/AJAX";
				String dbID = "root";
				String dbPassword = "root";
				Class.forName("com.mysql.jdbc.Driver");
				conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
				
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		public ArrayList<User> search(String userName){ // db�� ����Ǿ��ִ� ȸ�������� ������
			String SQL = "SELECT * FROM USER WHERE userName LIKE ?"; // LIKE �����ؼ�
			ArrayList<User> userList = new ArrayList<User>(); // userList ����
			try {
				pstmt = conn.prepareStatement(SQL); // pstmt�� ���� sql���� ����
				pstmt.setString(1, "%" + userName + "%"); // ?�� �� ����, �� ���� "%" : Ư���� ������ ����� ������ ��� ��� ���
				rs = pstmt.executeQuery(); // rs�� �������� ����
				while(rs.next()) { // ����� �ϳ��� �а� userList�� ������ ����
					User user = new User(); // user ����
					user.setUserName(rs.getString(1));
					user.setUserAge(rs.getInt(2));
					user.setUserGender(rs.getString(3));
					user.setUserEmail(rs.getString(4));
					userList.add(user); // userList�� �߰�
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return userList;
		}
		
		public int register(User user) {
			String SQL = "INSERT INTO USER VALUES(?, ?, ?, ?)";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, user.getUserName());
				pstmt.setInt(2, user.getUserAge());
				pstmt.setString(3, user.getUserGender());
				pstmt.setString(4, user.getUserEmail());
				return pstmt.executeUpdate();				
			}catch(Exception e){
				e.printStackTrace();
			}
			return -1; // �����ͺ��̽� ����
		}
}