import numpy as np
from enum import Enum


class Windowing:
    hanning = 0


# Options Global
class AnalyzeOptions:
    overlap = 0.6
    windowing = Windowing.hanning
    amplitudeCorrectionFactor = 2.0
    # refer https://community.sw.siemens.com/s/article/window-correction-factors
    energyCorrectionFactor = 1.63
    peakRmsCorrectionFactor = 1.41 #1/0.707

    engineRpmStart = 1000
    engineRpmEnd = 6000
    engineRpmDelta = 20

    speedStart = 0
    speedEnd = 140
    speedDelta = 1

    speedRegressionStart = 20
    speedRegressionEnd = 120

    def __init__(self):
        self.referenceValue = 0.00002
        self.frequencyResolution = 1
        self.highFrequencyResolution = 20
        self.startFrequency = 20

    def getWindow(self, n):
        if self.windowing == Windowing.hanning:
            return np.hanning(n)

        return np.hanning(n)  # default is hanning.
