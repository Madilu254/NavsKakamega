package school.examinations;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Connect {

    public static Connection connection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String url = System.getenv().getOrDefault(
                    "DB_URL", "jdbc:mysql://localhost:3306/studentperformance");
            String user = System.getenv().getOrDefault("DB_USER", "root");
            String password = System.getenv("DB_PASSWORD");
            if (password == null || password.isBlank()) {
                System.err.println("DB_PASSWORD environment variable is required.");
                return null;
            }

            Connection con = DriverManager.getConnection(url, user, password);
            System.out.println("Database connected successfully!");

            return con;

        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found.");
            e.printStackTrace();

        } catch (SQLException e) {
            System.out.println("Failed to connect to database.");
            e.printStackTrace();
        }

        return null;
    }
}
