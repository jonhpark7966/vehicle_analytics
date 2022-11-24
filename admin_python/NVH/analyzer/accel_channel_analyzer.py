from .process.fourier_signal_process import FourierSignalProcess
from .nvh_channel_analyzer import NoiseChannelAnalyzer, VibrationChannelAnalyzer
from .process.tacho_process import TachoProcessor 



class AccelNoiseAnalyzer(NoiseChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels, vehicelMap):
        super().__init__(signalChannel, tachoChannels, vehicelMap)

    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT(self.signalChannel, self.analyzeOptions.referenceValue, self.analyzeOptions.frequencyResolution)

        #check vehicleType, layout & pt type. ev??
        engineRpmIndices = TachoProcessor(self.tachoChannels).getOrderTrackedIndices("Engine Speed", 1000, 6000, 20)
        self.dataDict3D["Engine RPM Colormap"] = processor.orderFFT(
            self.signalChannel, self.analyzeOptions.referenceValue,
            self.analyzeOptions.frequencyResolution, engineRpmIndices)
        #self.dataDict3D["Motor RPM Colormap"] = processor.orderFFT()
        #self.dataDict3D["Tire RPM Colormap"] = processor.orderFFT()
        #self.dataDict3D["PShaft RPM Colormap"] = processor.orderFFT()

    def analyze3to2():
        return 

    def analyze2to1():
        return

class AccelVibrationAnalyzer(VibrationChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels, vehicleMap):
        super().__init__(signalChannel, tachoChannels, vehicleMap)

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

