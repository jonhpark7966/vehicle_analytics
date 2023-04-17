from .nvh_channel_analyzer import NoiseChannelAnalyzer, VibrationChannelAnalyzer
from ..data_models.data_models import DataModel1D
from ..process.project_process import ProjectProcess 
from ..process.fourier_signal_process import FourierSignalProcess
from ..process.utils import UtilsProcessor
from ..process.tacho_process import TachoProcessor



class WOTNoiseAnalyzer(NoiseChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels, vehicleMap):
        super().__init__(signalChannel, tachoChannels, vehicleMap)
        self.lowEndFreq = 2000
        self.highFreqRes = 20
        self.highEndFreq = 10000 # TODO, check EV for over 10kHz


    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT(self.signalChannel, self.analyzeOptions.referenceValue, self.analyzeOptions.frequencyResolution)
        self.dataDict3D["Time Colormap High Freq"] = processor.timeFFT(
                self.signalChannel, self.analyzeOptions.referenceValue, self.highFreqRes)
        
        self.rpmFFT()
        self.speedFFT()
        
    def analyze3to2(self):
        processor = ProjectProcess()
        self.dataDict2D["RPM Overall Graph"] = processor.projectYOA(
            self.dataDict3D["Engine RPM Colormap"],
            self.analyzeOptions.referenceValue,
            20, self.highEndFreq, True)
        self.dataDict2D["Speed Overall Graph"] = processor.projectYOA(
            self.dataDict3D["Speed Colormap"],
            self.analyzeOptions.referenceValue,
            20, self.highEndFreq, True)



    def analyze2to1(self):
        noiseSlopeRPM, noiseInterceptRPM = UtilsProcessor().getLinearRegression(
            self.dataDict2D["RPM Overall Graph"],
            self.analyzeOptions.engineRpmRegressionStart,
            self.analyzeOptions.engineRpmRegressionEnd)
        noiseSlopeSpeed, noiseInterceptSpeed = UtilsProcessor().getLinearRegression(
            self.dataDict2D["Speed Overall Graph"],
            self.analyzeOptions.speedRegressionStart,
            self.analyzeOptions.speedRegressionEnd)


        self.dataDict1D["WOT Noise Slope Speed"] = DataModel1D("dBA/kph", noiseSlopeSpeed)
        self.dataDict1D["WOT Noise Intercept Speed"] = DataModel1D("dBA", noiseInterceptSpeed)
        self.dataDict1D["WOT Noise Slope RPM"] = DataModel1D("dBA/rpm", noiseSlopeRPM)
        self.dataDict1D["WOT Noise Intercept RPM"] = DataModel1D("dBA", noiseInterceptRPM)

       
    
    def export(self, outputPath):
        for k,value in self.dataDict3D.items():
            if "High Freq" in k:
                value.export(k, outputPath, self.signalChannel.name, self.highEndFreq)
            else:
                value.export(k, outputPath, self.signalChannel.name, self.lowEndFreq)

        self.export2D(outputPath)
        self.export1D(outputPath)


class WOTVibrationAnalyzer(VibrationChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels, vehicleMap):
        super().__init__(signalChannel, tachoChannels, vehicleMap)
        self.endFreq = 2000
        self.oaEndFreq = 80

    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT(self.signalChannel, self.analyzeOptions.referenceValue, self.analyzeOptions.frequencyResolution)

        self.rpmFFT()
        self.speedFFT() 

    def analyze3to2(self):
        # TODO, handle EV
        processor = ProjectProcess()
        mainOrder = self.vehicleProcessor.getMainOrder()
        self.dataDict2D["RPM Main Order Graph"] = processor.projectYOrder(
            self.dataDict3D["Engine RPM Colormap"],
            self.analyzeOptions.referenceValue,
            mainOrder, 
            1.0)

    def analyze2to1(self):
        engineMax, engineRPMatMax = self.dataDict2D["RPM Main Order Graph"].getMaxValueAt()
        self.dataDict1D["Engine Max Vibration"] = DataModel1D(
                "dB@rpm", str(round(engineMax,2)) + "@" + str(round(engineRPMatMax)))

        
    def export(self, outputPath):
        for k,value in self.dataDict3D.items():
            value.export(k, outputPath, self.signalChannel.name, self.endFreq)

        self.export2D(outputPath)
        self.export1D(outputPath)