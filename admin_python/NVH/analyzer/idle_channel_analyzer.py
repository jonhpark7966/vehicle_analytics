from NVH.analyzer.nvh_channel_analyzer import NoiseChannelAnalyzer, VibrationChannelAnalyzer
from .process.project_process import ProjectProcess 
from .process.fourier_signal_process import FourierSignalProcess

class IdleNoiseAnalyzer(NoiseChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels):
        super().__init__(signalChannel, tachoChannels)

    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT(self.signalChannel, self.analyzeOptions)

    def analyze3to2(self):
        processor = ProjectProcess()
        self.dataDict2D["Frequency Graph"] = processor.projectX(self.dataDict3D["Time Colormap"], self.analyzeOptions)

    def analyze2to1(self):
        #get rms
        self.dataDict2D["Frequency Graph"] 

class IdleVibrationAnalyzer(VibrationChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels):
        super().__init__(signalChannel, tachoChannels)

    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT(self.signalChannel, self.analyzeOptions)

    def analyze3to2(self):
        processor = ProjectProcess()
        self.dataDict2D["Frequency Graph"] = processor.projectX(self.dataDict3D["Time Colormap"], self.analyzeOptions)

    def analyze2to1():
        return

