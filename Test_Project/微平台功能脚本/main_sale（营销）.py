# -*- coding: utf-8 -*-
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import NoAlertPresentException
import unittest, time, re

class MainSale(unittest.TestCase):
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
        driver.find_element_by_link_text(u"券类别管理").click()
        driver.find_element_by_id("newCls").click()
        driver.find_element_by_xpath("(//button[@type='button'])[2]").click()
        driver.find_element_by_id("input_color").click()
        driver.find_element_by_id("Color102").click()
        driver.find_element_by_id("txt_reduce_cost").clear()
        driver.find_element_by_id("txt_reduce_cost").send_keys("1")
        driver.find_element_by_id("txt_title").clear()
        driver.find_element_by_id("txt_title").send_keys(u"减免1")
        driver.find_element_by_id("txt_subtitle").clear()
        driver.find_element_by_id("txt_subtitle").send_keys("")
        driver.find_element_by_id("radio_day").click()
        driver.find_element_by_id("btn_sub").click()
        driver.find_element_by_id("txt_kc").clear()
        driver.find_element_by_id("txt_kc").send_keys("5")
        driver.find_element_by_id("txt_ljxz").clear()
        driver.find_element_by_id("txt_ljxz").send_keys("5")
        driver.find_element_by_id("txt_clicktip").clear()
        driver.find_element_by_id("txt_clicktip").send_keys("")
        driver.find_element_by_id("btn_sub").click()
        driver.find_element_by_id("txt_memo").clear()
        driver.find_element_by_id("txt_memo").send_keys("")
        driver.find_element_by_id("txt_phonenum").clear()
        driver.find_element_by_id("txt_phonenum").send_keys("")
        driver.find_element_by_id("btn_sub").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"关注/绑定/注册活动").click()
        driver.find_element_by_xpath("//div[@id='layout_content']/div/div[4]/label/span[2]/a/span").click()
        driver.find_element_by_id("select_status").click()
        driver.find_element_by_id("ui-id-4").click()
        driver.find_element_by_css_selector("input.newAddBut").click()
        driver.find_element_by_id("input_givename").clear()
        driver.find_element_by_id("input_givename").send_keys(u"注册活动")
        driver.find_element_by_id("input_sdate").click()
        driver.find_element_by_id("dpTodayInput").click()
        driver.find_element_by_id("input_edate").click()
        driver.find_element_by_id("dpTodayInput").click()
        driver.find_element_by_id("TextArea_memo").clear()
        driver.find_element_by_id("TextArea_memo").send_keys(u"无")
        driver.find_element_by_id("xjBtn_detail").click()
        driver.find_element_by_xpath("//div[@id='divDetail']/table/tbody/tr/td[2]/span/a").click()
        driver.find_element_by_id("ui-id-5").click()
        driver.find_element_by_xpath("(//button[@type='button'])[2]").click()
        driver.find_element_by_id("btn_sub").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_id("btn_check").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"关注/绑定/注册活动").click()
        driver.find_element_by_css_selector("span.delBtn").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"抽奖营销活动").click()
        driver.find_element_by_xpath("//div[@id='layout_content']/div/div[4]/label/span[2]/a/span").click()
        driver.find_element_by_id("select_status").click()
        driver.find_element_by_id("ui-id-5").click()
        driver.find_element_by_css_selector("input.newAddBut").click()
        driver.find_element_by_id("input_givename").clear()
        driver.find_element_by_id("input_givename").send_keys(u"摇奖")
        driver.find_element_by_id("input_sdate").click()
        driver.find_element_by_id("dpTodayInput").click()
        driver.find_element_by_id("input_edate").click()
        driver.find_element_by_id("dpTodayInput").click()
        driver.find_element_by_id("TextArea_memo").clear()
        driver.find_element_by_id("TextArea_memo").send_keys(u"无")
        driver.find_element_by_id("xjBtn_detail").click()
        driver.find_element_by_id("txt_hitnums1").clear()
        driver.find_element_by_id("txt_hitnums1").send_keys("1")
        driver.find_element_by_xpath("(//button[@type='button'])[7]").click()
        driver.find_element_by_id("btn_sub").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"线下赠送营销活动").click()
        driver.find_element_by_xpath("//div[@id='layout_content']/div/div[4]/label/span[2]/a").click()
        driver.find_element_by_id("select_status").click()
        driver.find_element_by_id("ui-id-4").click()
        driver.find_element_by_css_selector("input.newAddBut").click()
        driver.find_element_by_id("input_givename").clear()
        driver.find_element_by_id("input_givename").send_keys(u"线下活动")
        driver.find_element_by_id("input_sdate").click()
        driver.find_element_by_id("dpTodayInput").click()
        driver.find_element_by_id("input_edate").click()
        driver.find_element_by_id("dpTodayInput").click()
        driver.find_element_by_id("input_saleamt").clear()
        driver.find_element_by_id("input_saleamt").send_keys("1")
        driver.find_element_by_id("TextArea_memo").clear()
        driver.find_element_by_id("TextArea_memo").send_keys(u"无")
        driver.find_element_by_id("xjBtn_detail").click()
        driver.find_element_by_xpath("//div[@id='divDetail']/table/tbody/tr/td[2]/span/a/span").click()
        driver.find_element_by_id("ui-id-5").click()
        driver.find_element_by_xpath("(//button[@type='button'])[2]").click()
        driver.find_element_by_id("btn_sub").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_id("btn_check").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"线下赠送营销活动").click()
        driver.find_element_by_css_selector("span.delBtn").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"活动流水表").click()
        driver.find_element_by_link_text(u"券类别管理").click()
        driver.find_element_by_css_selector("span.deleteIco").click()
        driver.find_element_by_link_text(u"确定").click()
        driver.find_element_by_link_text(u"劵使用列表").click()
    
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
