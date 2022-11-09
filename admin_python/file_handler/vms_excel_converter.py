import os
import pandas as pd

import csv

class VMSExcelConverter:
    paths = []
    outputPath = ""
    runNumber = 0

    variablesToGet = ["Time(sec)", "GPSSpeed", "RunningDistance"]

    def _getFilePrefix(self, date, direction, runNumber):
        return "_Run"+str(runNumber) + "_direction("+direction+")_" + date + "_"

    def _isValidExcelFile(self, filePath):
        # Open Excel
        try:
            xls = pd.ExcelFile(filePath)
        except:
            print(filePath, " - Excel Open Failed!")
            raise

        # Test Sheet
        sheets = xls.sheet_names
        if len(sheets) != 1 or sheets[0] != 'Sheet1':
            print(filePath, " - Not a appropriate File!")
            raise
        
        return xls 

    
    def _parseExcel(self, xls, filePath, prefix):
            
            self.runNumber = self.runNumber + 1
            
            test = xls.parse(nrows=1, sheet_name=0)
            date = test.columns[0].split('(')[1].split(')')[0]
            direction = filePath.split('(')[-1].split(')')[0]
            barometer = 0
            airTemp = 0

            sheet = xls.parse(skiprows=3, sheet_name=0)

            rowsToWrite = []
            distanceInit = False
            for i, row in sheet.iterrows():
                rowToWrite = []
                for var in self.variablesToGet:
                    if var == "RunningDistance" and not distanceInit:
                        if row[var] == 0.0:
                            distanceInit = True
                        else:
                            row[var] = 0.0

                    rowToWrite.append("{:.2f}".format(row[var]))
                rowsToWrite.append(rowToWrite)

                if i == 0:
                    barometer = "{:.2f}".format(row["Barometer"])
                    airTemp = "{:.2f}".format(row["TAir"])

            f = open(os.path.join(self.outputPath, prefix + self._getFilePrefix(date,direction, self.runNumber) + ".csv"), 'w')
            writer = csv.writer(f)
            writer.writerow(["Barometer", barometer, "Air Temperature", airTemp ])
            writer.writerow(self.variablesToGet)
            writer.writerows(rowsToWrite)
            f.close() 


class StartingAccelExcelConverter(VMSExcelConverter):
    # Constructor.
    def __init__(self, paths, outputPath):
        self.paths = paths
        self.outputPath = outputPath

    def convert(self):
        for filePath in self.paths:
            try:
                xls =  self._isValidExcelFile(filePath)
                self._parseExcel(xls, filePath, "StartingAccel")
            except:
                continue
            
class PassingAccelExcelConverter(VMSExcelConverter):
    # Constructor.
    def __init__(self, paths, outputPath):
        self.paths = paths 
        self.outputPath = outputPath

    def _getKphRangeFromFilePath(self, filePath):
        return filePath.split('kph')[0].split('_')[-1]

    def convert(self):

        lastKphRange = "0"
        self.paths.sort()
        for filePath in self.paths:
            try:
                xls =  self._isValidExcelFile(filePath)
                kphRange = self._getKphRangeFromFilePath(filePath)
                if lastKphRange != kphRange:
                    self.runNumber = 0
                    lastKphRange = kphRange

                self._parseExcel(xls, filePath, "PassingAccel_" + kphRange + "kph")
            except:
                continue


