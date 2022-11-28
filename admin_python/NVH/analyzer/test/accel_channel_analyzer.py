from ..process.fourier_signal_process import FourierSignalProcess
from .nvh_channel_analyzer import NoiseChannelAnalyzer, VibrationChannelAnalyzer
from ..process.tacho_process import TachoProcessor 
from ..process.project_process import ProjectProcess
from ..process.utils import UtilsProcessor
from ..data_models.data_models import DataModel1D



class AccelNoiseAnalyzer(NoiseChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels, vehicelMap):
        super().__init__(signalChannel, tachoChannels, vehicelMap)
        self.lowEndFreq = 2000
        self.highFreqRes = 20
        self.highEndFreq = 20000

    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT(self.signalChannel, self.analyzeOptions.referenceValue, self.analyzeOptions.frequencyResolution)
        self.dataDict3D["Time Colormap High Freq"] = processor.timeFFT(
                self.signalChannel, self.analyzeOptions.referenceValue, self.highFreqRes)

        self.rpmFFT()
        self.speedFFT()
        
    def analyze3to2(self):
        processor = ProjectProcess()
        self.dataDict2D["Speed Overall Graph"] = processor.projectYOA(
            self.dataDict3D["Speed Colormap"],
            self.analyzeOptions.referenceValue,
            20,20000
            )
        self.dataDict2D["RPM Overall Graph"] = processor.projectYOA(
            self.dataDict3D["Engine RPM Colormap"],
            self.analyzeOptions.referenceValue,
            20, 20000)

    def analyze2to1(self):
        noiseSlope, noiseIntercept = UtilsProcessor().getLinearRegression(
            self.dataDict2D["Speed Overall Graph"],
            self.analyzeOptions.speedRegressionStart,
            self.analyzeOptions.speedRegressionEnd)

        self.dataDict1D["Accel Noise Slope"] = DataModel1D("dBA/kph", noiseSlope)
        self.dataDict1D["Accel Noise Intercept"] = DataModel1D("dBA", noiseIntercept)


    def export(self, outputPath):
        for k,value in self.dataDict3D.items():
            if "High Freq" in k:
                value.export(k, outputPath, self.signalChannel.name, self.highEndFreq)
            else:
                value.export(k, outputPath, self.signalChannel.name, self.lowEndFreq)

        self.export2D(outputPath)
        self.export1D(outputPath)



class AccelVibrationAnalyzer(VibrationChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels, vehicleMap):
        super().__init__(signalChannel, tachoChannels, vehicleMap)

    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT(self.signalChannel, self.analyzeOptions.referenceValue, self.analyzeOptions.frequencyResolution)

        self.rpmFFT()
        self.speedFFT
        
    def analyze3to2(self):
        processor = ProjectProcess()

        tireTransTacho = self.vehicleProcessor.getSpeedToTireRatio()
        self.dataDict2D["Tire Graph"] = processor.projectYOrder(
            self.dataDict3D["Speed Colormap"],
            self.analyzeOptions.referenceValue,
            1.0,
            tireTransTacho)

        pShaftTransTacho = self.vehicleProcessor.getSpeedToPropellerShaftRatio()
        if pShaftTransTacho != 0:
            self.dataDict2D["Propeller Shaft Graph"] = processor.projectYOrder(
                self.dataDict3D["Speed Colormap"],
                self.analyzeOptions.referenceValue,
                1.0,
                pShaftTransTacho)

    def analyze2to1(self):
        tireMax, tireRPMatMax = self.dataDict2D["Tire Graph"].getMaxValueAt()
        speedAtTireMax = tireRPMatMax / self.vehicleProcessor.getSpeedToTireRatio()
        self.dataDict1D["Tire Max Vibration"] = DataModel1D(
                "dB@kph", str(round(tireMax,2)) + "@" + str(round(speedAtTireMax)))


        if self.vehicleProcessor.isPropellerExist():
            propellerMax, propellerRPMatMax = self.dataDict2D["Tire Graph"].getMaxValueAt()
            speedAtPropellerMax = propellerRPMatMax / self.vehicleProcessor.getSpeedToPropellerShaftRatio()
            self.dataDict1D["Propeller Shaft Max Vibration"] = DataModel1D(
                "dB@kph", str(round(propellerMax,2)) + "@" + str(round(speedAtPropellerMax)))

    def export(self, outputPath):
        for k,value in self.dataDict3D.items():
            value.export(k, outputPath, self.signalChannel.name, self.endFreq)

        self.export2D(outputPath)
        self.export1D(outputPath)