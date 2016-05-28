package listaTowarow;

import org.assertj.core.api.Assertions;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;
import utils.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ZamowieniaTest extends SeleniumTest {

    private DBConnector db;
    private Map<Integer, Integer> firstOrder;
    private Map<Integer, Integer> secondOrder;
    private StorageDataStore storageDataStore;
    private List<Integer> productIds;

    @BeforeClass
    public void init(){
        super.init();
        db = new DBConnector();
        db.reset();
        firstOrder = new HashMap<>();
        firstOrder.put(12, 236);
        firstOrder.put(13, 10);
        firstOrder.put(2, 44);
        firstOrder.put(4, 1);
        secondOrder = new HashMap<>();
        secondOrder.put(23, 6);
        secondOrder.put(27, 100);
        productIds = new ArrayList<>(firstOrder.keySet());
        productIds.addAll(secondOrder.keySet());
        storageDataStore = db.findStorageDataOfProducts(productIds);
    }

    @Test
    public void shouldCreateTwoOrdersAndUpdateStorageData(){
        //given
        List<Order> expectedOrders = createExpectedOrders();
        List<OrderDetails> expectedFirstOrderDetails = createExpectedOrder(firstOrder, 1);
        List<OrderDetails> expectedSecondOrderDetails = createExpectedOrder(secondOrder, 2);

        //when
        order(firstOrder);
        order(secondOrder);

        //then
        List<Order> actualOrders = db.findOrders();
        Assertions.assertThat(actualOrders).containsOnlyElementsOf(expectedOrders);
        Assertions.assertThat(db.findOrderDetails(actualOrders.get(0).getId())).containsOnlyElementsOf(expectedFirstOrderDetails);
        Assertions.assertThat(db.findOrderDetails(actualOrders.get(1).getId())).containsOnlyElementsOf(expectedSecondOrderDetails);
        Assertions.assertThat(db.findStorageDataOfProducts(productIds).getStorageData()).containsOnlyElementsOf(storageDataStore.getStorageData());
    }
    
    private void order(Map<Integer, Integer> details){
        getTo("/");
        details.entrySet().stream().forEach(detail -> typeOrderAmount(detail.getKey(), detail.getValue()));
        clickZamow();
    }

    private List<OrderDetails> createExpectedOrder(Map<Integer, Integer> details, int orderId){
        List<OrderDetails> result = new ArrayList<>();
        details.entrySet().stream().forEach(detail -> result.addAll(storageDataStore.realizeOrder(detail.getKey(), detail.getValue(), orderId)));
        return result;
    }

    private List<Order> createExpectedOrders(){
        List<Order> result = new ArrayList<>();
        result.add(new Order(0, 1, "S"));
        result.add(new Order(0, 1, "S"));
        return result;
    }

    private List<OrderDetails> createExpectedSecondOrderDetails(){
        List<OrderDetails> result = new ArrayList<>();
        result.add(new OrderDetails(2, 23, 6));
        result.add(new OrderDetails(3, 27, 100));
        return result;
    }

}
