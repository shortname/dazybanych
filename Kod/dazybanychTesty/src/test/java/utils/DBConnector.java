package utils;

import java.sql.*;
import java.math.*;
import java.util.HashMap;
import java.util.Map;

public class DBConnector {

    Driver mysql;
    Connection connection;
    Statement statement;

    private final static String USER = "root";
    private final static String PASSWORD = "admin";
    private final static String DB_URL = "jdbc:mysql://localhost:3306/sklepbd";

    public DBConnector(){
        try {
            mysql = new com.mysql.jdbc.Driver();
            DriverManager.registerDriver(mysql);
            connection = DriverManager.getConnection(DB_URL, USER, PASSWORD);
            statement = connection.createStatement();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Map<String, Integer> findProductsWithProducerId(){
        ResultSet wares = null;
        try {
            wares = execute("SELECT * FROM produkty;");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        Map<String, Integer> result = new HashMap<>();
        try {
            while(wares.next()){
                String name = wares.getString("nazwa");
                Integer producerId = wares.getInt("idProducenta");
                result.put(name, producerId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public Map<String, Integer> findProductsWithCategoryId(){
        ResultSet wares = null;
        try {
            wares = execute("SELECT * FROM produkty;");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        Map<String, Integer> result = new HashMap<>();
        try {
            while(wares.next()){
                String name = wares.getString("nazwa");
                Integer categoryId = wares.getInt("idKategorii");
                result.put(name, categoryId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public String findProducer(int id){
        ResultSet producers = null;
        String result = null;
        try {
            producers = execute("SELECT * FROM producenci WHERE id="+id+";");
            producers.first();
            result = producers.getString("nazwaProducenta");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public String findCategory(int id){
        ResultSet producers = null;
        String result = null;
        try {
            producers = execute("SELECT * FROM kategorie WHERE id="+id+";");
            producers.first();
            result = producers.getString("nazwaKategorii");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public ResultSet execute(String query) throws SQLException {
        return statement.executeQuery(query);
    }

}
