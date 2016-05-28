package listaTowarow;

import org.assertj.core.api.Assertions;
import org.junit.Before;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;
import utils.DBConnector;
import utils.SeleniumTest;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class ListaTowarowTest extends SeleniumTest{

    private DBConnector db;

    @BeforeClass
    public void init(){
        super.init();
        db = new DBConnector();
        db.reset();
    }

    @BeforeMethod
    public void setUp(){
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

    @Test
    public void shouldFilterProducers(){
        List<Integer> producerIds = Arrays.asList(1, 3, 7);
        List<Integer> expectedProducts = db.findRowsForProducers(producerIds);
        producerIds.forEach(id -> checkProducer(id));
        filter();
        waitForFilter();

        Assertions.assertThat(findShownRows()).containsOnlyElementsOf(expectedProducts);
    }

    @Test
    public void shouldFilterCategories(){
        List<Integer> categoryIds = Arrays.asList(1, 3);
        List<Integer> expectedProducts = db.findRowsForCategories(categoryIds);
        categoryIds.forEach(id -> checkCategory(id));
        filter();
        waitForFilter();

        Assertions.assertThat(findShownRows()).containsOnlyElementsOf(expectedProducts);
    }

    @Test
    public void shouldFilterCategoriesAndProducers(){
        List<Integer> producerIds = Arrays.asList(1, 3, 7);
        List<Integer> categoryIds = Arrays.asList(1, 3);
        List<Integer> expectedProducts = db.findRowsForCategoriesAndProducers(categoryIds, producerIds);
        producerIds.forEach(id -> checkProducer(id));
        categoryIds.forEach(id -> checkCategory(id));
        filter();
        waitForFilter();

        Assertions.assertThat(findShownRows()).containsOnlyElementsOf(expectedProducts);
    }

    @Test
    public void shouldFilterEverything(){
        List<Integer> expectedProducts = db.findAllRows();
        filter();
        waitForFilter();

        Assertions.assertThat(findShownRows()).containsOnlyElementsOf(expectedProducts);
    }

}
