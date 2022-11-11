#-*- coding: utf-8 -*-

import os
import chardet

class FileOrganizer:
    #root directory path
    rootPath = ""

    # Coastdown
    j2263LogPath = ""
    j2263RawPath = ""
    wltpLogPath = ""
    wltpRawPath = ""

    #Performance
    performanceHtmlPath = ""
    performanceStartingAccelRawList = []
    performancePassingAccelRawList = []
    brakingHtmlPath = ""
    brakingRawList = []

    #NVH
    idleHdfPathList = []
    cruiseHdfPathList = []
    # ...

    # Constructor.
    def __init__(self, rootPath):
        self.rootPath = rootPath

    def parsingFiles(self):

        parsingPerformanceExcels()

        return "parsing results"



    def checkFiles(self):
        childrenList = os.listdir(self.rootPath)
        self.checkCoastdownFiles(childrenList)
        self.checkPerformanceFiles(childrenList)
        #checkNVHFiles()

        return self.throwEmptyFiles()

    def checkCoastdownFiles(self, list):
        for path in list:
            if "J2263" in path:
                for filePath in os.listdir(os.path.join(self.rootPath, path)):
                    if "log" in filePath:
                        self.j2263LogPath = os.path.join(self.rootPath, path, filePath)
                    elif "raw" in filePath:
                        self.j2263RawPath = os.path.join(self.rootPath, path, filePath)
            if "WLTP" in path:
                for filePath in os.listdir(os.path.join(self.rootPath, path)):
                    if "log" in filePath:
                        self.wltpLogPath = os.path.join(self.rootPath, path, filePath)
                    elif "raw" in filePath:
                        self.wltpRawPath = os.path.join(self.rootPath, path, filePath)


    def checkPerformanceFiles(self, list):
        for dirpath in list:
            if '동력성능' in dirpath:
                for filePath in os.listdir(os.path.join(self.rootPath, dirpath)):
                    # acceleration
                    if "가속.html" in filePath:
                        self.performanceHtmlPath = os.path.join(self.rootPath, dirpath, filePath)

                    elif '발진가속' in filePath:
                        subdirPath = filePath
                        filePaths = os.listdir(os.path.join(self.rootPath, dirpath, subdirPath))
                        for path in filePaths:
                            self.performanceStartingAccelRawList.append(os.path.join(self.rootPath, dirpath, subdirPath, path))

                    elif '추월가속' in filePath:
                        subdirPath = filePath
                        filePaths = os.listdir(os.path.join(self.rootPath, dirpath, subdirPath))
                        for path in filePaths:
                            self.performancePassingAccelRawList.append(os.path.join(self.rootPath, dirpath, subdirPath, path))
                        
                    # braking
                    elif "제동.html" in filePath:
                        self.brakingHtmlPath = os.path.join(self.rootPath, dirpath, filePath)

                    elif '제동성능' in filePath:
                        self.brakingRawList.append(os.path.join(self.rootPath, dirpath, filePath))

    def throwEmptyFiles(self):
        ret = "Checking result files ..."

        if self.j2263LogPath == "":
            ret += "\n J2263 Log file is empty"

        if self.j2263RawPath == "":
            ret += "\n J2263 Raw file is empty"

        if self.wltpLogPath == "":
            ret += "\n WLTP Log file is empty"

        if self.wltpRawPath == "":
            ret += "\n WLTP Raw file is empty"

        if self.performanceHtmlPath == "":
            ret += "\n Accleration HTML file is empty"

        if len(self.performanceStartingAccelRawList) == 0:
            ret += "\n Starting Accleration Raw files are empty"

        if len(self.performancePassingAccelRawList) == 0:
            ret += "\n Passing Accleration Raw files are empty"

        if self.brakingHtmlPath == "":
            ret += "\n Braking HTML file is empty"

        if len(self.brakingRawList) == 0:
            ret += "\n Braking  Raw files are empty"

        return ret