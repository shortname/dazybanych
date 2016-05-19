package listaTowarow;

import org.junit.Before;
import org.junit.Test;
import utils.DBConnector;
import utils.SeleniumTest;

import java.util.Map;
import java.util.stream.Collectors;

public class ListaTowarowTest extends SeleniumTest{

    private DBConnector db;

    @Before
    public void init(){
        super.init();
        db = new DBConnector();
    }

    @Test
    public void shouldFindProducerNames(){
        //given
        Map<String, String> expected = db.findProductsWithProducerId().entrySet().stream().collect(Collectors.toMap(entry -> entry.getKey(), entry -> db.findProducer(entry.getValue())));
        findProducers().forEach(System.out::println);
        //when

    }



}
