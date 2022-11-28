from NVH.analyzer.data_models.data_model_3d import DataModel3D
from NVH.analyzer.data_models.data_model_2d import DataModel2D
from .utils import UtilsProcessor

import numpy as np


class ProjectProcess():

    def projectX(self, data3D, referenceValue):
        ret = DataModel2D(
            "dB", data3D.xAxisunit, data3D.xAxisDelta)

        # prepare columns
        columns = []
        for datum in data3D.data[0]:
            columns.append([])
        for row in data3D.data:
            for i, datum in enumerate(row):
                columns[i].append(datum)

        # get RMS 
        for column in columns: 
            ret.data.append(UtilsProcessor().getRMS(column, referenceValue, True))

        return ret


    def projectYOA(self, data3D, referenceValue, startFreq, endFreq):
        ret = DataModel2D(
            "dB", data3D.yAxisunit, data3D.yAxisDelta)

        # get RMS 
        for row in data3D.data:
            row2D =  DataModel2D(
                "dB", data3D.yAxisunit, data3D.yAxisDelta)
            row2D.data = row
            ret.data.append(UtilsProcessor().getRMSFreq(row2D, startFreq, endFreq, referenceValue))

        return ret


    def projectYOrder(self, data3D, referenceValue, order, transTacho=1.0):
        ret = DataModel2D(
            "dB", data3D.yAxisunit, data3D.yAxisDelta)

        # get RMS 
        for i, row in enumerate(data3D.data): 
            startFreq, endFreq = self._getFreqRangeFromOrder(data3D.yAxisDelta*i*transTacho, order)
            ret.data.append(UtilsProcessor().getRMSFreq(row, startFreq, endFreq, referenceValue))

        return ret 

    def _getFreqRangeFromOrder(self, tacho, order):
        orderWidth = 0.25
        return tacho/60*(order - orderWidth), tacho/60*(order + orderWidth)

