
# implementation
# - go to 'http://card.cgbchina.com.cn/Channel/11608406', get a list of city
# - for each city, set cookie
# - for a page, get all 'merchant info' hyperlinks
#   go to next page
# - now you have a 'merchant info link' list, fetch info in each of them

import urllib
import cookielib
import urllib2
import gzip
import cStringIO
from HTMLParser import HTMLParser


### city | merchant | class | g | time | address | phone

class MerchantInfoParser(HTMLParser):
  def __init__(self):
    HTMLParser.__init__(self)
    ## all under "base div" = 'html->body->div.main->div.right.border->div.teihui->div.teihuiinfo->div.theleft'
    self.city = ''     # base -> div.shuanghuxx->div.text->p
    self.merchant = '' # base -> div.shuanghuxx->div.text->div->h2
    self.category = '' # base -> div.shuanghuxx->div.text->p
    self.discount = '' # base -> div.shuanghuxx->div.text->div.text_yh
    self.time = ''     # base -> div.shuanghuqq->ul-li
    self.addr = ''     # base -> div.shuanghuqq->ul-li
    self.phone = ''    # base -> div.shuanghuqq->ul-li

    self.in_main = False
    self.in_right_border = False #<div class="right border">
    self.in_teihui = False       #<div class="teihui" style="position:relative;">
    self.in_teihuiinfo = False   #<div class="teihuiinfo">      
    self.in_thleft = False       #<div class="thleft">          
    self.in_base_div = False     # now, use self.in_teihuiinfo and self.in_thleft to see if we enter into self.in_base_div or not
    self.in_shuanghuqq_div = False

    self.got_city = False
    self.got_merchant = False
    self.got_category = False
    self.got_discount = False
    self.got_time = False
    self.got_addr = False
    self.got_phone = False

    self.index_p = 0
    self.index_shuanghuqq_li = 0
    

  def handle_starttag(self, tag, attrs):
    if tag == 'div':
      for a,v in attrs:
        if a == 'class' and v == 'teihuiinfo':
          self.in_teihuiinfo = True
        if a == 'class' and v == 'thleft':
          self.in_thleft = True
        if a == 'class' and v == 'thright':  #if we enter 'thright' div, then mark all false
          self.in_teihuiinfo = False
          self.in_thleft = False
          self.in_base_div = False

    if self.in_teihuiinfo and self.in_thleft:
      self.in_base_div = True

    if self.in_base_div:
      if tag == 'h2':
        self.got_merchant = True  # the name of merchant is the only h2 in base

      if tag == 'div':
        for a,v in attrs:
          if a == 'class' and v == 'text_yh':
            self.got_discount = True  #  only div of discount is 'text_yh'
            break
          if a == 'class' and v == 'shuanghuqq':
            self.in_shuanghuqq_div = True   # only 1 shuanghuqq
            break

      if tag == 'p':
        self.index_p = self.index_p + 1
        if self.index_p == 1:
          self.got_city = True   # city is the first p in base div
        elif self.index_p == 2:
          self.got_category = True    # category is the second p in base div
      
      if self.in_shuanghuqq_div:
        if tag == 'li':
          self.index_shuanghuqq_li = self.index_shuanghuqq_li + 1
          if self.index_shuanghuqq_li == 2:
            self.got_time = True
          elif self.index_shuanghuqq_li == 4:
            self.got_addr = True
          elif self.index_shuanghuqq_li == 6:
            self.got_phone = True


  def handle_endtag(self, tag):
    pass

  def handle_data(self, data):
    if self.got_city:
      self.city = data
      self.got_city = False

    if self.got_merchant:
      self.got_merchant = False
      self.merchant = data

    if self.got_category:
      self.got_category = False
      self.category = data

    if self.got_discount:
      self.got_discount = False
      self.discount = data

    if self.got_time:
      self.got_time = False
      self.time = data

    if self.got_addr:
      self.got_addr = False
      self.addr = data

    if self.got_phone:
      self.got_phone = False
      self.phone = data

  def info(self):
    return (self.merchant, self.city, self.category, self.discount, self.time, self.addr, self.phone)


class LinkFetcher(HTMLParser):
  def __init__(self):
    HTMLParser.__init__(self)
    self.in_list_content = False
    self.merchantLinks = {}
    self.page_number = 0
    self.in_next_page_div = False

  def clear(self):  # for next feed() call
    self.in_list_content = False
    self.in_next_page_div = False

  def handle_starttag(self, tag, attrs):
    if tag == 'div':
      for a,v in attrs:
        if a == 'class' and v == 'list_content':
          self.in_list_content = True
        elif a == 'class' and v == 'page gray':
          self.in_list_content = False     # if we go in div 'page gray', means we outside 'list_content'
          self.in_next_page_div = True

    if self.in_list_content:
      if tag == 'a':
        for a,v in attrs:
          if a == 'href':
            self.merchantLinks[v.strip()] = 1

    if self.in_next_page_div:
      for a,v in attrs:
        if a == 'href' and v.find('javascript:gotopage') != -1:
          numstr = v.split("'")[1].strip()
          self.page_number = int(numstr)

  def handle_endtag(self, tag):
    pass

  def handle_data(self, data):
    pass


class CityParser(HTMLParser):
  def __init__(self):
    HTMLParser.__init__(self)
    self.cities = []
    self.found_city = False

  def handle_starttag(self, tag, attrs):
    if tag == 'a':
      for a,v in attrs:
        if a == 'href' and v.find('changeCity2') != -1:
          self.found_city = True

  def handle_endtag(self, tag):
    pass

  def handle_data(self, data):
    if self.found_city:
      self.found_city = False
      self.cities.append(data.strip())


def fetchMerchantInfo(urlstr):
  req = urllib2.Request(urlstr)
  res = urllib2.urlopen(req)
  page = res.read()

  html = page
  if html[:6] == '\x1f\x8b\x08\x00\x00\x00':
    html = gzip.GzipFile(fileobj = cStringIO.StringIO(html)).read()

  #html = html.decode('gbk').encode('utf-8')
  html = html.decode('gb18030').encode('utf-8')   # the page says it's gbk... but use gbk will be wrong...
  parser = MerchantInfoParser()
  parser.feed(html)

  #print parser.info()
  for a in parser.info():
    print a.strip()




def fetchCities(cityurl):
  req = urllib2.Request(cityurl)
  res = urllib2.urlopen(req)
  page = res.read()

  html = page
  if html[:6] == '\x1f\x8b\x08\x00\x00\x00':
    html = gzip.GzipFile(fileobj = cStringIO.StringIO(html)).read()

  html = html.decode('gbk').encode('utf-8')
  parser = CityParser()
  parser.feed(html)
  #print parser.cities     # it's ok to access directly
  for c in parser.cities:
    print c

  return parser.cities

  #processACity(parser.cities[1], 'http://card.cgbchina.com.cn/jsp/include/CN2/common/cookiesAction.jsp')
  processCityByCookie(parser.cities[1])

def fetchMerchantLinks(starturl):
  req = urllib2.Request(starturl)
  res = urllib2.urlopen(req)
  page = res.read()

  html = page
  if html[:6] == '\x1f\x8b\x08\x00\x00\x00':
    html = gzip.GzipFile(fileobj = cStringIO.StringIO(html)).read()

  html = html.decode('gbk').encode('utf-8')
  parser = LinkFetcher()
  parser.feed(html)
  print parser.merchantLinks     # it's ok to access directly


def processACity(city, url):
  values = {'channelId': '/Channel/11608406',
            'mCity': city, 
            'currentSelCity': city}
            #'currentCity': city}
  data = urllib.urlencode(values) 
  req = urllib2.Request(url, data)
  response = urllib2.urlopen(req)
  page = response.read()
  #print page
  html = page
  if html[:6] == '\x1f\x8b\x08\x00\x00\x00':
    html = gzip.GzipFile(fileobj = cStringIO.StringIO(html)).read()

  html = html.decode('gbk').encode('utf-8')
  print html
  print city


def nextPage(url, page_num):
  values = {'_tp_info': page_num,  # page_num is a string
            'areaName': '', 
            'mCondition': ''}
  
  data = urllib.urlencode(values) 
  req = urllib2.Request(url, data)
  response = urllib2.urlopen(req)
  page = response.read()
  #print page
  html = page
  if html[:6] == '\x1f\x8b\x08\x00\x00\x00':
    html = gzip.GzipFile(fileobj = cStringIO.StringIO(html)).read()

  html = html.decode('gbk').encode('utf-8')
  #print html
  #print city
  return html


#
def processCityByCookie(url, city):
  cjar=cookielib.CookieJar()
  opener=urllib2.build_opener(urllib2.HTTPCookieProcessor(cjar))
  urllib2.install_opener(opener)
  cookie=urllib.urlencode({'cookie_city':city})
  #response=urllib2.urlopen('http://card.cgbchina.com.cn/Channel/11608406',cookie)
  response=urllib2.urlopen(url,cookie)
  page = response.read()
  #print page
  html = page
  if html[:6] == '\x1f\x8b\x08\x00\x00\x00':
    html = gzip.GzipFile(fileobj = cStringIO.StringIO(html)).read()

  html = html.decode('gbk').encode('utf-8')
  #print html
  #print city

  # process 1st page
  parser = LinkFetcher()
  parser.feed(html)
  print parser.merchantLinks     # it's ok to access directly

  n_page = parser.page_number
  #for i in range(n_page):    # hong
  for i in range(5):    # hong
    html = nextPage(url, str(i))
    print '--------------page ' + str(i)
    parser.feed(html)
    print parser.merchantLinks

  return parser.merchantLinks


def fetchAllMerchants(url, baseurl):
  #url = 'http://card.cgbchina.com.cn/Channel/11608406'
  cities = fetchCities(url)
  mlink_list = []
  #for c in cities:
  for c in cities[1:6]:
    print c
    mlink_list.append(processCityByCookie(url, c))

  print mlink_list
  for m in mlink_list:
    for k,v in m.iteritems():
      murl = baseurl + k
      fetchMerchantInfo(murl)

  

baseurl = 'http://card.cgbchina.com.cn'
url = 'http://card.cgbchina.com.cn/Channel/11608406'
#selectCityForm2_action = '/jsp/include/CN2/common/cookiesAction.jsp'
#fetchMerchantLinks('http://card.cgbchina.com.cn/Channel/11608406')
#fetchMerchantInfo('http://card.cgbchina.com.cn/Info/17280179')

fetchAllMerchants(url, baseurl)


