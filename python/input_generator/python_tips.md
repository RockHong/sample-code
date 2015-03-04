varMap = {}
len(varMap)   # test if a map is empty or not

---
if value is not None:

there is only ONE None object. you should not test like,     
if value != None

==, != are to test 'content' of a object with the object None    
'is' is to test if a object is None or not    

when you look something in map, map['xxx'], if not find it, the value of map['xxx'] will be None    

---
      try:
        return float(value)
      except ValueError:
        print "error: {0}'s value {1}  is not numeric".format(t, value)
        print 'exit...'
        exit(1)

float(value) might encounter some exception     

---
print "error: {0}'s value {1}  is not numeric".format(t, value)   
in python 2.x, you need use {0}; in 3.x, you can use {}, (to confirm)

---
when define a method of a class, remember 'self' para,    
def f(self):

when use data members of a object in methods, you should add 'self.', like below,     
class X:
  def f(self):
    self.data = 1

when use data member of a class, you should add 'classname.' prefix, like below,     
class X:
  i = 1
  def f(self):
    X.i = 1

---
    cmd = []
    cmd.append('sqlite3')
    cmd.append(self.db)
    cmd.append(self.query)
    print cmd
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output, errors = p.communicate()

put command and its parameters into a list, don't pass a string like 'cmd para1 para2'(though passing a string is ok). Or, somethings
you may get wired error

---
    for name, value in configMap.iteritems():    
in python 2.x, you need adding .iteritems(), seem so...     
in 3.x, you can omit it, seem so

---
remember close file object

---
import modules in other directory     

  import sys
  import os
  feedTableModule = sys.path[0] + '/../tablefeeder/'
  sys.path.append(feedTableModule)
  import feedTable

maybe exist other ways...

### shlex

lex = shlex.shlex(str)  # you can pass a string, or file object; return an object

tokens = shlex.split(postfixStr)  # split by whitespace, seem so



### subprocess
