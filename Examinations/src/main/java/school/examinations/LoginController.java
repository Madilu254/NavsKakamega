package school.examinations;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.stage.Stage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginController {

    @FXML private TextField user;
    @FXML private PasswordField pass;
    @FXML private Label error;

    @FXML
    public void handleRegister(ActionEvent event) throws IOException {

        Stage stage = (Stage)((Node)event.getSource()).getScene().getWindow();

        FXMLLoader loader = new FXMLLoader(getClass().getResource("Register.fxml"));
        Parent root = loader.load();

        stage.setScene(new Scene(root));
        stage.setTitle("Register Page");
        stage.show();
    }

    @FXML
    public void handleCancel(ActionEvent event) {

        user.clear();
        pass.clear();

        Connection conn = Connect.connection();

        if (conn != null) {
            error.setText("Database connected successfully!");
        } else {
            error.setText("Database connection failed!");
        }
    }

    @FXML
    public void handleLogin(ActionEvent event) throws SQLException, IOException {

        Connection con = Connect.connection();

        if (con == null) {
            error.setText("Database connection failed!");
            return;
        }

        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

        PreparedStatement pst = con.prepareStatement(sql);

        pst.setString(1, user.getText());
        pst.setString(2, pass.getText());

        ResultSet rs = pst.executeQuery();

        if (rs.next()) {

            Stage stage = (Stage)((Button)event.getSource()).getScene().getWindow();

            FXMLLoader loader = new FXMLLoader(getClass().getResource("StudentDetails.fxml"));
            Parent root = loader.load();

            stage.setScene(new Scene(root));
            stage.setTitle("Student Details");
            stage.show();

        } else {

            error.setText("Invalid username or password!");
        }

        con.close();
    }
}
