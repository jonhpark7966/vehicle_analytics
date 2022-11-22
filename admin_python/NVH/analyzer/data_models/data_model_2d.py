import os
import json

class DataModel2D:
    def __init__(self, unit, xAxisunit, xAxisDelta):
        self.unit = unit
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

