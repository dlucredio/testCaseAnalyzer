import csv, os
import xml.etree.ElementTree as ET

def parseXML(xmlfile, methoditems):
    tree = ET.parse(xmlfile)
    root = tree.getroot()
    for projectNode in root.findall('./group'):
        projectName = projectNode.attrib['name']
        print('   Found project '+projectName)
        for classNode in projectNode.findall('.//class'):
            typeName = classNode.attrib['name']
            for methodNode in classNode.findall('./method'):
                methodName = methodNode.attrib['name']
                methoditem = {}
                methoditem['methodName'] = methodName
                methoditem['typeName'] = typeName
                methoditem['projectName'] = projectName
                for counterNode in methodNode:
                    counterTypeMissed = counterNode.attrib['type'] + "_missed"
                    counterTypeCovered = counterNode.attrib['type'] + "_covered"
                    methoditem[counterTypeMissed] = counterNode.attrib['missed']
                    methoditem[counterTypeCovered] = counterNode.attrib['covered']
                methoditems.append(methoditem)

def safe_str(obj):
    try: return str(obj)
    except UnicodeEncodeError:
        return obj.encode('ascii', 'ignore').decode('ascii')
    return ""

def savetoCSV(methoditems, filename):
    fields = ['projectName','typeName','methodName','INSTRUCTION_missed', 'INSTRUCTION_covered', 'LINE_missed', 'LINE_covered', 'COMPLEXITY_missed', 'COMPLEXITY_covered', 'METHOD_missed', 'METHOD_covered', 'BRANCH_missed', 'BRANCH_covered']
    with open(filename, 'w', encoding="UTF-8") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames = fields)
        writer.writeheader()
        writer.writerows(methoditems)

def main():
    methoditems = []
    # parseXML('./jacocoFiles/jbehave-maps-example.xml',methoditems)
    for file in os.listdir('./jacocoFiles'):
        print('Parsing '+file)
        parseXML(os.path.join('./jacocoFiles', file), methoditems)
    savetoCSV(methoditems, './output.csv')


if __name__ == "__main__":
    main()