import xml.dom.minidom
import getopt
import sys

def buildDataMap(inputFileName):
	fobj = open(inputFileName)
	map = {}
	i = 0
	for line in fobj:
		i += 1
		line = line.strip()
		if len(line) == 0 or line[0] == '#':
			continue
		pos = line.find('#')
		if pos != -1:
			line = line[:pos]
		pos = line.find('=')
		if pos == -1:
			print 'line({0}) has wrong format. skip...'.format(i)
		else:
			map[line[:pos].strip()] = line[pos+1:].strip()

	fobj.close()
	return map


def fillTable(map, templateFileName, outputFileName):
	fobj = open(templateFileName)
	try:
		dom = xml.dom.minidom.parse(fobj)
	except:
		print 'error happens when parsing file:' + templateFileName
		print '\n\n\nTraceback info:\n'
		raise
	headerList = dom.getElementsByTagName('th')
	cellList = dom.getElementsByTagName('td')

	for cell in cellList:
		if cell.firstChild.data.strip() in map:
			cell.firstChild.data = map[cell.firstChild.data.strip()]
	for header in headerList:
		if header.firstChild.data.strip() in map:
			header.firstChild.data = map[header.firstChild.data.strip()]

	#print dom.toprettyxml()
	ofobj = open(outputFileName, 'w')
	dom.writexml(ofobj, newl='\n', addindent='  ')
	print 'writing result to ' + outputFileName +' done.'
	fobj.close()
	ofobj.close()

def printUsage():
	print '''example: {0} --input=input_file_name --output=output_file_name

  --input: if not specified, use tableData.txt

  --output: if not specified, use result.html
'''.format(sys.argv[0])

if __name__ == "__main__":

	templateFileName = 'template.html'
	tableDataSourceFileName = 'tableData.txt'
	outputFileName = 'result.html'

	opts, args = getopt.getopt(sys.argv[1:], "h", ["input=", "help", "output="])	
	for o, a in opts:
		if o in ('--help', '-h'):
			printUsage()
			exit(0)
		elif o == '--input':
			tableDataSourceFileName = a
		elif o == '--output':
			outputFileName = a

	map = buildDataMap(tableDataSourceFileName)
	fillTable(map, templateFileName, outputFileName)
