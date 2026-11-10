package school.examinations;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.ComboBox;
import javafx.scene.control.RadioButton;
import javafx.scene.control.ToggleGroup;

import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class StudentController implements Initializable {
    @FXML private RadioButton female;
    @FXML private RadioButton male;
    ToggleGroup gender = new ToggleGroup();
    @FXML private ComboBox yos;
    @FXML private ComboBox prog;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        female.setToggleGroup(gender);
        male.setToggleGroup(gender);
        Integer [] yosItems = {1, 2, 3, 4, 5, 6};
        ObservableList<Integer> yosList = FXCollections.observableArrayList(yosItems);
        yos.setItems(yosList);

        ObservableList<String> progItems = FXCollections.observableArrayList();
        Connection conn = Connect.connection();
        String sqlProgs = "SELECT pcode, pname FROM programme";
        try {
            PreparedStatement pstProgs = conn.prepareStatement(sqlProgs);
            ResultSet rsProgs = pstProgs.executeQuery();
            while(rsProgs.next()) {
                progItems.add(rsProgs.getString("pcode") +  " | " + rsProgs.getString("pname"));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        prog.setItems(progItems);

    }
}
