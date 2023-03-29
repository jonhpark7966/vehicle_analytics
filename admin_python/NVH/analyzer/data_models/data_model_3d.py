import json
import os
import matplotlib.pyplot as plt
from .data_model_2d import DataModel2D

import sys

class DataModel3D:
    def __init__(self, unit, xAxisunit, xAxisDelta, yAxisunit, yAxisDelta):
        self.unit = unit
        self.xAxisunit = xAxisunit
        self.xAxisDelta = xAxisDelta        
        self.yAxisunit = yAxisunit 
        self.yAxisDelta = yAxisDelta
        self.data = []

    def showColormap(self):
        if len(self.data) == 0:
            sys.stderr.write(" Not anlayzed yet. ")
            return

        # DEBUG FLAG to show colormap
        if True:
            return

        plt.imshow(self.data, origin='lower', aspect='auto', vmin=30, vmax=80, cmap="jet")
        plt.colorbar() 
        plt.show()

    def getAWeighted(self):
        ret = DataModel3D(self.unit, "dBA", self.xAxisDelta, self.yAxisunit, self.yAxisDelta)
        for row in self.data:
            dataModel2D = DataModel2D(self.unit, self.xAxisunit, self.xAxisDelta)
            dataModel2D.data = row
            ret.data.append(dataModel2D.getAWeighted().data)
        return ret
    
    
    def export(self, dataName, outputPath, channelName, endFreq):
        if len(self.data) == 0:
            sys.stderr.write(" Not analyzed yet. ")
            return

        with open(os.path.join(outputPath, channelName+"_"+dataName+".json"), "w") as f:
            jsonDict = {"name":dataName, "unit":self.unit,
             "xAxisunit": self.xAxisunit, "xAxisDelta":self.xAxisDelta, "xAxisNumber": int(endFreq/self.xAxisDelta),
             "yAxisunit": self.yAxisunit, "yAxisDelta":self.yAxisDelta,
             }
            json.dump(jsonDict, f)
            sys.stdout.write("Success! :" + f.name + "\n")

        with open(os.path.join(outputPath, channelName+"_"+dataName+".bin"), "wb") as f:
            f.write(self._zipData(endFreq))
            sys.stdout.write("Success! :" + f.name + "\n")

            
    def _zipData(self, endFreq):
        endIndex = int(endFreq/self.xAxisDelta)
        ret = bytes()
        for row in (self.data):
            ret = ret + row[0:endIndex].tobytes()
        return ret


