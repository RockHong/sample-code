#!/usr/bin/python
#coding=utf-8

import urllib
import re
from sgmllib import SGMLParser

def getHTML(url):
    urlobj = urllib.urlopen(url)
    page = urlobj.read()
    urlobj.close()
    return page


class PriceParser(SGMLParser):
    def __init__(self):
        SGMLParser.__init__(self)
        self.in_specs = False
        self.in_purchase_info = False
        self.in_price = False
        #self.all_specs = []
        #self.all_price = []
        self.specs = ''
        self.price = 0.0
        self.items = []

    def start_td(self, attrs):
        for k, v in attrs:
            if k == 'class' and v == 'specs':
                self.in_specs = True
                self.specs = ''
                #print 'specs...'
            elif k == 'class' and v == 'purchase-info':
                self.in_purchase_info = True
                self.price = 0.0
                #print 'purchase-info...'

    def end_td(self):
        if self.in_specs:
            self.in_specs = False
            #self.all_specs.append(self.specs.lstrip('\n'))
        if self.in_purchase_info:
            self.in_purchase_info = False
            self.items.append((self.price, self.specs.lstrip('\n')))
            #self.all_price.append(self.price)

    def start_span(self, attrs):
        for k, v in attrs:
            if k == 'itemprop' and v == 'price':
                self.in_price = True

    def end_span(self):
        self.in_price = False

    def extract_specs(self, data):
        pass
        tmpstr = data.strip('\n')
        tmpstr = tmpstr.lstrip()
        tmpstr = tmpstr.rstrip()
        if not tmpstr.isspace() and not len(tmpstr) == 0:
            if tmpstr.lower().find('superdrive') == -1:
                #print 'specs---|' + tmpstr + '|' + '{}'.format(len(tmpstr))
                self.specs += '\n'
                self.specs += tmpstr
                #self.specs.append(tmpstr)

    def extract_price(self, data):
        pass
        tmpstr = data.strip('\n')
        tmpstr = tmpstr.lstrip()
        tmpstr = tmpstr.rstrip()
        if not tmpstr.isspace() and not len(tmpstr) == 0:
            m = re.search(r'[0-9]{1,3}(?:,?[0-9]{3})*', tmpstr) # use search(), not match()
            if m is not None:
                self.price = float(m.group(0).replace(',', ''))
                #print 'price---|{}'.format(self.price)
                
    
    def handle_data(self, data):
        if self.in_specs:
            self.extract_specs(data)
        elif self.in_purchase_info and self.in_price:
            self.extract_price(data)


class ExchangeRateParser(SGMLParser):
    def __init__(self, currency_type):
        SGMLParser.__init__(self)
        self.currency_type = currency_type
        self.in_table_cell = False
        self.start_extract = False
        self.target_col = 6 # zhong hang zhe suan jia
        self.current_col = 1
        self.rate = 0.0 
    
    def start_td(self, attrs):
        self.in_table_cell = True

    def end_td(self):
        self.in_table_cell = False

    def handle_data(self, data):
        if not self.in_table_cell:
            return

        if data.decode('utf-8') == self.currency_type: # unicode comparation
            self.start_extract = True
 
        if self.start_extract and self.current_col < self.target_col:
            self.current_col = self.current_col + 1
        elif self.start_extract and self.current_col == self.target_col:
            self.rate = float(data)/100
            self.start_extract = False

       
def exchange_rate(currency_type):
    url = 'http://www.boc.cn/sourcedb/whpj/'
    rate_parser = ExchangeRateParser(currency_type)
    rate_parser.feed(getHTML(url))
    #print 'rate is :{}'.format(rate_parser.rate)
    return rate_parser.rate

if __name__ == "__main__":
    rate_us = exchange_rate(u'美元')
    rate_hk = exchange_rate(u'港币')

    # HK Store
    parser_hk = PriceParser()
    url = 'http://store.apple.com/hk-zh/browse/home/specialdeals/mac/macbook_pro/15'
    parser_hk.feed(getHTML(url))

    # US Store
    parser_us = PriceParser()
    url = 'http://store.apple.com/us/browse/home/specialdeals/mac/macbook_pro/15'
    parser_us.feed(getHTML(url))

    all_items = [(p, p*rate_hk, s) for p, s in parser_hk.items] + [(p, p*rate_us, s) for p, s in parser_us.items]
    all_items.sort(key = lambda tup: tup[1])

    # output
    print 'USD - RMB: {} / HKD - RMB: {}'.format(rate_us, rate_hk)

    for p, p_cn, s in all_items:
        print 'RMB: {}, HKD/USD: {}'.format(p_cn, p)
        print '\t' + s.replace('\n', '\n\t')
        print '\n'
