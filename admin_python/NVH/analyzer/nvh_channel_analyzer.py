from NVH.channel_data_model import *
from NVH.analyzer.analyze_options import AnalyzeOptions


class NVHChannelAnalyzer:
    def __init__(self, signalChannel, tachoChannels):
        self.dataDict1D = {}
        self.dataDict2D = {}
        self.dataDict3D = {}

        self.analyzeOptions = AnalyzeOptions()
        self.signalChannel = signalChannel
        self.tachoChannels = tachoChannels

    def analyzeSignalTo3():
        return

    def analyze3to2():
        return

    def analyze2to1():
        return

    def export(self, outputPath):
        for k,value in self.dataDict3D.items():
            value.export(k, outputPath, self.signalChannel.name)
        for k,value in self.dataDict2D.items():
            value.export(k, outputPath, self.signalChannel.name)



class NoiseChannelAnalyzer(NVHChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels):
        super().__init__(signalChannel, tachoChannels)
        self.analyzeOptions.frequencyResolution =1.0 
        self.analyzeOptions.referenceValue = 0.00002

class VibrationChannelAnalyzer(NVHChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels):
        super().__init__(signalChannel, tachoChannels)
        self.analyzeOptions.frequencyResolution = 0.5
        self.analyzeOptions.referenceValue = 0.000001


