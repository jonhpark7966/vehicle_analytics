import numpy as np
from enum import Enum

class Windowing:
    hanning = 0


class AnalyzeOptions:
    frequencyResolution = 1
    referenceValue = 0.00002 
    overlap = 0.6
    windowing = Windowing.hanning 
    energyCorrectionFactor = 1.63 # refer https://community.sw.siemens.com/s/article/window-correction-factors

    def getWindow(self, n):
        if self.windowing == Windowing.hanning:
            return np.hanning(n)

        
        return np.hanning(n) # default is hanning.

