package listaTowarow;

import org.assertj.core.api.Assertions;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;
import utils.DBConnector;
import utils.SeleniumTest;

import java.util.Map;
import java.util.stream.Collectors;

public class ListaTowarowTest extends SeleniumTest{

    private DBConnector db;

    @BeforeClass
    public void init(){
        super.init();
        db = new DBConnector();
        db.reset();
        getTo("/");
    }

    @Test()
    public void shouldFindProducerNames(){
        //given
        Map<Integer, String> expected = db.findProductsWithProducerId().entrySet().stream().collect(Collectors.toMap(entry -> entry.getKey(), entry -> db.findProducer(entry.getValue())));
        
        //when
        for(Map.Entry<Integer, String> entry : expected.entrySet()){
        	Assertions.assertThat(findProducer(entry.getKey())).isEqualTo(entry.getValue());
        }
    }
    
    @Test
    public void shouldFindCategoryNames(){
        //given
        Map<Integer, String> expected = db.findProductsWithCategoryId().entrySet().stream().collect(Collectors.toMap(entry -> entry.getKey(), entry -> db.findCategory(entry.getValue())));
        
        //when
        for(Map.Entry<Integer, String> entry : expected.entrySet()){
        	Assertions.assertThat(findCategory(entry.getKey())).isEqualTo(entry.getValue());
        }
    }
    
    @Test
    public void shouldFindAmounts(){
        //given
        Map<Integer, Integer> expected = db.findProductsWithAmount();
        
        //when
        for(Map.Entry<Integer, Integer> entry : expected.entrySet()){
            if(entry.getValue() == 0)
                Assertions.assertThat(findAmount(entry.getKey())).isEqualTo("Brak towaru!");
            else
        	    Assertions.assertThat(findAmount(entry.getKey())).isEqualTo(entry.getValue().toString());
        }
    }



}
