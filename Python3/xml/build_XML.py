import sys
class BuildNewXML():
    
    def __init__(self,filename=None):
        self.filename=filename
        self.__get_f=None
    def openfile(self):
        if self.filename==None:
            print("没有提供文件名!在建立实例时,请提供建立文件的名称!")
            return False
        try:
            self.__get_f=open(self.filename,'a',encoding='utf-8')
        except:
            print('打开%s文件有问题!'%(self.filename))
            return False
            
    def writeXML(self,n,element):
        try:
            if n==0 :  
                self.__get_f.write(element+'\n')
            else:
                self.__get_f.write(' '*n+element+'\n')
        except:
            print('往%s文件写%s出错!'%(self.filename,element))
            sys.exit() 
    def closeXML(self):
        if self.__get_f:
            self.__get_f.close()
#====================================
filename="storehouse.xml"
flag=False
content={1:[0,'<storehouse>'],
         2:[4,'<goods category="fish">'],
         3:[8,'<title>淡水鱼</title>'],
         4:[8,'<name>鲫鱼</name>'],
         5:[8,'<amount>18</amount>'],
         6:[8,'<price>8</price>'],
         7:[4,'</goods>'],
         8:[4,'<goods category="fruit">'],
         9:[8,'<title>温带水果</title>'],
         10:[8,'<name>猕猴桃</name> '],
         11:[8,'<amount>10</amount>'],
         12:[8,'<price>10</price>'],
         13:[4,'</goods>'],
         14:[0,'</storehouse>']
            }
build_xml=BuildNewXML(filename)
try:
    build_xml.openfile()
    for get_item in content.items():
        build_xml.writeXML(get_item[1][0],get_item[1][1] )
    flag=True
except:
    print('往文件内容出错,退出程序!')
    sys.exit()
finally:
    if flag:
        build_xml.closeXML()
        print('往%s写内容完成!'%(filename))

    
