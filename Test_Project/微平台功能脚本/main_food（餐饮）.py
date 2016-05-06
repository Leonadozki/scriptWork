# -*- coding: utf-8 -*-
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import NoAlertPresentException
import unittest, time, re

class MainFood(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.Firefox()
        self.driver.implicitly_wait(30)
        self.base_url = "http://weixin-test.kemai.com.cn"
        self.verificationErrors = []
        self.accept_next_alert = True
    
    def test_main_food(self):
        driver = self.driver
        driver.get(self.base_url + "/KMWeixin/")
        driver.find_element_by_id("username").clear()
        driver.find_element_by_id("username").send_keys("104026")
        driver.find_element_by_id("password").clear()
        driver.find_element_by_id("password").send_keys("123456")
        driver.find_element_by_css_selector("input.loginBut").click()
        driver.find_element_by_link_text(u"类别管理").click()
        driver.find_element_by_id("new").click()
        driver.find_element_by_id("txt_clsno").clear()
        driver.find_element_by_id("txt_clsno").send_keys("02")
        driver.find_element_by_id("txt_clsname").clear()
        driver.find_element_by_id("txt_clsname").send_keys(u"小类")
        driver.find_element_by_xpath("(//button[@type='button'])[2]").click()
        driver.find_element_by_link_text(u"菜品管理").click()
        driver.find_element_by_css_selector(u"li[name=\"小类\"] > span.file").click()
        driver.find_element_by_id("new").click()
        driver.find_element_by_css_selector(u"li[name=\"焖锅类\"] > span.file").click()
        driver.find_element_by_css_selector(u"li[name=\"焖锅类\"] > ul > li > span.file").click()
        driver.find_element_by_css_selector("#tab_offlineitems > tbody > tr > td > input[type=\"checkbox\"]").click()
        driver.find_element_by_xpath("(//button[@type='button'])[5]").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_xpath("(//button[@type='button'])[6]").click()
        driver.find_element_by_css_selector("span.deleteIco").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"类别管理").click()
        driver.find_element_by_xpath("//table[@id='foodcls_list']/tbody/tr[2]/td[8]/p/span[2]").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"菜品属性管理").click()
        driver.find_element_by_id("newCls").click()
        driver.find_element_by_id("input_attrname").clear()
        driver.find_element_by_id("input_attrname").send_keys("01")
        driver.find_element_by_id("imgBtn").click()
        driver.find_element_by_xpath("(//button[@type='button'])[6]").click()
        driver.find_element_by_xpath("(//button[@type='button'])[3]").click()
        driver.find_element_by_link_text(u"市别管理").click()
        driver.find_element_by_id("new").click()
        driver.find_element_by_id("txt_periodid").clear()
        driver.find_element_by_id("txt_periodid").send_keys("01")
        driver.find_element_by_id("txt_periodname").clear()
        driver.find_element_by_id("txt_periodname").send_keys(u"早市")
        driver.find_element_by_id("txt_begintime").click()
        driver.find_element_by_id("dpOkInput").click()
        driver.find_element_by_id("txt_endtime").click()
        driver.find_element_by_id("dpOkInput").click()
        driver.find_element_by_css_selector("div.layerBut > input[type=\"button\"]").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_id("txt_endtime").click()
        driver.find_element_by_id("dpTodayInput").click()
        driver.find_element_by_id("txt_endtime").click()
        driver.find_element_by_id("dpOkInput").click()
        driver.find_element_by_css_selector("div.layerBut > input[type=\"button\"]").click()
        driver.find_element_by_link_text(u"台位类别管理").click()
        driver.find_element_by_id("new").click()
        driver.find_element_by_id("txt_tabletypeno").clear()
        driver.find_element_by_id("txt_tabletypeno").send_keys("01")
        driver.find_element_by_id("txt_tabletypename").clear()
        driver.find_element_by_id("txt_tabletypename").send_keys(u"四人桌")
        driver.find_element_by_xpath("(//button[@type='button'])[2]").click()
        driver.find_element_by_link_text(u"打印台位二维码").click()
        driver.find_element_by_css_selector("span.print").click()
        driver.find_element_by_css_selector("span.edtIco").click()
        driver.find_element_by_xpath("(//button[@type='button'])[2]").click()
        driver.find_element_by_css_selector("div.easyui-layout-content-tags > a").click()
        driver.find_element_by_css_selector("span.delIco").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"绑定服务员").click()
        driver.find_element_by_id("new").click()
        driver.find_element_by_id("radio_cardType2").click()
        driver.find_element_by_xpath("(//button[@type='button'])[2]").click()
        driver.find_element_by_link_text(u"选择会员OpenID").click()
        driver.find_element_by_css_selector("span.viewIco").click()
        driver.find_element_by_link_text(u"选择员工ID").click()
        driver.find_element_by_xpath("(//button[@type='button'])[3]").click()
    
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
