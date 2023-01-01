from bs4 import BeautifulSoup
import pandas as pd
import os
import sys

class VMSHtmlConverter:
    paths = []
    outputPath = ""

    def _processDataFrame(self, dataframe):
        print("Error: Pure Virtual Function!")

    def _parseHtml(self, filePath, prefix):
        f = open(filePath, "r", encoding='utf-16')
        html = f.read()
        f.close()

        bs = BeautifulSoup(html, 'html.parser')
        tables = bs.find_all('table')

        table = [ elem for elem in tables if "시험" in str(elem) ]

        df = pd.read_html(str(table[0]))[0]
        self._processDataframe(df)

        f = open(os.path.join(self.outputPath, prefix + ".json"), 'w')
        f.write(df.to_json(orient="table", force_ascii=False, indent=2))
        f.close() 
        sys.stdout.write("Success! :" + f.name+"\n")

    
class AccelHtmlConverter(VMSHtmlConverter):
    # Constructor.
    def __init__(self, paths, outputPath):
        self.paths = paths
        self.outputPath = outputPath

    def _processDataframe(self,dataframe):
        #remove useless lines
        dataframe.drop(labels=range(89,106), axis=0, inplace=True)
        #print(dataframe.to_string())

    def convert(self):
        for filePath in self.paths:
            try:
                self._parseHtml(filePath, "Acceleration")
            except Exception as e:
                sys.stderr.write(str(e)+"\n")
                continue


class BrakeHtmlConverter(VMSHtmlConverter):
    # Constructor.
    def __init__(self, paths, outputPath):
        self.paths = paths
        self.outputPath = outputPath

    def _processDataframe(self,dataframe):
        #remove useless lines
        dataframe.drop(labels=range(5,19), axis=0, inplace=True)
        #print(dataframe.to_string())

    def convert(self):
        for filePath in self.paths:
            try:
                self._parseHtml(filePath, "Braking")
            except Exception as e:
                sys.stderr.write(str(e+"\n"))
                continue
 