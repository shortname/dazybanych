package utils;

import org.junit.After;
import org.junit.Before;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

public class SeleniumTest {

    private WebDriver webDriver = new FirefoxDriver();
    private static final String BASE_URL = "http://localhost";

    @Before
    public void init(){
        webDriver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS);
    }
    
    protected void getTo(String path){
    	webDriver.get(BASE_URL + path);
    }

    protected List<String> findNames(){
        return webDriver.findElements(By.id("nazwa")).stream().map(WebElement::getText).collect(Collectors.toList());
    }

    protected List<String> findProducers(String name){
        return webDriver.findElements(By.xpath("//*[contains(span, '" +name+ "')]/../td[@id='producent']")).stream().map(we -> we.getText()).collect(Collectors.toList());
    }

    protected List<String> findProducers(){
        return webDriver.findElements(By.id("producent")).stream().map(WebElement::getText).collect(Collectors.toList());
    }
    
    @After
    public void finish(){
    	webDriver.close();
    }

}
