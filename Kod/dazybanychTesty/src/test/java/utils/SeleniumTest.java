package utils;

import org.assertj.core.internal.Integers;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;

import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

public class SeleniumTest {

    private WebDriver webDriver = new FirefoxDriver();
    private WebDriverWait webDriverWait = new WebDriverWait(webDriver, 30L, 10000L);
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

    protected void clickZamow(){
        WebElement button = webDriver.findElement(By.id("orderButton"));
        button.click();
    }

    protected void checkProducer(int id){
        WebElement checkbox = webDriver.findElement(By.id("pro"+id));
        checkbox.click();
    }

    protected void checkCategory(int id){
        WebElement checkbox = webDriver.findElement(By.id("cat"+id));
        checkbox.click();
    }

    protected void filter(){
        WebElement checkbox = webDriver.findElement(By.id("filterButton"));
        checkbox.click();
    }

    protected void waitForFilter(){
        webDriverWait.until((WebDriver d) -> d.getPageSource().contains("reallyFiltered"));
    }

    protected List<Integer> findShownRows(){
        return webDriver.findElements(By.className("product")).stream().map(el -> Integer.parseInt(el.getAttribute("id"))).collect(Collectors.toList());
    }
    
    @AfterClass
    public void finish(){
    	webDriver.close();
    }

}
