package utils;

import org.junit.Test;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DBConnector {

    Driver mysql;
    Connection connection;
    Statement statementA, statementB;

    private final static String USER = "root";
    private final static String PASSWORD = "admin";
    private final static String DB_URL = "jdbc:mysql://localhost:3306/sklepbd";

    public DBConnector(){
        try {
            mysql = new com.mysql.jdbc.Driver();
            DriverManager.registerDriver(mysql);
            connection = DriverManager.getConnection(DB_URL, USER, PASSWORD);
            statementA = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            statementB = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            reset();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Map<Integer, Integer> findProductsWithProducerId(){
        ResultSet wares = null;
        try {
            wares = executeA("SELECT * FROM produkty;");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        Map<Integer, Integer> result = new HashMap<>();
        try {
            while(wares.next()){
                Integer id = wares.getInt("id");
                Integer producerId = wares.getInt("idProducenta");
                result.put(id, producerId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public Map<Integer, Integer> findProductsWithAmount(){
        Map<Integer, Integer> result = new HashMap<>();
        try (
                ResultSet wares = executeA("SELECT * FROM produkty;");
                ResultSet amounts = executeB("SELECT * FROM zaopatrzenie;");
        ){
            while(wares.next()){
                int id = wares.getInt("id");
                int amount = 0;
                amounts.beforeFirst();
                while(amounts.next()){
                	if(amounts.getInt("idProduktu") == id){
                		amount += amounts.getInt("ilosc");
                	}
                }
                result.put(id, amount);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public Map<Integer, Integer> findProductsWithCategoryId(){
        ResultSet wares = null;
        try {
            wares = executeA("SELECT * FROM produkty;");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        Map<Integer, Integer> result = new HashMap<>();
        try {
            while(wares.next()){
                Integer id = wares.getInt("id");
                Integer categoryId = wares.getInt("idKategorii");
                result.put(id, categoryId);
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
            producers = executeA("SELECT * FROM producenci WHERE id="+id+";");
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
            producers = executeA("SELECT * FROM kategorie WHERE id="+id+";");
            producers.first();
            result = producers.getString("nazwaKategorii");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public ResultSet executeA(String query) throws SQLException {
        return statementA.executeQuery(query);
    }

    public ResultSet executeB(String query) throws SQLException {
        return statementB.executeQuery(query);
    }

    public void reset(){
        Path resetScript = Paths.get("").toAbsolutePath().getParent().getParent().resolve("Baza Danych/sklepDROP.sql");
        System.out.println(resetScript.toUri());
        List<String> queries = SimpleScriptSplitter.splitQueriesFromFile(resetScript);
        for(String query : queries){
            try {
                System.err.println(query);
                statementA.executeUpdate(query);
            } catch (SQLException e) {
                e.printStackTrace();
                System.exit(-1);
            }
        }
    }

}
