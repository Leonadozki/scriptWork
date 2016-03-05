# coding=utf-8
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time

driver=webdriver.Chrome()
first_url='http://weixin-test.kemai.com.cn/KMWeixin/AllOf/Account/Login'
driver.get(first_url);
driver.maximize_window()
#login
print "now login km1174"
driver.find_element_by_id("username").send_keys("km1174")
driver.find_element_by_id("password").send_keys("km-o2o-1")
driver.find_element_by_class_name("loginBut").click()

#indexpage
print "now access to the indexpage"
driver.find_element_by_link_text("客户信息").click()
# driver.find_element_by_id("keywords").send_keys("857726") #Websale
driver.find_element_by_id("keywords").send_keys("753978") #Zy v9
# driver.find_element_by_id("keywords").send_keys("897214") #Cy v8
driver.find_element_by_id("submit").click()
print "now get customer info"
driver.implicitly_wait(1)
driver.find_element_by_xpath("//*[@id='layout_content']/div/table/tbody/tr/td[8]/p/span").click()
custName1=driver.find_element_by_id("CustName").get_attribute('value')
driver.find_element_by_id("AppID").clear()
driver.find_element_by_id("AppSecret").clear()
driver.find_element_by_id("AppID").send_keys("wxe6a7640349f98724")
driver.find_element_by_id("AppSecret").send_keys("fffdbfd96f16a877e76331a95f5be812")
urlofkm=driver.find_element_by_id("HandlerUrl").get_attribute('value')
tokenofkm=driver.find_element_by_id("Token").get_attribute('value')
if tokenofkm=='246TJBRB':
    print u"successful to setting right ZhiYing customer!"                     
else:
    print u"wrong ZhiYing customer!"
driver.find_element_by_id("submit").click()
driver.implicitly_wait(1)
driver.find_element_by_class_name("popBox").find_element_by_class_name("sgBtn").click()
driver.back()
    
#Weipay Setting
print "now Setting the WeiPay"
driver.implicitly_wait(4)
driver.find_element_by_link_text(u"查看门店").click()
driver.find_element_by_css_selector("#layout_content > div > table > tbody > tr > td:nth-child(7) > p > span:nth-child(1)").click()
driver.implicitly_wait(3)
driver.find_element_by_id("MchId").clear()
driver.find_element_by_id("MchId").send_keys("1241916402")
driver.find_element_by_id("MchKey").clear()
driver.find_element_by_id("MchKey").send_keys("jmmAiUVN2xaWtnYJ7xm8uWRy1y8hkJbF")
driver.find_element_by_id("btn_testPayAccount").click()
driver.implicitly_wait(3)
driver.find_element_by_link_text(u"确定").click()
    
#Weinxin website
print "now access to weixin"
driver.get("https://mp.weixin.qq.com")
driver.find_element_by_id("account").send_keys("kemai_px_shop") 
driver.find_element_by_id("pwd").send_keys("km666888*") 
driver.find_element_by_id("loginBt").click()
print "now set the url and token"
driver.implicitly_wait(1)
driver.find_element_by_link_text(u"取消").click()
driver.find_element_by_partial_link_text(u"基本配置").click()
#driver.find_element_by_xpath("//*[@id='menuBar']/dl[7]/dd[1]/a").click()
driver.find_element_by_link_text(u"修改配置").click()
driver.find_element_by_id("url").clear()
driver.find_element_by_id("token").clear()
driver.find_element_by_id("url").send_keys(urlofkm)
driver.find_element_by_id("token").send_keys(tokenofkm)
driver.find_element_by_xpath("//*[@id='form']/div/span/button").click()
driver.implicitly_wait(1)
driver.find_element_by_link_text(u"确定").click()
print "successful !"
driver.get(first_url);
print "now back and login ZhiYing account"
# driver.find_element_by_id("username").send_keys("102999") #websale
driver.find_element_by_id("username").send_keys("103021") #Zy v9
# driver.find_element_by_id("username").send_keys("103001")  #Cy v8
driver.find_element_by_id("password").send_keys("123456")
driver.find_element_by_class_name("loginBut").click()
print "done."

