# -*- coding: utf-8 -*-
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import NoAlertPresentException
import unittest, time, re

class MainAccount(unittest.TestCase):
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
        driver.find_element_by_link_text(u"客户信息").click()
        driver.find_element_by_css_selector("p.operating > span").click()
        driver.find_element_by_id("submit").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_css_selector("p.operating > span").click()
        driver.find_element_by_link_text(u"查看门店").click()
        driver.find_element_by_css_selector("p.operating > span").click()
        driver.find_element_by_id("_submit").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"用户列表").click()
        # ERROR: Caught exception [ERROR: Unsupported command [selectWindow | null | ]]
        driver.find_element_by_link_text(u"图文设置").click()
        driver.find_element_by_css_selector("span.viewIco").click()
        driver.find_element_by_id("but").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"权限管理").click()
        driver.find_element_by_xpath(u"//span[@onclick=\"Ztree(100074,'全部权限')\"]").click()
        driver.find_element_by_id("Save").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_css_selector("input.newAddBut").click()
        driver.find_element_by_name("role_name").clear()
        driver.find_element_by_name("role_name").send_keys(u"新的")
        driver.find_element_by_id("treeDemo_1_check").click()
        driver.find_element_by_id("treeDemo_6_check").click()
        driver.find_element_by_id("treeDemo_17_check").click()
        driver.find_element_by_id("treeDemo_35_check").click()
        driver.find_element_by_id("treeDemo_43_check").click()
        driver.find_element_by_id("treeDemo_48_check").click()
        driver.find_element_by_id("close").click()
        driver.find_element_by_link_text(u"用户列表").click()
        driver.find_element_by_css_selector("span.viewIcos").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_css_selector("span.viewIco").click()
        driver.find_element_by_css_selector("input[type=\"checkbox\"]").click()
        driver.find_element_by_id("Update").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_css_selector("span.viewIco").click()
        driver.find_element_by_css_selector("input[type=\"checkbox\"]").click()
        driver.find_element_by_id("Update").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_css_selector("span.viewIcos").click()
        driver.find_element_by_link_text(u"确定").click()
    
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
