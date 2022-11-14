from NVH.analyzer.nvh_channel_analyzer import NoiseChannelAnalyzer, VibrationChannelAnalyzer 
from .process.fourier_signal_process import FourierSignalProcess

class IdleNoiseAnalyzer(NoiseChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels):
        super().__init__(signalChannel, tachoChannels)

    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT(self.signalChannel, self.analyzeOptions)

    def analyze3to2():
        return 

    def analyze2to1():
        return

class IdleVibrationAnalyzer(VibrationChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels):
        super().__init__(signalChannel, tachoChannels)

    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT(self.signalChannel, self.analyzeOptions)

    def analyze3to2(self):
        return 

    def analyze2to1():
        return

