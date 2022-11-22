import math

class UtilsProcessor:

    def getRMSFreq(self, dataModel2D, startFreq, endFreq, referenceValue):
        startIndex = (startFreq - dataModel2D.xAxisStart)/dataModel2D.xAxisDelta
        endIndex = (endFreq - dataModel2D.xAxisStart)/dataModel2D.xAxisDelta

        if not startIndex.is_integer():
            assert False # TODO, handle this case. 
        if not endIndex.is_integer():
            assert False # TODO, handle this case. 

        dataToRMS = dataModel2D.data[int(startIndex):int(endIndex)]

        return self.getRMS(dataToRMS, referenceValue)

    def getRMS(self, data, referenceValue, divideByLength=False):
        ret = 0.0
        for datum in data:
            # log to linear
            linear = 10**(datum/20) * referenceValue
            ret = ret + linear * linear

        if divideByLength:
            ret = ret / len(data) 

        ret = math.sqrt(ret)
        ret = 20 * math.log10(ret / referenceValue)

        return ret

    



