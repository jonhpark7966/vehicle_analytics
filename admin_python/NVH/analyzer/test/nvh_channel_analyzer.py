import json
from NVH.channel_data_model import *
from NVH.analyzer.analyze_options import AnalyzeOptions
from ..process.fourier_signal_process import FourierSignalProcess
from ..process.tacho_process import TachoProcessor
from ..process.vehicle_process import VehicleProcessor


class NVHChannelAnalyzer:
    def __init__(self, signalChannel, tachoChannels, vehicleMap):
        self.dataDict1D = {}
        self.dataDict2D = {}
        self.dataDict3D = {}

        self.analyzeOptions = AnalyzeOptions()
        self.signalChannel = signalChannel
        self.tachoChannels = tachoChannels
        self.vehicleProcessor = VehicleProcessor(vehicleMap)

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

    
    def rpmFFT(self):
        processor = FourierSignalProcess()

        if not self.vehicleProcessor.isEV():
            engineRpmIndices = TachoProcessor(self.tachoChannels).getOrderTrackedIndices(
                "Engine Speed",
                self.analyzeOptions.engineRpmStart,
                self.analyzeOptions.engineRpmEnd,
                self.analyzeOptions.engineRpmDelta)
            self.dataDict3D["Engine RPM Colormap"] = processor.orderFFT(
            self.signalChannel, self.analyzeOptions.referenceValue,
            self.analyzeOptions.frequencyResolution, engineRpmIndices,
              "rpm", self.analyzeOptions.engineRpmDelta)
            
    def speedFFT(self):
        processor = FourierSignalProcess()

        speedIndices = TachoProcessor(self.tachoChannels).getOrderTrackedIndices(
                "GPS Speed",
                self.analyzeOptions.speedStart,
                self.analyzeOptions.speedEnd,
                self.analyzeOptions.speedDelta)
        self.dataDict3D["Speed Colormap"] = processor.orderFFT(
            self.signalChannel, self.analyzeOptions.referenceValue,
            self.analyzeOptions.frequencyResolution, speedIndices,
            "kph", self.analyzeOptions.speedDelta)
        





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


