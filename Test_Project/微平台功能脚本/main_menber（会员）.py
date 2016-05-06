# -*- coding: utf-8 -*-
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import NoAlertPresentException
import unittest, time, re

class MainMenber(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.Firefox()
        self.driver.implicitly_wait(30)
        self.base_url = "http://weixin-test.kemai.com.cn"
        self.verificationErrors = []
        self.accept_next_alert = True
    
    def test_main_menber(self):
        driver = self.driver
        driver.get(self.base_url + "/KMWeixin/")
        driver.find_element_by_id("username").clear()
        driver.find_element_by_id("username").send_keys("104026")
        driver.find_element_by_id("password").clear()
        driver.find_element_by_id("password").send_keys("123456")
        driver.find_element_by_css_selector("input.loginBut").click()
        driver.find_element_by_link_text(u"粉丝列表").click()
        driver.find_element_by_xpath("//div[@id='layout_content']/div/div[4]/span/a/span").click()
        driver.find_element_by_id("ui-id-6").click()
        driver.find_element_by_xpath("//div[@id='layout_content']/div/div[4]/span/a/span").click()
        driver.find_element_by_id("ui-id-8").click()
        driver.find_element_by_xpath("//div[@id='layout_content']/div/table/tbody/tr/td[2]/p").click()
        driver.find_element_by_id("CardNo").clear()
        driver.find_element_by_id("CardNo").send_keys("leonadozki")
        driver.find_element_by_id("newBind").click()
        driver.find_element_by_css_selector("span.lookIco").click()
        driver.find_element_by_link_text(u"返回列表").click()
        driver.find_element_by_link_text(u"粉丝来源分析").click()
        driver.find_element_by_link_text(u"会员卡充值").click()
        driver.find_element_by_link_text(u"充值流水").click()
        driver.find_element_by_id("newBind").click()
        driver.find_element_by_link_text(u"会员积分兑换").click()
        driver.find_element_by_id("new").click()
        driver.find_element_by_id("Title_info").clear()
        driver.find_element_by_id("Title_info").send_keys("song")
        driver.find_element_by_id("Begin_Date").click()
        driver.find_element_by_id("dpTodayInput").click()
        driver.find_element_by_id("End_Date").click()
        driver.find_element_by_id("dpTodayInput").click()
        driver.find_element_by_id("Count").clear()
        driver.find_element_by_id("Count").send_keys("3")
        driver.find_element_by_id("btn_sub").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_id("xjBtn_detail").click()
        driver.find_element_by_id("txt_integrate").clear()
        driver.find_element_by_id("txt_integrate").send_keys("1")
        driver.find_element_by_xpath("(//button[@type='button'])[5]").click()
        driver.find_element_by_id("btn_sub").click()
        driver.find_element_by_css_selector("span.delIco").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"积分兑换流水").click()
        driver.find_element_by_link_text(u"礼品汇总").click()
        driver.find_element_by_id("newBind").click()
    
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
