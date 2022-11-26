from .process.vehicle_process import VehicleProcessor
from .process.fourier_signal_process import FourierSignalProcess
from .nvh_channel_analyzer import NoiseChannelAnalyzer, VibrationChannelAnalyzer
from .process.tacho_process import TachoProcessor 
from .process.project_process import ProjectProcess



class AccelNoiseAnalyzer(NoiseChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels, vehicelMap):
        super().__init__(signalChannel, tachoChannels, vehicelMap)

    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT(self.signalChannel, self.analyzeOptions.referenceValue, self.analyzeOptions.frequencyResolution)

        #check vehicleType, layout & pt type. ev??
        engineRpmIndices = TachoProcessor(self.tachoChannels).getOrderTrackedIndices("Engine Speed", 0, 6000, 20)
        self.dataDict3D["Engine RPM Colormap"] = processor.orderFFT(
            self.signalChannel, self.analyzeOptions.referenceValue,
            self.analyzeOptions.frequencyResolution, engineRpmIndices)

        speedIndices = TachoProcessor(self.tachoChannels).getOrderTrackedIndices("GPS Speed", 0, 140, 1)
        self.dataDict3D["Speed Colormap"] = processor.orderFFT(
            self.signalChannel, self.analyzeOptions.referenceValue,
            self.analyzeOptions.frequencyResolution, speedIndices)

    def analyze3to2(self):
        processor = ProjectProcess()
        self.dataDict2D["RPM Overall Graph"] = processor.projectYOA(
            self.dataDict3D["Engine RPM Colormap"].getAWeighted(), self.analyzeOptions.referenceValue)
        self.dataDict2D["Speed Overall Graph"] = processor.projectYOA(
            self.dataDict3D["Speed Colormap"].getAWeighted(), self.analyzeOptions.referenceValue)

    def analyze2to1():
        return

class AccelVibrationAnalyzer(VibrationChannelAnalyzer):
    def __init__(self, signalChannel, tachoChannels, vehicleMap):
        super().__init__(signalChannel, tachoChannels, vehicleMap)

    def analyzeSignalTo3(self):
        processor = FourierSignalProcess()
        self.dataDict3D["Time Colormap"] = processor.timeFFT(self.signalChannel, self.analyzeOptions.referenceValue, self.analyzeOptions.frequencyResolution)

        #check vehicleType, layout & pt type. ev??
        engineRpmIndices = TachoProcessor(self.tachoChannels).getOrderTrackedIndices("Engine Speed", 1000, 6000, 20)
        self.dataDict3D["Engine RPM Colormap"] = processor.orderFFT(
            self.signalChannel, self.analyzeOptions.referenceValue,
            self.analyzeOptions.frequencyResolution, engineRpmIndices)

        speedIndices = TachoProcessor(self.tachoChannels).getOrderTrackedIndices("GPS Speed", 1, 140, 1)
        self.dataDict3D["Speed Colormap"] = processor.orderFFT(
            self.signalChannel, self.analyzeOptions.referenceValue,
            self.analyzeOptions.frequencyResolution, speedIndices)

    def analyze3to2(self):
        processor = ProjectProcess()

        tireTransTacho = VehicleProcessor(self.vehicleMap).getSpeedToTireRatio()
        self.dataDict2D["Tire Graph"] = processor.projectYOrder(
            self.dataDict3D["Speed Colormap"],
            self.analyzeOptions.referenceValue,
            tireTransTacho)

        pShaftTransTacho = VehicleProcessor(self.vehicleMap).getSpeedToPropellerShaftRatio()
        if pShaftTransTacho != 0:
            self.dataDict2D["Propeller Shaft Graph"] = processor.projectYOrder(
                self.dataDict3D["Speed Colormap"],
                self.analyzeOptions.referenceValue,
                pShaftTransTacho)

    def analyze2to1():
        return

