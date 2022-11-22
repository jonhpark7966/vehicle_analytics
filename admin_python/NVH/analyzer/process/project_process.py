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


    def projectY(self, data3D, oa, order):
        return 