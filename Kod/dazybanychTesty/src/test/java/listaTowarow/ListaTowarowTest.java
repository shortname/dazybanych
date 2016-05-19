package listaTowarow;

import org.assertj.core.api.Assertions;
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
        getTo("/");
    }

    @Test
    public void shouldFindProducerNames(){
        //given
        Map<String, String> expected = db.findProductsWithProducerId().entrySet().stream().collect(Collectors.toMap(entry -> entry.getKey(), entry -> db.findProducer(entry.getValue())));
        
        //when
        for(Map.Entry<String, String> entry : expected.entrySet()){
        	Assertions.assertThat(findProducers(entry.getKey())).contains(entry.getValue());
        }
    }
    
    @Test
    public void shouldFindCategoryNames(){
        //given
        Map<String, String> expected = db.findProductsWithCategoryId().entrySet().stream().collect(Collectors.toMap(entry -> entry.getKey(), entry -> db.findCategory(entry.getValue())));
        
        //when
        for(Map.Entry<String, String> entry : expected.entrySet()){
        	Assertions.assertThat(findCategories(entry.getKey())).contains(entry.getValue());
        }
    }



}
