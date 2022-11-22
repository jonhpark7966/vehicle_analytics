import os
import json
from ..process.weighting_process import WeightingProcessor

class DataModel2D:
    def __init__(self, unit, xAxisunit, xAxisDelta):
        self.unit = unit
        self.xAxisStart = 0.0
        self.xAxisunit = xAxisunit
        self.xAxisDelta = xAxisDelta        
        self.data = []

    def export(self, dataName, outputPath, channelName):
        if len(self.data) == 0:
            print(" Not analyzed yet. ")
            return

        with open(os.path.join(outputPath, channelName+"_"+dataName+".json"), "w") as f:
            jsonDict = {"name":dataName, "unit":self.unit,
             "xAxisunit": self.xAxisunit, "xAxisDelata":self.xAxisDelta,
            }
            for i, datum in enumerate(self.data):
                jsonDict[str(i)] = str(round(datum, 2))

            json.dump(jsonDict, f)

    def getAWeighted(self):
        ret = DataModel2D(self.unit, self.xAxisunit, self.xAxisDelta)
        ret.data = self._weights().processAweighting(self.data)
        return ret
    
    def getCWeighted(self):
        ret = DataModel2D(self.unit, self.xAxisunit, self.xAxisDelta)
        ret.data = self._weights().processCweighting(self.data)
        return ret

    def _weights(self):
        if self.xAxisunit is not "Hz":
            assert False
        endFreq = int(len(self.data) / self.xAxisDelta - self.xAxisStart/self.xAxisDelta)
        weights = WeightingProcessor(endFreq, self.xAxisDelta)  
        return weights






        



