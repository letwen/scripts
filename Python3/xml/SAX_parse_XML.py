import xml.sax
import sys
get_record=[]
class GetStorehouse(xml.sax.ContentHandler):
    def __init__(self):
        self.CurrentData=""
        self.title=""
        self.name=""
        self.amount=""
        self.price=""
    def startElement(self,label,attributes):
        self.CurrentData=label
        if label=="goods":
            category=attributes["category"]
            return category
    def endElement(self,label):
        global get_record
        if self.CurrentData=="title":
            get_record.append(self.title)
        elif self.CurrentData=="name":
            get_record.append(self.name)
        elif self.CurrentData=="amount":
            get_record.append(self.amount)
        elif self.CurrentData=="price":
            get_record.append(self.price)
    def characters(self,content):
        if self.CurrentData=="title":
            self.title=content
        elif self.CurrentData=="name":
            self.name=content
        elif self.CurrentData=="amount":
            self.amount=content
        elif self.CurrentData=="price":
            self.price=content
#---------------------------------------------------------------------
parser=xml.sax.make_parser()
# parser.setFeature(xml.sax.handler.feature_namespaces,0)
Handler=GetStorehouse()
parser.setContentHandler(Handler)
parser.parse("storehouse.xml")
print(get_record)