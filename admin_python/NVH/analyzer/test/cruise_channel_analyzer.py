from .nvh_channel_analyzer import NoiseChannelAnalyzer, VibrationChannelAnalyzer
from ..data_models.data_models import DataModel1D
from ..process.project_process import ProjectProcess 
from ..process.fourier_signal_process import FourierSignalProcess
from ..process.utils import UtilsProcessor
from ..process.tacho_process import TachoProcessor



class CruiseNoiseAnalyzer(NoiseChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels, vehicleMap):
        super().__init__(signalChannel, tachoChannels, vehicleMap)
        self.endFreq = 2000 # for color map export
        self.boomingEndFreq = 100
        self.tireStartFreq = 150
        self.tireEndFreq = 250
        self.rumbleStartFreq = 250
        self.rumbleEndFreq = 500
        self.windStartFreq = 500
        self.windEndFreq = 10000

    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT(self.signalChannel, self.analyzeOptions.referenceValue, self.analyzeOptions.frequencyResolution)

    def analyze3to2(self):
        processor = ProjectProcess()
        self.dataDict2D["Frequency Graph"] = processor.projectX(self.dataDict3D["Time Colormap"], self.analyzeOptions.referenceValue)

    def analyze2to1(self):
        aWeighted = self.dataDict2D["Frequency Graph"].getAWeighted()
        tireNoiseValue = UtilsProcessor().getRMSFreq(
            aWeighted,
            self.tireStartFreq, self.tireEndFreq, self.analyzeOptions.referenceValue)
        rumbleNoiseValue = UtilsProcessor().getRMSFreq(
            self.dataDict2D["Frequency Graph"].getAWeighted(),
            self.rumbleStartFreq, self.rumbleEndFreq, self.analyzeOptions.referenceValue)
        windNoiseValue = UtilsProcessor().getRMSFreq(
            self.dataDict2D["Frequency Graph"].getAWeighted(),
            self.windStartFreq, self.windEndFreq, self.analyzeOptions.referenceValue)
        roadNoiseValue = UtilsProcessor().getRMSFreq(
            self.dataDict2D["Frequency Graph"].getAWeighted(),
            self.analyzeOptions.startFrequency, self.rumbleEndFreq, self.analyzeOptions.referenceValue)
        boomingValue = UtilsProcessor().getRMSFreq(
            self.dataDict2D["Frequency Graph"].getCWeighted(),
            self.analyzeOptions.startFrequency, self.boomingEndFreq, self.analyzeOptions.referenceValue)

        self.dataDict1D["Tire Noise"] = DataModel1D("dBA", tireNoiseValue)
        self.dataDict1D["Rumble Noise"] = DataModel1D("dBA", rumbleNoiseValue)
        self.dataDict1D["Road Noise"] = DataModel1D("dBA", roadNoiseValue)
        self.dataDict1D["Wind Noise"] = DataModel1D("dBA", windNoiseValue)
        self.dataDict1D["Cruise Booming Noise"] = DataModel1D("dBC", boomingValue)
    
    def export(self, outputPath):
        for k,value in self.dataDict3D.items():
            value.export(k, outputPath, self.signalChannel.name, self.endFreq)

        self.export2D(outputPath)
        self.export1D(outputPath)


class CruiseVibrationAnalyzer(VibrationChannelAnalyzer):
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
        self.dataDict1D["Cruise Vibration"] = DataModel1D("dB", oaValue)

    def export(self, outputPath):
        for k,value in self.dataDict3D.items():
            value.export(k, outputPath, self.signalChannel.name, self.endFreq)

        self.export2D(outputPath)
        self.export1D(outputPath)

