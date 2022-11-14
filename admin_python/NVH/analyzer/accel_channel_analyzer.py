from NVH.analyzer.process.fourier_signal_process import FourierSignalProcess
from NVH.analyzer.nvh_channel_analyzer import NoiseChannelAnalyzer, VibrationChannelAnalyzer 



class AccelNoiseAnalyzer(NoiseChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels):
        super().__init__(signalChannel, tachoChannels)

    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT()

        #check vehicleType, layout & pt type. ev??

        self.dataDict3D["Engine RPM Colormap"] = processor.orderFFT()
        self.dataDict3D["Motor RPM Colormap"] = processor.orderFFT()
        self.dataDict3D["Tire RPM Colormap"] = processor.timeFFT()
        self.dataDict3D["PShaft RPM Colormap"] = processor.timeFFT()

    def analyze3to2():
        return 

    def analyze2to1():
        return

class AccelVibrationAnalyzer(VibrationChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels):
        super().__init__(signalChannel, tachoChannels)

    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT()

        #check vehicleType, layout & pt type. ev??

        self.dataDict3D["Engine RPM Colormap"] = processor.orderFFT()
        self.dataDict3D["Motor RPM Colormap"] = processor.orderFFT()
        self.dataDict3D["Tire RPM Colormap"] = processor.timeFFT()
        self.dataDict3D["PShaft RPM Colormap"] = processor.timeFFT()

    def analyze3to2():
        return 

    def analyze2to1():
        return

