#coding=utf-8
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import unittest, time

class websaleTest(unittest.TestCase):
        
    def setUp(self):
        self.driver = webdriver.Chrome()
        self.base_url = "http://localhost/WebSale/Home/login.aspx" 
        self.inner_url = "http://localhost/WebSale/Home/index.aspx"
        self.verificationErrors = []
        self.accept_next_alert = True

    def test_login(self):
        driver = self.driver
        driver.get(self.base_url)
        print("准备登录，地址：%s" %self.base_url)
        driver.find_element_by_id('TxtUserId').send_keys('9001')
        driver.find_element_by_id('Password').send_keys('9001')
        driver.find_element_by_id('btnLogin').click()
        print('切换到登录主页，地址：%s' %self.inner_url)
        driver.implicitly_wait(20)
        driver.get(self.inner_url)
        driver.find_element_by_id('autocomplete').clear()
        print('创建商品类别')
        #press 'Down' and 'Enter' keys in one code
        driver.find_element_by_id('autocomplete').send_keys(u'商品类', Keys.ARROW_DOWN, Keys.ARROW_DOWN, Keys.ENTER)
        #switch to iframe1
        driver.implicitly_wait(20)
        iframe1 = driver.find_element_by_xpath('//*[@id="funcArea"]/div[2]/div[2]/div/iframe')
        driver.switch_to_frame(iframe1)
        driver.find_element_by_id('NewBtn').click()
        #switch to iframe2
        driver.implicitly_wait(20)
        driver.switch_to_default_content()
        iframe2 = driver.find_element_by_xpath('//*[@id="content:1481101641489"]/iframe')
        # driver.implicitly_wait(20)
        # driver.switch_to_frame('1481101641489')
        driver.switch_to_frame(iframe2)
        # driver.implicitly_wait(20)
        driver.find_element_by_id('Id').clear()
        driver.find_element_by_id('Id').send_keys('80')
        driver.find_element_by_id('Name').clear()
        driver.find_element_by_id('Name').send_keys('测试类')
        driver.find_element_by_class_name('ui-popup ui-popup-modal ui-popup-show ui-popup-focus').find_element_by_id('bSave').click()
        driver.implicitly_wait(20)
        # driver.find_element_by_xpath('//*[@id="form1"]/div[3]/'
        # 'table/tbody/tr[3]/td/table/tbody/tr/td[3]').click()
        # driver.find_element_by_xpath("//*[@id='form1']/div[3]/table/tbody"
        #                              "/tr[1]/td/table/tbody/tr/td[3]/div/ul/li[2]").click()

    def is_alert_present(self):
		try: self.driver.switch_to_alert()
		except NoAlertPresentException, e: return False
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

if __name__ == '__main__':
	unittest.main()
