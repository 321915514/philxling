---
date: 2020-3-24 13:56:23
categories: python爬虫
tags: [python爬虫,python]
top: 6
title: 正则表达式和re模块
---
# 3-正则表达式和re模块

## 什么是正则表达式：

通俗理解：按照一定的规则，从某个字符串中匹配出想要的数据。这个规则就是正则表达式。
标准答案：https://baike.baidu.com/item/正则表达式/1700215?fr=aladdin

## 一个段子：
世界是分为两种人，一种是懂正则表达式的，一种是不懂正则表达式的.
<!--more-->
## 正则表达式常用匹配规则：

### 匹配某个字符串：

```python
text = 'hello'
ret = re.match('he',text)
print(ret.group())
>> he
```

以上便可以在`hello`中，匹配出`he`。

### 点（.）匹配任意的字符：

```python
text = "ab"
ret = re.match('.',text)
print(ret.group())
>> a
```

但是点（.）不能匹配不到换行符。示例代码如下：

```python
text = "ab"
ret = re.match('.',text)
print(ret.group())
>> AttributeError: 'NoneType' object has no attribute 'group'
```

### \d匹配任意的数字：

```python
text = "123"
ret = re.match('\d',text)
print(ret.group())
>> 1
```

### \D匹配任意的非数字：

```python
text = "a"
ret = re.match('\D',text)
print(ret.group())
>> a
```

而如果text是等于一个数字，那么就匹配不成功了。示例代码如下：

```python
text = "1"
ret = re.match('\D',text)
print(ret.group())
>> AttributeError: 'NoneType' object has no attribute 'group'
```

### \s匹配的是空白字符（包括：\n，\t，\r和空格）：

```python
text = "\t"
ret = re.match('\s',text)
print(ret.group())
>> 空白
```

### \w匹配的是`a-z`和`A-Z`以及数字和下划线：

```python
text = "_"
ret = re.match('\w',text)
print(ret.group())
>> _
```

而如果要匹配一个其他的字符，那么就匹配不到。示例代码如下：

```python
text = "+"
ret = re.match('\w',text)
print(ret.group())
>> AttributeError: 'NoneType' object has no attribute
```

### \W匹配的是和\w相反的：

```python
text = "+"
ret = re.match('\W',text)
print(ret.group())
>> +
```

而如果你的text是一个下划线或者英文字符，那么就匹配不到了。示例代码如下：

```python
text = "_"
ret = re.match('\W',text)
print(ret.group())
>> AttributeError: 'NoneType' object has no attribute
```

### []组合的方式，只要满足中括号中的某一项都算匹配成功：

```python
text = "0731-88888888"
ret = re.match('[\d\-]+',text)
print(ret.group())
>> 0731-88888888
```

之前讲到的几种匹配规则，其实可以使用中括号的形式来进行替代：

- \d：[0-9]
- \D：[0-9](#fn_0-9)
- \w：[0-9a-zA-Z_]
- \W：[^0-9a-zA-Z_]

### 匹配多个字符：

1. `*`：可以匹配0或者任意多个字符。示例代码如下：

   ```python
    text = "0731"
    ret = re.match('\d*',text)
    print(ret.group())
    >> 0731
   ```

   以上因为匹配的要求是`\d`，那么就要求是数字，后面跟了一个星号，就可以匹配到0731这四个字符。

2. `+`：可以匹配1个或者多个字符。最少一个。示例代码如下：

   ```python
    text = "abc"
    ret = re.match('\w+',text)
    print(ret.group())
    >> abc
   ```

   因为匹配的是`\w`，那么就要求是英文字符，后面跟了一个加号，意味着最少要有一个满足`\w`的字符才能够匹配到。如果text是一个空白字符或者是一个不满足\w的字符，那么就会报错。示例代码如下：

   ```python
    text = ""
    ret = re.match('\w+',text)
    print(ret.group())
    >> AttributeError: 'NoneType' object has no attribute
   ```

3. `?`：匹配的字符可以出现一次或者不出现（0或者1）。示例代码如下：

   ```python
    text = "123"
    ret = re.match('\d?',text)
    print(ret.group())
    >> 1
   ```

4. `{m}`：匹配m个字符。示例代码如下：

   ```python
    text = "123"
    ret = re.match('\d{2}',text)
    print(ret.group())
    >> 12
   ```

5. `{m,n}`：匹配m-n个字符。在这中间的字符都可以匹配到。示例代码如下：

   ```python
    text = "123"
    ret = re.match('\d{1,2}',text)
    prit(ret.group())
    >> 12
   ```

   如果text只有一个字符，那么也可以匹配出来。示例代码如下：

   ```python
    text = "1"
    ret = re.match('\d{1,2}',text)
    prit(ret.group())
    >> 1
   ```

### 小案例：

1. 验证手机号码：手机号码的规则是以`1`开头，第二位可以是`34587`，后面那9位就可以随意了。示例代码如下：

   ```python
    text = "18570631587"
    ret = re.match('1[34587]\d{9}',text)
    print(ret.group())
    >> 18570631587
   ```

   而如果是个不满足条件的手机号码。那么就匹配不到了。示例代码如下：

   ```python
    text = "1857063158"
    ret = re.match('1[34587]\d{9}',text)
    print(ret.group())
    >> AttributeError: 'NoneType' object has no attribute
   ```

2. 验证邮箱：邮箱的规则是邮箱名称是用`数字、数字、下划线`组成的，然后是`@`符号，后面就是域名了。示例代码如下：

   ```python
    text = "hynever@163.com"
    ret = re.match('\w+@\w+\.[a-zA-Z\.]+',text)
    print(ret.group())
   ```

3. 验证URL：URL的规则是前面是`http`或者`https`或者是`ftp`然后再加上一个冒号，再加上一个斜杠，再后面就是可以出现任意非空白字符了。示例代码如下：

   ```python
    text = "http://www.baidu.com/"
    ret = re.match('(http|https|ftp)://[^\s]+',text)
    print(ret.group())
   ```

4. 验证身份证：身份证的规则是，总共有18位，前面17位都是数字，后面一位可以是数字，也可以是小写的x，也可以是大写的X。示例代码如下：

   ```python
    text = "3113111890812323X"
    ret = re.match('\d{17}[\dxX]',text)
    print(ret.group())
   ```

### ^（脱字号）：表示以...开始：

```python
text = "hello"
ret = re.match('^h',text)
print(ret.group())
```

如果是在中括号中，那么代表的是取反操作.

### $：表示以...结束：

```python
# 匹配163.com的邮箱
text = "xxx@163.com"
ret = re.search('\w+@163\.com$',text)
print(ret.group())
>> xxx@163.com
```

### |：匹配多个表达式或者字符串：

```python
text = "hello|world"
ret = re.search('hello',text)
print(ret.group())
>> hello
```

### 贪婪模式和非贪婪模式：

贪婪模式：正则表达式会匹配尽量多的字符。默认是贪婪模式。
非贪婪模式：正则表达式会尽量少的匹配字符。
示例代码如下：

```python
text = "0123456"
ret = re.match('\d+',text)
print(ret.group())
# 因为默认采用贪婪模式，所以会输出0123456
>> 0123456
```

可以改成非贪婪模式，那么就只会匹配到0。示例代码如下：

```python
text = "0123456"
ret = re.match('\d+?',text)
print(ret.group())
```

### 案例：匹配`0-100`之间的数字：

```python
text = '99'
ret = re.match('[1-9]?\d$|100$',text)
print(ret.group())
>> 99
```

而如果`text=101`，那么就会抛出一个异常。示例代码如下：

```python
text = '101'
ret = re.match('[1-9]?\d$|100$',text)
print(ret.group())
>> AttributeError: 'NoneType' object has no attribute 'group'
```

### 转义字符和原生字符串：

在正则表达式中，有些字符是有特殊意义的字符。因此如果想要匹配这些字符，那么就必须使用反斜杠进行转义。比如`$`代表的是以...结尾，如果想要匹配`$`，那么就必须使用`\$`。示例代码如下：

```python
text = "apple price is \$99,orange paice is $88"
ret = re.search('\$(\d+)',text)
print(ret.group())
>> $99
```

原生字符串：
在正则表达式中，`\`是专门用来做转义的。在Python中`\`也是用来做转义的。因此如果想要在普通的字符串中匹配出`\`，那么要给出四个`\`。示例代码如下：

```python
text = "apple \c"
ret = re.search('\\\\c',text)
print(ret.group())
```

因此要使用原生字符串就可以解决这个问题：

```python
text = "apple \c"
ret = re.search(r'\\c',text)
print(ret.group())
```

------

## re模块中常用函数：

### match：

从开始的位置进行匹配。如果开始的位置没有匹配到。就直接失败了。示例代码如下：

```python
text = 'hello'
ret = re.match('h',text)
print(ret.group())
>> h
```

如果第一个字母不是`h`，那么就会失败。示例代码如下：

```python
text = 'ahello'
ret = re.match('h',text)
print(ret.group())
>> AttributeError: 'NoneType' object has no attribute 'group'
```

如果想要匹配换行的数据，那么就要传入一个`flag=re.DOTALL`，就可以匹配换行符了。示例代码如下：

```python
text = "abc\nabc"
ret = re.match('abc.*abc',text,re.DOTALL)
print(ret.group())
```

### search：

在字符串中找满足条件的字符。如果找到，就返回。说白了，就是只会找到第一个满足条件的。

```python
text = 'apple price $99 orange price $88'
ret = re.search('\d+',text)
print(ret.group())
>> 99
```

### 分组：

在正则表达式中，可以对过滤到的字符串进行分组。分组使用圆括号的方式。

1. `group`：和`group(0)`是等价的，返回的是整个满足条件的字符串。
2. `groups`：返回的是里面的子组。索引从1开始。
3. `group(1)`：返回的是第一个子组，可以传入多个。
   示例代码如下：

```python
text = "apple price is $99,orange price is $10"
ret = re.search(r".*(\$\d+).*(\$\d+)",text)
print(ret.group())
print(ret.group(0))
print(ret.group(1))
print(ret.group(2))
print(ret.groups())
```

### findall：

找出所有满足条件的，返回的是一个列表。

```python
text = 'apple price $99 orange price $88'
ret = re.findall('\d+',text)
print(ret)
>> ['99', '88']
```

### sub：

用来替换字符串。将匹配到的字符串替换为其他字符串。

```python
text = 'apple price $99 orange price $88'
ret = re.sub('\d+','0',text)
print(ret)
>> apple price $0 orange price $0
```

`sub`函数的案例，获取拉勾网中的数据：

```python
html = """
<div>
<p>基本要求：</p>
<p>1、精通HTML5、CSS3、 JavaScript等Web前端开发技术，对html5页面适配充分了解，熟悉不同浏览器间的差异，熟练写出兼容各种浏览器的代码；</p>
<p>2、熟悉运用常见JS开发框架，如JQuery、vue、angular，能快速高效实现各种交互效果；</p>
<p>3、熟悉编写能够自动适应HTML5界面，能让网页格式自动适应各款各大小的手机；</p>
<p>4、利用HTML5相关技术开发移动平台、PC终端的前端页面，实现HTML5模板化；</p>
<p>5、熟悉手机端和PC端web实现的差异，有移动平台web前端开发经验，了解移动互联网产品和行业，有在Android,iOS等平台下HTML5+CSS+JavaScript（或移动JS框架）开发经验者优先考虑；6、良好的沟通能力和团队协作精神，对移动互联网行业有浓厚兴趣，有较强的研究能力和学习能力；</p>
<p>7、能够承担公司前端培训工作，对公司各业务线的前端（HTML5\CSS3）工作进行支撑和指导。</p>
<p><br></p>
<p>岗位职责：</p>
<p>1、利用html5及相关技术开发移动平台、微信、APP等前端页面，各类交互的实现；</p>
<p>2、持续的优化前端体验和页面响应速度，并保证兼容性和执行效率；</p>
<p>3、根据产品需求，分析并给出最优的页面前端结构解决方案；</p>
<p>4、协助后台及客户端开发人员完成功能开发和调试；</p>
<p>5、移动端主流浏览器的适配、移动端界面自适应研发。</p>
</div>
"""

ret = re.sub('</?[a-zA-Z0-9]+>',"",html)
print(ret)
```

### split：

使用正则表达式来分割字符串。

```python
text = "hello world ni hao"
ret = re.split('\W',text)
print(ret)
>> ["hello","world","ni","hao"]
```

### compile：

对于一些经常要用到的正则表达式，可以使用`compile`进行编译，后期再使用的时候可以直接拿过来用，执行效率会更快。而且`compile`还可以指定`flag=re.VERBOSE`，在写正则表达式的时候可以做好注释。示例代码如下：

```python
text = "the number is 20.50"
r = re.compile(r"""
                \d+ # 小数点前面的数字
                \.? # 小数点
                \d* # 小数点后面的数字
                """,re.VERBOSE)
ret = re.search(r,text)
print(ret.group())
```