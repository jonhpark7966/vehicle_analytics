import json
import os

class DataModel3D:
    unit = ""
    xAxisunit = ""
    xAxisDelta = 0
    yAxisunit = ""
    yAxisDelta = 0
    data = None # 2d array after fft.

    def __init__(self, unit, xAxisunit, xAxisDelta, yAxisunit, yAxisDelta):
        self.unit = unit
        self.xAxisunit = xAxisunit
        self.xAxisDelta = xAxisDelta        
        self.yAxisunit = yAxisunit 
        self.yAxisDelta = yAxisDelta
        self.data = []

    def showColormap(self):
        if len(self.data) == 0:
            print(" Not anlayzed yet. ")
            return

        # DEBUG FLAG to show colormap
        if True:
            return

        plt.imshow(self.data, origin='lower', aspect='auto', vmin=30, vmax=80, cmap="jet")
        plt.colorbar() 
        plt.show()

    def export(self, dataName, outputPath, channelName):
        if len(self.data) == 0:
            print(" Not analyzed yet. ")
            return

        with open(os.path.join(outputPath, channelName+"_"+dataName+".json"), "w") as f:
            jsonDict = {"name":dataName, "unit":self.unit,
             "xAxisunit": self.xAxisunit, "xAxisDelata":self.xAxisDelta, "xAxisNumber":len(self.data[0]),
             "yAxisunit": self.yAxisunit, "yAxisDelata":self.yAxisDelta,
             }
            json.dump(jsonDict, f)

        with open(os.path.join(outputPath, channelName+"_"+dataName+".bin"), "wb") as f:
            f.write(self._zipData())
            
    def _zipData(self):
        ret = bytes()
        for row in (self.data):
            ret = ret + row.tobytes()
        return ret


