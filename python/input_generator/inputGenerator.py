import shlex
import subprocess
import time
import getopt


tagBeg = 'sql^'
tagEnd = '^'

# sql^ select * from table ^
def isSqlite3Query(str):
	sstr = str.strip()
	if sstr.find(tagBeg) != -1 and sstr[-1] == tagEnd:
		return True

	return False


def getQueryStr(str, beg, end):
	sstr = str.strip()
	sstr = sstr[len(tagBeg):-1]	
	timerange = 'timestamp >= {0} and timestamp <= {1}'.format(beg, end)
	sstr = sstr + ' and ' + timerange
	#print sstr
	return sstr


def isArithmeticExpr(str):
	#TODO, using regular expr
	return True


def isOperator(t):
	#print t
	return t == '+' or t == '*' or t == '/' or t == '-'


def isOperand(t):
	#print t
	# now simply let the variable name be alphanumeric
	return t.isalnum()
	

def isHigher(a, b):
	if (a == '*' or a == '/') and (b == '+' or b =='-'):
		return True
	return False


def evalOperand(t, varMap={}):
	if t.isdigit():
		return float(t)

	#print varMap
	if len(varMap) != 0:
		value = varMap[t]
		if value is not None:
			try:
				return float(value)
			except ValueError:
				print "error: {0}'s value {1}  is not numeric".format(t, value)
				print 'exit...'
				exit(1)
		else:
			print 'error: there is no var: {0}'.format(t)
			print 'exit...'
			exit(1)

	print 'error: {0} is not digit number, or varMap is empty'.format(t)
	print 'exit...'
	exit(1)


def buildPostfixExpr(str):
	postfixStr = ''
	stack = []

	lex = shlex.shlex(str)

	t = lex.get_token()
	while t:
		if isOperand(t):
			postfixStr = postfixStr + t + ' '
		elif isOperator(t):
			while True:
				if len(stack) == 0 or not isOperator(stack[-1]) or not isHigher(stack[-1], t):
					break
				top = stack.pop()
				postfixStr = postfixStr + top + ' '

			stack.append(t)
		elif t == '(' :
			stack.append(t)
		elif t == ')':
			top = stack.pop()
			while top != '(':
				postfixStr = postfixStr + top + ' '
				top = stack.pop()

		t = lex.get_token()

	while len(stack) != 0:
		top = stack.pop()
		postfixStr = postfixStr + top + ' '

	postfixStr = postfixStr[:-1]

	#print 'postfixStr:' + postfixStr 
	return postfixStr


def postfixExprEval(postfixStr, varMap):
	tokens = shlex.split(postfixStr)
	#print tokens

	stack = []

	for t in tokens:
		if isOperand(t):
			v = evalOperand(t, varMap)
			stack.append(v)
		elif isOperator(t):
			rhs = stack.pop()
			lhs = stack.pop()
			if t == '+':
				value = lhs + rhs
			if t == '-':
				value = lhs - rhs
			if t == '*':
				value = lhs * rhs
			if t == '/':
				if rhs == 0:
					value = 'divide zero error. skip eval...'
					return value
				value = lhs / rhs
			stack.append(value)

	#print len(stack)
	#print stack[0]
	return stack[0]


class ValueSqlite3:
	def __init__(self, name, query, db):
		self.name = name
		self.query = query
		self.db = db

	def evaluate(self):
		cmd = []
		cmd.append('sqlite3')
		cmd.append(self.db)
		cmd.append(self.query)
		#print cmd
		p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		output, errors = p.communicate()
		if len(errors) > 0:
			print errors
			exit(1)
		try:
			value = float(output)
			return value
		except ValueError:
			print 'error: the result of "{0}" is {1}, which is not a number'.format(self.query, output)
			print 'exit...'
			exit(1)	


class ValueArithmetic:
	varMap = {}
	def __init__(self, name, expression):
		self.name = name
		self.expression = expression

	def evaluate(self):
		postfixstr = buildPostfixExpr(self.expression)
		return postfixExprEval(postfixstr, ValueArithmetic.varMap)


def generateInputForTableFeeder(configFileName, db, beg, end, outputFileName):

	configMap = feedTable.buildDataMap(configFileName)

	sqlitesValues = []
	arithmeticValues = []
	for name, value in configMap.iteritems():
		if isSqlite3Query(value):
			vobj = ValueSqlite3(name, getQueryStr(value, beg, end), db)
			sqlitesValues.append(vobj)
		elif isArithmeticExpr(value):
			vobj = ValueArithmetic(name, value)
			arithmeticValues.append(vobj)
		else:
			print 'error: wrong input format "{0}" in file "{1}"'.format(value, configFileName)
			print 'skipping that line...'

	resultMap = {}
	map = {}
	for vobj in sqlitesValues:
		value = vobj.evaluate()
		map[vobj.name] = value
		resultMap[vobj.name] = value

	ValueArithmetic.varMap = map
	for vobj in arithmeticValues:
		value = vobj.evaluate()
		resultMap[vobj.name] = value

	resultFileName = outputFileName
	foutput = open(resultFileName, 'w')

	foutput.write('timestamp_beg=' + str(beg) + ', ' + time.asctime(time.localtime(beg)) + '\n');
	foutput.write('timestamp_end=' + str(end) + ', ' + time.asctime(time.localtime(end)) + '\n');

	for k,v in resultMap.iteritems():
		foutput.write(k + ' = ' + str(v) + '\n')
	foutput.close()
	print 'result has written into {0}'.format(resultFileName)
		

def printUsage():
	print '''example: {0} --i=2h --db=sqlite3_db_name --output=output_file_name

  --i: 2h means handling data from 2 hours ago till now.
      2d means handling data from 2 days ago till now.
      if not given, default value is 1h.

  --db: the sqlite3 db file. if not given, use the file named CALData.db.

  --output: specify the result file name.
'''.format(sys.argv[0])


if __name__ == '__main__':
		
	# module location of buildDataMap
	import sys
	import os
	feedTableModule = sys.path[0] + '/../table_feeder/'
	sys.path.append(feedTableModule)
	import feedTable

	configFileName = 'config.txt'
	db = 'CALData.db'
	range = 3600 # 1h
	outputFileName = 'tableData.txt'

	opts, args = getopt.getopt(sys.argv[1:], "h", ["db=", "i=", "help", "output="])
	for o, a in opts:
		if o in ('--help', '-h'):
			printUsage()
			exit(0)
		elif o == '--i':
			avalue = a
			if avalue[-1] == 'h':
				s = int(avalue[:-1])
				range = s * 3600
				if range <= 0:
					print 'error argument, exit ...'
					exit(1)
			elif avalue[-1] == 'd':
				s = float(avalue[:-1])
				range = s * 3600 * 24
				if range <= 0:
					print 'error argument, exit ...'
					exit(1)
			else:
				print 'error argument, exit ...'
				exit(1)
		elif o == '--db':
			db = a
		elif o == '--output':
			outputFileName = a

	end = int(time.time())
	beg = end - range

	print '''########################
db file is {0}
time range is ['{1}', '{2}']
output file is {3}
########################'''.format(db, time.asctime(time.localtime(beg)), time.asctime(time.localtime(end)), outputFileName)

	generateInputForTableFeeder(configFileName, db, beg, end, outputFileName)



