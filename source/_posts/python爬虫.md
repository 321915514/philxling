python爬虫基础

urllib库,url库含有四个模块

* request 是最基本的请求方式,error是异常处理信息,parse是解析的工具类,你可以将没有编码的url放在parse工具中编码和解码,robotparser主要是用来识别网站的 robots.txt 文件.

例: 

<!--more-->

```python
from urllib import request#导入库
response=request.urlopen('http://www.baidu.com')#请求baidu.com
print(response.read())
<!--more-->
request.urlretrieve('http://www.baidu.com','baidu.html')
#将百度的网页下载到本地baidu.html
#urlencode用法
#https://www.baidu.com/s?wd=hello&rsv_spt=1&rsv_iqid=0xc249d2880001381f&issp=1&f=8&rsv_bp=1&rsv_idx=2&ie=utf-8&tn=baiduhome_pg&rsv_enter=1&rsv_dl=tb&rsv_sug3=6&rsv_sug1=5&rsv_sug7=101&rsv_sug2=0&inputT=1310&rsv_sug4=2416
#将参数为中文的字符转换为浏览器能够识别的字符
data={'wd':'你好','age':12,'gender':'男'}
data=parse.urlencode(data)
print(data)
#wd=%E4%BD%A0%E5%A5%BD&age=12&gender=%E7%94%B7

#例
from urllib import request#导入库
from urllib import parse#用于编码
data={'wd':'你好'}
data=parse.urlencode(data)
response=request.urlopen('http://www.baidu.com/s?'+data)#请求baidu.com
print(response.read())

#解码


#parse_qs()解码
data=parse.parse_qs(data)
#url='http://www.baidu.com/s?'+data
print(data)


urlparse和urlsplit
#urlparse将url地址进行分割
#例
from urllib import parse
url='http://www.baidu.com/s?wd=hello&username=123#12'
print(parse.urlparse(url))

#ParseResult(scheme='http', netloc='www.baidu.com', path='/s', params='', query='wd=hello&username=123', fragment='12')
print(parse.urlparse(url).scheme)
print(parse.urlparse(url).netloc)
print(parse.urlsplit(url))
#SplitResult(scheme='http', netloc='www.baidu.com', path='/s', query='wd=hello&username=123', fragment='12')
#前者多了一个params参数
```

Request类

```python
from urllib import request

url='https://www.lagou.com/jobs/list_python?labelWords=&fromSearch=true&suginput='

headers={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'}
req=request.Request(url,headers=headers)

print(request.urlopen(req).read())

#Request()参数
```

代理设置

ProxyHandler处理器(代理设置)

```python
from urllib import request

url='https://httpbin.org/ip'

# print(request.urlopen(url).read())
#没有使用代理

#使用代理

handler=request.ProxyHandler({'http':'112.84.55.122:9999'})

openner=request.build_opener(handler)

res=openner.open(url)

print(res.read())


```

http.cookiejar保存cookie

```python
from urllib import request
from http.cookiejar import MozillaCookieJar
#保存cookie信息
cookieJar = MozillaCookieJar('cookie.txt')
#加载cookie
cookieJar.load(ignore_discard=True)
handler = request.HTTPCookieProcessor(cookieJar)
opener = request.build_opener(handler)
resp = opener.open("http://www.baidu.com")
cookieJar.save(ignore_discard=True)
#打印cookie信息
for cookie in cookieJar:
    print(cookie)

```

requests库

requests发送get请求

```python
import requests

params = {'wd': '中国', 'ie': 'utf-8',
'f': 3,
'rsv_bp': 1,
'rsv_idx': 2,
'tn': 'baiduhome_pg',
'rsv_spt': 1,
'oq': 100,
'rsv_pq': 9282010e00005646,
'rsv_t': '65b6ZN8IJiXpluNcz/pIQxWDy8QWRjCXH7ym3yqE583HxR32Ytg75ZGh3MGjaslBNJxC',
'rqlang': 'cn',
'rsv_enter': 1,
'rsv_dl': 'ts_0',
'rsv_sug3': 9,
'rsv_sug1': 10,
'rsv_sug7': 101,
'rsv_sug2': 1,
'prefixsug': 'zhongu',
'rsp': 0,
'inputT': 4623}
headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                         'Chrome/76.0.3809.100 Safari/537.36'}
response = requests.get('http://www.baidu.com/s', params=params, headers=headers)
# print(type(response.text)) #str类型 手动解码 
# print(type(response.content))# bytes类型 一般采用response.content.decode('utf-8')
print(response.url)
with open('baidu.html', 'w', encoding='utf-8') as fp:#将页面写在baidu.html上
    fp.write(response.content.decode('utf-8'))
print(response.content.decode('utf-8'))
# print(response.status_code)

```

发送post请求

```python
import requests

data = {
    'first': 'true',
    'pn': 1,
    'kd': 'python'
}
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                         'Chrome/76.0.3809.100 Safari/537.36',
    'Referer': 'https://www.lagou.com/jobs/list_python?labelWords=&fromSearch=true&suginput=',
    'Host': 'www.lagou.com'
}
# 使用代理
# proxy={
#     'http':'27.43.190.11:9999'
# }
response = requests.post('https://www.lagou.com/jobs/positionAjax.json?needAddtionalResult=false', data=data, headers=headers) #proxies=proxy)
print(response.text)

```

requests的cookie保存

```python
import requests

resp = requests.get('http://www.baidu.com')
print(resp.cookies.get_dict())

```

session 利用session保存信息并访问

```python
import requests

session=requests.session()#创建会话
session.post(url,data,headers)#登录
res=session.get(url)#访问页面
print(res.text)
```

数据的提取

XPath和lxml

```
		1 /AAA/DD/BBB 表示aaa下的dd下的bbb元素
		2 //aaa 选择所有的aaa元素
		3 //aaa/bbb 所有的aaa下的所有bbb元素
		4 /* 表示所有
		5 bbb[1] 表示bbb第一个元素
		6 bbb[@id] 只要bbb上有id属性，都能得到
		7 bbb[@id='b1'] 元素是bbb，上有id属性，并且属性的值为b1
		在某个标签下执行xpath在这个标签加.
		即 trs=html.xpath('//tr')
		   for i in trs:
		   		harf=i.xpath('.//a/@href')
		   		
		获取文本是text()即//a/text()
```

使用lxml解析html

```python
from lxml import etree

text = '''
<ul class="r_company_con">
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/9251.html">美柚</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/1373.html">喜马拉雅fm</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/14229.html">微盟</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/49369.html">淘粉吧</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/107435.html">熊猫TV</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/2768.html">易到用车</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/40738.html">小红唇</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/97631.html">汽车超人</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/109.html">蚂蜂窝</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/36996.html">三好网</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/4760.html">唯品会</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/1686.html">爱奇艺</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/23014.html">快法务</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/1575.html">百度招聘</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/81491.html">蚂蚁金服</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/62.html">今日头条</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/2474.html">滴滴</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/20909.html">AcFun</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/23489.html">点点客</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/59251.html">映客</a></li>
    	    		<li class="r_search_item"><a href="https://www.lagou.com/gongsi/3712.html">京东</a></li>
    	    </ul>   


'''


def parse_text():
    htmlElement = etree.HTML(text)  # 对象
    print(etree.tostring(htmlElement, encoding='utf-8').decode('utf-8'))


def parse_file():
    parser=etree.HTMLParser(encoding='utf-8') # 解析器
    htmlElement = etree.parse("lagou.html", parser=parser)
    print(etree.tostring(htmlElement, encoding='utf-8').decode('utf-8'))


if __name__ == '__main__':
    parse_file()
//解析html的代码有两种,一种是解析字符串类型的html代码直接使用etree.HTML(字符串)一种是解析html文件
使用parser=etree.HTMLParser(encoding='utf-8')  htmlElement = etree.parse("lagou.html", parser=parser)解析
如果有不规范的html代码就要自定义解析器parser=etree.HTMLParser(encoding='utf-8')
```

爬取电影天堂案例

```python
import pandas as pd
import requests
from lxml import etree
import xlwt
DOMAIN = 'https://www.dytt8.net'
HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                  'Chrome/76.0.3809.100 Safari/537.36'}

movies = []


def get_details():
    for i in range(1, 8):
        url = 'https://www.dytt8.net/html/gndy/dyzz/list_23_' + str(i) + '.html'
        response = requests.get(url, headers=HEADERS)
        text = response.text
        html = etree.HTML(text)
        detail_urls = html.xpath("//table[@class='tbspan']//a/@href")
        for detail_url in detail_urls:
            movie = parse_detail(DOMAIN + detail_url)
            movies.append(movie)
            # pf = pd.DataFrame(list(movie))
            #             # print(pf)
            # columns_map = {
            #     'title': '名称',
            #     'cover': '封面',
            #     'year': '年份',
            #     'country': '国家',
            #     'category': '分类',
            #     'douban_rating': '豆瓣评分',
            #     'size': '分辨率',
            #     'actors': '演员',
            #     'director': '导演',
            #     'label': '标签',
            #     'download_url': '下载地址',
            #     'profile': '简介'}
            # pf.rename(columns=columns_map, inplace=True)
            # pf.fillna(' ', inplace=True)
            # pf.to_excel('d:/my.xlsx', encoding='utf-8', index=False)
            # data = movie
            # data_df = pd.DataFrame(data)
            # data_df.index = range(1, 100)
            # writer = pd.ExcelWriter('my.xlsx')
            # data_df.to_excel(writer, float_format='%.5f')
            # writer.save()


def parse_detail(url):
    movie = {}
    response = requests.get(url, headers=HEADERS)
    text = response.content.decode('gbk')
    html = etree.HTML(text)
    movie['title'] = html.xpath("//div[@class='title_all']//font/text()")[0]
    if len(html.xpath("//div[@id='Zoom']//img/@src")):
        movie['cover'] = html.xpath("//div[@id='Zoom']//img/@src")[0]
    parse_movie_content(html, movie)  # 解析content
    movie_download_url = html.xpath("//td[@bgcolor='#fdfddf']/a/@href")
    movie['download_url'] = movie_download_url
    return movie


def parse_movie_content(html, movie):
    movie_content = html.xpath("//div[@id='Zoom']//p/text()")
    for index, info in enumerate(movie_content):
        if info.startswith("◎年　　代"):
            info = info.replace("◎年　　代", "").strip()
            movie['year'] = info
        if info.startswith("◎产　　地"):
            info = info.replace("◎产　　地", "").strip()
            movie['country'] = info
        if info.startswith("◎类　　别"):
            info = info.replace("◎类　　别", "").strip()
            movie['category'] = info
        if info.startswith("◎豆瓣评分"):
            info = info.replace("◎豆瓣评分", "").strip()
            movie['douban_rating'] = info
        if info.startswith("◎视频尺寸"):
            info = info.replace("◎视频尺寸", "").strip()
            movie['size'] = info
        if info.startswith('◎导　　演'):
            info = info.replace("◎导　　演", "").strip()
            movie["director"] = info
        if info.startswith('◎主　　演'):
            info = info.replace("◎主　　演", "").strip()
            actors = [info]
            for actor in range(index + 1, len(movie_content)):
                if movie_content[actor].startswith("◎标　　签"):
                    break
                actors.append(movie_content[actor].strip())
            movie["actors"] = actors
        if info.startswith('◎标　　签'):
            info = info.replace("◎标　　签", "").strip()
            movie['label'] = info
        if info.startswith('◎简　　介'):
            info = movie_content[index + 1].strip()
            movie["profile"] = info


if __name__ == '__main__':
    get_details()
    pf = pd.DataFrame(list(movies))
    columns_map = {
        'title': '名称',
        'cover': '封面',
        'year': '年份',
        'country': '国家',
        'category': '分类',
        'douban_rating': '豆瓣评分',
        'size': '分辨率',
        'actors': '演员',
        'director': '导演',
        'label': '标签',
        'download_url': '下载地址',
        'profile': '简介'}
    pf.rename(columns=columns_map, inplace=True)
    pf.to_excel('D:/my.xlsx', encoding='utf-8', index=False)

```

爬取公众号文章

```python
from typing import Dict

import requests
import json
import pandas as pd
from lxml import etree

url = 'https://data.wxb.com/rank/day/2020-02-22/%E7%A7%91%E6%8A%80?sort=&page=1&page_size=50&is_new=1'

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                  'Chrome/76.0.3809.100 Safari/537.36',
    'Cookie': 'PHPSESSID=beac3d26447612afc0000369ce0a6b37; Qs_lvt_288791=1582549381; Qs_pv_288791=4313460905624405000; '
              'aliyungf_tc=AQAAAKyqam5YtgQAWQMTOkuQHo7LO0N2; visit-wxb-id=847ecde119a5cefbe55b022b9af2debe ',
}

response=requests.get(url, headers=headers)
json_obj=json.loads(response.text,encoding='utf-8')
url_id=[]
articles = []
for i in json_obj['data']:
    url_id.append(i['wx_origin_id'])
for url in url_id:
    headers['Referer'] = 'https://data.wxb.com/details/postRead?id='+url
    for j in range(1, 11):
        resp = requests.get('https://data.wxb.com/account/statArticles/'+url+'?period=30&page='+str(j)+'&sort=', headers=headers)
        json_obj = json.loads(resp.text, encoding='utf-8')
        for i in json_obj['data']:
            article = {'title': i['title'], 'url': i['url']}
            articles.append(article)
            # for article in article_url:
            #     res=requests.get(article)
            #     print(res.url)
            #     print(res.text)
                # html=etree.HTML(res.text)
                # head=html.xpath("//head")
                # for i in head:
                #     print(etree.tostring(i, encoding='utf-8').decode('utf-8'))
pf = pd.DataFrame(list(articles))
columns = {
        'title': '名称',
        'url': '网址'
    }
pf.rename(columns=columns, inplace=True)
pf.to_excel('D:/公众号文章.xlsx', encoding='utf-8', index=False)

```

BeautifulSoup4解析

```python
1 .find_all('a',limit=*) //查所有的a标签,参数limit可以限制找到几个
2 .find_all('tr',class_='even')//查找所有的tr标签并且class为even
3 .find_all('tr',attrs={'class':'even'})
4 .find_all('tr',id='even')
5 //获取纯文本
	trs=soup.find_all('tr')//获取所有tr标签
	for tr in trs:
		title=tr[0].string//某个标签下有多行文本不能取到
		category=tr[1].string常用
		infos=list(tr.stripped_strings)//获取tr下的所有非空文本(常用)
6 .find('a')//返回第一个符合条件的a标签
7 contents和children//返回某个标签下的直接子元素,contents返回列表,children返回迭代器
8 使用css选择器,使用soup.select('css语法'),应该写css语法的字符串
```

中国天气网

```python
import requests
from bs4 import BeautifulSoup
from pyecharts import Bar

ALL_DATA = []


def main():
    page = ['hb', 'db', 'hd', 'hz', 'hn', 'xb', 'xn', 'gat']
    for url in page:
        url = 'http://www.weather.com.cn/textFC/' + url + '.shtml'
        parse_page(url)
    # 根据最低气温排序
    ALL_DATA.sort(key=lambda data: data['min_temp'])
    data = ALL_DATA[0:10]
    charts = Bar('中国最低气温排行榜')
    cities = list(map(lambda x: x['city'], data))
    temp = list(map(lambda x: x['min_temp'], data))
    charts.add('', cities, temp)
    charts.render('temperature.html')


def parse_page(url):
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                      'Chrome/76.0.3809.100 Safari/537.36'
    }
    response = requests.get(url, headers=headers)
    html = response.content.decode('utf-8')
    soup = BeautifulSoup(html, 'html5lib')
    div = soup.find_all('div', attrs={'class': 'conMidtab'})[0]
    tables = div.find_all('table')
    for table in tables:
        trs = table.find_all('tr')[2:]
        for tr in trs:
            tds = tr.find_all('td')
            city_td = tds[-8]
            city = list(city_td.stripped_strings)[0]
            temp_td = tds[-2]
            min_temp = list(temp_td.stripped_strings)[0]
            ALL_DATA.append({'city': city, 'min_temp': int(min_temp)})


if __name__ == '__main__':
    main()

```

正则表达式匹配

```python
import re

# 1 * 可以匹配0或任意多个字符
text = 'aqw+q123ad1232'
# result = re.match('\s*', text)
# + 匹配1个或多个字符
# result = re.match('\w+', text)
# aqw
# ? 匹配一个或0个(要么没有,要么就只有一个)
# result = re.match('\w?', text)
# a
# {m} 匹配m个字符
# result = re.match('\w{2}', text)
# aq
# {m, n} 匹配m-n个字符
test = '\\n'
test1 = 'apple is $22, orange is $12'
test2 = 'Hello ni hao'
result = re.search('\\\\n', test)  # \\\\表示 \\ 表示一个\ \\后面一个表示一个\ 即 \\n 用python匹配 则是\n
# aqw
res = re.findall('\$\d+', test1)
# ['$22', '$12']

# sub函数
print(re.sub('\$\d+', '0', test1))
# apple is 0, orange is 0
print(res)
print(re.split(' ', test2))
# ['Hello', 'ni', 'hao']

```

案例

```python
import re
# 验证手机号
text = '13991471643'
result = re.match('1[34578]\d{9}', text)
# print(result.group())
# 验证邮箱
email = '321915@163.com'
ret = re.match('\w+@[a-z0-9]+\.[a-z]+', email)

# 验证url

url = 'http://www.baidu.com/s?re=233'
resultUrl = re.match('(http|https|ftp)://[^\s]+', url)#

# 验证身份证

id = '61252619971008357x'
res = re.match('\d{17}[\dXx]', id)
print(res.group())

```

用正则表达式爬取古诗文网

```python
import re
import requests
import pandas as pd
poems = []


def get_urls():
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                      'Chrome/76.0.3809.100 Safari/537.36'
    }
    for i in range(1, 10):
        # response = requests.get('https://www.gushiwen.org/default_' + str(i) + '.aspx', headers=headers)
        response = requests.get('https://so.gushiwen.org/shiwen/default_0AA'+str(i)+'.aspx', headers=headers)
        html = response.text
        titles = re.findall(r'<div\sclass="cont".*?<b>(.*?)</b>', html, re.DOTALL)
        dynasties = re.findall(r'<p\sclass="source".*?<a.*?>(.*?)</a>', html, re.DOTALL)
        authors = re.findall(r'<p\sclass="source">.*?<span.*?<a.*?>(.*?)</a>', html, re.DOTALL)
        content_tag = re.findall(r'<div\sclass="contson".*?>(.*?)</div>', html, re.DOTALL)
        contents = []
        for content in content_tag:
            content = re.sub(r'<.*?>', '', content)
            contents.append(content.strip())
        for value in zip(titles, dynasties, authors, contents):
            title, dynasty, author, content = value
            poem = {
                'title': title,
                'dynasty': dynasty,
                'author': author,
                'content': content
            }
            poems.append(poem)


if __name__ == '__main__':
    get_urls()
    pf = pd.DataFrame(list(poems))
    columns = {
        'title': '诗名',
        'dynasty': '朝代',
        'author': '作者',
        'content': '内容'
        }
    pf.rename(columns=columns, inplace=True)
    pf.to_excel('D:/古诗词.xlsx', encoding='utf-8', index=False)
    print(len(poems))

```

json数据

```python
//字符转json
json.dumps(json_str)
//json转python对象
json.loads(json字符串)
```

将json写入文件

![image-20200228161318410](assets/image-20200228161318410.png)

csv文件

![image-20200228175101405](assets/image-20200228175101405.png)

![image-20200228175137667](assets/image-20200228175137667.png)

多线程

```python
import threading
import time

value = 0

def writer_():
    global value
    for i in range(1000000):
        value += 1
    print(value)

def drawing():
    global value
    for i in range(1000000):
        value += 1
    print(value)


def main():
    threading.Thread(target=writer_).start()
    threading.Thread(target=drawing).start()


if __name__ == '__main__':
    main()
#  1254106
#  1396958
# 出现线程抢占问题
```

```python
import threading
import time

value = 0

gLock = threading.Lock() # 创建锁

def writer_():
    global value
    gLock.acquire()  # 加锁
    for i in range(1000000000):
        value += 1
    gLock.release()  # 释放锁
    print(value)


def main():
    threading.Thread(target=writer_).start()
    threading.Thread(target=writer_).start()


if __name__ == '__main__':
    main()

```

lock版生产者消费者

```python
# 生产者消费者

import threading
import time
import random

gTimes = 0
gTotalTimes = 10
gMoney = 1000

gLock = threading.Lock()


class Producer(threading.Thread):
    def run(self):
        global gMoney
        global gTimes
        while True:
            money = random.randint(100, 1000)
            gLock.acquire()
            if gTimes > gTotalTimes:
                gLock.release()
                break
            gMoney += money
            gTimes += 1
            print('%s生产了%d的钱,还剩%d的钱' % (threading.current_thread(), money, gMoney))
            gLock.release()
            time.sleep(0.5)


class Consumer(threading.Thread):
    def run(self):
        global gMoney
        while True:
            money = random.randint(100, 1000)
            gLock.acquire()
            if money <= gMoney:
                gMoney -= money
                print('%s消费了%d的钱,还剩%d的钱' % (threading.current_thread(), money, gMoney))
            else:
                if gTimes > gTotalTimes:
                    gLock.release()
                    break
                print('%s消费%d的钱,还剩%d的钱,钱不足' % (threading.current_thread(), money, gMoney))
            gLock.release()
            time.sleep(0.5)


def main():
    for x in range(5):
        Consumer(name='消费者%d' % x).start()
    for x in range(5):
        Producer(name='生产者%d' % x).start()


if __name__ == '__main__':
    main()

```

condition版,即线程通信的方式

```python
# 生产者消费者

import threading
import time
import random

gTimes = 0
gTotalTimes = 10
gMoney = 1000

gCondition = threading.Condition()


class Producer(threading.Thread):
    def run(self):
        global gMoney
        global gTimes
        while True:
            money = random.randint(100, 1000)
            gCondition.acquire()
            if gTimes > gTotalTimes:
                gCondition.release()
                break
            gMoney += money
            gCondition.notify_all()
            gTimes += 1
            print('%s生产了%d的钱,还剩%d的钱' % (threading.current_thread(), money, gMoney))
            gCondition.release()
            time.sleep(0.5)


class Consumer(threading.Thread):
    def run(self):
        global gMoney
        while True:
            money = random.randint(100, 1000)
            gCondition.acquire()
            while gMoney < money:
                if gTimes >= gTotalTimes:
                    gCondition.release()
                    return
                print('%s准备消费%d,还剩%d的钱,钱不足' % (threading.current_thread(), money, gMoney))
                gCondition.wait()
            gMoney -= money
            print('%s消费了%d的钱,还剩%d的钱' % (threading.current_thread(), money, gMoney))
            gCondition.release()
            time.sleep(0.5)


def main():
    for x in range(5):
        Consumer(name='消费者%d' % x).start()
    for x in range(5):
        Producer(name='生产者%d' % x).start()


if __name__ == '__main__':
    main()

    
    
    
<Consumer(消费者0, started 11240)>消费了811的钱,还剩189的钱
<Consumer(消费者1, started 16408)>消费了153的钱,还剩36的钱
<Consumer(消费者2, started 14100)>准备消费762,还剩36的钱,钱不足
<Consumer(消费者3, started 12012)>准备消费512,还剩36的钱,钱不足
<Consumer(消费者4, started 6924)>准备消费568,还剩36的钱,钱不足
<Producer(生产者0, started 18116)>生产了692的钱,还剩728的钱
<Consumer(消费者2, started 14100)>准备消费762,还剩728的钱,钱不足
<Consumer(消费者3, started 12012)>消费了512的钱,还剩216的钱
<Consumer(消费者4, started 6924)>准备消费568,还剩216的钱,钱不足
<Producer(生产者1, started 18792)>生产了523的钱,还剩739的钱
<Producer(生产者2, started 19104)>生产了457的钱,还剩1196的钱
<Consumer(消费者2, started 14100)>消费了762的钱,还剩434的钱
<Consumer(消费者4, started 6924)>准备消费568,还剩434的钱,钱不足
<Producer(生产者3, started 17256)>生产了171的钱,还剩605的钱
<Producer(生产者4, started 1284)>生产了486的钱,还剩1091的钱
<Consumer(消费者4, started 6924)>消费了568的钱,还剩523的钱
<Consumer(消费者0, started 11240)>准备消费584,还剩523的钱,钱不足
<Consumer(消费者1, started 16408)>准备消费605,还剩523的钱,钱不足
<Producer(生产者2, started 19104)>生产了774的钱,还剩1297的钱
<Consumer(消费者3, started 12012)>消费了621的钱,还剩676的钱
<Consumer(消费者0, started 11240)>消费了584的钱,还剩92的钱
<Consumer(消费者1, started 16408)>准备消费605,还剩92的钱,钱不足
<Producer(生产者0, started 18116)>生产了383的钱,还剩475的钱
<Producer(生产者1, started 18792)>生产了639的钱,还剩1114的钱
<Consumer(消费者1, started 16408)>消费了605的钱,还剩509的钱
<Consumer(消费者4, started 6924)>消费了116的钱,还剩393的钱
<Producer(生产者3, started 17256)>生产了550的钱,还剩943的钱
<Consumer(消费者2, started 14100)>消费了543的钱,还剩400的钱
<Producer(生产者4, started 1284)>生产了957的钱,还剩1357的钱
<Consumer(消费者3, started 12012)>消费了754的钱,还剩603的钱
<Producer(生产者2, started 19104)>生产了463的钱,还剩1066的钱
<Consumer(消费者0, started 11240)>消费了778的钱,还剩288的钱
```

队列 queue

from queue import Queue

使用多线程爬取表情包

```python
import requests
import os
import re
from lxml import etree
import threading
from queue import Queue

# 生产者消费者下载表情包
#  其中需要两个队列,一个是获取每一页的url 还有一个获取每个表情的url
# 生产者负责获取每个表情包的url,消费者负责将表情的url写进文件

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                  'Chrome/76.0.3809.100 Safari/537.36 '
}


class Producer(threading.Thread):
    def __init__(self, page_queue, img_queue, *args, **kwargs):  # 构造函数
        super(Producer, self).__init__(*args, **kwargs)  # 继承父类的方法
        self.page_queue = page_queue
        self.img_queue = img_queue

    def run(self):
        while True:
            if self.page_queue.empty():
                break
            url = self.page_queue.get()
            self.parse_page(url)

    def parse_page(self, url):
        response = requests.get(url, headers=headers)
        html = etree.HTML(response.text)
        images = html.xpath("//div[@class='page-content text-center']//img[@class!='gif']")
        for img in images:
            file_url = img.get('data-original')
            alt = img.get('alt')
            suffix = os.path.splitext(file_url)
            alt = re.sub(r"[!\?,\.！？]", '', alt)
            filename = alt + suffix[1]
            self.img_queue.put((file_url, filename))
            # download_img(file_url, filename)
            # 此处不能用urllib.request.urlretrieve() 会403


class Consumer(threading.Thread):
    def __init__(self, page_queue, img_queue, *args, **kwargs):  # 构造函数
        super(Consumer, self).__init__(*args, **kwargs)  # 继承父类的方法
        self.page_queue = page_queue
        self.img_queue = img_queue

    def run(self):
        while True:
            if self.img_queue.empty() and self.page_queue.empty():
                break
            img_url, filename = self.img_queue.get()  # 解析元组
            self.download_img(img_url, filename)

    def download_img(self, url, filename):
        file_name = 'D:\\images\\' + filename
        response = requests.get(url, headers=headers)
        with open(file_name, 'wb') as f:
            f.write(response.content)
        print(filename + '下载完成')


def main():
    page_queue = Queue(100)
    img_queue = Queue(50000)
    for i in range(1, 101):
        url = 'http://www.doutula.com/photo/list/?page=%d' % i
        page_queue.put(url)  # 将每一页的url加入队列中
    for i in range(5):
        Producer(page_queue, img_queue).start()
    for i in range(5):
        Consumer(page_queue, img_queue).start()


if __name__ == '__main__':
    main()

```

selenium与chromedriver

安装selenium

```
pip install selenium
```

安装chromedriver(安装与自己浏览器匹配的版本,将chromedriver放在不含中文的文件夹下)

```
https://npm.taobao.org/mirrors/chromedriver/
```

selenium测试和行为链

```python

from selenium import webdriver
#  行为链
from selenium.webdriver.common.action_chains import ActionChains
driver_path = r'E:\Program Files\chromedriver\chromedriver.exe'
driver = webdriver.Chrome(executable_path=driver_path)
driver.get('http://www.baidu.com')
actions = ActionChains(driver)
inputTag = driver.find_element_by_name('wd')
submit = driver.find_element_by_id('su')
actions.move_to_element(inputTag)
actions.send_keys_to_element(inputTag, 'python')
actions.move_to_element(submit)
actions.click(submit)
actions.perform()
```

selenium api文档

```
https://selenium-python.readthedocs.io/api.html#module-selenium.webdriver.common.action_chains
```

操作cookie

```python
for cookie in driver.get_cookies():
    print(cookie)

print(driver.get_cookie('PSTM'))

print(driver.delete_cookie('PSTM'))

print(driver.delete_all_cookies())

```

显示等待和隐式等待

```python

from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By

driver_path = r'E:\Program Files\chromedriver\chromedriver.exe'

driver = webdriver.Chrome(driver_path)
driver.get('http://www.douban.com')
# driver.implicitly_wait(5)  # 隐式等待

WebDriverWait(driver, 10).until(  # 显示等待 当元素出现就返回
    EC.presence_of_element_located((By.ID, 'anony-group'))
)
# driver.find_element_by_name('weweweew')

```

页面切换

```python
from selenium import webdriver

driver_path = r'E:\Program Files\chromedriver\chromedriver.exe'

driver = webdriver.Chrome(driver_path)

driver.get('http://www.baidu.com')

driver.execute_script("window.open('http://www.douban.com')")
driver.switch_to.window(driver.window_handles[1])  # driver.window_handles[1] 页面句柄 
# switch_to.window 跳转页面
print(driver.current_url)

```

使用代理

```python
from selenium import webdriver
driver_path = r'E:\Program Files\chromedriver\chromedriver.exe'
options = webdriver.ChromeOptions()  # 代理
options.add_argument('--proxy-server=http://119.57.108.65:53281')
driver = webdriver.Chrome(executable_path=driver_path, chrome_options=options)

driver.get('http://httpbin.org/ip')
```

```
# 对元素进行操作
from selenium.webdriver.remote.webelement import WebElement
# 对元素进行操作
submitBtn = driver.fin_element_by_id('su')
print(submitBtn.get_attribute("value"))
```

selenium实现获取拉勾网职位信息

```python
from selenium import webdriver
from lxml import etree
import re
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By


class requesst_url():
    driver_path = r'E:\Program Files\chromedriver\chromedriver.exe'

    def __init__(self):
        self.driver = webdriver.Chrome(requesst_url.driver_path)
        self.url = 'https://www.lagou.com/jobs/list_python?labelWords=&fromSearch=true&suginput='
        self.positions = []

    def run(self):
        self.driver.get(self.url)
        self.driver.find_element_by_xpath("//div[@class='body-btn']").click()
        while True:
            source = self.driver.page_source
            self.parse_page(source)
            WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.XPATH, "//div[@class='pager_container']//span[last()]"))
            )
            next_btn = self.driver.find_element_by_xpath("//div[@class='pager_container']//span[last()]")
            if 'pager_next_disabled' in next_btn.get_attribute('class'):
                break
            else:
                next_btn.click()

    def parse_page(self, source):
        html = etree.HTML(source)
        detail_urls = html.xpath("//a[@class='position_link']/@href")
        for detail_url in detail_urls:
            self.driver.execute_script("window.open('%s')" % detail_url) # 切换到新的页面
            self.driver.switch_to.window(self.driver.window_handles[1])
            WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.XPATH, "//div[@class='job-name']"))
            )
            source = self.driver.page_source
            self.parse_detail_page(source)
            self.driver.close()
            self.driver.switch_to.window(self.driver.window_handles[0]) # 切换到原来的页面

    def parse_detail_page(self, source):
        html = etree.HTML(source)
        position_name = html.xpath("//div[@class='job-name']/@title")[0]
        spans = html.xpath("//dd[@class='job_request']")[0]
        salary = spans.xpath(".//span[@class='salary']/text()")[0].strip()
        city = re.sub(r"[\s/]", '', spans.xpath(".//span/text()")[1]).strip()
        work_years = re.sub(r"[\s/]", '', spans.xpath(".//span/text()")[2]).strip()
        company_name = html.xpath("//div[@class='job_company_content']//em/text()")[0].strip()
        require = re.sub(r"[\s/]", '', spans.xpath(".//span/text()")[3]).strip()
        description = "".join(html.xpath("//div[@class='job-detail']//text()")).strip()
        position = {
            'position_name': position_name,
            'salary': salary,
            'city': city,
            'work_years': work_years,
            'company_name': company_name,
            'require': require,
            'description': description
        }
        self.positions.append(position)
        print(position)



def main():
    requesst_url().run()


if __name__ == '__main__':
    main()

```

图形验证码识别技术

tesseract的安装

```
https://digi.bib.uni-mannheim.de/tesseract/
```

配置环境变量

```
D:\Program Files\Tesseract-OCR\tessdata
```

测试验证码

```python

import pytesseract
import time
from urllib import request
from PIL import Image


def main():
    pytesseract.pytesseract.tesseract_cmd = r'D:\Program Files\Tesseract-OCR\tesseract.exe'
    while True:
        time_stamp = int(time.time())
        url = 'http://47.103.204.177/BookStore/Vcode?a=%d' % time_stamp
        request.urlretrieve(url, 'captcha.png')
        image = Image.open('captcha.png')
        text = pytesseract.image_to_string(image)
        print(text)
        time.sleep(2)


if __name__ == '__main__':
    main()

```

Scrapy框架

![image-20200305165442113](assets/image-20200305165442113.png)

安装

```
pip install scrapy
# windows下还要安装
pip install pypiwin32
```

文档

scrapy中文文档

```
https://scrapy-chs.readthedocs.io/zh_CN/1.0/intro/overview.html
```

使用命令行创建项目

创建项目前将scrapy加到环境变量

```
scrapy startproject 项目名称
```

目录结构

![image-20200305162348095](assets/image-20200305162348095.png)

使用命令生成一个爬虫

项目路径:

![image-20200305162546702](assets/image-20200305162546702.png)

进入项目下创建

![image-20200305162952859](assets/image-20200305162952859.png)

(创建爬虫项目要与项目名不一样)

生成项目

```python
# -*- coding: utf-8 -*-
import scrapy


class QsbkSpiderSpider(scrapy.Spider):
    name = 'qsbk_spider'
    allowed_domains = ['funnyba.com']
    start_urls = ['http://funnyba.com/']

    def parse(self, response):
        pass

```

在settings设置

```
ROBOTSTXT_OBEY = False  # 机器人协议
```

在请求头添加User-Agent

```python
DEFAULT_REQUEST_HEADERS = {
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'en',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                  'Chrome/80.0.3987.132 Safari/537.36 '
}
```

例:爬取段子

qsbk_spider.py代码

```python
# -*- coding: utf-8 -*-
import scrapy
import re

from scrapy_demo.qsbk.qsbk.items import QsbkItem


class QsbkSpiderSpider(scrapy.Spider):
    name = 'qsbk_spider'
    allowed_domains = ['xiaohuabang.cn']
    start_urls = []
    for i in range(1, 190):
        start_urls.append('http://www.xiaohuabang.cn/duanzi/hunduanzi/p%d/' % i)
    def parse(self, response):
        hrefs = response.xpath("//a[@class='link_more']/@href").getall()
        for href in hrefs:
            url = 'http://www.xiaohuabang.cn'+href
            yield scrapy.Request(url, callback=self.parse_detail)

    def parse_detail(self, response):
        title = response.xpath("//em[contains(@style,'font')]/text()").get()
        content = "".join(response.xpath("//div[@class='block untagged noline']//div[@class='content']//text()").getall()).strip()
        content = re.sub(r"[\s\n\s?]", '', content)
        item = QsbkItem(title=title, content=content)

        yield item

        
```

pipelines.py代码

```python
# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html
import json
from scrapy.exporters import JsonLinesItemExporter
class QsbkPipeline(object):
    def __init__(self):
        self.fp = open("duanzi.json", "wb")
        self.exporter = JsonLinesItemExporter(self.fp, ensure_ascii=False, encoding='utf-8')

    def open_spider(self, spider):
        pass

    def process_item(self, item, spider):
        self.exporter.export_item(item)
        return item

    def close_spider(self, spider):
        self.fp.close()

```

CrawlSpider爬虫

LinkExtractors链接提取器

常用参数

```
allow=() #允许的url,满足这个正则的url都会被提取
deny=() 禁止的url,满足这个正则的url都不会被提取
```

Rule 规则类

创建crawl模板的spider

![image-20200306135437033](assets/image-20200306135437033.png)

```
scrapy startproject 项目名称
进入项目下
即cd 项目名称
创建 crawl模板的spider
scrapy genspider -t crawl wxapp_spider "域名"
```

需要使用LinkExtractors和Rule 规则

```python
    start_urls = ['http://www.wxapp-union.com/portal.php?mod=list&catid=2&page=1']
    # start_url 是爬虫开始的url

    rules = (
        Rule(LinkExtractor(allow=r'.+mod=list&catid=2&page=\d'), follow=True),
        Rule(LinkExtractor(allow=".+article-.+\.html"), callback="parse_detail", follow=False)
    )
    # 重点是rules 其中的Rule(LinkExtractor(allow="")#allow 使用正则表达式,区分所有的url follow表示 是否要跟进比如前十页后面还有则设置为true 为详情页的rule设置callback是返回执行的解析函数,follow不跟进, 什么情况下需要指定callback如果这个url只为获取更多的url并不需要里面的数据, 则不用设置,若这个url需要获取页面的信息则要指定callback
```

```python
# -*- coding: utf-8 -*-
import scrapy
from scrapy.linkextractors import LinkExtractor
from scrapy.spiders import CrawlSpider, Rule

from scrapy_demo.wxapp.wxapp.items import WxappItem


class WxappSpiderSpider(CrawlSpider):
    name = 'wxapp_spider'
    allowed_domains = ['wxapp-union.com']
    start_urls = ['http://www.wxapp-union.com/portal.php?mod=list&catid=2&page=1']

    rules = (
        Rule(LinkExtractor(allow=r'.+mod=list&catid=2&page=\d'), follow=True),
        Rule(LinkExtractor(allow=".+article-.+\.html"), callback="parse_detail", follow=False)
    )

    def parse_detail(self, response):
        # item = {}
        # item['domain_id'] = response.xpath('//input[@id="sid"]/@value').get()
        # item['name'] = response.xpath('//div[@id="name"]').get()
        # item['description'] = response.xpath('//div[@id="description"]').get()
        title = response.xpath("//h1[@class='ph']/text()").get()
        author_p = response.xpath("//p[@class='authors']")
        author = author_p.xpath(".//a/text()").get()
        pub_time = author_p.xpath(".//span/text()").get()
        article_content = "".join(response.xpath("//td[@id='article_content']//text()").getall()).strip()
        # print(article_content)
        # print("author: %s,pub_time: %s" % (author, pub_time))
        item = WxappItem(title=title, author=author, pub_time=pub_time, content=article_content)
        yield item

```

```python
# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html

from scrapy.exporters import JsonLinesItemExporter

class WxappPipeline(object):

    def __init__(self):
        self.fp = open('wxapp.json', 'wb')
        self.exporters = JsonLinesItemExporter(self.fp, ensure_ascii=False, encoding="utf-8")

    def process_item(self, item, spider):
        self.exporters.export_item(item)
        return item

    def close_spider(self):
        self.fp.close()

```

主意要开启

```
ITEM_PIPELINES = {
   'wxapp.pipelines.WxappPipeline': 300,
}
```

```python
# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class WxappItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    title = scrapy.Field()
    author = scrapy.Field()
    pub_time = scrapy.Field()
    content = scrapy.Field()


```

Scrapy shell 

![image-20200306140125182](assets/image-20200306140125182.png)

request和response对象

![image-20200306141415606](assets/image-20200306141415606.png)

![image-20200306141525160](assets/image-20200306141525160.png)

发送post请求

重写start_request方法,使用FormRequest()

![image-20200306165729994](assets/image-20200306165729994.png)

模拟登录豆瓣网

