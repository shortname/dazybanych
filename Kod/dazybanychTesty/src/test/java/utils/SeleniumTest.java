package utils;

import org.junit.After;
import org.junit.Before;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

public class SeleniumTest {

    private WebDriver webDriver = new FirefoxDriver();
    private static final String BASE_URL = "http://localhost";

    @BeforeClass
    public void init(){
        webDriver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS);
    }
    
    protected void getTo(String path){
    	webDriver.get(BASE_URL + path);
    }

    protected String findProducer(int id){
        return webDriver.findElement(By.xpath("//tr[@id='" +id+ "']/td[@id='producent']")).getText();
    }
    
    protected String findCategory(int id){
        return webDriver.findElement(By.xpath("//tr[@id='" +id+ "']/td[@id='kategoria']")).getText();
    }
    
    protected String findAmount(int id){
        return webDriver.findElement(By.xpath("//tr[@id='" +id+ "']/td[@id='ilosc']")).getText();
    }

    protected void typeOrderAmount(int id, int amount){
        WebElement field = webDriver.findElement(By.xpath("//tr[@id='" +id+ "']//input[@id='order']"));
        field.clear();
        field.sendKeys("" + amount);
    }
    
    @AfterClass
    public void finish(){
    	webDriver.close();
    }

}
