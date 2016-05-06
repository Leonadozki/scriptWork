# -*- coding: utf-8 -*-
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import NoAlertPresentException
import unittest, time, re

class MainWebsite(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.Firefox()
        self.driver.implicitly_wait(30)
        self.base_url = "http://weixin-test.kemai.com.cn"
        self.verificationErrors = []
        self.accept_next_alert = True
    
    def test_main_website(self):
        driver = self.driver
        driver.get(self.base_url + "/KMWeixin/")
        driver.find_element_by_id("username").clear()
        driver.find_element_by_id("username").send_keys("104026")
        driver.find_element_by_id("password").clear()
        driver.find_element_by_id("password").send_keys("123456")
        driver.find_element_by_css_selector("input.loginBut").click()
        driver.find_element_by_link_text(u"微首页").click()
        driver.find_element_by_css_selector("input.newSubmitBut").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"自动回复").click()
        driver.find_element_by_css_selector("span.emotion").click()
        driver.find_element_by_xpath("//div[@id='facebox']/table/tbody/tr/td[8]/img").click()
        driver.find_element_by_id("Save").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_id("delIco").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_css_selector("a.graphicIco > i").click()
        driver.find_element_by_css_selector("div.itmeImgBox > img").click()
        driver.find_element_by_xpath("(//button[@type='button'])[2]").click()
        driver.find_element_by_id("Save").click()
        driver.find_element_by_xpath("//div[7]/div[2]/div[3]/div/a").click()
        driver.find_element_by_id("delIco").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"关键词自动回复").click()
        driver.find_element_by_id("addRuleBut").click()
        driver.find_element_by_css_selector("input.addruleNameText").clear()
        driver.find_element_by_css_selector("input.addruleNameText").send_keys("ss")
        driver.find_element_by_css_selector("a.graphicIco > i").click()
        driver.find_element_by_xpath("//div[2]/div/div/img").click()
        driver.find_element_by_xpath("(//button[@type='button'])[8]").click()
        driver.find_element_by_id("btn_Del").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"粉丝列表").click()
    
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
