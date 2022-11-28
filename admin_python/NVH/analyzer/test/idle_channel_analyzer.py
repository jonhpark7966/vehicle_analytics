from .nvh_channel_analyzer import NoiseChannelAnalyzer, VibrationChannelAnalyzer
from ..data_models.data_models import DataModel1D
from ..process.project_process import ProjectProcess 
from ..process.fourier_signal_process import FourierSignalProcess
from ..process.utils import UtilsProcessor
from ..process.tacho_process import TachoProcessor



class IdleNoiseAnalyzer(NoiseChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels, vehicleMap):
        super().__init__(signalChannel, tachoChannels, vehicleMap)
        self.endFreq = 2000
        self.boomingEndFreq = 100

    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT(self.signalChannel, self.analyzeOptions.referenceValue, self.analyzeOptions.frequencyResolution)

    def analyze3to2(self):
        processor = ProjectProcess()
        self.dataDict2D["Frequency Graph"] = processor.projectX(self.dataDict3D["Time Colormap"], self.analyzeOptions.referenceValue)

    def analyze2to1(self):
        noiseValue = UtilsProcessor().getRMSFreq(
            self.dataDict2D["Frequency Graph"].getAWeighted(),
            self.analyzeOptions.startFrequency, self.endFreq, self.analyzeOptions.referenceValue)

        self.dataDict1D["Idle Noise"] = DataModel1D("dBA", noiseValue)

        boomingValue = UtilsProcessor().getRMSFreq(
            self.dataDict2D["Frequency Graph"].getCWeighted(),
            self.analyzeOptions.startFrequency, self.boomingEndFreq, self.analyzeOptions.referenceValue)

        self.dataDict1D["Idle Booming Noise"] = DataModel1D("dBC", boomingValue)

    
    def export(self, outputPath):
        for k,value in self.dataDict3D.items():
            value.export(k, outputPath, self.signalChannel.name, self.endFreq)

        self.export2D(outputPath)
        self.export1D(outputPath)


class IdleVibrationAnalyzer(VibrationChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels, vehicleMap):
        super().__init__(signalChannel, tachoChannels, vehicleMap)
        self.endFreq = 2000
        self.oaEndFreq = 80

    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT(self.signalChannel,  self.analyzeOptions.referenceValue, self.analyzeOptions.frequencyResolution)

    def analyze3to2(self):
        processor = ProjectProcess()
        self.dataDict2D["Frequency Graph"] = processor.projectX(self.dataDict3D["Time Colormap"], self.analyzeOptions.referenceValue)

    def analyze2to1(self):
        # idle o/a
        oaValue = UtilsProcessor().getRMSFreq(
            self.dataDict2D["Frequency Graph"],
            self.analyzeOptions.startFrequency, self.oaEndFreq, self.analyzeOptions.referenceValue)
        self.dataDict1D["Idle Vibration"] = DataModel1D("dB", oaValue)

        # ICE & Hybrid 
        # idle main order 
        rpmAverage = TachoProcessor(self.tachoChannels).getAvergeEngineRPM()
        mainOrder = self.vehicleProcessor.getMainOrder()
        mainOrderFreq = (rpmAverage/60) * mainOrder
        mainOrderValue = UtilsProcessor().getRMSFreq(
            self.dataDict2D["Frequency Graph"],
            mainOrderFreq - 1, mainOrderFreq + 1, self.analyzeOptions.referenceValue)
        self.dataDict1D["Idle Main Order Vibration"] = DataModel1D("dB", mainOrderValue)

        # idle first order
        firstOrderFreq = (rpmAverage/60)
        firstOrderValue = UtilsProcessor().getRMSFreq(
            self.dataDict2D["Frequency Graph"],
            firstOrderFreq - 1, firstOrderFreq + 1, self.analyzeOptions.referenceValue)
        self.dataDict1D["Idle First Order Vibration"] = DataModel1D("dB", firstOrderValue)

    def export(self, outputPath):
        for k,value in self.dataDict3D.items():
            value.export(k, outputPath, self.signalChannel.name, self.endFreq)

        self.export2D(outputPath)
        self.export1D(outputPath)

