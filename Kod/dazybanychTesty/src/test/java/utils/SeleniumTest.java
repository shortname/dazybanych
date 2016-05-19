package utils;

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
    private static final String BASE_URL = "http://localhost/";

    @Before
    public void init(){
        webDriver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS);
    }

    protected List<String> findNames(){
        webDriver.get(BASE_URL);
        return webDriver.findElements(By.id("nazwa")).stream().map(WebElement::getText).collect(Collectors.toList());
    }

    protected Map<String, String> findProducers(String name){
        webDriver.get(BASE_URL);
        webDriver.findElements(By.xpath(""))
    }

    protected List<String> findProducers(){
        webDriver.get(BASE_URL);
        return webDriver.findElements(By.id("producent")).stream().map(WebElement::getText).collect(Collectors.toList());
    }

}
