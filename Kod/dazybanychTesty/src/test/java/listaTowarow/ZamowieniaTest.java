package listaTowarow;

import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;
import utils.DBConnector;
import utils.SeleniumTest;

public class ZamowieniaTest extends SeleniumTest {

    private DBConnector db;

    @BeforeClass
    public void init(){
        super.init();
        db = new DBConnector();
        getTo("/");
    }

    @Test
    public void shouldCreateOrder(){
        typeOrderAmount(2, 10);
    }
}
