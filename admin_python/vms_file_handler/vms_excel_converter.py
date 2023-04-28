import os
import pandas as pd
import sys

import csv
import re

class VMSExcelConverter:
    paths = []
    outputPath = ""
    runNumber = 0

    variablesToGet = ["Time(sec)", "GPSSpeed", "RunningDistance"]

    def _getFilePrefix(self, date, direction, runNumber):
        if direction == "":
            return "_Run"+str(runNumber) + "_" + date 
        else:
            return "_Run"+str(runNumber) + "_direction("+direction+")_" + date

    def _isValidExcelFile(self, filePath):
        # Open Excel
        try:
            xls = pd.ExcelFile(filePath)
        except:
            sys.stderr.write(filePath, " - Excel Open Failed!"+"\n")
            raise

        # Test Sheet
        sheets = xls.sheet_names
        if len(sheets) != 1 or sheets[0] != 'Sheet1':
            sys.stderr.write(filePath, " - Not a appropriate File!"+"\n")
            raise
        
        return xls 

    def _parseTSV(self, filePath, prefix):
        self.runNumber = self.runNumber + 1

        date = re.findall('20[0-9]{6} [0-9]{6}', filePath)[0]
        barometer = 0
        airTemp = 0

        sheet = pd.read_csv(filePath, delimiter='\t', keep_default_na=False)

        rowsToWrite = []
        testState = 0  # 0: before start, # 1: running over 100kph , # 2: started braking.
        distance = 0.0
        lastSpeed = 0.0
        for i, row in sheet.iterrows():
            rowToWrite = []

            if i == 0: # skip second line. 
                continue

            speed = float(row["[GPSSpeed]"])

            if testState == 0:
                if speed >= 100.0 and (lastSpeed - speed) < 1.0: # validate by speed changing. 
                    testState = 1
                continue
            
            if testState == 1 and speed < 100.0:
                testState = 2

            for var in self.variablesToGet:
                if var == "[RunningDistance]":
                    if testState == 1:
                        row[var] = 0.0
                    elif testState == 2:
                        distance += speed *1000/3600 * 0.01 #0.01s per row
                        row[var] = distance 

                rowToWrite.append("{:.2f}".format(float(row[var])))
            rowsToWrite.append(rowToWrite)

            lastSpeed = speed

            if i == 0:
                barometer = "{:.2f}".format(row["[Barometer]"])
                airTemp = "{:.2f}".format(row["[TAir]"])

        f = open(os.path.join(self.outputPath, prefix + self._getFilePrefix(date,"", self.runNumber) + ".csv"), 'w')
        writer = csv.writer(f)
        writer.writerow(["Barometer", barometer, "Air Temperature", airTemp ])
        writer.writerow(self.variablesToGet)
        writer.writerows(rowsToWrite)
        f.close() 
        sys.stdout.write("Success! :" + f.name+"\n")

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
            sys.stdout.write("Success! :" + f.name+"\n")


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


## txt file but tsv format.
class BrakingExcelConverter(VMSExcelConverter):
    # Constructor.
    def __init__(self, paths, outputPath):
        self.paths = paths
        self.outputPath = outputPath
        self.variablesToGet = ["[Time]", "[GPSSpeed]", "[RunningDistance]"]

    def convert(self):
        for filePath in self.paths:
            try:
                self._parseTSV(filePath, "Braking")
            except:
                continue
