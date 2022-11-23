import json
from NVH.channel_data_model import *
from NVH.analyzer.analyze_options import AnalyzeOptions


class NVHChannelAnalyzer:
    def __init__(self, signalChannel, tachoChannels, vehicleMap):
        self.dataDict1D = {}
        self.dataDict2D = {}
        self.dataDict3D = {}

        self.analyzeOptions = AnalyzeOptions()
        self.signalChannel = signalChannel
        self.tachoChannels = tachoChannels
        self.vehicleMap = vehicleMap

    def analyzeSignalTo3():
        return

    def analyze3to2():
        return

    def analyze2to1():
        return

    def export(self, outputPath):
        return

    def export1D(self, outputPath):
        with open(os.path.join(outputPath, self.signalChannel.name+".json"), "w") as f:
            jsonDict = {}
            for k,v in self.dataDict1D.items():
                jsonDict[k] = v.getString()

            json.dump(jsonDict, f)
    
    def export2D(self, outputPath):
        for k,value in self.dataDict2D.items():
            value.export(k, outputPath, self.signalChannel.name)






class NoiseChannelAnalyzer(NVHChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels, vehicleMap):
        super().__init__(signalChannel, tachoChannels, vehicleMap)
        self.analyzeOptions.frequencyResolution = 1.0 
        self.analyzeOptions.referenceValue = 0.00002
        self.analyzeOptions.startFrequency = 20

class VibrationChannelAnalyzer(NVHChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels, vehicleMap):
        super().__init__(signalChannel, tachoChannels, vehicleMap)
        self.analyzeOptions.frequencyResolution = 0.5
        self.analyzeOptions.referenceValue = 0.000001
        self.analyzeOptions.startFrequency = 2


