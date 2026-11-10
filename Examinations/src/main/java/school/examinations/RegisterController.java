package school.examinations;

import javafx.animation.PauseTransition;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

import java.io.IOException;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;
import java.util.regex.Pattern;

public class RegisterController implements Initializable {

    @FXML private TextField fname;
    @FXML private TextField lname;
    @FXML private TextField email;
    @FXML private TextField username;
    @FXML private TextField password;
    @FXML private TextField confirm;
    @FXML private Label emailError;

    private static final String EMAIL_REGEX =
            "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    private static final Pattern EMAIL_PATTERN = Pattern.compile(EMAIL_REGEX);

    @FXML
    public void handleRegister(ActionEvent event) throws SQLException, IOException {

        if (!password.getText().equals(confirm.getText())) {
            showAlert(Alert.AlertType.ERROR, "Passwords do not match!");
            return;
        }

        if (!validateEmail(email.getText())) {
            showAlert(Alert.AlertType.ERROR, "Invalid email address!");
            return;
        }

        Connection con = Connect.connection();

        if (con == null) {
            showAlert(Alert.AlertType.ERROR, "Database connection failed!");
            return;
        }

        String checkUser = "SELECT * FROM users WHERE username = ?";
        PreparedStatement checkStmt = con.prepareStatement(checkUser);
        checkStmt.setString(1, username.getText());

        ResultSet rs = checkStmt.executeQuery();

        if (rs.next()) {
            showAlert(Alert.AlertType.ERROR, "Username already exists!");
            return;
        }

        String sql = "INSERT INTO users (fname, lname, email, username, password) VALUES (?, ?, ?, ?, ?)";

        PreparedStatement pst = con.prepareStatement(sql);

        pst.setString(1, fname.getText());
        pst.setString(2, lname.getText());
        pst.setString(3, email.getText());
        pst.setString(4, username.getText());
        pst.setString(5, password.getText());

        int result = pst.executeUpdate();

        if (result > 0) {

            showAlert(Alert.AlertType.INFORMATION, "Registration successful!");

            Stage stage = (Stage)((Button)event.getSource()).getScene().getWindow();

            FXMLLoader loader = new FXMLLoader(getClass().getResource("Login.fxml"));
            Parent root = loader.load();

            stage.setScene(new Scene(root));
            stage.setTitle("Login Page");
            stage.show();

        } else {
            showAlert(Alert.AlertType.ERROR, "Failed to register user!");
        }

        con.close();
    }

    private void showAlert(Alert.AlertType type, String message) {

        Alert alert = new Alert(type);

        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.show();

        PauseTransition delay = new PauseTransition(javafx.util.Duration.seconds(3));
        delay.setOnFinished(e -> alert.close());
        delay.play();
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {

        email.textProperty().addListener((observable, oldValue, newValue) -> {

            if (newValue == null || newValue.isEmpty()) {

                emailError.setText("");

            } else if (validateEmail(newValue)) {

                emailError.setText("Valid email address!");
                emailError.setStyle("-fx-text-fill: green;");

            } else {

                emailError.setText("Invalid email format.");
                emailError.setStyle("-fx-text-fill: red;");
            }
        });
    }

    private boolean validateEmail(String email) {
        return EMAIL_PATTERN.matcher(email).matches();
    }
}
