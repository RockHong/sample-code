#!/usr/bin/python
#coding=utf-8

from HTMLParser import HTMLParser
import urllib
import re
from urlparse import urljoin

class HomePageParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self._user_name = ''
        self.event_link = ''
        self.is_title = False
        self.near_event_link = False

    def user_name(self):
        return self._user_name

    def online_events_link(self):
        pass
        return self.event_link

    def handle_starttag(self, tag, attrs):
        pass
        if tag == 'title':
            self.is_title = True
        elif tag == 'a' and self.near_event_link:
            for k, v in attrs:
                if k == 'href':
                    self.event_link = v
            self.near_event_link = False


    def handle_endtag(self, tag):
        if tag == 'title':
            self.is_title = False

    def handle_data(self, data):
        if self.is_title:
            pass
            tmp = data.strip()
            self._user_name = tmp
        #if u'的线上活动'.decode('utf-8') in data.decode('utf-8'):
        if u'的线上活动' in data:
            print data
            self.near_event_link = True

class UserEventPageParser(HTMLParser):
    link_pattern = r'/online/[0-9]+/'

    def __init__(self):
        HTMLParser.__init__(self)
        self.reset()

    def reset(self):
        HTMLParser.reset(self)
        self.links = {}
        self.near_next_page_link = ''
        self.next_page_link = ''

    def event_links(self):
        pass
        return self.links.keys()
    
    def next_page(self):
        pass
        return self.next_page_link

    def empty(self):
        pass
        return len(self.links.keys()) == 0

    def handle_starttag(self, tag, attrs):
        pass
        if tag == 'a':
            for k, v in attrs:
                if k == 'href' and re.search(self.link_pattern, v):
                    self.links[v] = 1
        elif tag == 'link':
            for k, v in attrs:
                if k == 'rel' and v == 'next':
                    self.near_next_page_link = True
                if k == 'href' and self.near_next_page_link:
                    self.next_page_link = v
                        

class EventHomePageParser(HTMLParser):
    pass

class EventAlbumPageParser(HTMLParser):
    pass


if __name__ == '__main__':
    test_link = 'http://www.douban.com/people/enenenene/'
    #test_link = 'http://docs.python.org/2/library/htmlparser.html'

    try:
        urlobj = urllib.urlopen(test_link)
    except IOError:
        print "can't open this url, %s." % test_link
    else:
        page = urlobj.read()
        urlobj.close()
        #return page #TODO: when excption happens, what is returned?
    
    encoding = urlobj.headers.getparam('charset')

    parser = HomePageParser()
    parser.feed(page.decode(encoding)) # must decoding, or HTMLParser will raise an error
    user_name = parser.user_name()
    user_events_link = parser.online_events_link()


    parser = UserEventPageParser()
    xxx_link = user_events_link
    all_event_links = []
    while True:
        urlobj = urllib.urlopen(xxx_link)
        page = urlobj.read()
        xxx_url = urlobj.geturl()
        urlobj.close()

        parser.reset()
        parser.feed(page.decode(encoding))
        print parser.event_links()
        print parser.next_page()
        print '---------',parser.empty()
        if parser.empty():
            break
        else:
            all_event_links += parser.event_links()
            xxx_link = urljoin(xxx_url, parser.next_page())

