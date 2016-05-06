# -*- coding: utf-8 -*-
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import NoAlertPresentException
import unittest, time, re

class MainPay(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.Firefox()
        self.driver.implicitly_wait(30)
        self.base_url = "http://weixin-test.kemai.com.cn"
        self.verificationErrors = []
        self.accept_next_alert = True
    
    def test_(self):
        driver = self.driver
        driver.get(self.base_url + "/KMWeixin/")
        driver.find_element_by_id("username").clear()
        driver.find_element_by_id("username").send_keys("104026")
        driver.find_element_by_id("password").clear()
        driver.find_element_by_id("password").send_keys("123456")
        driver.find_element_by_css_selector("input.loginBut").click()
        driver.find_element_by_link_text(u"微支付客户汇总").click()
        driver.find_element_by_link_text(u"微信支付门店汇总").click()
        driver.find_element_by_link_text(u"微信支付明细").click()
        driver.find_element_by_xpath("//div[@id='layout_content']/div/div[4]/div/span/span/a/span").click()
        driver.find_element_by_id("ui-id-7").click()
        driver.find_element_by_xpath("//div[@id='layout_content']/div/div[4]/div/span/span/a/span").click()
        driver.find_element_by_id("ui-id-14").click()
        driver.find_element_by_xpath("//div[@id='layout_content']/div/div[4]/div/span/span/a/span").click()
        driver.find_element_by_id("ui-id-21").click()
        driver.find_element_by_xpath("//div[@id='layout_content']/div/div[4]/div/span/span/a/span").click()
        driver.find_element_by_id("ui-id-28").click()
        driver.find_element_by_xpath("//div[@id='layout_content']/div/div[4]/div/span/span/a/span").click()
        driver.find_element_by_id("ui-id-35").click()
        driver.find_element_by_link_text(u"微信支付对账单").click()
        driver.find_element_by_id("time").click()
        driver.find_element_by_css_selector("div.navImg.NavImgl > a").click()
        driver.find_element_by_id("dpOkInput").click()
    
    def is_element_present(self, how, what):
        try: self.driver.find_element(by=how, value=what)
        except NoSuchElementException as e: return False
        return True
    
    def is_alert_present(self):
        try: self.driver.switch_to_alert()
        except NoAlertPresentException as e: return False
        return True
    
    def close_alert_and_get_its_text(self):
        try:
            alert = self.driver.switch_to_alert()
            alert_text = alert.text
            if self.accept_next_alert:
                alert.accept()
            else:
                alert.dismiss()
            return alert_text
        finally: self.accept_next_alert = True
    
    def tearDown(self):
        self.driver.quit()
        self.assertEqual([], self.verificationErrors)

if __name__ == "__main__":
    unittest.main()
