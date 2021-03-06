package utils;

import org.assertj.core.util.Strings;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.*;
import java.util.*;
import java.util.function.BiPredicate;

public class DBConnector {

    Driver mysql;
    Connection connection;
    Statement statementA, statementB;

    private final static String USER = "root";
    private final static String PASSWORD = "admin";
    private final static String DB_URL = "jdbc:mysql://localhost:3306/sklepbd?characterEncoding=utf8";

    public DBConnector(){
        try {
            mysql = new com.mysql.jdbc.Driver();
            DriverManager.registerDriver(mysql);
            connection = DriverManager.getConnection(DB_URL, USER, PASSWORD);
            statementA = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            statementB = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
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

    public List<Order> findOrders(){
        List<Order> result = new ArrayList<>();
        ResultSet orders = null;
        try {
            orders = executeA("SELECT * FROM zamowienia;");
            while(orders.next()){
                Order order = new Order(orders.getInt("id"), orders.getInt("idKlienta"), orders.getString("status"));
                result.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<OrderDetails> findOrderDetails(int orderId){
        List<OrderDetails> result = new ArrayList<>();
        ResultSet orders = null;
        try {
            orders = executeA("SELECT * FROM zamowienia_produkty WHERE idZamowienia = " + orderId + ";");
            while(orders.next()){
                OrderDetails orderDetails = new OrderDetails(orders.getInt("idMagazynu"), orders.getInt("idProduktu"), orders.getInt("ilosc"));
                result.add(orderDetails);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public StorageDataStore findStorageDataOfProducts(List<Integer> ids){
            StorageDataStore  result = new StorageDataStore();
            String set = Strings.join(ids).with(",");
            ResultSet records = null;
        try {
            records = executeA("SELECT * FROM zaopatrzenie WHERE FIND_IN_SET(idProduktu, '" + set + "') > 0;");
            while(records.next()){
                StorageData storageData = new StorageData(records.getInt("id"), records.getInt("idMagazynu"), records.getInt("idProduktu"), records.getInt("ilosc"));
                result.add(storageData);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Integer> findRowsForCategories(List<Integer> categoryIds){
        ResultSet wares = null;
        try {
            wares = executeA("SELECT idProduktu, idKategorii FROM lista_towarow;");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        Set<Integer> result = new HashSet<>();
        try {
            while(wares.next()){
                if(categoryIds.contains(wares.getInt("idKategorii")))
                    result.add(wares.getInt("idProduktu"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new ArrayList<>(result);
    }

    public List<Integer> findRowsForProducers(List<Integer> producerIds){
        ResultSet wares = null;
        try {
            wares = executeA("SELECT idProduktu, idProducenta FROM lista_towarow;");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        Set<Integer> result = new HashSet<>();
        try {
            while(wares.next()){
                if(producerIds.contains(wares.getInt("idProducenta")))
                    result.add(wares.getInt("idProduktu"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new ArrayList<>(result);
    }

    public List<Integer> findRowsForCategoriesAndProducers(List<Integer> categoryIds, List<Integer> producerIds){
        ResultSet wares = null;
        try {
            wares = executeA("SELECT idProduktu, idProducenta, idKategorii FROM lista_towarow;");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        Set<Integer> result = new HashSet<>();
        try {
            while(wares.next()){
                if(categoryIds.contains(wares.getInt("idKategorii")) && producerIds.contains(wares.getInt("idProducenta")))
                    result.add(wares.getInt("idProduktu"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new ArrayList<>(result);
    }

    public List<Integer> findAllRows(){
        ResultSet wares = null;
        try {
            wares = executeA("SELECT idProduktu FROM lista_towarow;");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        Set<Integer> result = new HashSet<>();
        try {
            while(wares.next()){
                result.add(wares.getInt("idProduktu"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new ArrayList<>(result);
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
                System.err.println("#");
                statementA.executeUpdate(query);
            } catch (SQLException e) {
                e.printStackTrace();
                System.exit(-1);
            }
        }
    }

}
