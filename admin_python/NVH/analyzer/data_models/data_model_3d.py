class DataModel3D:
    unit = ""
    xAxisunit = ""
    xAxisDelta = 0
    yAxisunit = ""
    yAxisDelta = 0
    data = [] # 2d array after fft.

    def __init__(self, unit, xAxisunit, xAxisDelta, yAxisunit, yAxisDelta):
        self.unit = unit
        self.xAxisunit = xAxisunit
        self.xAxisDelta = xAxisDelta        
        self.yAxisunit = yAxisunit 
        self.yAxisDelta = yAxisDelta
