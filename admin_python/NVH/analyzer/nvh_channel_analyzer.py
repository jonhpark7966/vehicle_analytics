from NVH.channel_data_model import *
from NVH.analyzer.analyze_options import AnalyzeOptions


class NVHChannelAnalyzer:
    dataDict1D = {}
    dataDict2D = {}
    dataDict3D = {}
    
    signalChannel = None
    tachoChannels = []
    analyzeOptions = None

    def __init__(self, signalChannel, tachoChannels):
        self.dataDict1D = {}
        self.dataDict2D = {}
        self.dataDict3D = {}

        self.analyzeOptions = AnalyzeOptions()
        self.signalChannel = signalChannel
        self.tachoChannels = tachoChannels

    def analyzer(self):
        self.analyzeSignalTo3()
        self.analyze3to2()
        self.analyze2to1()

    def analyzeSignalTo3():
        return

    def analyze3to2():
        return

    def analyze2to1():
        return

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


