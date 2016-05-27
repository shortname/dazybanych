package listaTowarow;

import org.assertj.core.api.Assertions;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;
import utils.*;

import java.util.*;

public class ZamowieniaTest extends SeleniumTest {

    private DBConnector db;
    private Map<Integer, Integer> firstOrder;
    private Map<Integer, Integer> secondOrder;

    @BeforeClass
    public void init(){
        super.init();
        db = new DBConnector();
        firstOrder = new HashMap<>();
        firstOrder.put(12, 236);
        firstOrder.put(13, 10);
        firstOrder.put(2, 44);
        firstOrder.put(4, 1);
        secondOrder = new HashMap<>();
        secondOrder.put(23, 6);
        secondOrder.put(27, 100);
    }

    @Test
    public void shouldCreateTwoOrdersAndUpdateStorageData(){
        //given
        List<Order> expectedOrders = createExpectedOrders();
        List<OrderDetails> expectedFirstOrderDetails = createExpectedFirstOrderDetails();
        List<OrderDetails> expectedSecondOrderDetails = createExpectedSecondOrderDetails();
        List<StorageData> storageDataBefore = db.findStorageDataOfProducts(Arrays.asList(2, 4, 12, 13, 23, 27));

        //when
        createFirstOrder();
        createSecondOrder();

        //then
        List<Order> actualOrders = db.findOrders();
        Assertions.assertThat(actualOrders).containsOnlyElementsOf(expectedOrders);
        Assertions.assertThat(db.findOrderDetails(actualOrders.get(0).getId())).containsOnlyElementsOf(expectedFirstOrderDetails);
        Assertions.assertThat(db.findOrderDetails(actualOrders.get(1).getId())).containsOnlyElementsOf(expectedSecondOrderDetails);
    }
    
    private void createOrder(List<OrderDetails> details){
        getTo("/");
        details.stream().forEach(detail -> typeOrderAmount(detail.getIdProduktu(), detail.getIlosc()));
        clickZamow();
    }

    private void createFirstOrder(){
        getTo("/");
        typeOrderAmount(12, 236);
        typeOrderAmount(13, 10);
        typeOrderAmount(2, 44);
        typeOrderAmount(4, 1);
        clickZamow();
    }

    private void createSecondOrder(){
        getTo("/");
        typeOrderAmount(23, 6);
        typeOrderAmount(27, 100);
        clickZamow();
    }

    private List<Order> createExpectedOrders(){
        List<Order> result = new ArrayList<>();
        result.add(new Order(0, 1, "S"));
        result.add(new Order(0, 1, "S"));
        return result;
    }

    private List<OrderDetails> createExpectedFirstOrderDetails(){
        List<OrderDetails> result = new ArrayList<>();
        result.add(new OrderDetails(1, 2, 44));
        result.add(new OrderDetails(1, 4, 1));
        result.add(new OrderDetails(2, 12, 234));
        result.add(new OrderDetails(1, 12, 2));
        result.add(new OrderDetails(1, 13, 10));
        return result;
    }

    private List<OrderDetails> createExpectedSecondOrderDetails(){
        List<OrderDetails> result = new ArrayList<>();
        result.add(new OrderDetails(2, 23, 6));
        result.add(new OrderDetails(3, 27, 100));
        return result;
    }

}
